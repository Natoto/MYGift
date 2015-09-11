//
//  TRUserLoginView.h
//  PPHelper
//
//  Created by chenjunhong on 13-5-7.
//  Copyright (c) 2013年 Jun. All rights reserved.
//

#import <TeironUserSDK/ui/TRUserPopView.h>
#import <TeironUserSDK/TRUserRequest.h>


@class MBProgressHUD, TRUIButton, TRUserInfo;

typedef void (^LoginSuccessCallback) (NSString *tokenKey, unsigned long long userId, NSString *userName, NSString *tmpUserName);

@interface TRUserLoginView : TRUserPopView
<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, TRUserRequestDelegate
//TRKeyValueRequestDelegate
>
{
    TRUIButton *_loginButton;
    
    UIImageView *_iconImageView;
    UIImageView *_userNameImageView;
    UIImageView *_passWordImageView;
    
    UILabel *_userNameLabel;
    UILabel *_passWordLabel;
    
    UITextField *_userNameField;
    UITextField *_passWordField;
    
    TRUIButton *_recordUserNameButton;
    
    TRUIButton *_keepPassWordButton;
    TRUIButton *_keepAutoLoginButton;
    
    UILabel    *_midLineLabel;
    TRUIButton *_forgetPassWordButton;
    TRUIButton *_registerButton;
    
    UITableView *_userNameTableView;
    
    MBProgressHUD *_mbProgressHUD;
    
    BOOL _userNameTableViewIsShow;

    BOOL _isKeepPassWord;
    BOOL _isKeepAutoLogin;
    BOOL _isLoadedDeviceLoginRecords;
    BOOL _isPassedEdition;
    NSMutableArray *_userInfoList;
    NSMutableArray *_oldUserInfoList;
    NSString *_lastLoginUserName;
//    NSString *_lastLoginPassword;
    NSData *_lastLoginPassword_;
    
    LoginSuccessCallback _loginSuccessCallback;
    BOOL _isCheck;
}

+ (TRUserLoginView*)defaultTRUserLoginView;

- (void)login:(LoginSuccessCallback)success cancel:(CloseCallback)cancel isCheck:(BOOL)isCheck;
- (void)login:(NSString*)user password:(NSData*)password;

@end
