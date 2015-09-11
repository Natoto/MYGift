//
//  GBRequest.h
//  GameGifts
//
//  Created by Teiron-37 on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GCDNetworkOperation.h"
#import "GBNetworkDefine.h"
#import "BaseParameter.h"

typedef enum {
    KResponseDataTypeBinary = 0,
    KResponseDataTypeJSON = 1,
    KResponseDataTypeXML = 2
}KResponseDataType;

@class GBRequest;
@class GBResponse;
@class BaseParameter;

typedef void (^DidEndWithResponseBlock) (GBRequest* request, GBResponse* response);

typedef void (^CacheResponseBlock) (GBRequest* request, GBResponse* response);

@interface GBRequest : GCDNetworkOperation

/*
 *
 * @abstract 请求完成回调
 *
 * @discussion
 *
 */
@property (nonatomic, copy) DidEndWithResponseBlock responseBlock;
@property (nonatomic, copy) CacheResponseBlock cacheResponseBlock;

@property (nonatomic, KT_STRONG) Class responseClass;
@property (nonatomic, KT_STRONG) BaseParameter *parameters;

@property (nonatomic, assign) KResponseDataType responseDataType;

/****************************  Public Methods  ***************************/

/*
 *
 * @abstract 若子类有 init... 方法，则使用子类的方法来初始化
 *
 * @discussion 不能重写 init 方法，否则会进入死循环，因为父类的 initWithURL 会调用 [self init]
 *
 */
- (id)initRequest;

/*
 *
 * @abstract 异步请求
 *
 * @discussion
 *
 */
- (void)sendAsynchronous;

/*
 *
 * @abstract 同步请求
 *
 * @discussion
 *
 */
- (void)sendSynchronous;


/****************************  Private Methods  **************************/

/*
 *
 * @abstract 请求参数列表
 *
 * @discussion 若参数不同于默认值，子类需覆盖
 *
 */
- (BaseParameter *)parameters;

/*
 *
 * @abstract 结构化请求参数列表(json or xml)
 *
 * @discussion 若参数不同于默认值，子类需覆盖(JSON ro xml,post请求重写)
 *
 */
- (NSData *)structuredParameters;

/*
 *
 * @abstract 返回用于处理请求报文的类
 *
 * @discussion
 *
 */
- (Class)responseClass;

/*
 *
 * @abstract url前缀
 *
 * @discussion 与默认值不同时，子类需覆盖
 *
 */
- (NSString *)apiURLPrefix;

/*
 *
 * @abstract url后缀
 *
 * @discussion 与默认值不同时，子类需覆盖
 *
 */
- (NSString *)apiURLSuffix;

/*
 *
 * @abstract 请求的类型:GET or POST
 *
 * @discussion 默认POST,与默认值不同时，子类需覆盖
 *
 */
- (NSString *)apiRequestMethod;

/*
 *
 * @abstract 参数合法性校验
 *
 * @discussion 返回值：YES 合法，NO 不合法
 *
 */
- (BOOL)validateParameters:(NSMutableString *)errorMessage;


/*
 *
 * @abstract 释放资源
 *
 * @discussion UI层调用 界面释放前必须先调用cancel，否则会崩溃
 *
 */
- (void)cancel;

@end
