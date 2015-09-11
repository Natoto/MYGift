//
//  TRUserRequest.h
//  TeironSDK_Static
//
//  Created by chenjunhong on 13-7-3.
//  Copyright (c) 2013年 Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TeironSDK/net/TRHTTPConnection.h>

//用户系统请求的URL地址
static NSString * const USER_REQUEST_URL = @"http://passport_i.25pp.com:8080/i";

//用户系统相关指令
typedef enum {
    UserLogin                               = 0xAA000013,       //用户登录
    UserLogin_                              = 0xAA00F013,       //用户登录返回
    GameUserLogin                           = 0xAA000007,       //游戏用户登录
    GameTmpUserLogin                        = 0xAA000002,       //游戏临时用户登录
    GameUserLogin_                          = 0xAA00F012,       //游戏正式用户/临时用户登录返回
    UserRegister                            = 0xAA00C101,       //用户注册
    UserRegister_                           = 0xAA00F101,       //用户注册返回
    UserModifyPassword                      = 0xAA00C201,       //用户修改密码
    UserModifyPassword_                     = 0xAA00F201,       //用户修改密码返回
    GameUserBindAccount                     = 0xAA00C601,       //游戏临时用户绑定正式用户
    GameUserBindAccount_                    = 0xAA00F601,       //游戏临时用户绑定正式用户返回
    CheckUserExist                          = 0xAA00C301,       //检查用户是否存在/检查用户是否存在返回
    RepeatUser_                             = 0xAA00F005,       //用户登陆时返回是重复用户
    ImportRepeatUser                        = 0xAA00C005,       //导入重复用户
    ImportRepeatUser_                       = 0xAA00F006,       //导入重复用户返回
    VerificationTokenKey                    = 0xAA000023,       //验证TokenKey
    VerificationTokenKey_                   = 0xAA00F023        //验证TokenKey返回
} SDKUserCommmand;

//用户系统全局错误码
typedef enum {
    SDKUserSuccess                          = 0x00000000,       //成功
    SDKUserErrorIllegalUserName             = 0xE0000000,       //用户名不符合规则
    SDKUserErrorUserNotExists               = 0xE0000001,       //用户名不存在
    SDKUserErrorInvalidOperation            = 0xE0000006,       //无效的操作
    SDKUserErrorUserAleradyExists           = 0xE000000E,       //该正式账号已经存在
    SDKUserErrorPasswordError               = 0xE000001E,       //密码错误
    SDKUserErrorPasswordCheckError          = 0xE0000102,       //密码错误
    SDKUserErrorBanUser                     = 0xE00000BA,       //该用户被禁止登录
    SDKUserErrorDBError                     = 0xE00000DB,       //数据库错误
    SDKUserErrorSessionTimeout              = 0xE0000101,       //会话超时
    SDKUserErrorAlreadyBind                 = 0xE0000B0D,       //该临时账号已经绑定过正式账号，无法再绑定
    SDKUserErrorTryAfter10Min               = 0xE0000C00        //错误请求过多，请10分钟后再试
} SDKUserErrorCode;

//导入重复用户全局错误码
typedef enum {
    SDKImportRepeatUserSuccess              = 0x00000000,       //成功
    SDKImportRepeatUserErrorUserNotExists   = 0xE0000001,       //导入的用户名不存在
    SDKImportRepeatUserErrorNoImport        = 0xE0000006,       //该用户无需导入
    SDKImportRepeatUserErrorPasswordError   = 0xE000001E,       //密码错误
    SDKImportRepeatUserErrorDBError         = 0xE00000DB,       //数据库错误
} SDKImportRepeatUserErrorCode;

//用户类型
typedef enum {
    SDKUserTypeNormal,                                  //一般用户
    SDKUserTypeGame,                                    //游戏用户
    SDKUserTypeGameTmp                                  //游戏临时用户
} SDKUserType;

//窗口类型
typedef enum {
    SDKUserWindowTypeLogin,                             //登录窗口
    SDKUserWindowTypeRegister,                          //注册窗口
    SDKUserWindowTypeModifyPassword,                    //修改密码窗口
    SDKUserWindowTypeUserCenter,                        //用户中心窗口
    SDKUserWindowTypeUserForgotPassword                 //找回密码窗口
} SDKUserWindowType;

@class TRUserRequest;
@protocol TRUserRequestDelegate <NSObject>

@optional

/**
 * @description 请求失败回调（通信层）
 * @param errorCode: TRHTTPConnectionError
 * @param userInfo: 请求时的用户自定义数据
 */
- (void)didFailRequestUserConnection:(TRUserRequest*)tRUserRequest
                           errorCode:(TRHTTPConnectionError)errorCode
                            userInfo:(NSMutableDictionary*)userInfo;


/**
 * @description 请求业务异常回调（业务层）
 * @param errorCode: SDKUserErrorCode
 * @param userInfo: 请求时的用户自定义数据
 */
- (void)didFailRequestUser:(TRUserRequest*)tRUserRequest
                 errorCode:(SDKUserErrorCode)errorCode
                  userInfo:(NSMutableDictionary*)userInfo;

/**
 * @description 请求登录成功回调
 * @param tokenKey: token_key
 * @param userId: 用户表ID
 * @param userName: 用户名
 * @param tmpUserName: 临时用户名
 * @param userInfo: 请求时的用户自定义数据
 */
- (void)didSuccessRequestLogin:(TRUserRequest*)tRUserRequest
                      tokenKey:(NSString*)tokenKey
                        userId:(unsigned long long)userId
                      userName:(NSString*)userName
                   tmpUserName:(NSString*)tmpUserName
                      userInfo:(NSMutableDictionary*)userInfo;

/**
 * @description 请求注册成功回调
 * @param userId: 用户表ID
 * @param userInfo: 请求时的用户自定义数据
 */
- (void)didSuccessRequestRegister:(TRUserRequest*)tRUserRequest
                           userId:(unsigned long long)userId
                         userInfo:(NSMutableDictionary*)userInfo;

/**
 * @description 请求修改密码成功回调
 * @param userInfo: 请求时的用户自定义数据
 */
- (void)didSuccessRequestModifyPassword:(TRUserRequest*)tRUserRequest
                               userInfo:(NSMutableDictionary*)userInfo;

/**
 * @description 请求绑定正式用户成功回调
 * @param userInfo: 请求时的用户自定义数据
 */
- (void)didSuccessRequestBindAccount:(TRUserRequest*)tRUserRequest
                            userInfo:(NSMutableDictionary*)userInfo;

/**
 * @description 请求检查用户名是否存在成功回调（注意：该请求不会有“请求业务异常回调”）
 * @param userId: 用户表ID (0-无此用户 其他-userid)
 * @param isAlias: 是否临时用户
 * @param userInfo: 请求时的用户自定义数据
 */
- (void)didSuccessRequestCheckUserExist:(TRUserRequest*)tRUserRequest
                                 userId:(unsigned long long)userId
                                isAlias:(BOOL)isAlias
                               userInfo:(NSMutableDictionary*)userInfo;

/**
 * @description 请求验证TokenKey成功回调
 * @param userName: 用户名
 * @param userId: 用户表ID
 * @param userInfo: 请求时的用户自定义数据
 */
- (void)didSuccessRequestVerificationTokenKey:(TRUserRequest*)tRUserRequest
                                     userName:(NSString*)userName
                                       userId:(unsigned long long)userId
                                     userInfo:(NSMutableDictionary*)userInfo;

@end



@interface TRUserRequest : NSObject
<TRHTTPConnectionDelegate>
{
    id<TRUserRequestDelegate> _delegate;
    TRHTTPConnection *_conn;
}

+ (id)defaultTRUserRequest;

/**
 * @description 取消请求
 */
- (void)cancel;

/**
 * @description 请求登录
 * @param userName: 用户名
 * @param password: 密码
 * @param userType: 用户类型
 * @param userInfo: 自定义数据，回调时返回
 * @param delegate: 委托对象（强引用，引用数+1）
 */
- (void)requestLogin:(NSString*)userName
            password:(NSData*)password
            userType:(SDKUserType)userType
            userInfo:(NSMutableDictionary*)userInfo
            delegate:(id<TRUserRequestDelegate>)delegate;

/**
 * @description 请求注册
 * @param userName: 用户名
 * @param password: 密码
 * @param isTmpUser: 是否临时用户
 * @param source: 注册来源
 * @param userInfo: 自定义数据，回调时返回
 * @param delegate: 委托对象（强引用，引用数+1）
 */
- (void)requestRegister:(NSString*)userName
               password:(NSString*)password
              isTmpUser:(BOOL)isTmpeUser
                 source:(unsigned int)source
               userInfo:(NSMutableDictionary*)userInfo
               delegate:(id<TRUserRequestDelegate>)delegate;

/**
 * @description 请求修改用户密码
 * @param userName: 用户名
 * @param oldPassword: 原密码
 * @param newPassword: 新密码
 * @param userInfo: 自定义数据，回调时返回
 * @param delegate: 委托对象（强引用，引用数+1）
 */
- (void)requestModifyPassword:(NSString*)userName
                  oldPassword:(NSData*)oldPassword
                  newPassword:(NSData*)newPassword
                     userInfo:(NSMutableDictionary*)userInfo
                     delegate:(id<TRUserRequestDelegate>)delegate;

/**
 * @description 请求绑定正式用户
 * @param tmpUserName: 临时用户名
 * @param tmpUserPassword: 临时用户密码
 * @param usrName: 正式用户名
 * @param userPassword: 正式用户密码
 * @param userInfo: 自定义数据，回调时返回
 * @param delegate: 委托对象（强引用，引用数+1）
 */
- (void)requestBindAccount:(NSString*)tmpUserName
           tmpUserPassword:(NSString*)tmpUserPassword
                  userName:(NSString*)userName
              userPassword:(NSString*)userPassword
                  userInfo:(NSMutableDictionary*)userInfo
                  delegate:(id<TRUserRequestDelegate>)delegate;

/**
 * @description 请求检查用户名是否存在
 * @param userName: 用户名
 * @param userInfo: 自定义数据，回调时返回
 * @param delegate: 委托对象（强引用，引用数+1）
 */
- (void)requestCheckUserExist:(NSString*)userName
                     userInfo:(NSMutableDictionary *)userInfo
                     delegate:(id<TRUserRequestDelegate>)delegate;

/**
 * @description 请求验证TokenKey
 * @param userName: 用户名
 * @param userInfo: 自定义数据，回调时返回
 * @param delegate: 委托对象（强引用，引用数+1）
 */
- (void)requestVerificationTokenKey:(NSString*)tokenKey
                           userInfo:(NSMutableDictionary *)userInfo
                           delegate:(id<TRUserRequestDelegate>)delegate;
@end
