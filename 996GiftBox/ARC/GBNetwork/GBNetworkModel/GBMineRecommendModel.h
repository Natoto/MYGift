//
//  GBMineRecommendModel.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-8.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBMineRecommendModel : GBBaseModel

@property (nonatomic, KT_STRONG) NSArray *codeModelArray;
@property (nonatomic, KT_STRONG) NSString *gameName;
@property (nonatomic, assign) BOOL isSelected;

@end
