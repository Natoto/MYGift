//
//  TRUtil.h
//  PPHelper
//
//  Created by chenjunhong on 13-5-8.
//  Copyright (c) 2013年 Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TeironSDK/net/TRBuffer.h>

#ifndef TRUtil_H
#define TRUtil_H

#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

unsigned char hexchar2num(char hexchar);
void str_to_hex(char * str, int str_len, unsigned char * hex);
void hex_to_str(unsigned char * hex, int hex_len, char * str);

void EncodeXor(unsigned char * buff, int len, unsigned char d);
void DecodeXor(unsigned char * buff, int len, unsigned char d);

unsigned int ParseIOSVersion(char * ver_str);

void MakeKey(char ver, uint64_t id, char * str1, char * str2, char * out_key/*16 bytes buffer*/);

#endif

@interface TRUtil : NSObject

+ (void)clostKeyBoard;


@end

