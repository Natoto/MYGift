//
//  GBActivitiesDetailsModel.h
//  GameGifts
//
//  Created by Keven on 14-1-20.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBActivitiesDetailsModel : NSObject
@property (nonatomic,assign)int32_t activityID;
@property (nonatomic,copy)NSString * activityName;
@property (nonatomic,copy)NSString * gameName;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * address;
@property (nonatomic,copy)NSString * iconURLString;
@property (nonatomic,assign)int32_t startTime;
@property (nonatomic,assign)int32_t endTime;
@property (nonatomic,copy)NSString * reward;
@end
