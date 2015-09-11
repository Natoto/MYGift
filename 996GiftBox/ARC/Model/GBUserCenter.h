//
//  GBUserCenter.h
//  996GiftBox
//
//  Created by Keven on 14-1-9.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBUserCenter : NSObject
KT_PROPERTY_COPY NSString * userName;
KT_PROPERTY_STRONG NSData * password; // 后面添加 @“996”字段 ，上传的时候记得去除
+ (id)sharedUserCenter;
@end
