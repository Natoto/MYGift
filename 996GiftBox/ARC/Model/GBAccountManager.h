//
//  GBAccountManager.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-23.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GBUserInfoModel;
@interface GBAccountManager : NSObject

@property (nonatomic, KT_STRONG) GBUserInfoModel *userInfoModel;

+ (GBAccountManager *) sharedAccountManager;

- (void)loginSuccess:(void(^)(void))success failure:(void (^)(void))failure;
- (void)logoutCallBack:(void(^)(void))callBack;

- (void)requestUserInfo;

@end
