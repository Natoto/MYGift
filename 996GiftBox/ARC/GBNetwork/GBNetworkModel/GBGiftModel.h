//
//  GBGiftModel.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-3.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBGiftModel : GBBaseModel

@property (nonatomic, assign) NSInteger giftCategary;
@property (nonatomic, KT_STRONG) NSString *giftName;
@property (nonatomic, KT_STRONG) NSString *iconUrl;
@property (nonatomic, KT_STRONG) NSString *comeFrom;
@property (nonatomic, KT_STRONG) NSString *time;
@property (nonatomic, assign) NSInteger surplus;
@property (nonatomic, assign) NSInteger categoryType;
@property (nonatomic, KT_STRONG) NSString *category;
@property (nonatomic, KT_STRONG) NSString *content;
@property (nonatomic, assign) NSInteger popularity;
@property (nonatomic, assign) NSInteger status;

@end
