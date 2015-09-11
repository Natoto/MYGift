//
//  GCDNetworkOperation.m
//  GameGifts
//
//  Created by Teiron-37 on 13-12-27.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "GCDNetworkKit.h"
#import "NSStream+BoundPairAdditions.h"

enum {
    kPostBufferSize = 32768
};

OSStatus extractIdentityAndTrust(CFDataRef inPKCS12Data,
                                 SecIdentityRef *outIdentity,
                                 SecTrustRef *outTrust,
                                 CFStringRef keyPassword);

@interface GCDNetworkOperation()
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSString *uniqueId;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSHTTPURLResponse *response;

@property (strong, nonatomic) NSMutableDictionary *fieldsToBePosted;
@property (strong, nonatomic) NSMutableArray *filesToBePosted;
@property (strong, nonatomic) NSMutableArray *dataToBePosted;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

@property (nonatomic, strong) NSMutableArray *responseBlocks;
@property (nonatomic, strong) NSMutableArray *errorBlocks;

@property (nonatomic, assign) GCDNetworkOperationState state;

@property (strong, nonatomic) NSMutableData *mutableData;
@property (assign, nonatomic) NSUInteger downloadedDataSize;

@property (nonatomic, strong) NSMutableArray *notModifiedHandlers;

@property (nonatomic, strong) NSMutableArray *uploadProgressChangedHandlers;
@property (nonatomic, strong) NSMutableArray *downloadProgressChangedHandlers;
@property (nonatomic, copy) GCDNKEncodingBlock postDataEncodingHandler;

@property (nonatomic, assign) NSInteger startPosition;

@property (nonatomic, strong) NSMutableArray *downloadStreams;
@property (nonatomic, strong) NSData *cachedResponse;
@property (nonatomic, copy) GCDNKCacheBlock cacheHandlingBlock;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;

@property (strong, nonatomic) NSError *error;

//For File Stream
@property (nonatomic, copy,   readwrite) NSData *           bodyPrefixData;
@property (nonatomic, strong, readwrite) NSInputStream *    fileStream;
@property (nonatomic, copy,   readwrite) NSData *           bodySuffixData;
@property (nonatomic, strong, readwrite) NSOutputStream *   producerStream;
@property (nonatomic, strong, readwrite) NSInputStream *    consumerStream;
@property (nonatomic, assign, readwrite) const uint8_t *    buffer;
@property (nonatomic, assign, readwrite) uint8_t *          bufferOnHeap;
@property (nonatomic, assign, readwrite) size_t             bufferOffset;
@property (nonatomic, assign, readwrite) size_t             bufferLimit;

@property (nonatomic, strong) ALAsset *          fileAsset;
@property (nonatomic, assign) NSUInteger         fileAssetOffset;
@property (nonatomic, assign) long long          toSendLength;
@property (nonatomic, assign) long long          alreadySentLength;

@property (nonatomic, assign) SecTrustRef serverTrust;

- (void) endBackgroundTask;

@end

@implementation GCDNetworkOperation
@synthesize postDataEncodingHandler = _postDataEncodingHandler;

@synthesize stringEncoding = _stringEncoding;
@dynamic freezable;
@synthesize uniqueId = _uniqueId; // freezable operations have a unique id

@synthesize connection = _connection;

@synthesize request = _request;
@synthesize response = _response;

@synthesize fieldsToBePosted = _fieldsToBePosted;
@synthesize filesToBePosted = _filesToBePosted;
@synthesize dataToBePosted = _dataToBePosted;

@synthesize username = _username;
@synthesize password = _password;
@synthesize clientCertificate = _clientCertificate;
@synthesize authHandler = _authHandler;
@synthesize operationStateChangedHandler = _operationStateChangedHandler;

@synthesize responseBlocks = _responseBlocks;
@synthesize errorBlocks = _errorBlocks;

@synthesize isCancelled = _isCancelled;
@synthesize mutableData = _mutableData;
@synthesize downloadedDataSize = _downloadedDataSize;

@synthesize notModifiedHandlers = _notModifiedHandlers;

@synthesize uploadProgressChangedHandlers = _uploadProgressChangedHandlers;
@synthesize downloadProgressChangedHandlers = _downloadProgressChangedHandlers;

@synthesize downloadStreams = _downloadStreams;

@synthesize cachedResponse = _cachedResponse;
@synthesize cacheHandlingBlock = _cacheHandlingBlock;
@synthesize credentialPersistence = _credentialPersistence;
@synthesize shouldNotCacheResponse = _shouldNotCacheResponse;
@synthesize clientCertificatePassword = _clientCertificatePassword;
@synthesize shouldCacheResponseEvenIfProtocolIsHTTPS = _shouldCacheResponseEvenIfProtocolIsHTTPS;
@synthesize shouldContinueWithInvalidCertificate = _shouldContinueWithInvalidCertificate;
@synthesize shouldSendAcceptLanguageHeader = _shouldSendAcceptLanguageHeader;

@synthesize startPosition = _startPosition;

@synthesize cacheHeaders = _cacheHeaders;

@synthesize backgroundTaskId = _backgroundTaskId;
@synthesize localNotification = localNotification_;
@synthesize shouldShowLocalNotificationOnError = shouldShowLocalNotificationOnError_;

@synthesize error = _error;

//For File Stream
@synthesize bodyPrefixData  = _bodyPrefixData;
@synthesize fileStream      = _fileStream;
@synthesize bodySuffixData  = _bodySuffixData;
@synthesize producerStream  = _producerStream;
@synthesize consumerStream  = _consumerStream;
@synthesize buffer          = _buffer;
@synthesize bufferOnHeap    = _bufferOnHeap;
@synthesize bufferOffset    = _bufferOffset;
@synthesize bufferLimit     = _bufferLimit;

@synthesize fileAsset       = _fileAsset;
@synthesize fileAssetOffset = _fileAssetOffset;

@synthesize toSendLength = _toSendLength;
@synthesize alreadySentLength = _alreadySentLength;

@synthesize serverTrust = _serverTrust;

//-(BOOL) isCacheable {
//    
//    if(self.shouldNotCacheResponse) return NO;
//    if(self.username != nil) return NO;
//    if(self.password != nil) return NO;
//    if(self.clientCertificate != nil) return NO;
//    if(self.clientCertificatePassword != nil) return NO;
//    if(![self.request.HTTPMethod isEqualToString:@"GET"]) return NO;
//    if([self.request.URL.scheme.lowercaseString isEqualToString:@"https"]) return self.shouldCacheResponseEvenIfProtocolIsHTTPS;
//    if(self.downloadStreams.count > 0) return NO; // should not cache operations that have streams attached
//    return YES;
//}

-(BOOL) isCacheable {
    
    if(self.shouldSynCache && self.command) return YES;
    return NO;
}

//===========================================================
// + (BOOL)automaticallyNotifiesObserversForKey:
//
//===========================================================
+ (BOOL)automaticallyNotifiesObserversForKey: (NSString *)theKey
{
    BOOL automatic;
    
    if ([theKey isEqualToString:@"postDataEncoding"]) {
        automatic = NO;
    } else {
        automatic = [super automaticallyNotifiesObserversForKey:theKey];
    }
    
    return automatic;
}

//===========================================================
//  postDataEncoding
//===========================================================
- (GCDNKPostDataEncodingType)postDataEncoding
{
    return _postDataEncoding;
}

- (void)setPostDataEncoding:(GCDNKPostDataEncodingType)aPostDataEncoding
{
    if (_postDataEncoding != aPostDataEncoding) {
        [self willChangeValueForKey:@"postDataEncoding"];
        _postDataEncoding = aPostDataEncoding;
        
        NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
        
        switch (self.postDataEncoding) {
                
            case GCDNKPostDataEncodingTypeURL: {
                [self.request setValue:
                 [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset]
                    forHTTPHeaderField:@"Content-Type"];
            }
                break;
            case GCDNKPostDataEncodingTypeJSON: {
                if(NSClassFromString(@"NSJSONSerialization")) {
                    [self.request setValue:
                     [NSString stringWithFormat:@"application/json; charset=%@", charset]
                        forHTTPHeaderField:@"Content-Type"];
                }
                else {
                    [self.request setValue:
                     [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset]
                        forHTTPHeaderField:@"Content-Type"];
                    
                }
            }
                break;
            case GCDNKPostDataEncodingTypePlist: {
                [self.request setValue:
                 [NSString stringWithFormat:@"application/x-plist; charset=%@", charset]
                    forHTTPHeaderField:@"Content-Type"];
            }
                
            default:
                break;
        }
        [self didChangeValueForKey:@"postDataEncoding"];
    }
}

-(NSString*) encodedPostDataString {
    
    NSString *returnValue = @"";
    if(self.postDataEncoding == GCDNKPostDataEncodingTypeURL)
        returnValue = [self.fieldsToBePosted urlEncodedKeyValueString];
    else if(self.postDataEncoding == GCDNKPostDataEncodingTypeJSON)
        returnValue = [self.fieldsToBePosted jsonEncodedKeyValueString];
    else if(self.postDataEncoding == GCDNKPostDataEncodingTypePlist)
        returnValue = [self.fieldsToBePosted plistEncodedKeyValueString];
    return returnValue;
}

-(void) setCustomPostDataEncodingHandler:(GCDNKEncodingBlock) postDataEncodingHandler forType:(NSString*) contentType {
    
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
    self.postDataEncoding = GCDNKPostDataEncodingTypeCustom;
    self.postDataEncodingHandler = postDataEncodingHandler;
    [self.request setValue:
     [NSString stringWithFormat:@"%@; charset=%@", contentType, charset]
        forHTTPHeaderField:@"Content-Type"];
}

//===========================================================
//  freezable
//===========================================================
- (BOOL)freezable
{
    return _freezable;
}

-(NSString*) url {
    
    return [[self.request URL] absoluteString];
}

-(NSURLRequest*) readonlyRequest {
    
    return [self.request copy];
}

-(NSHTTPURLResponse*) readonlyResponse {
    
    return [self.response copy];
}

- (NSDictionary *) readonlyPostDictionary {
    
    return [self.fieldsToBePosted copy];
}

-(NSString*) HTTPMethod {
    
    return self.request.HTTPMethod;
}

-(NSInteger) HTTPStatusCode {
    
    if(self.response)
        return self.response.statusCode;
    else
        return 0;
}

- (void)setFreezable:(BOOL)flag
{
    // get method cannot be frozen.
    // No point in freezing a method that doesn't change server state.
    if([self.request.HTTPMethod isEqualToString:@"GET"] && flag) return;
    _freezable = flag;
    
    if(_freezable && self.uniqueId == nil)
        self.uniqueId = [NSString uniqueString];
}

-(BOOL) isEqual:(id)object {
    
    if(object == self)
        return YES;
    if(!object || ![object isKindOfClass:[self class]])
        return NO;
    
    if([self.request.HTTPMethod isEqualToString:@"GET"] || [self.request.HTTPMethod isEqualToString:@"HEAD"]) {
        
        GCDNetworkOperation *anotherObject = (GCDNetworkOperation*) object;
        return ([[self uniqueIdentifier] isEqualToString:[anotherObject uniqueIdentifier]]);
    }
    
    return NO;
}

-(NSUInteger) hash {
    return [[self uniqueIdentifier] hash];
}

-(NSString*) uniqueIdentifier {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@ %@", self.request.HTTPMethod, self.url];
    
    if (self.command) {
        [str appendString:self.command];
    }
    
    if(self.username || self.password) {
        
        [str appendFormat:@" [%@:%@]",
         self.username ? self.username : @"",
         self.password ? self.password : @""];
    }
    
    if(self.freezable) {
        [str appendString:self.uniqueId];
    }
    return [str md5];
}

-(BOOL) isCachedResponse {
    
    return self.cachedResponse != nil;
}

-(void) notifyCache {
    
    if(![self isCacheable]) return;
    if(!([self.response statusCode] >= 200 && [self.response statusCode] < 300)) return;
    
    if(![self isCancelled])
        self.cacheHandlingBlock(self);
}

-(GCDNetworkOperationState) state {
    
    return (GCDNetworkOperationState)_state;
}

-(void) setState:(GCDNetworkOperationState)newState {
    
    switch (newState) {
        case GCDNetworkOperationStateReady:
            [self willChangeValueForKey:@"isReady"];
            break;
        case GCDNetworkOperationStateExecuting:
            [self willChangeValueForKey:@"isReady"];
            [self willChangeValueForKey:@"isExecuting"];
            break;
        case GCDNetworkOperationStateFinished:
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            break;
    }
    
    _state = newState;
    
    switch (newState) {
        case GCDNetworkOperationStateReady:
            [self didChangeValueForKey:@"isReady"];
            break;
        case GCDNetworkOperationStateExecuting:
            [self didChangeValueForKey:@"isReady"];
            [self didChangeValueForKey:@"isExecuting"];
            break;
        case GCDNetworkOperationStateFinished:
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
            break;
    }
    
    if(self.operationStateChangedHandler) {
        self.operationStateChangedHandler(newState);
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.stringEncoding forKey:@"stringEncoding"];
    [encoder encodeInteger:_postDataEncoding forKey:@"postDataEncoding"];
    
    [encoder encodeObject:self.uniqueId forKey:@"uniqueId"];
    [encoder encodeObject:self.request forKey:@"request"];
    [encoder encodeObject:self.response forKey:@"response"];
    [encoder encodeObject:self.fieldsToBePosted forKey:@"fieldsToBePosted"];
    [encoder encodeObject:self.filesToBePosted forKey:@"filesToBePosted"];
    [encoder encodeObject:self.dataToBePosted forKey:@"dataToBePosted"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.clientCertificate forKey:@"clientCertificate"];
    [encoder encodeBool:self.shouldContinueWithInvalidCertificate forKey:@"shouldContinueWithInvalidCertificate"];
    
    [encoder encodeObject:self.localNotification forKey:@"localNotification"];
    
    self.state = GCDNetworkOperationStateReady;
    [encoder encodeInt32:_state forKey:@"state"];
    [encoder encodeBool:self.isCancelled forKey:@"isCancelled"];
    [encoder encodeObject:self.mutableData forKey:@"mutableData"];
    [encoder encodeInteger:self.downloadedDataSize forKey:@"downloadedDataSize"];
    [encoder encodeObject:self.downloadStreams forKey:@"downloadStreams"];
    [encoder encodeInteger:self.startPosition forKey:@"startPosition"];
    [encoder encodeInteger:self.credentialPersistence forKey:@"credentialPersistence"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        [self setStringEncoding:[decoder decodeIntegerForKey:@"stringEncoding"]];
        _postDataEncoding = (GCDNKPostDataEncodingType)[decoder decodeIntegerForKey:@"postDataEncoding"];
        self.request = [decoder decodeObjectForKey:@"request"];
        self.uniqueId = [decoder decodeObjectForKey:@"uniqueId"];
        
        self.response = [decoder decodeObjectForKey:@"response"];
        self.fieldsToBePosted = [decoder decodeObjectForKey:@"fieldsToBePosted"];
        self.filesToBePosted = [decoder decodeObjectForKey:@"filesToBePosted"];
        self.dataToBePosted = [decoder decodeObjectForKey:@"dataToBePosted"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.clientCertificate = [decoder decodeObjectForKey:@"clientCertificate"];
        
        self.localNotification = [decoder decodeObjectForKey:@"localNotification"];
        
        [self setState:[decoder decodeInt32ForKey:@"state"]];
        
        self.isCancelled = [decoder decodeBoolForKey:@"isCancelled"];
        self.mutableData = [decoder decodeObjectForKey:@"mutableData"];
        self.downloadedDataSize = [decoder decodeIntegerForKey:@"downloadedDataSize"];
        self.downloadStreams = [decoder decodeObjectForKey:@"downloadStreams"];
        self.startPosition = [decoder decodeIntegerForKey:@"startPosition"];
        self.credentialPersistence = [decoder decodeIntegerForKey:@"credentialPersistence"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    GCDNetworkOperation *theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    theCopy.postDataEncoding = _postDataEncoding;
    [theCopy setStringEncoding:self.stringEncoding];
    [theCopy setUniqueId:[self.uniqueId copy]];
    
    [theCopy setConnection:[self.connection copy]];
    [theCopy setRequest:[self.request copy]];
    [theCopy setResponse:[self.response copy]];
    [theCopy setFieldsToBePosted:[self.fieldsToBePosted copy]];
    [theCopy setFilesToBePosted:[self.filesToBePosted copy]];
    [theCopy setDataToBePosted:[self.dataToBePosted copy]];
    [theCopy setUsername:[self.username copy]];
    [theCopy setPassword:[self.password copy]];
    [theCopy setClientCertificate:[self.clientCertificate copy]];
    [theCopy setResponseBlocks:[self.responseBlocks copy]];
    [theCopy setErrorBlocks:[self.errorBlocks copy]];
    [theCopy setState:self.state];
    [theCopy setIsCancelled:self.isCancelled];
    [theCopy setMutableData:[self.mutableData copy]];
    [theCopy setDownloadedDataSize:self.downloadedDataSize];
    [theCopy setNotModifiedHandlers:[self.notModifiedHandlers copy]];
    [theCopy setUploadProgressChangedHandlers:[self.uploadProgressChangedHandlers copy]];
    [theCopy setDownloadProgressChangedHandlers:[self.downloadProgressChangedHandlers copy]];
    [theCopy setDownloadStreams:[self.downloadStreams copy]];
    [theCopy setCachedResponse:[self.cachedResponse copy]];
    [theCopy setCacheHandlingBlock:self.cacheHandlingBlock];
    [theCopy setStartPosition:self.startPosition];
    [theCopy setCredentialPersistence:self.credentialPersistence];
    
    return theCopy;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    GCDNetworkOperation *theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    theCopy.postDataEncoding = _postDataEncoding;
    [theCopy setStringEncoding:self.stringEncoding];
    [theCopy setUniqueId:[self.uniqueId copy]];
    
    [theCopy setConnection:[self.connection mutableCopy]];
    [theCopy setRequest:[self.request mutableCopy]];
    [theCopy setResponse:[self.response mutableCopy]];
    [theCopy setFieldsToBePosted:[self.fieldsToBePosted mutableCopy]];
    [theCopy setFilesToBePosted:[self.filesToBePosted mutableCopy]];
    [theCopy setDataToBePosted:[self.dataToBePosted mutableCopy]];
    [theCopy setUsername:[self.username copy]];
    [theCopy setPassword:[self.password copy]];
    [theCopy setClientCertificate:[self.clientCertificate copy]];
    [theCopy setClientCertificatePassword:[self.clientCertificatePassword copy]];
    [theCopy setResponseBlocks:[self.responseBlocks mutableCopy]];
    [theCopy setErrorBlocks:[self.errorBlocks mutableCopy]];
    [theCopy setState:self.state];
    [theCopy setIsCancelled:self.isCancelled];
    [theCopy setMutableData:[self.mutableData mutableCopy]];
    [theCopy setDownloadedDataSize:self.downloadedDataSize];
    [theCopy setNotModifiedHandlers:[self.notModifiedHandlers mutableCopy]];
    [theCopy setUploadProgressChangedHandlers:[self.uploadProgressChangedHandlers mutableCopy]];
    [theCopy setDownloadProgressChangedHandlers:[self.downloadProgressChangedHandlers mutableCopy]];
    [theCopy setDownloadStreams:[self.downloadStreams mutableCopy]];
    [theCopy setCachedResponse:[self.cachedResponse mutableCopy]];
    [theCopy setCacheHandlingBlock:self.cacheHandlingBlock];
    [theCopy setStartPosition:self.startPosition];
    [theCopy setCredentialPersistence:self.credentialPersistence];
    
    return theCopy;
}

- (instancetype)copyForRetry
{
    GCDNetworkOperation *theCopy = [[[self class] alloc] init];
    
    [theCopy setConnection:nil];
    [theCopy setResponse:nil];
    [theCopy setState:GCDNetworkOperationStateReady];
    [theCopy setIsCancelled:NO];
    [theCopy setDownloadedDataSize:0];
    [theCopy setStartPosition:0];
    
    theCopy.postDataEncoding = _postDataEncoding;
    [theCopy setStringEncoding:self.stringEncoding];
    [theCopy setUniqueId:[self.uniqueId copy]];
    [theCopy setRequest:[self.request copy]];
    [theCopy setFieldsToBePosted:[self.fieldsToBePosted mutableCopy]];
    [theCopy setFilesToBePosted:[self.filesToBePosted mutableCopy]];
    [theCopy setDataToBePosted:[self.dataToBePosted mutableCopy]];
    [theCopy setUsername:[self.username copy]];
    [theCopy setPassword:[self.password copy]];
    [theCopy setClientCertificate:[self.clientCertificate copy]];
    [theCopy setClientCertificatePassword:[self.clientCertificatePassword copy]];
    [theCopy setResponseBlocks:[self.responseBlocks mutableCopy]];
    [theCopy setErrorBlocks:[self.errorBlocks mutableCopy]];
    [theCopy setMutableData:[self.mutableData mutableCopy]];
    [theCopy setNotModifiedHandlers:[self.notModifiedHandlers mutableCopy]];
    [theCopy setUploadProgressChangedHandlers:[self.uploadProgressChangedHandlers mutableCopy]];
    [theCopy setDownloadProgressChangedHandlers:[self.downloadProgressChangedHandlers mutableCopy]];
    [theCopy setDownloadStreams:[self.downloadStreams mutableCopy]];
    [theCopy setCachedResponse:[self.cachedResponse mutableCopy]];
    [theCopy setCacheHandlingBlock:self.cacheHandlingBlock];
    [theCopy setCredentialPersistence:self.credentialPersistence];
    
    return theCopy;
}

-(void) dealloc {

    [_connection cancel];
    _connection = nil;
}

-(void) updateHandlersFromOperation:(GCDNetworkOperation*) operation {
    
    [self.responseBlocks addObjectsFromArray:operation.responseBlocks];
    [self.errorBlocks addObjectsFromArray:operation.errorBlocks];
    [self.notModifiedHandlers addObjectsFromArray:operation.notModifiedHandlers];
    [self.uploadProgressChangedHandlers addObjectsFromArray:operation.uploadProgressChangedHandlers];
    [self.downloadProgressChangedHandlers addObjectsFromArray:operation.downloadProgressChangedHandlers];
    [self.downloadStreams addObjectsFromArray:operation.downloadStreams];
}

-(void) setCachedData:(NSData*) cachedData {
    
    self.cachedResponse = cachedData;
    [self operationSucceeded:YES];
}

-(void) updateOperationBasedOnPreviousHeaders:(NSMutableDictionary*) headers {
    
    NSString *lastModified = [headers objectForKey:@"Last-Modified"];
    NSString *eTag = [headers objectForKey:@"ETag"];
    if(lastModified) {
        [self.request setValue:lastModified forHTTPHeaderField:@"IF-MODIFIED-SINCE"];
    }
    
    if(eTag) {
        [self.request setValue:eTag forHTTPHeaderField:@"IF-NONE-MATCH"];
    }
}

-(void) setUsername:(NSString*) username password:(NSString*) password {
    
    self.username = username;
    self.password = password;
}

-(void) setUsername:(NSString*) username password:(NSString*) password basicAuth:(BOOL) bYesOrNo {
    
    [self setUsername:username password:password];
    NSString *base64EncodedString = [[[NSString stringWithFormat:@"%@:%@", self.username, self.password] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
    
    [self setAuthorizationHeaderValue:base64EncodedString forAuthType:@"Basic"];
}

-(void) onCompletion:(GCDNKResponseBlock) response onError:(GCDNKErrorBlock) error {
    
    [self.responseBlocks addObject:[response copy]];
    [self.errorBlocks addObject:[error copy]];
}

-(void) addCompletionHandler:(GCDNKResponseBlock) response errorHandler:(GCDNKErrorBlock) error {
    
    if(response)
        [self.responseBlocks addObject:[response copy]];
    if(error)
        [self.errorBlocks addObject:[error copy]];
}

-(void) onNotModified:(GCDNKVoidBlock)notModifiedBlock {
    
    [self.notModifiedHandlers addObject:[notModifiedBlock copy]];
}

-(void) onUploadProgressChanged:(GCDNKProgressBlock) uploadProgressBlock {
    
    [self.uploadProgressChangedHandlers addObject:[uploadProgressBlock copy]];
}

-(void) onDownloadProgressChanged:(GCDNKProgressBlock) downloadProgressBlock {
    
    [self.downloadProgressChangedHandlers addObject:[downloadProgressBlock copy]];
}

-(void) setUploadStream:(NSInputStream*) inputStream {
    
    //#warning Method not tested yet.
    self.request.HTTPBodyStream = inputStream;
}

-(void) addDownloadStream:(NSOutputStream*) outputStream {
    
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.downloadStreams addObject:outputStream];
}

- (id)init

{
    if((self = [super init])) {
        
        self.responseBlocks = [NSMutableArray array];
        self.errorBlocks = [NSMutableArray array];
        
        self.filesToBePosted = [NSMutableArray array];
        self.dataToBePosted = [NSMutableArray array];
        self.fieldsToBePosted = [NSMutableDictionary dictionary];
        
        self.notModifiedHandlers = [NSMutableArray array];
        self.uploadProgressChangedHandlers = [NSMutableArray array];
        self.downloadProgressChangedHandlers = [NSMutableArray array];
        self.downloadStreams = [NSMutableArray array];
        
        self.credentialPersistence = NSURLCredentialPersistenceForSession;
        
        self.stringEncoding = NSUTF8StringEncoding; // use a delegate to get these values later
        
        self.state = GCDNetworkOperationStateReady;
    }
    
    return self;
}

- (void)buildWithURLString:(NSString *)aURLString
                    params:(NSMutableDictionary *)params
                httpMethod:(NSString *)method

{
    NSURL *finalURL = nil;
    
    if(params)
        self.fieldsToBePosted = params;
    
    if ([method isEqualToString:@"GET"])
        self.cacheHeaders = [NSMutableDictionary dictionary];
    
    if (([method isEqualToString:@"GET"] ||
         [method isEqualToString:@"DELETE"]) && (params && [params count] > 0)) {
        
        finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", aURLString,
                                         [self encodedPostDataString]]];
    } else {
        finalURL = [NSURL URLWithString:aURLString];
    }
    
    self.request = [NSMutableURLRequest requestWithURL:finalURL
                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                       timeoutInterval:GCDKNetworkKitRequestTimeOutInSeconds];
    
    [self.request setHTTPMethod:method];
    
    [self.request setValue:[NSString stringWithFormat:@"%@, en-us",
                            [[NSLocale preferredLanguages] componentsJoinedByString:@", "]
                            ] forHTTPHeaderField:@"Accept-Language"];
    
    if (([method isEqualToString:@"POST"] ||
         [method isEqualToString:@"PUT"]) && (params && [params count] > 0)) {
        
        self.postDataEncoding = GCDNKPostDataEncodingTypeURL;
    }
}

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params
             httpMethod:(NSString *)method

{
    if((self = [super init])) {
        
        self.responseBlocks = [NSMutableArray array];
        self.errorBlocks = [NSMutableArray array];
        
        self.filesToBePosted = [NSMutableArray array];
        self.dataToBePosted = [NSMutableArray array];
        self.fieldsToBePosted = [NSMutableDictionary dictionary];
        
        self.notModifiedHandlers = [NSMutableArray array];
        self.uploadProgressChangedHandlers = [NSMutableArray array];
        self.downloadProgressChangedHandlers = [NSMutableArray array];
        self.downloadStreams = [NSMutableArray array];
        
        self.credentialPersistence = NSURLCredentialPersistenceForSession;
        
        NSURL *myURL = nil;
        
        if(params){
            self.fieldsToBePosted = params;
        }
        
        self.stringEncoding = NSUTF8StringEncoding; // use a delegate to get these values later
        
        if ([method isEqualToString:@"GET"]){
            self.cacheHeaders = [NSMutableDictionary dictionary];
        }
        
        
        if (([method isEqualToString:@"GET"] ||
             [method isEqualToString:@"DELETE"]) && (params && [params count] > 0)) {
            
            myURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", aURLString,
                                          [self encodedPostDataString]]];
        } else {
            myURL = [NSURL URLWithString:aURLString];
        }
        
        if(myURL == nil) {
            
            UDLog(@"Cannot create a URL with %@ and parameters %@ and method %@", aURLString, self.fieldsToBePosted, method);
            return nil;
        }

        
        self.request = [NSMutableURLRequest requestWithURL:myURL
                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                           timeoutInterval:GCDKNetworkKitRequestTimeOutInSeconds];
        
        [self.request setHTTPMethod:method];
        
        [self.request setValue:[NSString stringWithFormat:@"%@, en-us",
                                [[NSLocale preferredLanguages] componentsJoinedByString:@", "]
                                ] forHTTPHeaderField:@"Accept-Language"];
        
        if (([method isEqualToString:@"POST"] ||
             [method isEqualToString:@"PUT"]) && (params && [params count] > 0)) {
            
            self.postDataEncoding = GCDNKPostDataEncodingTypeURL;
        }
        
        self.state = GCDNetworkOperationStateReady;
    }
    
    return self;
}

-(void) addParams:(NSDictionary*) paramsDictionary {
    
    [self.fieldsToBePosted addEntriesFromDictionary:paramsDictionary];
}

-(void) addHeaders:(NSDictionary*) headersDictionary {
    
    [headersDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.request addValue:obj forHTTPHeaderField:key];
    }];
}

-(void) addHeader:(NSString*)key withValue:(NSString*)value {
    
    [self.request addValue:value forHTTPHeaderField:key];
}

-(void) setHeader:(NSString*)key withValue:(NSString*)value {
    
    [self.request setValue:value forHTTPHeaderField:key];
}

-(void) setAuthorizationHeaderValue:(NSString*) token forAuthType:(NSString*) authType {
    
    [self.request setValue:[NSString stringWithFormat:@"%@ %@", authType, token]
        forHTTPHeaderField:@"Authorization"];
}

/*
 Printing a GCDNetworkOperation object is printed in curl syntax
 */
-(NSString*) description {
    
    NSMutableString *displayString = [NSMutableString stringWithFormat:@"%@\nRequest\n-------\n%@",
                                      [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]],
                                      [self curlCommandLineString]];
    
    NSString *responseString = [self responseString];
    if([responseString length] > 0) {
        [displayString appendFormat:@"\n--------\nResponse\n--------\n%@\n", responseString];
    }
    
    return displayString;
}

-(NSString*) curlCommandLineString
{
    __block NSMutableString *displayString = [NSMutableString stringWithFormat:@"curl -X %@", self.request.HTTPMethod];
    
    if([self.filesToBePosted count] == 0 && [self.dataToBePosted count] == 0) {
        [[self.request allHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop)
         {
             [displayString appendFormat:@" -H \"%@: %@\"", key, val];
         }];
    }
    
    [displayString appendFormat:@" \"%@\"",  self.url];
    
    if ([self.request.HTTPMethod isEqualToString:@"POST"] || [self.request.HTTPMethod isEqualToString:@"PUT"]) {
        
        NSString *option = [self.filesToBePosted count] == 0 ? @"-d" : @"-F";
        if(self.postDataEncoding == GCDNKPostDataEncodingTypeURL) {
            [self.fieldsToBePosted enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                [displayString appendFormat:@" %@ \"%@=%@\"", option, key, obj];
            }];
        } else {
            [displayString appendFormat:@" -d \"%@\"", [self encodedPostDataString]];
        }
        
        
        [self.filesToBePosted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *thisFile = (NSDictionary*) obj;
            [displayString appendFormat:@" -F \"%@=@%@;asset=%@;type=%@\"", [thisFile objectForKey:@"name"],
             [thisFile objectForKey:@"filepath"],[thisFile objectForKey:@"asset"], [thisFile objectForKey:@"mimetype"]];
        }];
        
        /* Not sure how to do this via curl
         [self.dataToBePosted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         
         NSDictionary *thisData = (NSDictionary*) obj;
         [displayString appendFormat:@" --data-binary \"%@\"", [thisData objectForKey:@"data"]];
         }];*/
    }
    
    return displayString;
}

-(void) addData:(NSData*) data forKey:(NSString*) key {
    
    [self addData:data forKey:key mimeType:@"application/octet-stream" fileName:@"file"];
}

-(void) addData:(NSData*) data forKey:(NSString*) key mimeType:(NSString*) mimeType fileName:(NSString*) fileName {
    
    if ([self.request.HTTPMethod isEqualToString:@"GET"]) {
        [self.request setHTTPMethod:@"POST"];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          data, @"data",
                          key, @"name",
                          mimeType, @"mimetype",
                          fileName, @"filename",
                          nil];
    
    [self.dataToBePosted addObject:dict];
}


-(void) addAsset:(ALAsset*) inAssert forKey:(NSString*) key {
    
    if ([self.request.HTTPMethod isEqualToString:@"GET"]) {
        [self.request setHTTPMethod:@"POST"];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          inAssert, @"asset",
                          key, @"name",
                          @"application/octet-stream", @"mimetype",
                          nil];
    
    [self.filesToBePosted addObject:dict];
}

-(void) addFile:(NSString*) filePath forKey:(NSString*) key {
    
    [self addFile:filePath forKey:key mimeType:@"application/octet-stream"];
}

-(void) addFile:(NSString*) filePath forKey:(NSString*) key mimeType:(NSString*) mimeType {
    
    if ([self.request.HTTPMethod isEqualToString:@"GET"]) {
        [self.request setHTTPMethod:@"POST"];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          filePath, @"filepath",
                          key, @"name",
                          mimeType, @"mimetype",
                          nil];
    
    [self.filesToBePosted addObject:dict];    
}

-(NSData*) bodyData {
    
    if([self.filesToBePosted count] == 0 && [self.dataToBePosted count] == 0) {
        
        return self.postDataEncodingHandler();//[[self encodedPostDataString] dataUsingEncoding:self.stringEncoding];
    }
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSMutableData *body = [NSMutableData data];
    __block NSUInteger postLength = 0;
    
    [self.fieldsToBePosted enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
                                     boundary, key, obj];
        
        [body appendData:[thisFieldString dataUsingEncoding:[self stringEncoding]]];
        [body appendData:[@"\r\n" dataUsingEncoding:[self stringEncoding]]];
    }];
    
    [self.filesToBePosted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *thisFile = (NSDictionary*) obj;
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",
                                     boundary,
                                     [thisFile objectForKey:@"name"],
                                     [[thisFile objectForKey:@"filepath"] lastPathComponent],
                                     [thisFile objectForKey:@"mimetype"]];
        
        [body appendData:[thisFieldString dataUsingEncoding:[self stringEncoding]]];
        [body appendData: [NSData dataWithContentsOfFile:[thisFile objectForKey:@"filepath"]]];
        [body appendData:[@"\r\n" dataUsingEncoding:[self stringEncoding]]];
    }];
    
    [self.dataToBePosted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *thisDataObject = (NSDictionary*) obj;
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",
                                     boundary,
                                     [thisDataObject objectForKey:@"name"],
                                     [thisDataObject objectForKey:@"filename"],
                                     [thisDataObject objectForKey:@"mimetype"]];
        
        [body appendData:[thisFieldString dataUsingEncoding:[self stringEncoding]]];
        [body appendData:[thisDataObject objectForKey:@"data"]];
        [body appendData:[@"\r\n" dataUsingEncoding:[self stringEncoding]]];
    }];
    
    if (postLength >= 1)
        [self.request setValue:[NSString stringWithFormat:@"%lu",(unsigned long) postLength] forHTTPHeaderField:@"content-length"];
    
    [body appendData: [[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:self.stringEncoding]];
    
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
    
    if(([self.filesToBePosted count] > 0) || ([self.dataToBePosted count] > 0)) {
        [self.request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, boundary]
            forHTTPHeaderField:@"Content-Type"];
        
        [self.request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    }
    
    return body;
}

-(void) setCacheHandler:(GCDNKCacheBlock) cacheHandler {
    
    self.cacheHandlingBlock = cacheHandler;
}

#pragma mark -
#pragma mark Handle File stream method


//- (NSString *)generateBoundaryString
//{
//    CFUUIDRef       uuid;
//    CFStringRef     uuidStr;
//    NSString *      result;
//    
//    uuid = CFUUIDCreate(NULL);
//    assert(uuid != NULL);
//    
//    uuidStr = CFUUIDCreateString(NULL, uuid);
//    assert(uuidStr != NULL);
//    
//    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
//    
//    CFRelease(uuidStr);
//    CFRelease(uuid);
//    
//    return result;
//}

//- (void)startSendFile:(NSDictionary *)fileDict
//{
//    NSString *              boundaryStr;
//    NSString *              contentType;
//    NSString *              bodyPrefixStr;
//    NSString *              bodySuffixStr;
//    NSNumber *              fileLengthNum;
//    unsigned long long      bodyLength;
//    NSInputStream *         consStream;
//    NSOutputStream *        prodStream;
//    
//    [self.request setAllHTTPHeaderFields:[NSDictionary dictionary]];
//    
//    NSString *filePath = [fileDict objectForKey:@"filepath"];
//    contentType = [fileDict objectForKey:@"mimetype"];
//    NSString *nameValue = [fileDict objectForKey:@"name"];
//    
//    assert(filePath != nil);
//    assert([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
//    //assert( [filePath.pathExtension isEqual:@"png"] || [filePath.pathExtension isEqual:@"jpg"] );
//    
//    assert(self.connection == nil);         // don't tap send twice in a row!
//    assert(self.bodyPrefixData == nil);     // ditto
//    assert(self.fileStream == nil);         // ditto
//    assert(self.bodySuffixData == nil);     // ditto
//    assert(self.consumerStream == nil);     // ditto
//    assert(self.producerStream == nil);     // ditto
//    assert(self.buffer == NULL);            // ditto
//    assert(self.bufferOnHeap == NULL);      // ditto
//    
//    // Determine the MIME type of the file.
//    
//    if ( [[filePath.pathExtension lowercaseString] isEqual:@"png"] ) {
//        contentType = @"image/png";
//    } else if ( [[filePath.pathExtension lowercaseString] isEqual:@"jpg"] ) {
//        contentType = @"image/jpg";
//    } else if ( [[filePath.pathExtension lowercaseString] isEqual:@"gif"] ) {
//        contentType = @"image/gif";
//    } else {
//        //assert(NO);
//        //contentType = nil;          // quieten a warning
//        
//        contentType=@"application/octet-stream";
//    }
//    
//    // Calculate the multipart/form-data body.  For more information about the
//    // format of the prefix and suffix, see:
//    //
//    // o HTML 4.01 Specification
//    //   Forms
//    //   <http://www.w3.org/TR/html401/interact/forms.html#h-17.13.4>
//    //
//    // o RFC 2388 "Returning Values from Forms: multipart/form-data"
//    //   <http://www.ietf.org/rfc/rfc2388.txt>
//    
//    boundaryStr = [self generateBoundaryString];
//    assert(boundaryStr != nil);
//    
//    NSMutableString *boundaryStrMut=[NSMutableString string];
//    
//    [self.fieldsToBePosted enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        
//        NSString *thisFieldString = [NSString stringWithFormat:
//                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
//                                     boundaryStr, key, obj];
//        
//        [boundaryStrMut appendString:thisFieldString];
//        [boundaryStrMut appendString:@"\r\n"];
//    }];
//    
//    //文件长度
//    fileLengthNum = (NSNumber *) [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL] objectForKey:NSFileSize];
//    assert( [fileLengthNum isKindOfClass:[NSNumber class]] );
//    
//    _alreadySentLength=0;
//    _toSendLength=fileLengthNum.doubleValue;
//    double fileOffset=0;
//    //云备份,文件偏移
//    if ([nameValue isEqualToString:@"uploadfile"]) {
//        NSString *ctrange=[self.fieldsToBePosted objectForKey:@"ctrange"];
//        NSArray *rangeArray = [ctrange componentsSeparatedByString:@"-"];
//        if (rangeArray.count>=2) {
//            NSString *offsetStr = [rangeArray objectAtIndex:0];
//            fileOffset = offsetStr.doubleValue;
//            NSString *lenStr = [rangeArray objectAtIndex:1];
//            _toSendLength=lenStr.doubleValue-fileOffset;
//        }
//    }
//    
//    NSString *bodyPrefixStrLast = [NSString stringWithFormat:
//                                   @
//                                   // empty preamble
//                                   "\r\n"
//                                   "--%@\r\n"
//                                   "Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n"
//                                   "Content-Type: %@\r\n"
//                                   "Content-Transfer-Encoding: binary\r\n"
//                                   "\r\n",
//                                   boundaryStr,
//                                   nameValue,
//                                   [filePath lastPathComponent],       // +++ very broken for non-ASCII
//                                   contentType
//                                   ];
//    
//    [boundaryStrMut appendString:bodyPrefixStrLast];
//    
//    bodyPrefixStr=boundaryStrMut;
//    assert(bodyPrefixStr != nil);
//    
//    
//    bodySuffixStr = [NSString stringWithFormat:
//                     @
//                     "\r\n"
//                     "--%@\r\n"
//                     "Content-Disposition: form-data; name=\"%@\"\r\n"
//                     "\r\n"
//                     "Upload File\r\n"
//                     "--%@--\r\n"
//                     "\r\n"
//                     //empty epilogue
//                     ,
//                     boundaryStr,
//                     nameValue,
//                     boundaryStr
//                     ];
//    
//    assert(bodySuffixStr != nil);
//    
//    self.bodyPrefixData = [bodyPrefixStr dataUsingEncoding:self.stringEncoding];//NSASCIIStringEncoding
//    assert(self.bodyPrefixData != nil);
//    self.bodySuffixData = [bodySuffixStr dataUsingEncoding:self.stringEncoding];//NSASCIIStringEncoding
//    assert(self.bodySuffixData != nil);
//    
//    bodyLength =
//    (unsigned long long) [self.bodyPrefixData length]
//    + _toSendLength
//    + (unsigned long long) [self.bodySuffixData length];
//    
//    // Open a stream for the file we're going to send.  We open this stream
//    // straight away because there's no need to delay.
//    
//    self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
//    assert(self.fileStream != nil);
//    [self.fileStream setProperty:[NSNumber numberWithDouble:fileOffset]
//                          forKey:NSStreamFileCurrentOffsetKey];
//    
//    [self.fileStream open];
//    
//    // Open producer/consumer streams.  We open the producerStream straight
//    // away.  We leave the consumerStream alone; NSURLConnection will deal
//    // with it.
//    
//    [NSStream createBoundInputStream:&consStream outputStream:&prodStream bufferSize:32768];
//    assert(consStream != nil);
//    assert(prodStream != nil);
//    self.consumerStream = consStream;
//    self.producerStream = prodStream;
//    
//    self.producerStream.delegate = self;
//    [self.producerStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    [self.producerStream open];
//    
//    // Set up our state to send the body prefix first.
//    
//    self.buffer      = [self.bodyPrefixData bytes];
//    self.bufferLimit = [self.bodyPrefixData length];
//    
//    [self.request setHTTPBodyStream:self.consumerStream];
//    
//    //Default string encoding is NSASCIIStringEncoding
//    //[self.request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryStr] forHTTPHeaderField:@"Content-Type"];
//    
//    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
//    
//    [self.request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, boundaryStr]
//        forHTTPHeaderField:@"Content-Type"];
//    
//    [self.request setValue:[NSString stringWithFormat:@"%llu", bodyLength] forHTTPHeaderField:@"Content-Length"];
//}
//
//- (void)startSendAsset:(NSDictionary *)assetDict
//{
//    NSString *              boundaryStr;
//    NSString *              contentType;
//    NSString *              bodyPrefixStr;
//    NSString *              bodySuffixStr;
//    NSNumber *              fileLengthNum;
//    unsigned long long      bodyLength;
//    NSInputStream *         consStream;
//    NSOutputStream *        prodStream;
//    
//    [self.request setAllHTTPHeaderFields:[NSDictionary dictionary]];
//    
//    ALAsset *inAsset=[assetDict objectForKey:@"asset"];
//    contentType = [assetDict objectForKey:@"mimetype"];
//    NSString *nameValue = [assetDict objectForKey:@"name"];
//    
//    NSString *generalFileName = nil;
//    if ([ALAssetRepresentation instancesRespondToSelector:@selector(filename)]) {
//        generalFileName = [[inAsset defaultRepresentation] filename];
//    }
//    else {
//        NSString *extension = [[inAsset.defaultRepresentation.url lastPathComponent] pathExtension];
//        generalFileName = [NSString stringWithFormat:@"%i.%@", abs(arc4random()), extension];
//    }
//    NSString *filePath=generalFileName;
//    
//    
//    assert(self.connection == nil);         // don't tap send twice in a row!
//    assert(self.bodyPrefixData == nil);     // ditto
//    assert(self.fileStream == nil);         // ditto
//    assert(self.bodySuffixData == nil);     // ditto
//    assert(self.consumerStream == nil);     // ditto
//    assert(self.producerStream == nil);     // ditto
//    assert(self.buffer == NULL);            // ditto
//    assert(self.bufferOnHeap == NULL);      // ditto
//    
//    // Determine the MIME type of the file.
//    
//    if ( [filePath.pathExtension isEqual:@"png"] ) {
//        contentType = @"image/png";
//    } else if ( [filePath.pathExtension isEqual:@"jpg"] ) {
//        contentType = @"image/jpeg";
//    } else if ( [filePath.pathExtension isEqual:@"gif"] ) {
//        contentType = @"image/gif";
//    } else {
//        //assert(NO);
//        //contentType = nil;          // quieten a warning
//        
//        contentType=@"application/octet-stream";
//    }
//    
//    // Calculate the multipart/form-data body.  For more information about the
//    // format of the prefix and suffix, see:
//    //
//    // o HTML 4.01 Specification
//    //   Forms
//    //   <http://www.w3.org/TR/html401/interact/forms.html#h-17.13.4>
//    //
//    // o RFC 2388 "Returning Values from Forms: multipart/form-data"
//    //   <http://www.ietf.org/rfc/rfc2388.txt>
//    
//    boundaryStr = [self generateBoundaryString];
//    assert(boundaryStr != nil);
//    
//    NSMutableString *boundaryStrMut=[NSMutableString string];
//    
//    [self.fieldsToBePosted enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        
//        NSString *thisFieldString = [NSString stringWithFormat:
//                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
//                                     boundaryStr, key, obj];
//        
//        [boundaryStrMut appendString:thisFieldString];
//        [boundaryStrMut appendString:@"\r\n"];
//    }];
//    
//    fileLengthNum = [NSNumber numberWithLongLong:[[inAsset defaultRepresentation] size]] ;
//    assert( [fileLengthNum isKindOfClass:[NSNumber class]] );
//    _alreadySentLength=0;
//    _toSendLength=fileLengthNum.doubleValue;
//    double fileOffset=0;
//    //云备份,文件偏移
//    if ([nameValue isEqualToString:@"uploadfile"]) {
//        NSString *ctrange=[self.fieldsToBePosted objectForKey:@"ctrange"];
//        NSArray *rangeArray = [ctrange componentsSeparatedByString:@"-"];
//        if (rangeArray.count>=2) {
//            NSString *offsetStr = [rangeArray objectAtIndex:0];
//            fileOffset = offsetStr.doubleValue;
//            NSString *lenStr = [rangeArray objectAtIndex:1];
//            _toSendLength=lenStr.doubleValue-fileOffset;
//        }
//    }
//    
//    NSString *bodyPrefixStrLast = [NSString stringWithFormat:
//                                   @
//                                   // empty preamble
//                                   "\r\n"
//                                   "--%@\r\n"
//                                   "Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n"
//                                   "Content-Type: %@\r\n"
//                                   "Content-Transfer-Encoding: binary\r\n"
//                                   "\r\n",
//                                   boundaryStr,
//                                   nameValue,
//                                   [filePath lastPathComponent],       // +++ very broken for non-ASCII
//                                   contentType
//                                   ];
//    
//    [boundaryStrMut appendString:bodyPrefixStrLast];
//    
//    bodyPrefixStr=boundaryStrMut;
//    assert(bodyPrefixStr != nil);
//    
//    
//    bodySuffixStr = [NSString stringWithFormat:
//                     @
//                     "\r\n"
//                     "--%@\r\n"
//                     "Content-Disposition: form-data; name=\"%@\"\r\n"
//                     "\r\n"
//                     "Upload File\r\n"
//                     "--%@--\r\n"
//                     "\r\n"
//                     //empty epilogue
//                     ,
//                     boundaryStr,
//                     nameValue,
//                     boundaryStr
//                     ];
//    
//    assert(bodySuffixStr != nil);
//    
//    self.bodyPrefixData = [bodyPrefixStr dataUsingEncoding:self.stringEncoding];//NSASCIIStringEncoding
//    assert(self.bodyPrefixData != nil);
//    self.bodySuffixData = [bodySuffixStr dataUsingEncoding:self.stringEncoding];//NSASCIIStringEncoding
//    assert(self.bodySuffixData != nil);
//    
//    bodyLength =
//    (unsigned long long) [self.bodyPrefixData length]
//    + _toSendLength
//    + (unsigned long long) [self.bodySuffixData length];
//    
//    // Open a stream for the file we're going to send.  We open this stream
//    // straight away because there's no need to delay.
//    
//    self.fileStream = nil;
//    self.fileAsset = inAsset;
//    self.fileAssetOffset = fileOffset;
//    
//    // Open producer/consumer streams.  We open the producerStream straight
//    // away.  We leave the consumerStream alone; NSURLConnection will deal
//    // with it.
//    
//    [NSStream createBoundInputStream:&consStream outputStream:&prodStream bufferSize:32768];
//    assert(consStream != nil);
//    assert(prodStream != nil);
//    self.consumerStream = consStream;
//    self.producerStream = prodStream;
//    
//    self.producerStream.delegate = self;
//    [self.producerStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    [self.producerStream open];
//    
//    // Set up our state to send the body prefix first.
//    
//    self.buffer      = [self.bodyPrefixData bytes];
//    self.bufferLimit = [self.bodyPrefixData length];
//    
//    [self.request setHTTPBodyStream:self.consumerStream];
//    
//    //Default string encoding is NSASCIIStringEncoding
//    //[self.request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryStr] forHTTPHeaderField:@"Content-Type"];
//    
//    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
//    
//    [self.request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, boundaryStr]
//        forHTTPHeaderField:@"Content-Type"];
//    
//    [self.request setValue:[NSString stringWithFormat:@"%llu", bodyLength] forHTTPHeaderField:@"Content-Length"];
//}
//
//- (void)clearFileStream
//{
//    if (self.bufferOnHeap) {
//        free(self.bufferOnHeap);
//        self.bufferOnHeap = NULL;
//    }
//    self.buffer = NULL;
//    self.bufferOffset = 0;
//    self.bufferLimit  = 0;
//    if (self.connection != nil) {
//        [self.connection cancel];
//        self.connection = nil;
//    }
//    self.bodyPrefixData = nil;
//    if (self.producerStream != nil) {
//        self.producerStream.delegate = nil;
//        [self.producerStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//        [self.producerStream close];
//        self.producerStream = nil;
//    }
//    self.consumerStream = nil;
//    if (self.fileStream != nil) {
//        [self.fileStream close];
//        self.fileStream = nil;
//    }
//    
//    if (self.fileAsset) {
//        self.fileAsset=nil;
//    }
//    self.fileAssetOffset=0;
//    
//    self.bodySuffixData = nil;
//}
//
//- (void)stopSendWithStatus:(NSString *)statusString
//{
//    NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:statusString,NSLocalizedDescriptionKey, nil];
//    NSError *sendError = [NSError errorWithDomain:NSOSStatusErrorDomain code:1000 userInfo:errorDict];
//    [self operationFailedWithError:sendError];
//    [self endBackgroundTask];
//}
//
//- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
//// An NSStream delegate callback that's called when events happen on our
//// network stream.
//{
//#pragma unused(aStream)
//    assert(aStream == self.producerStream);
//    
//    switch (eventCode) {
//        case NSStreamEventOpenCompleted: {
//            // UDLog(@"producer stream opened");
//        } break;
//        case NSStreamEventHasBytesAvailable: {
//            assert(NO);     // should never happen for the output stream
//        } break;
//        case NSStreamEventHasSpaceAvailable: {
//            // Check to see if we've run off the end of our buffer.  If we have,
//            // work out the next buffer of data to send.
//            
//            if (self.bufferOffset == self.bufferLimit) {
//                
//                // See if we're transitioning from the prefix to the file data.
//                // If so, allocate a file buffer.
//                
//                if (self.bodyPrefixData != nil) {
//                    self.bodyPrefixData = nil;
//                    
//                    assert(self.bufferOnHeap == NULL);
//                    self.bufferOnHeap = malloc(kPostBufferSize);
//                    assert(self.bufferOnHeap != NULL);
//                    self.buffer = self.bufferOnHeap;
//                    
//                    self.bufferOffset = 0;
//                    self.bufferLimit  = 0;
//                }
//                
//                // If we still have file data to send, read the next chunk.
//                
//                if (self.fileStream != nil) {
//                    NSInteger   bytesRead=0;
//                    NSInteger   bytesToRead=kPostBufferSize;
//                    
//                    NSInteger leftLength = _toSendLength-_alreadySentLength;
//                    if (leftLength<bytesToRead) {
//                        bytesToRead=leftLength;
//                    }
//                    
//                    bytesRead = [self.fileStream read:self.bufferOnHeap maxLength:bytesToRead];
//                    
//                    if (bytesRead == -1) {
//                        [self stopSendWithStatus:@"File read error"];
//                    } else if (bytesRead != 0) {
//                        self.bufferOffset = 0;
//                        self.bufferLimit  = bytesRead;
//                        _alreadySentLength+=bytesRead;
//                    } else {
//                        // If we hit the end of the file, transition to sending the
//                        // suffix.
//                        
//                        [self.fileStream close];
//                        self.fileStream = nil;
//                        
//                        assert(self.bufferOnHeap != NULL);
//                        free(self.bufferOnHeap);
//                        self.bufferOnHeap = NULL;
//                        self.buffer       = [self.bodySuffixData bytes];
//                        
//                        self.bufferOffset = 0;
//                        self.bufferLimit  = [self.bodySuffixData length];
//                    }
//                }
//                else if (self.fileAsset != nil) {
//                    NSInteger   bytesRead=0;
//                    NSInteger   bytesToRead=kPostBufferSize;
//                    
//                    NSInteger leftLength = _toSendLength-_alreadySentLength;
//                    if (leftLength<bytesToRead) {
//                        bytesToRead=leftLength;
//                    }
//                    
//                    //bytesRead = [self.fileStream read:self.bufferOnHeap maxLength:kPostBufferSize];
//                    
//                    NSError *error = nil;
//                    bytesRead = [[self.fileAsset defaultRepresentation] getBytes:self.bufferOnHeap fromOffset:self.fileAssetOffset length:bytesToRead error:&error];
//                    self.fileAssetOffset += bytesRead;
//                    
//                    if (error) {
//                        bytesRead=-1;
//                        UDLog(@"ERROR:%@",[error localizedDescription]);
//                    }
//                    
//                    if (bytesRead == -1) {
//                        [self stopSendWithStatus:@"File read error"];
//                    } else if (bytesRead != 0) {
//                        self.bufferOffset = 0;
//                        self.bufferLimit  = bytesRead;
//                        _alreadySentLength+=bytesRead;
//                    } else {
//                        // If we hit the end of the file, transition to sending the
//                        // suffix.
//                        
//                        self.fileAsset = nil;
//                        self.fileAssetOffset=0;
//                        
//                        assert(self.bufferOnHeap != NULL);
//                        free(self.bufferOnHeap);
//                        self.bufferOnHeap = NULL;
//                        self.buffer       = [self.bodySuffixData bytes];
//                        
//                        self.bufferOffset = 0;
//                        self.bufferLimit  = [self.bodySuffixData length];
//                    }
//                }
//                
//                // If we've failed to produce any more data, we close the stream
//                // to indicate to NSURLConnection that we're all done.  We only do
//                // this if producerStream is still valid to avoid running it in the
//                // file read error case.
//                
//                if ( (self.bufferOffset == self.bufferLimit) && (self.producerStream != nil) ) {
//                    // We set our delegate callback to nil because we don't want to
//                    // be called anymore for this stream.  However, we can't
//                    // remove the stream from the runloop (doing so prevents the
//                    // URL from ever completing) and nor can we nil out our
//                    // stream reference (that causes all sorts of wacky crashes).
//                    //
//                    // +++ Need bug numbers for these problems.
//                    self.producerStream.delegate = nil;
//                    // [self.producerStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//                    [self.producerStream close];
//                    // self.producerStream = nil;
//                }
//            }
//            
//            // Send the next chunk of data in our buffer.
//            
//            if (self.bufferOffset != self.bufferLimit) {
//                NSInteger   bytesWritten;
//                bytesWritten = [self.producerStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
//                if (bytesWritten <= 0) {
//                    [self stopSendWithStatus:@"Network write error"];
//                } else {
//                    self.bufferOffset += bytesWritten;
//                }
//            }
//        } break;
//        case NSStreamEventErrorOccurred: {
//            UDLog(@"producer stream error %@", [aStream streamError]);
//            [self stopSendWithStatus:@"Stream open error"];
//        } break;
//        case NSStreamEventEndEncountered: {
//            //assert(NO);     // should never happen for the output stream
//            //[self stopSendWithStatus:@"Network interupted"];
//            [self stopSendWithStatus:NSLocalizedString(@"网络异常，请重试", nil)];
//        } break;
//        default: {
//            assert(NO);
//        } break;
//    }
//}
//
//-(void) handleFileStream
//{
//    for (int i=0; i<self.filesToBePosted.count; i++) {
//        NSDictionary *thisFile = [self.filesToBePosted objectAtIndex:i];
//        NSString *filePathStr = [thisFile objectForKey:@"filepath"];
//        if (filePathStr) {
//            [self startSendFile:thisFile];
//            continue;
//        }
//        ALAsset *asset=[thisFile objectForKey:@"asset"];
//        if (asset) {
//            [self startSendAsset:thisFile];
//        }
//    }
//}

#pragma mark -
#pragma mark Main method

-(void) endBackgroundTask {
    
#if TARGET_OS_IPHONE
    __block GCDNetworkOperation *blockParam = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (blockParam.backgroundTaskId != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:blockParam.backgroundTaskId];
            blockParam.backgroundTaskId = UIBackgroundTaskInvalid;
        }
        blockParam=nil;
    });
#endif
}

- (void) start
{
    #if TARGET_OS_IPHONE
    __block GCDNetworkOperation *blockParam = self;
    
    self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        __block GCDNetworkOperation *blockParamMain = blockParam;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (blockParamMain.backgroundTaskId != UIBackgroundTaskInvalid)
            {
                [[UIApplication sharedApplication] endBackgroundTask:blockParamMain.backgroundTaskId];
                blockParamMain.backgroundTaskId = UIBackgroundTaskInvalid;
                [blockParamMain cancel];
            }
            blockParamMain=nil;
        });
        blockParam=nil;
    }];
    
    #endif
    
    if(!self.isCancelled) {
        
        if (([self.request.HTTPMethod isEqualToString:@"POST"] ||
             [self.request.HTTPMethod isEqualToString:@"PUT"] ||
             [self.request.HTTPMethod isEqualToString:@"PATCH"]) && !self.request.HTTPBodyStream) {
            
            [self.request setHTTPBody:[self bodyData]];
        }
        
        __block GCDNetworkOperation *blockParam = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            blockParam.connection = [[NSURLConnection alloc] initWithRequest:blockParam.request
                                                              delegate:blockParam
                                                      startImmediately:NO];
            
            [blockParam.connection scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                       forMode:NSRunLoopCommonModes];
            
            [blockParam.connection start];
            blockParam=nil;
        });
        
        self.state = GCDNetworkOperationStateExecuting;
    }
    else {
        self.state = GCDNetworkOperationStateFinished;
        [self endBackgroundTask];
    }
}

#pragma -
#pragma mark NSOperation stuff

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isReady {
    
    return (self.state == GCDNetworkOperationStateReady);
}

- (BOOL)isFinished
{
    return (self.state == GCDNetworkOperationStateFinished);
}

- (BOOL)isExecuting {
    
    return (self.state == GCDNetworkOperationStateExecuting);
}

-(void) cancel {
    
//    if([self isFinished])
//        return;
    
    @synchronized(self) {
        self.isCancelled = YES;
        
        [self.connection cancel];
        
        [self.responseBlocks removeAllObjects];
        self.responseBlocks = nil;
        
        [self.errorBlocks removeAllObjects];
        self.errorBlocks = nil;
        
        [self.notModifiedHandlers removeAllObjects];
        self.notModifiedHandlers = nil;
        
        [self.uploadProgressChangedHandlers removeAllObjects];
        self.uploadProgressChangedHandlers = nil;
        
        [self.downloadProgressChangedHandlers removeAllObjects];
        self.downloadProgressChangedHandlers = nil;
        
        for(NSOutputStream *stream in self.downloadStreams)
            [stream close];
        
        [self.downloadStreams removeAllObjects];
        self.downloadStreams = nil;
        
        self.authHandler = nil;
        self.mutableData = nil;
        self.downloadedDataSize = 0;
        
        self.cacheHandlingBlock = nil;
        
        if(self.state == GCDNetworkOperationStateExecuting)
            self.state = GCDNetworkOperationStateFinished; // This notifies the queue and removes the operation.
        // if the operation is not removed, the spinner continues to spin, not a good UX
        
        [self endBackgroundTask];
    }
}

#pragma mark -
#pragma mark NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    self.state = GCDNetworkOperationStateFinished;
    self.mutableData = nil;
    self.downloadedDataSize = 0;
    for(NSOutputStream *stream in self.downloadStreams)
        [stream close];
    
    [self operationFailedWithError:error];
    [self endBackgroundTask];
}

// https://developer.apple.com/library/mac/#documentation/security/conceptual/CertKeyTrustProgGuide/iPhone_Tasks/iPhone_Tasks.html
OSStatus extractIdentityAndTrust(CFDataRef inPKCS12Data,        // 5
                                 SecIdentityRef *outIdentity,
                                 SecTrustRef *outTrust,
                                 CFStringRef keyPassword)
{
    OSStatus securityError = errSecSuccess;
    
    
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { keyPassword };
    CFDictionaryRef optionsDictionary = NULL;
    
    /* Create a dictionary containing the passphrase if one
     was specified.  Otherwise, create an empty dictionary. */
    optionsDictionary = CFDictionaryCreate(
                                           NULL, keys,
                                           values, (keyPassword ? 1 : 0),
                                           NULL, NULL);  // 6
    
    CFArrayRef items = NULL;
    securityError = SecPKCS12Import(inPKCS12Data,
                                    optionsDictionary,
                                    &items);                    // 7
    
    
    //
    if (securityError == 0) {                                   // 8
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust,
                                             kSecImportItemIdentity);
        CFRetain(tempIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        
        CFRetain(tempTrust);
        *outTrust = (SecTrustRef)tempTrust;
    }
    
    if (optionsDictionary)
        CFRelease(optionsDictionary);                           // 9
    
    if (items)
        CFRelease(items);
    
    return securityError;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    if (challenge.previousFailureCount == 0) {
        
        if (((challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodDefault) ||
             (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic) ||
             (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPDigest) ||
             (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM)) &&
            (self.username && self.password))
        {
            
            // for NTLM, we will assume user name to be of the form "domain\\username"
            NSURLCredential *credential = [NSURLCredential credentialWithUser:self.username
                                                                     password:self.password
                                                                  persistence:self.credentialPersistence];
            
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        }
        else if ((challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) && self.clientCertificate) {
            
            NSError *error = nil;
            NSData *certData = [[NSData alloc] initWithContentsOfFile:self.clientCertificate options:0 error:&error];
            
            SecIdentityRef identity;
            SecTrustRef trust;
            OSStatus status = extractIdentityAndTrust((__bridge CFDataRef) certData, &identity, &trust, (__bridge CFStringRef) self.clientCertificatePassword);
            if(status == errSecSuccess) {
                SecCertificateRef certificate;
                SecIdentityCopyCertificate(identity, &certificate);
                const void *certs[] = { certificate };
                CFArrayRef certsArray = CFArrayCreate(NULL, certs, 1, NULL);
                NSArray *certificatesForCredential = (__bridge NSArray *)certsArray;
                NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity
                                                                         certificates:certificatesForCredential
                                                                          persistence:NSURLCredentialPersistencePermanent];
                [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
                CFRelease(identity);
                CFRelease(certificate);
                CFRelease(certsArray);
            } else {
                [challenge.sender cancelAuthenticationChallenge:challenge];
            }
        }
        else if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            
            if(challenge.previousFailureCount < 5) {
                
                self.serverTrust = challenge.protectionSpace.serverTrust;
                SecTrustResultType result;
                SecTrustEvaluate(self.serverTrust, &result);
                
                if(result == kSecTrustResultProceed ||
                   result == kSecTrustResultUnspecified //The cert is valid, but user has not explicitly accepted/denied. Ok to proceed (Ch 15: iOS PTL :Pg 269)
                   ) {
                    
                    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
                } else {
                    
                    // invalid or revoked certificate
                    if(self.shouldContinueWithInvalidCertificate) {
                        UDLog(@"Certificate is invalid, but self.shouldContinueWithInvalidCertificate is YES");
                        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
                    } else {
                        UDLog(@"Certificate is invalid, continuing without credentials. Might result in 401 Unauthorized");
                        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
                    }
                }
            } else {
                
                [challenge.sender cancelAuthenticationChallenge:challenge];
            }
        }
        else if (self.authHandler) {
            
            // forward the authentication to the view controller that created this operation
            // If this happens for NSURLAuthenticationMethodHTMLForm, you have to
            // do some shit work like showing a modal webview controller and close it after authentication.
            // I HATE THIS.
            self.authHandler(challenge);
        }
        else {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    } else {
        //  apple proposes to cancel authentication, which results in NSURLErrorDomain error -1012, but we prefer to trigger a 401
        //        [[challenge sender] cancelAuthenticationChallenge:challenge];
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSUInteger size = [self.response expectedContentLength] < 0 ? 0 : (NSUInteger)[self.response expectedContentLength];
    self.response = (NSHTTPURLResponse*) response;
    
    // dont' save data if the operation was created to download directly to a stream.
    if([self.downloadStreams count] == 0)
        self.mutableData = [NSMutableData dataWithCapacity:size];
    else
        self.mutableData = nil;
    
    for(NSOutputStream *stream in self.downloadStreams)
        [stream open];
    
    NSDictionary *httpHeaders = [self.response allHeaderFields];
    
    // if you attach a stream to the operation, MKNetworkKit will not cache the response.
    // Streams are usually "big data chunks" that doesn't need caching anyways.
    
    if([self.request.HTTPMethod isEqualToString:@"GET"] && [self.downloadStreams count] == 0) {
        
        // We have all this complicated cache handling since NSURLRequestReloadRevalidatingCacheData is not implemented
        // do cache processing only if the request is a "GET" method
        NSString *lastModified = [httpHeaders objectForKey:@"Last-Modified"];
        NSString *eTag = [httpHeaders objectForKey:@"ETag"];
        //NOTE
        NSString *expiresOn = [httpHeaders objectForKey:@"Expires"];
        
        NSString *contentType = [httpHeaders objectForKey:@"Content-Type"];
        // if contentType is image,
        
        NSDate *expiresOnDate = nil;
        
        if([contentType rangeOfString:@"image"].location != NSNotFound) {
            
            // For images let's assume a expiry date of 7 days if there is no eTag or Last Modified.
            if(!eTag && !lastModified)
                expiresOnDate = [[NSDate date] dateByAddingTimeInterval:GCDKNetworkKitDefaultImageCacheDuration];
            else
                expiresOnDate = [[NSDate date] dateByAddingTimeInterval:GCDKNetworkKitDefaultImageHeadRequestDuration];
        }
        
        NSString *cacheControl = [httpHeaders objectForKey:@"Cache-Control"]; // max-age, must-revalidate, no-cache
        NSArray *cacheControlEntities = [cacheControl componentsSeparatedByString:@","];
        
        for(NSString *substring in cacheControlEntities) {
            
            if([substring rangeOfString:@"max-age"].location != NSNotFound) {
                
                // do some processing to calculate expiresOn
                NSString *maxAge = nil;
                NSArray *array = [substring componentsSeparatedByString:@"="];
                if([array count] > 1)
                    maxAge = [array objectAtIndex:1];
                
                expiresOnDate = [[NSDate date] dateByAddingTimeInterval:[maxAge intValue]];
            }
            if([substring rangeOfString:@"no-cache"].location != NSNotFound) {
                
                // Don't cache this request
                expiresOnDate = [[NSDate date] dateByAddingTimeInterval:GCDKNetworkKitDefaultCacheDuration];
            }
        }
        
        // if there was a cacheControl entity, we would have a expiresOnDate that is not nil.
        // "Cache-Control" headers take precedence over "Expires" headers
        
       expiresOn  = [expiresOnDate rfc1123String];
        
        // now remember lastModified, eTag and expires for this request in cache
        if(expiresOn)
            [self.cacheHeaders setObject:expiresOn forKey:@"Expires"];
        if(lastModified)
            [self.cacheHeaders setObject:lastModified forKey:@"Last-Modified"];
        if(eTag)
            [self.cacheHeaders setObject:eTag forKey:@"ETag"];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if (self.downloadedDataSize == 0) {
        // This is the first batch of data
        // Check for a range header and make changes as neccesary
        NSString *rangeString = [[self request] valueForHTTPHeaderField:@"Range"];
        if ([rangeString hasPrefix:@"bytes="] && [rangeString hasSuffix:@"-"]) {
            NSString *bytesText = [rangeString substringWithRange:NSMakeRange(6, [rangeString length] - 7)];
            self.startPosition = [bytesText integerValue];
            self.downloadedDataSize = self.startPosition;
            UDLog(@"Resuming at %lu bytes", (unsigned long) self.startPosition);
        }
    }
    
    if([self.downloadStreams count] == 0)
        [self.mutableData appendData:data];
    
    for(NSOutputStream *stream in self.downloadStreams) {
        
        if ([stream hasSpaceAvailable]) {
            const uint8_t *dataBuffer = [data bytes];
            [stream write:&dataBuffer[0] maxLength:[data length]];
        }
    }
    
    self.downloadedDataSize += [data length];
    
    for(GCDNKProgressBlock downloadProgressBlock in self.downloadProgressChangedHandlers) {
        
        if([self.response expectedContentLength] > 0) {
            
            double progress = (double)(self.downloadedDataSize) / (double)(self.startPosition + [self.response expectedContentLength]);
            downloadProgressBlock(progress);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    for(GCDNKProgressBlock uploadProgressBlock in self.uploadProgressChangedHandlers) {
        
        if(totalBytesExpectedToWrite > 0) {
            uploadProgressBlock(((double)totalBytesWritten/(double)totalBytesExpectedToWrite));
        }
    }
}

// http://stackoverflow.com/questions/1446509/handling-redirects-correctly-with-nsurlconnection
- (NSURLRequest *)connection: (NSURLConnection *)inConnection
             willSendRequest: (NSURLRequest *)inRequest
            redirectResponse: (NSURLResponse *)inRedirectResponse;
{
    NSMutableURLRequest *r = [self.request mutableCopy];
    if (inRedirectResponse) {
        [r setURL: [inRequest URL]];
    } else {
        // Note that we need to configure the Accept-Language header this late in processing
        // because NSURLRequest adds a default Accept-Language header late in the day, so we
        // have to undo that here.
        // For discussion see:
        // http://lists.apple.com/archives/macnetworkprog/2009/Sep/msg00022.html
        // http://stackoverflow.com/questions/5695914/nsurlrequest-where-an-app-can-find-the-default-headers-for-http-request
        NSString* accept_language = self.shouldSendAcceptLanguageHeader ? [self languagesFromLocale] : nil;
        [r setValue:accept_language forHTTPHeaderField:@"Accept-Language"];
    }
    return r;
}

- (NSString*)languagesFromLocale {
    return [NSString stringWithFormat:@"%@, en-us", [[NSLocale preferredLanguages] componentsJoinedByString:@", "]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if([self isCancelled])
        return;
    
    self.state = GCDNetworkOperationStateFinished;
    
    for(NSOutputStream *stream in self.downloadStreams)
        [stream close];
    
    if (self.response.statusCode >= 200 && self.response.statusCode < 300 && ![self isCancelled]) {
        
        self.cachedResponse = nil; // remove cached data
        [self notifyCache];        
        [self operationSucceeded:NO];
        
    } 
    if (self.response.statusCode >= 300 && self.response.statusCode < 400) {
        
        if(self.response.statusCode == 301) {
            UDLog(@"%@ has moved to %@", self.url, [self.response.URL absoluteString]);
        }
        else if(self.response.statusCode == 304) {
            UDLog(@"%@ not modified", self.url);
            for(GCDNKVoidBlock notModifiedBlock in self.notModifiedHandlers) {
                
                notModifiedBlock();
            }
        }
        else if(self.response.statusCode == 307) {
            UDLog(@"%@ temporarily redirected", self.url);
        }
        else {
            UDLog(@"%@ returned status %d", self.url, (int) self.response.statusCode);
        }
        
    } else if (self.response.statusCode >= 400 && self.response.statusCode < 600 && ![self isCancelled]) {                        
        
        [self operationFailedWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                           code:self.response.statusCode
                                                       userInfo:self.response.allHeaderFields]];
    }  
    [self endBackgroundTask];
    
}

#pragma mark -
#pragma mark Our methods to get data

-(NSData*) responseData {
    
    if([self isFinished])
        return self.mutableData;
    else if(self.cachedResponse)
        return self.cachedResponse;
    else
        return nil;
}

-(NSString*)responseString {
    
    return [self responseStringWithEncoding:self.stringEncoding];
}

-(NSString*) responseStringWithEncoding:(NSStringEncoding) encoding {
    
    return [[NSString alloc] initWithData:[self responseData] encoding:encoding];
}

-(UIImage*) responseImage {
    
    return [UIImage imageWithData:[self responseData]];
}

-(void) decompressedResponseImageOfSize:(CGSize) size completionHandler:(void (^)(UIImage *decompressedImage)) imageDecompressionHandler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)([self responseData]), NULL);
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, 0, (__bridge CFDictionaryRef)(@{(id)kCGImageSourceShouldCache:@(YES)}));
        UIImage *decompressedImage = [UIImage imageWithCGImage:cgImage];
        if(source)
            CFRelease(source);
        if(cgImage)
            CGImageRelease(cgImage);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageDecompressionHandler(decompressedImage);
        });
    });
}

-(id) responseJSON {
    
    if(NSClassFromString(@"NSJSONSerialization")) {
        if([self responseData] == nil) return nil;
        NSError *error = nil;
        id returnValue = [NSClassFromString(@"NSJSONSerialization") JSONObjectWithData:[self responseData] options:0 error:&error];
        if(error) UDLog(@"JSON Parsing Error: %@", error);
        return returnValue;
    }
    else {
        UDLog("You are running on iOS 4. Subclass MKNO and override responseJSON to support custom JSON parsing");
        return [self responseString];
    }
}

-(void) responseJSONWithCompletionHandler:(void (^)(id jsonObject)) jsonDecompressionHandler {
    
    [self responseJSONWithOptions:0 completionHandler:jsonDecompressionHandler];
}

-(void) responseJSONWithOptions:(NSJSONReadingOptions) options completionHandler:(void (^)(id jsonObject)) jsonDecompressionHandler {
    
    if([self responseData] == nil) {
        
        jsonDecompressionHandler(nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSError *error = nil;
        id returnValue = [NSJSONSerialization JSONObjectWithData:[self responseData] options:options error:&error];
        if(error) {
            
            UDLog(@"JSON Parsing Error: %@", error);
            jsonDecompressionHandler(nil);
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            jsonDecompressionHandler(returnValue);
        });
    });
}

#pragma mark -
#pragma mark Overridable methods

-(void) operationSucceeded: (BOOL)isCacheData {
//    [self clearFileStream];
    
    for(GCDNKResponseBlock responseBlock in self.responseBlocks) {
        responseBlock(self,isCacheData);
    }
}

-(void) showLocalNotification {
#if TARGET_OS_IPHONE
    
    if(self.localNotification) {
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:self.localNotification];
    } else if(self.shouldShowLocalNotificationOnError) {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        localNotification.alertBody = [self.error localizedDescription];
        localNotification.alertAction = NSLocalizedString(@"Dismiss", @"");
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
#endif
}

-(void) operationFailedWithError:(NSError*) error {
    
//    [self clearFileStream];
    
    self.error = error;
    UDLog(@"%@, \nERROR:[%@]", self, [self.error localizedDescription]);
    for(GCDNKErrorBlock errorBlock in self.errorBlocks)
        errorBlock(error);
    
#if TARGET_OS_IPHONE
    UDLog(@"State: %lu", (unsigned long)[[UIApplication sharedApplication] applicationState]);
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        [self showLocalNotification];
#endif
    
}

@end
