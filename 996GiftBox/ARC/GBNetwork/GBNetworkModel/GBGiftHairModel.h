//
//  GBGiftHairModel.h
//  GameGifts
//
//  Created by Keven on 14-1-14.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBGiftHairModel : NSObject
KT_PROPERTY_ASSIGN int64_t packageID;
KT_PROPERTY_ASSIGN int32_t catID;//游戏分类
KT_PROPERTY_ASSIGN int32_t gameID;//游戏ID
KT_PROPERTY_COPY NSString * gameName;
KT_PROPERTY_COPY NSString * packName;
KT_PROPERTY_COPY NSString * subtitle;
KT_PROPERTY_COPY NSString * iconURLString;
KT_PROPERTY_ASSIGN NSTimeInterval publishTime;
KT_PROPERTY_ASSIGN int32_t packcount;
KT_PROPERTY_ASSIGN int8_t packStatus;
@end
