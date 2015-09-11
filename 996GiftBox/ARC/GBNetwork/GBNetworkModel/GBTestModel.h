//
//  GBTestModel.h
//  GameGifts
//
//  Created by Teiron-37 on 13-12-31.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBTestModel : GBBaseModel

@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, assign) NSInteger app_count;
@property (nonatomic, strong) NSString *icon;

@end
