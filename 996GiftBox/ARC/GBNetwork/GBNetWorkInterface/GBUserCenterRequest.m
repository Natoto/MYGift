//
//  GBUserCenterRequest.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-22.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBUserCenterRequest.h"
#import "GBUserCenterResponse.h"

@implementation GBUserCenterRequest

- (NSString *)apiURLPrefix {
    return USERCENTER_URL_PREFIX;
}

- (NSString *)apiURLSuffix {
    return @"";
}

- (NSString *)apiRequestMethod {
    return @"GET";
}

- (Class)responseClass {
    return super.responseClass;
}

@end


#pragma mark - GBUserInfoRequest 用户信息

@implementation GBUserInfoRequest

- (NSString *)apiURLPrefix {
    return USERCENTER_URL_PREFIX;
}

- (NSString *)apiURLSuffix {
    return [NSString stringWithFormat:@"info/?t=%@",[TRUser sharedInstance].tokenKey];
}

- (NSString *)apiRequestMethod {
    return @"GET";
}

- (Class)responseClass {
    return [GBUserInfoResponse class];
}

@end
