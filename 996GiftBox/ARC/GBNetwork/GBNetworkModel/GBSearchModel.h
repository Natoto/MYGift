//
//  GBSearchModel.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-15.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBSearchModel : GBBaseModel

@property (nonatomic, assign) int flags;          //活动：1 礼包：2
@property (nonatomic, assign) int remanCount;     //礼包剩余量
@property (nonatomic, assign) short packageStatus;  //礼包状态, '状态:1-未发布,2-等待领取,3-已领取,4-已使用'
@property (nonatomic, assign) long long modelID;        //id (可为活动或礼包)
@property (nonatomic, assign) NSTimeInterval createTime;     //创建时间
@property (nonatomic, assign) int data_view;
@property (nonatomic, copy) NSString *name;           //名称
@property (nonatomic, copy) NSString *content;        //内容
@property (nonatomic, copy) NSString *subContent;     //二级内容
@property (nonatomic, copy) NSString *picUrl;         //内容图片地质

@end
