//
//  GCDNetworkKit.h
//  GameGifts
//
//  Created by Teiron-37 on 13-12-27.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#ifndef _96GiftBox_GCDNetworkKit_h
#define _96GiftBox_GCDNetworkKit_h

#ifndef __IPHONE_4_0
#error "GCDNetworkKit uses features only available in iOS SDK 4.0 and later."
#endif

#ifdef DEBUG
#   define UDLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) UDLog(@"%@", err)}
#else
#   define UDLog(...)
#   define ELog(err)
#endif

#define ALog(fmt, ...) {UDLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);};

#if TARGET_OS_IPHONE
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define DO_GCD_RETAIN_RELEASE 0
#else
#define DO_GCD_RETAIN_RELEASE 1
#endif
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1080
#define DO_GCD_RETAIN_RELEASE 0
#else
#define DO_GCD_RETAIN_RELEASE 1
#endif
#endif

#import "Categories/NSString+GCDNetworkKitAdditions.h"
#import "Categories/NSDictionary+RequestEncoding.h"
#import "Categories/NSDate+RFC1123.h"
#import "Categories/NSData+Base64.h"

#import "Reachability.h"

#import "GCDNetworkOperation.h"
#import "GCDNetworkEngine.h"

#define GCDKNetworkEngineOperationCountChanged @"GCDKNetworkEngineOperationCountChanged"

#define GCDNETWORKCACHE_DEFAULT_DIRECTORY @"GCDNetworkKitCache"
#define GCDNETWORKCACHE_DEFAULT_COST 10
#define GCDKNetworkKitDefaultCacheDuration 60 // 1 minute
#define GCDKNetworkKitDefaultImageHeadRequestDuration 3600*24*1 // 1 day (HEAD requests with eTag are sent only after expiry of this. Not that these are not RFC compliant, but needed for performance tuning)
#define GCDKNetworkKitDefaultImageCacheDuration 3600*24*7 // 1 day

// if your server takes longer than 30 seconds to provide real data,
// you should hire a better server developer.
// on iOS (or any mobile device), 30 seconds is already considered high.

#define GCDKNetworkKitRequestTimeOutInSeconds 30
#endif
