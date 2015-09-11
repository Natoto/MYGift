//
//  HTTPConnection.h
//  PPHelper
//
//  Created by chenjunhong on 13-1-25.
//  Copyright (c) 2013年 Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TeironSDK/net/TRBuffer.h>

typedef enum {
    tTRHTTPConnectionSuccess            = 0,            //成功
    tTRHTTPConnectionError              = -1,           //连接失败
    tRHTTPConnectionErrorDataNull       = -2            //返回数据包为空
}TRHTTPConnectionError;

@class  TRHTTPConnection;
@protocol TRHTTPConnectionDelegate <NSObject>

- (void)didFailConnection:(TRHTTPConnection*)conn errorCode:(TRHTTPConnectionError)errorCode userInfo:(NSDictionary*)userInfo;
- (void)didFinishConnection:(TRHTTPConnection*)conn data:(NSData*)data userInfo:(NSDictionary*)userInfo;

@end

@interface TRHTTPConnection : NSObject
{
    id<TRHTTPConnectionDelegate> _delegate;
    NSURLConnection *_conn;
    NSMutableData *_retData;
    NSDictionary *_userInfo;
    
    NSTimer *_timer;
    NSTimeInterval _defaultTimeout;
}

@property (nonatomic) NSTimeInterval defaultTimeout;

+ (TRHTTPConnection*)defaultHTTPConnection;
- (void)sendPost:(NSString*)url buff:(TRBuffer *)buff userInfo:(NSDictionary*)userInfo delegate:(id<TRHTTPConnectionDelegate>)delegate;
- (void)cancel;

@end
