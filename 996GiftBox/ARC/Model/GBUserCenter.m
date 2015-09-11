//
//  GBUserCenter.m
//  996GiftBox
//
//  Created by Keven on 14-1-9.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBUserCenter.h"

static GBUserCenter * userCenter = nil;
@implementation GBUserCenter
+ (id)sharedUserCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userCenter = [[GBUserCenter alloc] init];
    });
    return userCenter;
}
@end
