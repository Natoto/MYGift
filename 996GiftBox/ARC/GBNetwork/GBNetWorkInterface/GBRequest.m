//
//  GBRequest.m
//  GameGifts
//
//  Created by Teiron-37 on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GBRequest.h"
#import "Reachability.h"
#import "GBResponse.h"
#import "GBNetwork.h"
#import "GCDNetworkKit.h"
#import "BaseParameter.h"

@implementation GBRequest

@synthesize responseBlock = _responseBlock;

- (id)initRequest {
    self = [super init];
    if (self) {
        _responseDataType = KResponseDataTypeBinary;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        _responseDataType = KResponseDataTypeBinary;
    }
    return self;
}

- (void)cancel
{
    self.parameters = nil;
    self.responseClass = nil;
    self.responseBlock = nil;
    self.cacheResponseBlock = nil;
    [super cancel];
}

- (void)buildRequest {
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@", [self apiURLPrefix], [self apiURLSuffix]];
    NSString *escapedURLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self structuredParameters]) {
        [super buildWithURLString:escapedURLString params:nil httpMethod:[self apiRequestMethod]];
        
        __weak GBRequest *request = self;
        [request setCustomPostDataEncodingHandler:^{
            NSData *data = [request structuredParameters];
            return data;
        } forType:@"application/json"];    }
    else{
        [super buildWithURLString:escapedURLString params:nil httpMethod:[self apiRequestMethod]];
        __weak GBRequest *request = self;
        [request setCustomPostDataEncodingHandler:^{
            return [request.parameters getSendData];
        } forType:@"application/octet-stream"];
    }
}

- (BaseParameter *)parameters {
    return _parameters;
}

- (NSData *)structuredParameters{
    return nil;
}

- (BOOL)validateParameters:(NSMutableString *)errorMessage {
    // DOTO
    return YES;
}

- (void)sendAsynchronous {
    NSMutableString *errorMessage = [NSMutableString string];
    BOOL validateResult = [self validateParameters:errorMessage];
    if (validateResult) {
        [self buildRequest];
        [self startAsynchronous];
    }
    else {
        GBResponse *errorResponse = [[GBResponse alloc] initWithErrorMessage:errorMessage];
        __weak GBRequest *request = self;
        dispatch_async(dispatch_get_main_queue(), ^(){
            if (request.responseBlock) {
                request.responseBlock(request,errorResponse);
            }
        });
        
    }
}

- (void)startAsynchronous
{
    GBRequest * __weak blockParam = self;
 
    [self onCompletion:^(GCDNetworkOperation *completedOperation,BOOL isCacheData) {
        // the completionBlock will be called twice.
        // if you are interested only in new values, move that code within the else block
        
        [blockParam requestFinished:blockParam cacheData:isCacheData];
        
    } onError:^(NSError *error) {
        [blockParam requestFailed:blockParam];
    }];
    
    [[GBNetwork sharedNetworkEngine] enqueueOperation:(GCDNetworkOperation *)self];
}

- (void)sendSynchronous {
    // DOTO
}

- (NSString *)apiURLPrefix {
    return @""; //子类覆盖,禁止在此定制
}

- (NSString *)apiURLSuffix {
    return @""; //子类覆盖,禁止在此定制
}

- (NSString *)apiRequestMethod {
    return @""; //子类覆盖,禁止在此定制
}

- (Class)responseClass {
    return _responseClass; //子类覆盖,禁止在此定制
}

- (NSString *)responseString
{
	NSString *respStr = [super responseString];
    return respStr;
}

#pragma mark - Network complete

- (void)requestFinished:(GBRequest *)currentRequest cacheData:(BOOL)isCacheData{
    if (currentRequest == self) {
        //NOTE
        //DOTO 添加解析方法
        GBResponse *response = nil;
        switch (self.responseDataType) {
            case KResponseDataTypeBinary:{ //二进制数据
                response = [[[self responseClass] alloc] initWithOriginal: self.responseData];
                break;
            }
            case KResponseDataTypeJSON:{ //JSON格式
                NSDictionary *json = [self responseJSON];
                response = [[[self responseClass] alloc] initWithResponseDictionary:json];
                break;
            }
            case KResponseDataTypeXML:{ //XML格式
                break;
            }
                
            default:
                break;
        }
        
        __weak GBRequest *request = self;
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if (isCacheData) {
                if (!request.isCancelled && request.cacheResponseBlock) {
                    request.cacheResponseBlock(request,response);
                }
            }
            else {
                if (!request.isCancelled && request.responseBlock) {
                    request.responseBlock(request,response);
                }
                
                [request cancel];
                [[GBNetwork sharedNetworkEngine] clearOperation:request];
            }
            
        });
    }
}

- (void)requestFailed:(GBRequest *)currentRequest{
    
    if (currentRequest == self) {
        
        NSString *errorMessage = nil;
        //NSInteger errorCode = [currentRequest.error code];
        
        errorMessage = [NSString stringWithFormat:@"%@", NSLocalizedString(@"网络异常，请重试", nil)];
        
        GBResponse *response = [[[self responseClass] alloc] initWithErrorMessage:errorMessage];
        response.netError = YES;
        __weak GBRequest *request = self;
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            if (!request.isCancelled && request.responseBlock) {
                request.responseBlock(request,response);
            }
            
            //清理
            [request cancel];
            [[GBNetwork sharedNetworkEngine] clearOperation:request];
        });
    }
}

@end
