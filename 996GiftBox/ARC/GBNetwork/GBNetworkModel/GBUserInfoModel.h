//
//  GBUserInfoModel.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-23.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBUserInfoModel : GBBaseModel

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *pp_money;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSString *genderStr;
@property (nonatomic, strong) NSString *device;
@property (nonatomic, strong) NSNumber *user_point;
@property (nonatomic, assign) NSTimeInterval birth;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *interest;
@property (nonatomic, strong) NSString *avatar_small_url;
@property (nonatomic, strong) NSString *avatar_middle_url;
@property (nonatomic, strong) NSString *avatar_big_url;

@end
