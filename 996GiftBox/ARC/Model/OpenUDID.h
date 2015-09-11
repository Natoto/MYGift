//
//  OpenUDID.h
//  996GameBox
//
//  Created by KevenTsang on 13-11-26.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//
#ifndef __KT_OPEN_UDID_H__
#define __KT_OPEN_UDID_H__

#import <Foundation/Foundation.h>

@interface OpenUDID : NSObject
/**
 *  获取OpenUDID
 *
 *  @return OpenUDID
 */
+ (NSString *)getOpenUDID;
/**
 *  获取UUID
 *
 *  @return UUID
 */
+ (NSString *)getUUID;
@end
#endif