//
//  GBOpenServiceAndTestChartModel.h
//  GameGifts
//
//  Created by Keven on 14-1-22.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBOpenServiceAndTestChartModel : NSObject
@property (nonatomic,assign)int64_t packageID;
@property (nonatomic,copy)NSString * gameName;
@property (nonatomic,assign)int32_t publishTime;
@property (nonatomic,copy)NSString * remark;
@property (nonatomic,assign)int32_t score;
@property (nonatomic,copy)NSString * iconURLString;
@property (nonatomic,copy)NSString * category;//游戏分类
@end
