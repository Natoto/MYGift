//
//  GBDefaultReqeust.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-15.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBRequest.h"

@interface GBDefaultReqeust : GBRequest

@end

//=======================用户中心===================

#pragma mark - GBLoginRequest 用户登录

@interface GBLoginRequest : GBDefaultReqeust

@end


//=======================礼包相关===================

@interface GBRequestForKT : GBDefaultReqeust

@end


//=======================其它======================

#pragma mark - GBFeedbackRequest 意见反馈

@interface GBFeedbackRequest : GBRequest

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *contact;

@end
