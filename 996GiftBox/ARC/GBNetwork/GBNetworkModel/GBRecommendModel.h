//
//  GBRecommendModel.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-8.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBRecommendModel : GBBaseModel

@property (nonatomic, KT_STRONG) NSString *iconStrUrl;
@property (nonatomic, KT_STRONG) NSString *codeName;
@property (nonatomic, KT_STRONG) NSString *code;
@property (nonatomic, assign) NSTimeInterval validDate;
@property (nonatomic, assign) BOOL isSelected;

@end
