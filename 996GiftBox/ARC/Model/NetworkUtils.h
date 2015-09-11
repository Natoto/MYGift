//
//  NetworkHelper.h
//  ZhiZhi
//
//  Created by Danny on 13-3-11.
//  Copyright (c) 2013年 Yi-Ma. All rights reserved.
//

#ifndef __KT_NETWORK_UTILS_H__
#define __KT_NETWORK_UTILS_H__

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>

typedef enum {
    NetworkTypeOfNotAvailable = 1,
    NetworkTypeOfWIFI = 2,
    NetworkTypeOfCellularNetwork = 3 //3G,4G, GPRS etc.
} NetworkType;

@interface NetworkUtils : NSObject <UIAlertViewDelegate>
@property (strong, nonatomic) Reachability* hostReach;
/**
 *  初始化一个网络类单利
 *
 *  @return 网络类单利
 */
+ (NetworkUtils *)sharedInstance;
/**
 *  获取此刻的网络类型
 *
 *  @return 网络类型 3G,4G, GPRS etc.
 */
+ (NetworkType)currentNetworkType;
/**
 *  开始检测网络类型的变化
 */
- (void)startMonitoringNetworkStatus;

@end
#endif