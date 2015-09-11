//
//  NetworkHelper.m
//  ZhiZhi
//
//  Created by Danny on 13-3-11.
//  Copyright (c) 2013年 Yi-Ma. All rights reserved.
//

#import "NetworkUtils.h"
#define APP_API_PREFIX  @"http://183.57.76.38:8008/" //要检测的网址
@implementation NetworkUtils
/**
 *  初始化一个网络类单利
 *
 *  @return 网络类单利
 */
+ (NetworkUtils *)sharedInstance
{
    __strong static NetworkUtils *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
/**
 *  开始检测网络类型的变化
 */
- (void)startMonitoringNetworkStatus
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
	self.hostReach = [Reachability reachabilityWithHostName:APP_API_PREFIX];
	[self.hostReach startNotifier];
}
/**
 *  网络类型变化事件
 *
 *  @param note 此刻网络类型
 */
- (void)reachabilityChanged:(NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus networkStatus = [NetworkUtils sharedInstance].hostReach.currentReachabilityStatus;
    if (networkStatus == NotReachable) {
        KT_DLog(@"%@, Network available .........", NSStringFromSelector(_cmd));
        [Utils setupWorkStatus:NO];
        
    } else if (networkStatus == ReachableViaWiFi) {
        KT_DLog(@"%@, Network Wifi .........", NSStringFromSelector(_cmd));
        [Utils setupWorkStatus:YES];
    } else if (networkStatus == ReachableViaWWAN) {
        KT_DLog(@"%@, Network 3G,4G,GPRS.........", NSStringFromSelector(_cmd));
        [Utils setupWorkStatus:YES];
    }
}
/**
 *  获取此刻的网络类型
 *
 *  @return 网络类型 3G,4G, GPRS etc.
 */
+ (NetworkType)currentNetworkType
{
    NetworkType networkType = NetworkTypeOfNotAvailable;
    NetworkStatus networkStatus = [NetworkUtils sharedInstance].hostReach.currentReachabilityStatus;
    if (networkStatus == NotReachable) {
        networkType = NetworkTypeOfNotAvailable;
    } else if (networkStatus == ReachableViaWiFi) {
        networkType = NetworkTypeOfWIFI;
    } else if (networkStatus == ReachableViaWWAN) {
        networkType =  NetworkTypeOfCellularNetwork;
    }
    return networkType;
}
/**
 *  释放内存
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
