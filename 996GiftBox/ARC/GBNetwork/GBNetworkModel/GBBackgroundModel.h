//
//  GBBackgroundModel.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-7.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBBackgroundModel : GBBaseModel

@property (nonatomic, KT_STRONG) NSString *bgName;
@property (nonatomic, KT_STRONG) NSString *iconUrl;
@property (nonatomic, KT_STRONG) NSString *sourceUrl;
@property (nonatomic, assign) BOOL isSelected;

@end
