//
//  TRSDKConstants.h
//  PPHelper
//
//  Created by chenjunhong on 13-5-7.
//  Copyright (c) 2013年 Jun. All rights reserved.
//

#ifndef PPHelper_TRSDKConstants_h
#define PPHelper_TRSDKConstants_h

////是否iPad
#define isIpad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
////是否模拟器
//#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
//屏幕高度
#define screenHeight [UIScreen mainScreen].applicationFrame.size.height
//屏幕宽度
#define screenWidth [UIScreen mainScreen].applicationFrame.size.width


#define EXPORT_PATH @"export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games;"

#define PP_PATH @"/Applications/PPHelperNS.app"
#define PP_SYSTEM_PATH PP_PATH "/PPServices"
#define RP_PATH PP_PATH "/RepairPermissions.sh"

#define ND_PXL_DB @"/private/var/root/Media/PXL/DB"


#endif


////设备屏幕类型
//typedef enum {
//    IPHONE3 = 3,
//    IPHONE4 = 5,
//    IPHONE5 = 7,
//    IPAD = 2,
//    NEWIPAD = 6
//} DeviceType;




NSString *uuid;                         //uuid
NSString *platform;                     //设备型号
NSString *systemVersionStr;             //固件版本号
double systemVersion;                   //固件版本号
UInt32 iosVersion;                      //经过过滤的固件版本号
//DeviceType deviceType;                  //设备屏幕类型
