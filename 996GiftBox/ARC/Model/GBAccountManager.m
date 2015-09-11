//
//  GBAccountManager.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-23.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBAccountManager.h"
#import "GBUserCenterRequest.h"
#import "GBUserCenterResponse.h"
#import "BaiduMobStat.h"

@interface GBAccountManager ()

@property (nonatomic, KT_STRONG) GBUserInfoRequest *request;

@end

@implementation GBAccountManager

+ (GBAccountManager *) sharedAccountManager {
    
    static GBAccountManager *sharedAccountInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountInstance = [[self alloc] init];
    });
    return sharedAccountInstance;
}

- (void)dealloc
{
    [self.request cancel];
}

- (void)loginSuccess:(void(^)(void))success failure:(void (^)(void))failure
{
    if ([TRUser sharedInstance].tokenKey != nil) {
        success();
    }
    else{
        [[TRUser sharedInstance] login:^(NSString *tokenKey, unsigned long long userId, NSString *userName, NSString *tmpUserName) {
            [self requestUserInfo];
            success();
            [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_LOGIN_SUCCESS eventLabel:@"登录成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GLOBAL_LOGINSTATUS_CHANGE object:nil];
        } cancel:^{
            //        PopUpBox *popUpBox = [[PopUpBox alloc] initWithMessage:@"登陆失败"
            //                                                  buttonTitles:[NSArray arrayWithObject:@"确定"]
            //                                                      callback:^(int index){
            //
            //                                                      }];
            //        [popUpBox show];
            failure();
        } isCheck:NO];
    }
}

- (void)logoutCallBack:(void(^)(void))callBack
{
    TRUserLoginView * loginView = [TRUserLoginView defaultTRUserLoginView];
    TRUserCenterView * centerView = [TRUserCenterView defaultTRUserCenterView];
    centerView.logoutCallback = ^(void){
        self.userInfoModel = nil;
        callBack();
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GLOBAL_LOGINSTATUS_CHANGE object:nil];
    };
    [loginView pushChildPopView:centerView];
    
    [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_LOGOUT_BUTTON eventLabel:@""];
}

- (void)requestUserInfo
{
    [self.request cancel];
    self.request = [[GBUserInfoRequest alloc] init];
    self.request.responseDataType = KResponseDataTypeJSON;
    __weak GBAccountManager *manager = self;
    [self.request setResponseBlock:^(GBRequest* request, GBResponse* response){
        if (response.isError) { //出错
            
        }else{
            GBUserInfoResponse *infoResponse = (GBUserInfoResponse *)response;
            manager.userInfoModel = infoResponse.userInfoModel;
        }
    }];
    [self.request sendAsynchronous];
}

@end
