//
//  GBDefaultReqeust.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-15.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "NSDictionary+RequestEncoding.h"
@implementation GBDefaultReqeust

- (NSString *)apiURLPrefix {
    return GIFTBOX_URL_PREFIX;
}

- (NSString *)apiURLSuffix {
    return @"";
}

- (NSString *)apiRequestMethod {
    return @"POST";
}

- (Class)responseClass {
    return super.responseClass;
}

@end


//=======================用户中心===================

#pragma mark - GBLoginRequest 用户登录

@implementation GBLoginRequest

@end


//=======================礼包相关===================

#pragma mark - Request For KEVEN 首页

@implementation GBRequestForKT

- (NSString *)apiURLPrefix {
    return GIFTBOX_URL_PREFIX;
}

- (NSString *)apiURLSuffix {
    return @"";
}

- (NSString *)apiRequestMethod {
    return @"POST";
}

@end


#pragma mark - GBFeedbackRequest 意见反馈

@implementation GBFeedbackRequest

- (NSString *)apiURLPrefix {
    return FEEDBACK_URL_PREFIX;
}

- (NSString *)apiURLSuffix {
//    return [NSString stringWithFormat:@"?message=%@&contact=%@",self.message, self.contact];
    return @"";
}

- (NSString *)apiRequestMethod {
    return @"POST";
}
- (Class)responseClass {
    return [GBFeedbackResponse class];
}

- (NSData *)structuredParameters{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic setObject:self.message forKey:@"message"];
    [dic setObject:self.contact forKey:@"contact"];
    return [[dic jsonEncodedKeyValueString] dataUsingEncoding:NSUTF8StringEncoding];
}

@end

