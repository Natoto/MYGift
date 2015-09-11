//
// NSString+MD5.h
// Originally created for MyFile
//
// Created by Árpád Goretity, 2011. Some infos were grabbed from StackOverflow.
// Released into the public domain. You can do whatever you want with this within the limits of applicable law (so nothing nasty!).
// I'm not responsible for any damage related to the use of this software. There's NO WARRANTY AT ALL.
//
#ifndef __KT_MD5_HASH_H__
#define __KT_MD5_HASH_H__

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)
/**
 *  对字符串签名
 *
 *  @return 字符串的签名
 */
- (NSString *) MD5Hash;
@end
#endif
