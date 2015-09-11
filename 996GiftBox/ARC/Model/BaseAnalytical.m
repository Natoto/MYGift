//
//  BaseAnalytical.m
//  NetWorkTwo
//
//  Created by Keven on 13-12-23.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "BaseAnalytical.h"

@implementation BaseAnalytical
/**
 *  给解析数据类注入解析数据
 *
 *  @param data 要解析的数据
 */
- (void)setDataBufferWithData:(NSData *)data
{
    size_t length = data.length;
    self.dataBuffer = malloc(length);
    memcpy(self.dataBuffer, ((char const *)data.bytes), length);
    self.readLength = 0;
}
/**
 *  从数据缓存dataBuffer里面读取8个字节
 *
 *  @return 8个字节的数据
 */
- (int64_t)readInt_64
{
    int64_t  * t_64 = malloc(sizeof(int64_t));
    memset(t_64, 0, sizeof(int64_t));
    memcpy(t_64, &self.dataBuffer[self.readLength], sizeof(int64_t));
    self.readLength +=sizeof(int64_t);
    int64_t over = *t_64;
    free(t_64);
    return  over;
}
/**
 *  从数据缓存dataBuffer里面读取4个字节
 *
 *  @return 4个字节的数据
 */
- (int32_t)readInt_32
{
    int32_t  * t_32 = malloc(sizeof(int32_t));
    memset(t_32, 0, sizeof(int32_t));
    memcpy(t_32, &self.dataBuffer[self.readLength], sizeof(int32_t));
    self.readLength +=sizeof(int32_t);
    int32_t over = *t_32;
    free(t_32);
    return  over;
}
/**
 *  从数据缓存dataBuffer里面读取2个字节
 *
 *  @return 2个字节的数据
 */
- (int16_t)readInt_16
{
    int16_t  * t_16 = malloc(sizeof(int16_t));
    memset(t_16, 0, sizeof(int16_t));
    memcpy(t_16, &self.dataBuffer[self.readLength], sizeof(int16_t));
    self.readLength +=sizeof(int16_t);
    int16_t over = *t_16;
    free(t_16);
    return  over;
}
/**
 *  从数据缓存dataBuffer里面读取1个字节
 *
 *  @return 1个字节的数据
 */
- (int8_t)readInt_8
{
    int8_t * t_8 = malloc(sizeof(int8_t));
    memset(t_8, 0, sizeof(int8_t));
    memcpy(t_8, &self.dataBuffer[self.readLength], sizeof(int8_t));
    self.readLength +=sizeof(int8_t);
    int8_t over = *t_8;
    free(t_8);
    return  over;
}
/**
 *  从数据缓存dataBuffer里面读取一串字符
 *
 *  @return 一串字符
 */
- (NSString *)readString
{
    char * aCString = (char *)malloc(1024);
    memset(aCString, 0, 1024);
    strcpy(aCString, &self.dataBuffer[self.readLength]);
    self.readLength += strlen(aCString) + 1;
    NSString * overString = [[NSString alloc] initWithCString:aCString encoding:NSUTF8StringEncoding];
    free(aCString);
    return overString;
}
/**
 *  释放缓存的内存空间
 */
- (void)dealloc
{
    free(self.dataBuffer);
    self.readLength = 0;
}
@end
