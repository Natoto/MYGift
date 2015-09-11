//
//  GBUserCenterResponse.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-23.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBResponse.h"

@interface GBUserCenterResponse : GBResponse

@end


#pragma mark - GBUserInfoResponse 用户信息

@class GBUserInfoModel;
@interface GBUserInfoResponse : GBUserCenterResponse

@property (nonatomic, strong) GBUserInfoModel *userInfoModel;

@end
