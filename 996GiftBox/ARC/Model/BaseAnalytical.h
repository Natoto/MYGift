//
//  BaseAnalytical.h
//  NetWorkTwo
//
//  Created by Keven on 13-12-23.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_BASE_ANALYTICAL_H__
#define __KT_BASE_ANALYTICAL_H__
#import <Foundation/Foundation.h>

@interface BaseAnalytical : NSObject
@property (nonatomic,assign)void * dataBuffer;
@property (nonatomic,assign)NSInteger readLength;
/**
 *  给解析数据类注入解析数据
 *
 *  @param data 要解析的数据
 */
- (void)setDataBufferWithData:(NSData *)data;
/**
 *  从数据缓存dataBuffer里面读取8个字节
 *
 *  @return 8个字节的数据
 */
- (int64_t)readInt_64;
/**
 *  从数据缓存dataBuffer里面读取4个字节
 *
 *  @return 4个字节的数据
 */
- (int32_t)readInt_32;
/**
 *  从数据缓存dataBuffer里面读取2个字节
 *
 *  @return 2个字节的数据
 */
- (int16_t)readInt_16;
/**
 *  从数据缓存dataBuffer里面读取1个字节
 *
 *  @return 1个字节的数据
 */
- (int8_t)readInt_8;
/**
 *  从数据缓存dataBuffer里面读取一串字符
 *
 *  @return 一串字符
 */
- (NSString *)readString;
@end
#endif