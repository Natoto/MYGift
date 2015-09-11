//
//  BaseParameter.h
//  Network
//
//  Created by KevenTsang on 13-11-19.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#ifndef __KT_BASE_PARAMETER_H__
#define __KT_BASE_PARAMETER_H__



#import <Foundation/Foundation.h>

@interface BaseParameter : NSObject
@property (nonatomic,assign)void * buffer;
@property (nonatomic,assign)int32_t length;
/**
 *  向组装数据类的新开辟的buffer写入8字节数据
 *
 *  @param t_64 8字节数据
 */
- (void)writeInt_64:(int64_t)t_64;
/**
 *  向组装数据类的新开辟的buffer写入4字节数据
 *
 *  @param t_32 4字节数据
 */
- (void)writeInt_32:(int32_t)t_32;
/**
 *  向组装数据类的新开辟的buffer写入2字节数据
 *
 *  @param t_16 2字节数据
 */
- (void)writeInt_16:(int16_t)t_16;
/**
 *  向组装数据类的新开辟的buffer写入1字节数据
 *
 *  @param t_8 1字节数据
 */
- (void)writeInt_8:(int8_t)t_8;
/**
 *  向组装数据类的新开辟的buffer写入1串字符
 *
 *  @param aString 1串字符
 */
- (void)writeString:(NSString *)aString;
/**
 *  修正组装数据类的buffer的数据长度
 *
 *  @param t_32 数据长度
 */
- (void)changeBufferSize:(int32_t)t_32;
/**
 *  转换buffer为NSData 二进制数据
 *
 *  @return NSData对象
 */
- (NSData *)getSendData;

@end
#endif