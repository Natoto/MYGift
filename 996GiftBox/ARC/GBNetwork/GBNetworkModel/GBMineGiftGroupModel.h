//
//  GBMineGiftGroupModel.h
//  GameGifts
//
//  Created by Teiron-37 on 14-2-12.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBMineGiftGroupModel : GBBaseModel

@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, strong) NSMutableArray *giftModelArray;
@property (nonatomic, assign) BOOL isSelected;

@end
