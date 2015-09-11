//
//  OpenUDID.m
//  996GameBox
//
//  Created by KevenTsang on 13-11-26.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "OpenUDID.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "NSString+MD5.h"
#import "KeychainItemWrapper.h"
@implementation OpenUDID
/**
 *  获取UUID
 *
 *  @return UUID
 */
+ (NSString *)getUUID
{
//    KeychainItemWrapper * wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUID" accessGroup:@"GG5L65FC6D.com.996.GameGifts_UUID"];
//    NSString * UUIDString = [wrapper objectForKey:(__bridge id)kSecValueData];
//    if (![Utils isNilOrEmpty:UUIDString]) {
//        return UUIDString;
//    }else{
//        NSString * newUUIDString = [OpenUDID UUID];
//        if (![Utils isNilOrEmpty:newUUIDString]) {
//            [wrapper setObject:newUUIDString forKey:(__bridge id)kSecValueData];
//            return newUUIDString;
//        }else{
//            KT_DLog(@"creater UUID  failer");
//        }
//        
//    }
    return @"abcdefg";
}
/**
 *  获取UUID
 *
 *  @return UUID
 */
+ (NSString *)UUID
{
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    return cfuuidString;
}
/**
 *  获取OpenUDID
 *
 *  @return OpenUDID
 */
+ (NSString *)getOpenUDID
{
    KeychainItemWrapper * wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"OPENUDID" accessGroup:@"GG5L65FC6D.com.996.GameGifts_OPENUDID"];
    NSString * openUDIDString = [wrapper objectForKey:(__bridge id)kSecValueData];
    if (![Utils isNilOrEmpty:openUDIDString]) {
        return openUDIDString;
    }else{
        NSString * newOpenUDIDString = [OpenUDID generateFreshOpenUDID];
        if (![Utils isNilOrEmpty:newOpenUDIDString]) {
            [wrapper setObject:newOpenUDIDString forKey:(__bridge id)kSecValueData];
            return newOpenUDIDString;
        }else{
            KT_DLog(@"creater OpenUDID  failer");
        }
        
    }
    return nil;
}
/**
 *  获取OpenUDID
 *
 *  @return OpenUDID
 */
+ (NSString*)generateFreshOpenUDID {
    
    NSString* _openUDID = nil;
    if (_openUDID==nil) {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
        unsigned char result[16];
        CC_MD5( cStr, strlen(cStr), result );
        CFRelease(uuid);
        CFRelease(cfstring);
        
        _openUDID = [NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08x",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15],
                     (NSUInteger)(arc4random() % NSUIntegerMax)];
    }
    return _openUDID;
}
/* 另一种 得到 UUID 的方法
NSString *executableUUID()
{
    const uint8_t *command = (const uint8_t *)(&_mh_execute_header + 1);
    for (uint32_t idx = 0; idx < _mh_execute_header.ncmds; ++idx) {
        if (((const struct load_command *)command)->cmd == LC_UUID) {
            command += sizeof(struct load_command);
            return [NSString stringWithFormat:@"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
                    command[0], command[1], command[2], command[3],
                    command[4], command[5],
                    command[6], command[7],
                    command[8], command[9],
                    command[10], command[11], command[12], command[13], command[14], command[15]];
        } else {
            command += ((const struct load_command *)command)->cmdsize;
        }
        
    }
    return nil;
}
*/
@end
