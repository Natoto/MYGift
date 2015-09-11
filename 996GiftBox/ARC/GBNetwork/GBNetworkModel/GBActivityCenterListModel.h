//
//  GBActivityCenterListModel.h
//  GameGifts
//
//  Created by Keven on 14-1-20.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBActivityCenterListModel : NSObject
@property (nonatomic,assign)int32_t activityID;
@property (nonatomic,copy)NSString * gameName;
@property (nonatomic,copy)NSString * activityName;
@property (nonatomic,assign)int32_t publishTime;
@property (nonatomic,assign)int32_t popularityCount;
@property (nonatomic,copy)NSString * iconURLString;
@property (nonatomic,copy)NSString * subtitle;
@property (nonatomic,copy)NSString * description;
@end
