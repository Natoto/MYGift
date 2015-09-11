//
//  GBPackageReceiveModel.h
//  GameGifts
//
//  Created by Keven on 14-1-14.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBPackageReceiveModel : NSObject
@property (nonatomic,assign)int64_t packageID;
@property (nonatomic,assign)int32_t catID;
@property (nonatomic,assign)int32_t gameID;
@property (nonatomic,copy)NSString * gameName;
@property (nonatomic,assign)int32_t publishTime;
@property (nonatomic,assign)int32_t outTime;
@property (nonatomic,copy)NSString * packageName;
@property (nonatomic,copy)NSString * subtitle;
@property (nonatomic,copy)NSString * iconURLString;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * exchange;
@property (nonatomic,assign)int32_t packageCount;
@property (nonatomic,assign)int32_t packageSurplusCount;
@property (nonatomic,assign)int32_t packageStatus;
@property (nonatomic,copy)NSString * number;//兑换码
@end
