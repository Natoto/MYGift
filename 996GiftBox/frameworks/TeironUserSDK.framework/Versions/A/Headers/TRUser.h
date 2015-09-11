//
//  TRUser.h
//  PPHelper
//
//  Created by chenjunhong on 13-5-7.//  Copyright (c) 2013年 Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TeironUserSDK/ui/TRUserLoginView.h>
#import <TeironUserSDK/ui/TRUserCenterView.h>

typedef enum{
    TRK_User_Icon_Size_Small,
    TRK_User_Icon_Size_Middle,
    TRK_User_Icon_Size_Big,
}TRK_User_Icon_Size; //用户头像 size类型





@interface TRUserLoginItem :NSObject
@property (nonatomic, retain) id                    idMark;
@property (nonatomic, assign)LoginSuccessCallback   loginSuccessCallback;
@property (nonatomic, assign)CloseCallback          loginCancelCallback;
@end

@interface TRUser : NSObject
{
    //正式账号
    NSString *_userName;
    //临时账号
    NSString *_tmpUserName;
    //token_key
    NSString *_tokenKey;
    //表ID
    unsigned long long _userId;
    
    TRUserRequest *_request;
    NSDate *_startTime;
    MBProgressHUD *_hud;
    
//    LoginSuccessCallback _loginSuccessCallback;
//    CloseCallback _loginCancelCallback;
    NSMutableArray *_loginQueue;
    
    BOOL _isCheck;
    BOOL _isLogin;
}

@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* tmpUserName;
@property (nonatomic, retain) NSString* tokenKey;
@property (nonatomic) unsigned long long userId;
@property (nonatomic, retain) NSDate* startTime;

+ (TRUser*)sharedInstance;

/*
 *  获取用户头像url
 *  userID 用户id
 *  size   图片尺寸
 */
+ (NSString *)getUserIconUrlWithUserID:(uint64_t)userID size:(TRK_User_Icon_Size)size;


/*
 *  添加后台登录
 */
- (void)addLoginQueue:(LoginSuccessCallback)success
               cancel:(CloseCallback)cancel
               markId:(id)markId; //标识Id。用作取消登录队列标识

/*
 * 移除登陆队列
 */
- (void)removeLoginQueue:(id)markId;

/**
 * @description 登录
 */

- (void)login:(LoginSuccessCallback)success
       cancel:(CloseCallback)cancel
      isCheck:(BOOL)isCheck;

/**
 * @description 
 */
- (void)showUserCenter:(void(^)())logout
                cancel:(void(^)())cancel;



@end