//
//  BaseParameter.m
//  Network
//
//  Created by KevenTsang on 13-11-19.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "BaseParameter.h"
#define DEFAULT_LEGNGTH   1 * 1024
@implementation BaseParameter
/**
 *  初始化一个数据组装类
 *
 *  @return 组装类对象
 */
- (id)init
{
    self = [super init];
    if (self) {
        self.length = 0;
        [self getMalloc];
    }
    return self;
}
/**
 *  释放缓存的内存空间
 */
- (void)dealloc
{
    free(self.buffer);
    self.length = 0;
}
/**
 *  开辟新buffer空间
 */
- (void)getMalloc
{
    self.buffer  = malloc(DEFAULT_LEGNGTH);
    if (self.buffer != NULL) {
        KT_DLog(@"堆内存开辟成功");
    }else{
        KT_DLog(@"堆内存开辟失败");
    }
    memset(self.buffer,'\0',DEFAULT_LEGNGTH);
}

/**
 *  转换buffer为NSData 二进制数据
 *
 *  @return NSData对象
 */
- (NSData *)getSendData
{
    return [[NSData alloc] initWithBytes:self.buffer length:self.length];
}
/**
 *  向组装数据类的新开辟的buffer写入8字节数据
 *
 *  @param t_64 8字节数据
 */
- (void)writeInt_64:(int64_t)t_64
{
    memcpy(&self.buffer[self.length], &t_64, sizeof(int64_t));
    self.length += sizeof(int64_t);
}
/**
 *  向组装数据类的新开辟的buffer写入4字节数据
 *
 *  @param t_32 4字节数据
 */
- (void)writeInt_32:(int32_t)t_32
{
    memcpy(&self.buffer[self.length], &t_32, sizeof(int32_t));
    self.length += sizeof(int32_t);
}
/**
 *  向组装数据类的新开辟的buffer写入2字节数据
 *
 *  @param t_16 2字节数据
 */
- (void)writeInt_16:(int16_t)t_16
{
    memcpy(&self.buffer[self.length], &t_16, sizeof(int16_t));
     self.length +=sizeof(int16_t);
}
/**
 *  向组装数据类的新开辟的buffer写入1字节数据
 *
 *  @param t_8 1字节数据
 */
- (void)writeInt_8:(int8_t)t_8
{
    memcpy(&self.buffer[self.length], &t_8, sizeof(int8_t));
    self.length +=sizeof(int8_t);
}
/**
 *  向组装数据类的新开辟的buffer写入1串字符
 *
 *  @param aString 1串字符
 */
- (void)writeString:(NSString *)aString
{
    const char * aCString = [aString UTF8String];
    memcpy(&self.buffer[self.length], aCString, strlen(aCString) + 1);
    self.length +=strlen(aCString) + 1;
}
/**
 *  修正组装数据类的buffer的数据长度
 *
 *  @param t_32 数据长度
 */
- (void)changeBufferSize:(int32_t)t_32
{
    memcpy(&self.buffer[0], &t_32, sizeof(int32_t));
}
@end
