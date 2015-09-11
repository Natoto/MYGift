//
//  GBResponse.m
//  GameGifts
//
//  Created by Teiron-37 on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GBResponse.h"
#import "GBNetworkDefine.h"

@implementation GBResponse

@synthesize isError = _isError, errorMessage = _errorMessage, length = _length, netError = _netError;

- (id)initWithResponseDictionary:(NSDictionary *)responseDictionary {
    self = [super init];
    if (self) {
        _isError = YES;
    }
    return self;
}

- (id)initWithErrorMessage:(NSString *)errorMessage {
    self = [super init];
    if (self) {
        _isError = YES;
        _errorMessage = errorMessage;
    }
    return self;
}

- (id)initWithOriginal:(NSData *)responseData {
    self = [super init];
    if (self) {
        [self setDataBufferWithData:responseData];
        _length = [self readInt_32];
        _command = [self readInt_32];
        _isError = [self determineStateWithStatus:[self readInt_16]];
    }
    return self;
}

- (BOOL)determineStateWithStatus:(int16_t)t_16
{
    /*
     REQUEST_SERVICES_STATUS_CODE_IH_E_OK                                = 0,    //结果码为0时，才取结果码后面的数据
     REQUEST_SERVICES_STATUS_CODE_IH_E_NEGATIVE_VALUE                    = 1,    //无效的页码或每页数量
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PACKAGE_LIST              = 2,    //系统错误
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PACKAGE                   = 3,    //系统错误
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_USER                      = 4,    //系统错误
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PACKAGE_ID                = 5,    //无效的礼包ID值
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PUBLISHTIME               = 6,    //系统错误
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_ACTIVITY_LIST             = 7,    //系统错误
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_ACTIVITY                  = 8,    //系统错误
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_ACTIVITY_ID               = 9,    //无效的礼包ID值
     REQUEST_SERVICES_STATUS_CODE_IH_E_UNKNOWN                           = 10,   //未知错误
     
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_GAME                      = 11,   //系统错误
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_GAME_RESTYPE              = 12,   //无效res_type
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_GAME_LIST                 = 13,   //系统错误
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_USER_ID                   = 14,   //无效的userid
     REQUEST_SERVICES_STATUS_CODE_IH_E_GET_PACKAGE_ERROR                 = 15,   //获取礼包失败
     REQUEST_SERVICES_STATUS_CODE_IH_E_GET_NUMBER_ERROR                  = 16,   //获取我的兑现码失败
     REQUEST_SERVICES_STATUS_CODE_IH_E_GET_NUMBER_OUTTIME                = 17,   //获取兑现码超时
     
     REQUEST_SERVICES_STATUS_CODE_IH_E_USER_ID                           = 101,  //user_id 出错
     REQUEST_SERVICES_STATUS_CODE_IH_E_PACKAGE_ID                        = 102,  //package_id 出错
     REQUEST_SERVICES_STATUS_CODE_IH_E_NO_PACKAGE_NUMBER                 = 103,  //礼包号领完
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_SEARCH_COUNT              = 104,  //无效 搜索返回树量
     REQUEST_SERVICES_STATUS_CODE_IH_E_EMPTY_SEARCH_KEY                  = 105,  //search_key  为空“”
     REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_REQUEST                   = 110,  //无效请求request
     */
    KT_DLog(@"\n==================================STATUS_CODE:%d=============================\n",t_16);
    switch (t_16) {
        case REQUEST_SERVICES_STATUS_CODE_IH_E_OK:{
            KT_DLog(@"\n==================================数据获取正确，正在解析---=============================\n");
            _errorMessage = nil;
            return NO;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_NEGATIVE_VALUE:{
            KT_DLog(@"\n==================================数据获取错误，客户端（无效的页码或每页数量）=============================\n");
            _errorMessage = @"数据获取错误，客户端（无效的页码或每页数量）";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PACKAGE_LIST:{
            KT_DLog(@"\n==================================数据获取错误，服务器端（系统错误）=============================\n");
            _errorMessage = @"数据获取错误，服务器端（系统错误）";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PACKAGE:{
            KT_DLog(@"\n==================================数据获取错误，服务器端（系统错误）=============================\n");
            _errorMessage = @"数据获取错误，服务器端（系统错误）";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_USER:{
            KT_DLog(@"\n==================================数据获取错误，服务器端（系统错误）=============================\n");
            _errorMessage = @"数据获取错误，服务器端（系统错误）";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PACKAGE_ID:{
            KT_DLog(@"\n==================================数据获取错误，客户端（无效的礼包ID值）=============================\n");
            _errorMessage = @"数据获取错误，客户端（无效的礼包ID值）";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PUBLISHTIME:{
            KT_DLog(@"\n==================================数据获取错误（系统错误）=============================\n");
            _errorMessage = @"数据获取错误，（未知错误）";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_ACTIVITY_LIST:{
            KT_DLog(@"\n==================================数据获取错误（系统错误）=============================\n");
            _errorMessage = @"数据获取错误，（未知错误）";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_ACTIVITY:{
            KT_DLog(@"\n==================================数据获取错误（系统错误）=============================\n");
            _errorMessage = @"数据获取错误，（未知错误）";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_ACTIVITY_ID:{
            KT_DLog(@"\n==================================数据获取错误（系统错误）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_USER_ID:{
            KT_DLog(@"\n==================================数据获取错误（user_id 出错）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_PACKAGE_ID:{
            KT_DLog(@"\n==================================数据获取错误（user_id 出错）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_NO_PACKAGE_NUMBER:{
            KT_DLog(@"\n==================================数据获取错误（user_id 出错）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_GAME:{
            KT_DLog(@"\n==================================数据获取错误（系统错误）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_GAME_RESTYPE:{
            KT_DLog(@"\n==================================数据获取错误（无效res_type）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_GAME_LIST:{
            KT_DLog(@"\n==================================数据获取错误（系统错误）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_USER_ID:{
            KT_DLog(@"\n==================================数据获取错误（无效的userid）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_GET_PACKAGE_ERROR:{
            KT_DLog(@"\n==================================数据获取错误（获取礼包失败）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_GET_NUMBER_ERROR:{
            KT_DLog(@"\n==================================数据获取错误（获取我的兑现码失败）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_GET_NUMBER_OUTTIME:{
            KT_DLog(@"\n==================================数据获取错误（获取兑现码超时）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_UNKNOWN:{
            KT_DLog(@"\n==================================数据获取错误（未知错误）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_SEARCH_COUNT:{
            KT_DLog(@"\n==================================数据获取错误（无效 搜索返回树量）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_EMPTY_SEARCH_KEY:{
            KT_DLog(@"\n==================================数据获取错误（search_key  为空“”）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        case REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_REQUEST:{
            KT_DLog(@"\n==================================数据获取错误（无效请求request）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
        default:{
            KT_DLog(@"\n==================================数据获取错误（未知错误）=============================\n");
            _errorMessage = @"访问出错";
            return YES;
            break;
        }
    }
    return NO;
}

@end
