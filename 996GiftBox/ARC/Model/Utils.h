//
//  Utils.h
//  GameBox
//
//  Created by KevenTsang on 13-11-4.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//
#ifndef __KT_UTILS_H__
#define __KT_UTILS_H__

#import <Foundation/Foundation.h>
@class GBAppDelegate,KTMainViewController;
@interface Utils : NSObject
/**
 *  获取机器屏幕宽度
 *
 *  @return 宽度
 */
+ (CGFloat)screenWidth;
/**
 *  获取机器屏幕高度
 *
 *  @return 高度
 */
+ (CGFloat)screenHeight;
/**
 *  获取xib的文件名称（适配IOS7）
 *
 *  @param nibName xib的文件名称
 *
 *  @return xib/xib-568h
 */
+ (NSString *)fullNibNameWithNibname:(NSString *)nibName;
/**
 *  获取AppDelegate
 *
 *  @return AppDelegate
 */
+ (GBAppDelegate *)getAppDelegate;
/**
 *  获取最底层的MainViewController对象实例
 *
 *  @return MainViewController对象实例
 */
+ (KTMainViewController *)getMainViewContorller;
/**
 *  获取正在显示的窗口
 *
 *  @return 显示的窗口
 */
+ (UIWindow *)getKeyWindow;
/**
 *  判断obj是否存在、为空
 *
 *  @param obj obj对象实例
 *
 *  @return YES、NO
 */
+ (BOOL)isNilOrEmpty:(NSObject *)obj;
/**
 *  判断是否email
 *
 *  @param email 字符串
 *
 *  @return YES。NO
 */
+ (BOOL)isEmail:(NSString *)email;
/**
 *  是否电话号码
 *
 *  @param mobile 字符串
 *
 *  @return YES，NO
 */
+ (BOOL)isMobile:(NSString *)mobile;
/**
 *  是否网址
 *
 *  @param obj 字符串
 *
 *  @return YES，NO
 */
+ (BOOL)isURLString:(NSObject *)obj;
/**
 *  去除NSString中的空格
 *
 *  @param str 字符串
 *
 *  @return 去除空格的字符串
 */
+ (NSString *)trimString:(NSString *)str;
/**
 *  设置网络类型的变化,NONetwork  3G/4G,Wifi
 *
 *  @param stauts 网络状态，
 */
+ (void)setupWorkStatus:(BOOL)stauts;
/**
 *  获取网络是否存在
 *
 *  @return YES/NO
 */
+ (BOOL)IsNetwork;
/**
 *  获取Docunment 绝对路径
 *
 *  @return NSString
 */
+ (NSString *)getDocumentsDirectory;
/**
 *  得到手机总容量
 *
 *  @return 容量大小
 */
+ (CGFloat)getTotalCapacityOfMobilePhone;
/**
 *  得到手机的可用容量
 *
 *  @return 容量大小
 */
+ (CGFloat)getAvailableCapacityOfMobilePhone;
/**
 *  得到手机的已用容量
 *
 *  @return 容量大小
 */
+ (CGFloat)getUsedCapacityOfMobilePhone;
//把double格式的时间转换成 YYYY年-MM月-DD日 20:00:00
/**
 *  把double格式的时间转换成 YYYY-MM-DD
 *
 *  @param timeInterval NSTimeInterval 类型的 时间 用1973来记时
 *
 *  @return YYYY年MM月DD日 20:00:00
 */

+ (NSString *)getSecondTypeTimeWithTimeInterval:(NSTimeInterval)timeInterval;

//把double格式的时间转换成 YYYY-MM-DD
/**
 *  把double格式的时间转换成 YYYY-MM-DD
 *
 *  @param timeInterval NSTimeInterval 类型的 时间 用1973来记时
 *
 *  @return 2013-04-07
 */
+ (NSString *)getTimeWithTimeInterval:(NSTimeInterval)timeInterval;

//把double格式的时间转换成 MM月-DD日
/**
 *  把double格式的时间转换成 MM月-DD日
 *
 *  @param timeInterval NSTimeInterval 类型的 时间 用1973来记时
 *
 *  @return 06月-07日
 */
+ (NSString *)getThirdTimeWithTimeInterval:(NSTimeInterval)timeInterval;
/**
 *  给文件大小 使用 b，kb，mb，gb单位
 *
 *  @param size 文件大小
 *
 *  @return 大小的字符串
 */
NSString * UDFormatFileSize(unsigned long long size);
/**
 *  获取客户端版本 e.g. 1.0
 *
 *  @return e.g. 1.0
 */
+ (NSString *)getAppVersion;
/**
 *  获取设置系统语言 e.g. EN /CN
 *
 *  @return e.g. EN /CN
 */
+ (NSString *)getSystemLanguage;
/**
 *  获取设置类型 e.g. @"iPhone", @"iPod touch"
 *
 *  @return e.g. @"iPhone", @"iPod touch"
 */
+ (NSString *)getSystemModel;
/**
 *  获取设置软件系统 e.g. IOS,OS_X,
 *
 *  @return e.g. IOS,OS_X,
 */
+ (NSString *)getSystemName;
/**
 *  获取设置系统的版本，e.g. @"4.0"
 *
 *  @return e.g. @"4.0"
 */
+ (NSString *)getSystemVersion;
/**
 *  获取用户在设置里面设置的名称 e.g. "My iPhone"
 *
 *  @return e.g. "My iPhone"
 */
+ (NSString *)getDevicesMasterName;
/**
 *  获取设置的信息 e.g. @"Keven 的 iPhone||iPhone touch||IOS||4.0||中文||1.0"
 *
 *  @return @"Keven 的 iPhone||iPhone touch||IOS||4.0||中文||1.0"
 */
+ (NSString *)getDevicesInfo;
/**
 *  分解getSystemVersion e.g. 各个部分 6.0.1 == 中得 6  0  1
 *
 *  @return e.g. @[6,0,1]
 */
+ (NSArray *)getPareIOSVersion;
/**
 *  没有数据显示的页面
 *
 *  @param sView   父类页面
 *  @param frame   尺寸
 *  @param image   默认图
 *  @param imgRect 图的尺寸
 *  @param action  刷新的点击事件
 *  @param 失效
 */
+ (UIView*)setupNoDataViewWithSuperView:(UIView *)sView
                                 frame:(CGRect)frame
                       backgroundImage:(UIImage *)image
                   backgroundImageRect:(CGRect)imgRect
                         refreshAction:(SEL)action;

@end

#endif