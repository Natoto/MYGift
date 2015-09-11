//
//  GBSearchRecommendModel.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-3.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBSearchRecommendModel : GBBaseModel

@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, assign) NSInteger trend;
@property (nonatomic, assign) unsigned long long package_id;
@property (nonatomic, strong) NSString *package_name;
@property (nonatomic, strong) NSString *package_gameName;

@end
