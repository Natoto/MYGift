//
//  GCDNetworkEngine.m
//  GameGifts
//
//  Created by Teiron-37 on 13-12-27.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GCDNetworkKit.h"
#define kFreezableOperationExtension @"mknetworkkitfrozenoperation"

#ifdef __OBJC_GC__
#error GCDNetworkKit does not support Objective-C Garbage Collection
#endif

#if ! __has_feature(objc_arc)
#error GCDNetworkKit is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#define MAX_CONCURRENT_CONNECTIONS_WIFI 6 //  长链接占用1个

@interface GCDNetworkEngine()

@property (strong, nonatomic) NSString *hostName;
@property (strong, nonatomic) Reachability *reachability;
@property (strong, nonatomic) NSDictionary *customHeaders;
@property (assign, nonatomic) Class customOperationSubclass;

@property (nonatomic, strong) NSMutableDictionary *memoryCache;
@property (nonatomic, strong) NSMutableArray *memoryCacheKeys;
@property (nonatomic, strong) NSMutableDictionary *cacheInvalidationParams;
@property (nonatomic, strong) NSMutableArray *operations;

-(void) saveCache;
-(void) saveCacheData:(NSData*) data forKey:(NSString*) cacheDataKey;

-(void) freezeOperations;
-(void) checkAndRestoreFrozenOperations;

-(BOOL) isCacheEnabled;

@end

//static NSMutableArray *_operations;
static dispatch_semaphore_t _semaphore;
static dispatch_queue_t _queue;
static dispatch_queue_t _sharedNetworkQueue;

//static const void * operationsCountKey = & operationsCountKey;

@implementation GCDNetworkEngine
@synthesize hostName = _hostName;
@synthesize reachability = _reachability;
@synthesize customHeaders = _customHeaders;
@synthesize customOperationSubclass = _customOperationSubclass;

@synthesize memoryCache = _memoryCache;
@synthesize memoryCacheKeys = _memoryCacheKeys;
@synthesize cacheInvalidationParams = _cacheInvalidationParams;

@synthesize reachabilityChangedHandler = _reachabilityChangedHandler;
@synthesize apiPath = _apiPath;
@synthesize portNumber = _portNumber;

+(void) initialize {
    if (!_sharedNetworkQueue) {
        _sharedNetworkQueue = dispatch_queue_create("com.teiren.giftbox", DISPATCH_QUEUE_CONCURRENT);
        _semaphore = dispatch_semaphore_create(MAX_CONCURRENT_CONNECTIONS_WIFI);
        _queue = dispatch_queue_create(NULL, NULL);
    }
}

- (id) init {
    
    return [self initWithHostName:nil];
}

- (id) initWithHostName:(NSString *)hostName {
    return [self initWithHostName:hostName apiPath:nil customHeaderFields:nil];
}

- (id) initWithHostName:(NSString*) hostName customHeaderFields:(NSDictionary*) headers {
    return [self initWithHostName:hostName apiPath:nil customHeaderFields:headers];
}

- (id) initWithHostName:(NSString*) hostName apiPath:(NSString*) apiPath customHeaderFields:(NSDictionary*) headers {
    self = [super init];
    if (self) {
        
        _operations = [[NSMutableArray alloc] init];
        self.apiPath = apiPath;
        
        if(hostName) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(reachabilityChanged:)
                                                         name:kReachabilityChangedNotification
                                                       object:nil];
            
            self.hostName = hostName;
            self.reachability = [Reachability reachabilityWithHostName:self.hostName];
            [self.reachability startNotifier];
        }
        
        if([headers objectForKey:@"User-Agent"] == nil) {
            
            NSMutableDictionary *newHeadersDict = [headers mutableCopy];
            NSString *userAgentString = [NSString stringWithFormat:@"%@/%@",
                                         [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey],
                                         [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
            [newHeadersDict setObject:userAgentString forKey:@"User-Agent"];
            self.customHeaders = newHeadersDict;
        } else {
            self.customHeaders = headers;
        }    
        
        self.customOperationSubclass = [GCDNetworkOperation class];
    }
    return self;
}

#pragma mark -
#pragma mark Memory Mangement

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
#if TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
#elif TARGET_OS_MAC
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationWillTerminateNotification object:nil];
#endif
    
}

#pragma mark -
#pragma mark Reachability related

-(void) reachabilityChanged:(NSNotification*) notification
{
    if([self.reachability currentReachabilityStatus] == ReachableViaWiFi)
    {
        UDLog(@"Server [%@] is reachable via Wifi", self.hostName);
//        _semaphore = dispatch_semaphore_create(MAX_CONCURRENT_CONNECTIONS_WIFI);
        
        [self checkAndRestoreFrozenOperations];
    }
    else if([self.reachability currentReachabilityStatus] == ReachableViaWWAN)
    {
        UDLog(@"Server [%@] is reachable only via cellular data", self.hostName);
//        _semaphore = dispatch_semaphore_create(MAX_CONCURRENT_CONNECTIONS_3G);
        [self checkAndRestoreFrozenOperations];
    }
    else if([self.reachability currentReachabilityStatus] == NotReachable)
    {
        UDLog(@"Server [%@] is not reachable", self.hostName);
        [self freezeOperations];
    }
    
    if(self.reachabilityChangedHandler) {
        self.reachabilityChangedHandler([self.reachability currentReachabilityStatus]);
    }
}

#pragma mark Freezing operations (Called when network connectivity fails)
-(void) freezeOperations {
    
    if(![self isCacheEnabled]) return;
    
    for(GCDNetworkOperation *operation in _operations) {
        
        // freeze only freeable operations.
        if(![operation freezable]) continue;
        
        if(!self.hostName) return;
        
        // freeze only operations that belong to this server
        if([[operation url] rangeOfString:self.hostName].location == NSNotFound) continue;
        
        NSString *archivePath = [[[self cacheDirectoryName] stringByAppendingPathComponent:[operation uniqueIdentifier]]
                                 stringByAppendingPathExtension:kFreezableOperationExtension];
        [NSKeyedArchiver archiveRootObject:operation toFile:archivePath];
        [operation cancel];
    }
    
}

-(void) checkAndRestoreFrozenOperations {
    
    if(![self isCacheEnabled]) return;
    
    NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDirectoryName] error:&error];
    if(error)
        UDLog(@"%@", error);
    
    NSArray *pendingOperations = [files filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        NSString *thisFile = (NSString*) evaluatedObject;
        return ([thisFile rangeOfString:kFreezableOperationExtension].location != NSNotFound);
    }]];
    
    for(NSString *pendingOperationFile in pendingOperations) {
        
        NSString *archivePath = [[self cacheDirectoryName] stringByAppendingPathComponent:pendingOperationFile];
        GCDNetworkOperation *pendingOperation = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        [self enqueueOperation:pendingOperation];
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:archivePath error:&error];
        if(error)
            UDLog(@"%@", error);
    }
}

-(NSString*) readonlyHostName {
    
    return [_hostName copy];
}

-(BOOL) isReachable {
    
    return ([self.reachability currentReachabilityStatus] != NotReachable);
}

#pragma mark -
#pragma mark Create methods

-(void) registerOperationSubclass:(Class) aClass {
    
    self.customOperationSubclass = aClass;
}

-(GCDNetworkOperation*) operationWithPath:(NSString*) path {
    
    return [self operationWithPath:path params:nil];
}

-(GCDNetworkOperation*) operationWithPath:(NSString*) path
                                  params:(NSMutableDictionary*) body {
    
    return [self operationWithPath:path
                            params:body
                        httpMethod:@"GET"];
}

-(GCDNetworkOperation*) operationWithPath:(NSString*) path
                                  params:(NSMutableDictionary*) body
                              httpMethod:(NSString*)method  {
    
    return [self operationWithPath:path params:body httpMethod:method ssl:NO];
}

-(GCDNetworkOperation*) operationWithPath:(NSString*) path
                                  params:(NSMutableDictionary*) body
                              httpMethod:(NSString*)method
                                     ssl:(BOOL) useSSL {
    
    if(self.hostName == nil) {
        
        UDLog(@"Hostname is nil, use operationWithURLString: method to create absolute URL operations");
        return nil;
    }
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@://%@", useSSL ? @"https" : @"http", self.hostName];
    
    if(self.portNumber != 0)
        [urlString appendFormat:@":%d", self.portNumber];
    
    if(self.apiPath)
        [urlString appendFormat:@"/%@", self.apiPath];
    
    [urlString appendFormat:@"/%@", path];
    
    return [self operationWithURLString:urlString params:body httpMethod:method];
}

-(GCDNetworkOperation*) operationWithURLString:(NSString*) urlString {
    
    return [self operationWithURLString:urlString params:nil httpMethod:@"GET"];
}

-(GCDNetworkOperation*) operationWithURLString:(NSString*) urlString
                                       params:(NSMutableDictionary*) body {
    
    return [self operationWithURLString:urlString params:body httpMethod:@"GET"];
}


-(GCDNetworkOperation*) operationWithURLString:(NSString*) urlString
                                       params:(NSMutableDictionary*) body
                                   httpMethod:(NSString*)method {
    
    GCDNetworkOperation *operation = [[self.customOperationSubclass alloc] initWithURLString:urlString params:body httpMethod:method];
    
    [self prepareHeaders:operation];
    return operation;
}

-(void) prepareHeaders:(GCDNetworkOperation*) operation {
    
    [operation addHeaders:self.customHeaders];
}

- (NSData*)cachedDataForOperation:(GCDNetworkOperation*) operation {
    NSData *cachedData = [self.memoryCache objectForKey:[operation uniqueIdentifier]];
    if(cachedData) return cachedData;
    NSString *filePath = [[self cacheDirectoryName] stringByAppendingPathComponent:[operation uniqueIdentifier]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        cachedData = [NSData dataWithContentsOfFile:filePath];
        [self saveCacheData:cachedData forKey:[operation uniqueIdentifier]]; // bring it back to the in-memory cache
        return cachedData;
    }
    
    return nil;
}

-(void) enqueueOperation:(GCDNetworkOperation* ) operation {
    [self enqueueOperation:operation forceReload:YES];
}

-(void) enqueueOperation:(GCDNetworkOperation*) operation forceReload:(BOOL) forceReload{
    NSParameterAssert(operation != nil);
    
    __weak GCDNetworkOperation *curOperation = operation;
    // Grab on to the current queue (We need it later)
    dispatch_queue_t originalQueue = dispatch_get_current_queue();
#if DO_GCD_RETAIN_RELEASE
    dispatch_retain(originalQueue);
#endif
    // Jump off the main thread, mainly for disk cache reading purposes
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [curOperation setCacheHandler:^(GCDNetworkOperation* completedCacheableOperation) {
            
            // if this is not called, the request would have been a non cacheable request
            //completedCacheableOperation.cacheHeaders;
            NSString *uniqueId = [completedCacheableOperation uniqueIdentifier];
            [self saveCacheData:[completedCacheableOperation responseData]
                         forKey:uniqueId];
        }];
    });
    
    //读缓存数据
    if (operation.cacheResponseAvailable) {
        NSData *cachedData = [self cachedDataForOperation:operation];
        if(cachedData) {
            dispatch_async(originalQueue, ^{
                // Jump back to the original thread here since setCachedData updates the main thread
                [curOperation setCachedData:cachedData];
            });
        }
    }
    
    //网络数据
    dispatch_async(_queue, ^{
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(_sharedNetworkQueue, ^{
            [curOperation start];
            dispatch_semaphore_signal(_semaphore);
        });
    });
    
    [_operations addObject:operation];
    
//    if (operation.cacheResponseAvailable) {
//        NSData *cachedData = [self cachedDataForOperation:operation];
//        if(cachedData) {
//            dispatch_async(originalQueue, ^{
//                // Jump back to the original thread here since setCachedData updates the main thread
//                [curOperation setCachedData:cachedData];
//            });
//        }
//        
//        if(forceReload) {
//            dispatch_async(_queue, ^{
//                dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
//                dispatch_async(_sharedNetworkQueue, ^{
//                    [curOperation start];
//                    dispatch_semaphore_signal(_semaphore);
//                });
//            });
//        }
//        [_operations addObject:operation];
//    }
//    else {
//        dispatch_async(_queue, ^{
//            dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
//            dispatch_async(_sharedNetworkQueue, ^{
//                [curOperation start];
//                dispatch_semaphore_signal(_semaphore);
//            });
//        });
//        
//        [_operations addObject:operation];
//    }
    
    if([self.reachability currentReachabilityStatus] == NotReachable)
        [self freezeOperations];
#if DO_GCD_RETAIN_RELEASE
    dispatch_release(originalQueue);
#endif
    
    KT_DLog(@"_operations.count = %d",[_operations count]);
}

- (void) clearOperation:(GCDNetworkOperation* ) operation
{
    if ([_operations containsObject:operation]) {
        [_operations removeObject:operation];
    }
}


- (GCDNetworkOperation*)imageAtURL:(NSURL *)url onCompletion:(GCDNKImageBlock) imageFetchedBlock
{
#ifdef DEBUG
    // I could enable caching here, but that hits performance and inturn affects table view scrolling
    // if imageAtURL is called for loading thumbnails.
    if(![self isCacheEnabled]) UDLog(@"imageAtURL:onCompletion: requires caching to be enabled.")
#endif
        
        if (url == nil) {
            return nil;
        }
    
    GCDNetworkOperation *op = [self operationWithURLString:[url absoluteString]];
    
    [op
     onCompletion:^(GCDNetworkOperation *completedOperation, BOOL isCacheData)
     {
         imageFetchedBlock([completedOperation responseImage],
                           url,
                           [completedOperation isCachedResponse]);
         
     }
     onError:^(NSError* error) {
         
         UDLog(@"%@", error);
     }];    
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark -
#pragma mark Cache related

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:GCDNETWORKCACHE_DEFAULT_DIRECTORY];
    return cacheDirectoryName;
}

-(int) cacheMemoryCost {
    
    return GCDNETWORKCACHE_DEFAULT_COST;
}

-(void) saveCache {
    
    for(NSString *cacheKey in [self.memoryCache allKeys])
    {
        NSString *filePath = [[self cacheDirectoryName] stringByAppendingPathComponent:cacheKey];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            ELog(error);
        }
        
        [[self.memoryCache objectForKey:cacheKey] writeToFile:filePath atomically:YES];
    }
    
    [self.memoryCache removeAllObjects];
    [self.memoryCacheKeys removeAllObjects];
    
    NSString *cacheInvalidationPlistFilePath = [[self cacheDirectoryName] stringByAppendingPathExtension:@"plist"];
    [self.cacheInvalidationParams writeToFile:cacheInvalidationPlistFilePath atomically:YES];
}

-(void) saveCacheData:(NSData*) data forKey:(NSString*) cacheDataKey
{
    @synchronized(self) {
        [self.memoryCache setObject:data forKey:cacheDataKey];
        
        NSUInteger index = [self.memoryCacheKeys indexOfObject:cacheDataKey];
        if(index != NSNotFound)
            [self.memoryCacheKeys removeObjectAtIndex:index];
        
        [self.memoryCacheKeys insertObject:cacheDataKey atIndex:0]; // remove it and insert it at start
        
        if([self.memoryCacheKeys count] >= [self cacheMemoryCost])
        {
            NSString *lastKey = [self.memoryCacheKeys lastObject];
            NSData *data = [self.memoryCache objectForKey:lastKey];
            NSString *filePath = [[self cacheDirectoryName] stringByAppendingPathComponent:lastKey];
            
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                
                NSError *error = nil;
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
                ELog(error);
            }
            [data writeToFile:filePath atomically:YES];
            
            [self.memoryCacheKeys removeLastObject];
            [self.memoryCache removeObjectForKey:lastKey];        
        }
    }
}

-(BOOL) isCacheEnabled {
    
    BOOL isDir = NO;
    BOOL isCachingEnabled = [[NSFileManager defaultManager] fileExistsAtPath:[self cacheDirectoryName] isDirectory:&isDir];
    return isCachingEnabled;
}

-(void) useCache {
    
    self.memoryCache = [NSMutableDictionary dictionaryWithCapacity:[self cacheMemoryCost]];
    self.memoryCacheKeys = [NSMutableArray arrayWithCapacity:[self cacheMemoryCost]];
    self.cacheInvalidationParams = [NSMutableDictionary dictionary];
    
    NSString *cacheDirectory = [self cacheDirectoryName];
    BOOL isDirectory = YES;
    BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory] && isDirectory;
    
    if (!folderExists)
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString *cacheInvalidationPlistFilePath = [cacheDirectory stringByAppendingPathExtension:@"plist"];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheInvalidationPlistFilePath];
    
    if (fileExists)
    {
        self.cacheInvalidationParams = [NSMutableDictionary dictionaryWithContentsOfFile:cacheInvalidationPlistFilePath];
    }
    
#if TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCache)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCache)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCache)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
#elif TARGET_OS_MAC
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCache)
                                                 name:NSApplicationWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCache)
                                                 name:NSApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCache)
                                                 name:NSApplicationWillTerminateNotification
                                               object:nil];
    
#endif
    
    
}

-(void) emptyCache {
    
    [self saveCache]; // ensures that invalidation params are written to disk properly
    NSError *error = nil;
    NSArray *directoryContents = [[NSFileManager defaultManager]
                                  contentsOfDirectoryAtPath:[self cacheDirectoryName] error:&error];
    if(error) UDLog(@"%@", error);
    
    error = nil;
    for(NSString *fileName in directoryContents) {
        
        NSString *path = [[self cacheDirectoryName] stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if(error) UDLog(@"%@", error);
    }
    
    error = nil;
    NSString *cacheInvalidationPlistFilePath = [[self cacheDirectoryName] stringByAppendingPathExtension:@"plist"];
    [[NSFileManager defaultManager] removeItemAtPath:cacheInvalidationPlistFilePath error:&error];
    if(error) UDLog(@"%@", error);
}

@end
