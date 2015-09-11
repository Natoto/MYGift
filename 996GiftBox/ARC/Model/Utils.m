//
//  Utils.m
//  GameBox
//
//  Created by KevenTsang on 13-11-4.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "Utils.h"
#import "GBAppDelegate.h"
#import "KTMainViewController.h"
//#import "UMSocial.h"
#import "APService.h"
@implementation Utils
+ (CGFloat)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (NSString *)fullNibNameWithNibname:(NSString *)nibName
{
    if (nibName) {
        if (KT_DEVICE_IPHONE_5) {
            nibName = [NSString stringWithFormat:@"%@-568h", nibName];
        }
    }
    return nibName;
}

+ (GBAppDelegate *)getAppDelegate
{
    return (GBAppDelegate *)[UIApplication sharedApplication].delegate;
}
+ (KTMainViewController *)getMainViewContorller
{
    return [(GBAppDelegate *)[[UIApplication sharedApplication] delegate] mainViewController];
}
+ (void)setupWorkStatus:(BOOL)stauts
{
    [(GBAppDelegate *)[UIApplication sharedApplication].delegate setupWorkStatus:stauts];
}
/**
 *  获取网络是否存在
 *
 *  @return YES/NO
 */
+ (BOOL)IsNetwork
{
    return [(GBAppDelegate *)[UIApplication sharedApplication].delegate workStatus];
}
/**
 *  获取Docunment 绝对路径
 *
 *  @return NSString
 */
+ (NSString *)getDocumentsDirectory
{
    return  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (UIWindow *)getKeyWindow
{
    return [[UIApplication sharedApplication] keyWindow];
}
/*
+ (NSString *)getOpenUDID
{
    return [(GBAppDelegate *)[UIApplication sharedApplication].delegate openUDID];
}
+ (NSString *)getUUID
{
    return [(GBAppDelegate *)[UIApplication sharedApplication].delegate UUID];
}
*/

+ (BOOL)isNilOrEmpty:(NSObject *)obj
{
    BOOL result = YES;
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            if (![[Utils trimString:(NSString *)obj] isEqualToString:@""]) {
                result = NO;
            }
        } else {
            result = NO;
        }
    }
    return result;
}

+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//手机号码判断， 大陆这边是11位的，香港澳门的手机号码是6位或8位的,美国那边是有10位的，现在判断至少6位数字
+ (BOOL)isMobile:(NSString *)mobile
{
    BOOL flag = NO;
    if ([Utils isNilOrEmpty:mobile]) {
        flag = NO;
    } else if ([mobile hasPrefix:@"13"] || [mobile hasPrefix:@"15"] || [mobile hasPrefix:@"18"]){//大陆手机
        //手机号以13， 15，18开头，八个 \d 数字字符
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        flag = [phoneTest evaluateWithObject:mobile];
        
    } else {//其他手机，至少6位数字
        NSString *phoneRegex = @"^([0-9])([0-9]{5,14})";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        flag = [phoneTest evaluateWithObject:mobile];
    }
    
    return flag;
}
+ (BOOL)isURLString:(NSObject *)obj
{
    BOOL result = NO;
    if (![Utils isNilOrEmpty:obj]) {
        
        if ([(NSString *)obj hasPrefix:@"http://"]) {
            result = YES;
        }else{
            result = NO;
        }
    }else{
        result = NO;
    }
    
    return result;
}

//NSCharacterSet 去除NSString中的空格
+ (NSString *)trimString:(NSString *)str
{
    if (str) {
//        NSCharacterSet其实是许多字符或者数字或者符号的组合
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];// 字符串中去除特殊符号
    }
    return str;
}

//得到手机总容量
+ (CGFloat)getTotalCapacityOfMobilePhone
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    return ([totalSpace doubleValue])/1024.0/1024.0/1024.0;
//    return [NSString stringWithFormat:@"总容量%0.1fG",([totalSpace doubleValue])/1024.0/1024.0/1024.0];
}
//得到手机的可用容量
+ (CGFloat)getAvailableCapacityOfMobilePhone
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    return ([freeSpace doubleValue])/1024.0/1024.0/1024.0;
//    return [NSString stringWithFormat:@"空闲%0.1fG",([freeSpace doubleValue])/1024.0/1024.0/1024.0];

}

//得到手机的已用容量
+ (CGFloat)getUsedCapacityOfMobilePhone
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    return ([totalSpace doubleValue]-[freeSpace doubleValue])/1024.0/1024.0/1024.0;
//    return [NSString stringWithFormat:@"已用%0.1fG",([totalSpace doubleValue]-[freeSpace doubleValue])/1024.0/1024.0/1024.0];
}

//把double格式的时间转换成 YYYY年-MM月-DD日 20:00:00
/**
 *  把double格式的时间转换成 YYYY-MM-DD
 *
 *  @param timeInterval NSTimeInterval 类型的 时间 用1973来记时
 *
 *  @return YYYY年MM月DD日 20:00:00
 */

+ (NSString *)getSecondTypeTimeWithTimeInterval:(NSTimeInterval)timeInterval
{

    NSDate * date =  [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter * matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    return [matter stringFromDate:date];
}

//把double格式的时间转换成 YYYY-MM-DD
/**
 *  把double格式的时间转换成 YYYY-MM-DD
 *
 *  @param timeInterval NSTimeInterval 类型的 时间 用1973来记时
 *
 *  @return 2013-04-07
 */
+ (NSString *)getTimeWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate * date =  [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter * matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:@"yyyy-MM-dd"];
    return [matter stringFromDate:date];
}

//把double格式的时间转换成 MM月-DD日
/**
 *  把double格式的时间转换成 MM月-DD日
 *
 *  @param timeInterval NSTimeInterval 类型的 时间 用1973来记时
 *
 *  @return 06月-07日
 */
+ (NSString *)getThirdTimeWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate * date =  [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter * matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:@"MM月-dd日"];
    return [matter stringFromDate:date];
}

NSString * UDFormatFileSize(unsigned long long size) {
    
    NSString *formattedStr = nil;
    
    if (size == 0)
        formattedStr = @"0 KB";
    
	else if (size > 0 && size < 1024)
        formattedStr = [NSString stringWithFormat:@"%qu bytes", size];
    
    else if (size >= 1024 && size < pow(1024, 2))
        formattedStr = [NSString stringWithFormat:@"%.0f KB", (size / 1024.)];
    
    else if (size >= pow(1024, 2) && size < pow(1024, 3))
        formattedStr = [NSString stringWithFormat:@"%.1f MB", (size / pow(1024, 2))];
    
    else if (size >= pow(1024, 3))
        formattedStr = [NSString stringWithFormat:@"%.2f GB", (size / pow(1024, 3))];
	
    return formattedStr;
}
/*

unsigned int ParseIOSVersion(char * ver_str)
{
	if(strlen(ver_str) > 40)
		return 0;
    
	unsigned int v = 0;
	int n = 0;
	char * s;
	char c[50];
	strcpy(c, ver_str);
	strcat(c, ".0.0.0.");
	char * t = c;
	while((s = strstr(t, ".")))
	{
		*s = '\0';
		v = v << 8;
		v = v | (atoi(t) % 0x100);
		t = s + 1;
		n++;
		if(n == 4)
			break;
	}
	
	return v;
}
 */

/**
 *  获取客户端版本 e.g. 1.0
 *
 *  @return e.g. 1.0
 */
+ (NSString *)getAppVersion
{
     return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 *  获取设置系统语言 e.g. EN /CN
 *
 *  @return e.g. EN /CN
 */
+ (NSString *)getSystemLanguage
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

/**
 *  获取设置类型 e.g. @"iPhone", @"iPod touch"
 *
 *  @return e.g. @"iPhone", @"iPod touch"
 */
+ (NSString *)getSystemModel
{
    return [[NSString alloc] initWithString:[[UIDevice currentDevice] model]];
}

/**
 *  获取设置软件系统 e.g. IOS,OS_X,
 *
 *  @return e.g. IOS,OS_X,
 */
+ (NSString *)getSystemName
{
    return [[NSString alloc] initWithString:[[UIDevice currentDevice] systemName]];
}

/**
 *  获取设置系统的版本，e.g. @"4.0"
 *
 *  @return e.g. @"4.0"
 */
+ (NSString *)getSystemVersion
{
    return [[NSString alloc] initWithString:[[UIDevice currentDevice] systemVersion]];
}

/**
 *  获取用户在设置里面设置的名称 e.g. "My iPhone"
 *
 *  @return e.g. "My iPhone"
 */
+ (NSString *)getDevicesMasterName
{
    return [[NSString alloc] initWithString:[[UIDevice currentDevice] name]];
}

/**
 *  获取设置的信息 e.g. @"Keven 的 iPhone||iPhone touch||IOS||4.0||中文||1.0"
 *
 *  @return @"Keven 的 iPhone||iPhone touch||IOS||4.0||中文||1.0"
 */
+ (NSString *)getDevicesInfo
{
    return [[NSString alloc] initWithFormat:@"||%@||%@||%@||%@||%@||%@||",
            [[UIDevice currentDevice] name],
            [[UIDevice currentDevice] model],
            [[UIDevice currentDevice] systemName],
            [[UIDevice currentDevice] systemVersion],
            [[NSLocale preferredLanguages] objectAtIndex:0],
            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}


//IOS系统版本 各个部分 6.0.1 == 中得 6  0  1
/**
 *  分解getSystemVersion e.g. 各个部分 6.0.1 == 中得 6  0  1
 *
 *  @return e.g. @[6,0,1]
 */
+ (NSArray *)getPareIOSVersion
{
    NSString * versionString = [Utils getSystemVersion];
    NSArray * versionArray = [versionString componentsSeparatedByString:@"."];
    if (versionArray.count <= 2) {
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:versionArray];
        [tmpArray addObject:@"0"];
        versionArray = tmpArray;
    }

    return versionArray;
}

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
+ (UIView *)setupNoDataViewWithSuperView:(UIView *)sView
                                   frame:(CGRect)frame
                         backgroundImage:(UIImage *)image
                     backgroundImageRect:(CGRect)imgRect
                           refreshAction:(SEL)action
{
    
    UIView * noDataViewTmp = [[UIView alloc] initWithFrame:frame];
    noDataViewTmp.backgroundColor = KT_HEXCOLOR(0xF5F5F5);
    [sView addSubview:noDataViewTmp];
    noDataViewTmp.hidden = YES;
    
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithFrame:imgRect];
    backgroundImageView.image = image; 
    [noDataViewTmp addSubview:backgroundImageView];
    
    
    UIButton * pressedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pressedButton.frame = noDataViewTmp.bounds;
    pressedButton.backgroundColor = KT_UICOLOR_CLEAR;
    [pressedButton addTarget:sView action:action forControlEvents:UIControlEventTouchUpInside];
    [noDataViewTmp addSubview:pressedButton];
    
    return noDataViewTmp;
}
@end
