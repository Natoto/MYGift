//
//  GBGetPackageNumberModel.h
//  GameGifts
//
//  Created by Keven on 14-1-24.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBGetPackageNumberModel : NSObject
@property (nonatomic,assign)int64_t packageID;
@property (nonatomic,assign)int32_t packageSurplus;
@property (nonatomic,assign)int32_t packageStatus;
@property (nonatomic,copy)NSString * packageNumber;
@end
