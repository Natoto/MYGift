//
//  Constants.h
//  GameBox
//
//  Created by KevenTsang on 13-11-4.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#ifndef __KT_CONSTANTS_H__
#define __KT_CONSTANTS_H__
#import <Foundation/Foundation.h>
/*
 #ifdef DEBUG
 # define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
 #else
 # define DLog(...);
 #endif
 　1) __VA_ARGS__ 是一个可变参数的宏，很少人知道这个宏，这个可变参数的宏是新的C99规范中新增的，目前似乎只有gcc支持（VC6.0的编译器不支持）。宏前面加上##的作用在于，当可变参数的个数为0时，这里的##起到把前面多余的","去掉的作用,否则会编译出错, 你可以试试。
 　　2) __FILE__ 宏在预编译时会替换成当前的源文件名
 　　3) __LINE__宏在预编译时会替换成当前的行号
 　　4) __FUNCTION__宏在预编译时会替换成当前的函数名称
 */

//调试开关，发布前把这个宏定义为0，1代表开启调试，0代表关闭调试
#define GIFTBOX_DEBUG 1

//---------------------------------------------------------------- SHOW_LOG
#define SHOW_LOG
#ifdef  SHOW_LOG
    #define KT_DLog(fmt, ...) NSLog((@"%s[Line %d]->" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #define KT_DLOG_SELECTOR    KT_DLog(@"%@",NSStringFromSelector(_cmd))
#else
    #define KT_DLog(...)
#endif
//---------------------------------------------------------------- SHOW_LOG

//----------------------------------------------------------------- IOS版本
#define KT_IOS_VERSION_5_OR_ABOVE (([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 5)? (YES):(NO))
#define KT_IOS_VERSION_6_OR_ABOVE (([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 6)? (YES):(NO))
#define KT_IOS_VERSION_7_OR_ABOVE (([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)? (YES):(NO))
#define KT_DEVICE_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//---------------------------------------------------------------- IOS版本


//----------------------------------------------------------------- 颜色
#define KT_HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define KT_UIColorWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define KT_UIColorWithRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
#define KT_UICOLOR_CLEAR [UIColor clearColor]
#define KT_DEFAULT_COLOR [UIColor whiteColor]   //默认颜色
#define KT_BlueColor    KT_HEXCOLOR(0x44B5FF)//领号
#define KT_GreenColor   KT_HEXCOLOR(0x19ab20)//预约
#define KT_PurpleColor  KT_HEXCOLOR(0xB35BD7)//已预约
#define KT_GrayColor    KT_HEXCOLOR(0xC0C0C0)//已领完/已过期/已领取
//---------------------------------------------------------------- 颜色

//----------------------------------------------------------------- 获取本地图片
#define KT_GET_LOCAL_PICTURE(imageName) [UIImage imageWithCGImage:[[[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]] CGImage] \
scale:[[UIScreen mainScreen] scale] \
orientation:UIImageOrientationUp]
#define KT_GET_LOCAL_PICTURE_SECOND(imageName) [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]]
//---------------------------------------------------------------- 获取本地图片

//----------------------------------------------------------------- 倒圆角
#define KT_CORNER_RADIUS(_OBJ,_RADIUS)   _OBJ.layer.masksToBounds = YES;\
 _OBJ.layer.cornerRadius = _RADIUS;
#define KT_CORNER_RADIUS_VALUE_2    2.0f
#define KT_CORNER_RADIUS_VALUE_5    5.0f
#define KT_CORNER_RADIUS_VALUE_10   10.0f
#define KT_CORNER_RADIUS_VALUE_15   15.0f
#define KT_CORNER_RADIUS_VALUE_20   20.0f
//---------------------------------------------------------------- 倒圆角

//----------------------------------------------------------------- instancetype 和非instancetype（id）
#ifndef KT_INSTANCETYPE
    #if __has_feature(objc_instancetype)
        #define KT_INSTANCETYPE instancetype
    #else
        #define KT_INSTANCETYPE id
    #endif
#endif
//----------------------------------------------------------------- instancetype 和非instancetype（id）

//----------------------------------------------------------------- ARC 和非ARC
#if __has_feature(objc_arc_weak)//objc_arc_weak <==>支持ARC 支持WEAk
#define KT_AUTORELEASE(exp)             exp
#define KT_RELEASE(exp)                 exp
#define KT_RETAIN(exp)                  exp
#define KT_DEALLOC(exp)                 exp
#define KT_STRONG                       strong
#define KT_WEAK                         weak
#define __KT_WEAK                       __weak
#define KT_CFTYPECAST(exp)              (__bridge exp)
#define KT_TYPECAST(exp)                (__bridge_transfer exp)
#define KT_CFRELEASE(exp)               CFRelease(exp)
    #elif __has_feature(objc_arc) //objc_arc <==>支持ARC 不支持WEAk
#define KT_AUTORELEASE(exp)             exp
#define KT_RELEASE(exp)                 exp
#define KT_RETAIN(exp)                  exp
#define KT_DEALLOC(exp)                 exp
#define KT_STRONG                       strong
#define KT_WEAK                         unsafe_unretained
#define __KT_WEAK                       __unsafe_unretained
#define KT_CFTYPECAST(exp)              (__bridge exp)
#define KT_TYPECAST(exp)                (__bridge_transfer exp)
#define KT_CFRELEASE(exp)               CFRelease(exp)
    #else  //非ARC <==>不支持ARC
#define KT_AUTORELEASE(exp)                 [exp autoreleas]
#define KT_RELEASE(exp)                     [exp release]
#define KT_RETAIN(exp)                      [exp retain]
#define KT_DEALLOC(exp)                     [exp dealloc]
#define KT_STRONG                           retain
#define KT_WEAK                             assign
#define __KT_WEAK                           assign
#define KT_CFTYPECAST(exp)                  exp
#define KT_TYPECAST(exp)                    exp
#endif
//---------------------------------------------------------------- ARC 和非ARC


//----------------------------------------------------------------- 属性的定义
#define  KT_PROPERTY_STRONG            @property (nonatomic,KT_STRONG)
#define  KT_PROPERTY_WEAK              @property (nonatomic,KT_WEAK)
#define  KT_PROPERTY_ASSIGN            @property (nonatomic,assign)
#define  KT_PROPERTY_COPY              @property (nonatomic,copy)
//---------------------------------------------------------------- (只读)
#define  KT_PROPERTY_STRONG_READ_ONLY  @property (readonly,nonatomic,KT_STRONG)
#define  KT_PROPERTY_WEAK_READ_ONLY    @property (readonly,nonatomic,KT_WEAK)
#define  KT_PROPERTY_ASSIGN_READ_ONLY  @property (readonly,nonatomic,assign)
#define  KT_PROPERTY_COPY_READ_ONLY    @property (readonly,nonatomic,copy)
//---------------------------------------------------------------- 属性的定义


//----------------------------------------------------------------- 扩展的定义
#define KT_COATEGORY_KEY(_OBJ)  static const void * _OBJ##Key = & _OBJ##Key
//----------------------------------------------------------------- 扩展的定义




//----------------------------------------------------------------- 文本对齐格式
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define KT_TextAlignmentLeft   NSTextAlignmentLeft
#define KT_TextAlignmentCenter NSTextAlignmentCenter
#define KT_TextAlignmentRight  NSTextAlignmentRight
    #else
#define KT_TextAlignmentLeft   UITextAlignmentLeft
#define KT_TextAlignmentCenter UITextAlignmentCenter
#define KT_TextAlignmentRight  UITextAlignmentRight
#endif
//---------------------------------------------------------------- 文本对齐格式

//----------------------------------------------------------------- 文本Size
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define KT_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
    boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin)\
    attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero
#define KT_TEXTSIZE_SIMPLE(text, font) [text length] > 0 ? [text \
    sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero

    #else

#define KT_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
    sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero
#define KT_TEXTSIZE_SIMPLE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero
#endif
//---------------------------------------------------------------- 文本Size

//UIFont的属性宏
#define GB_DEFAULT_FONT(fontSize)      [UIFont fontWithName:@"FZZhongDengXian-Z07S" size:fontSize]  //方正中等线简体


//默认展位图
//默认站位图片
#define KT_Placholder_Image_Name_50_50    @"placholder_50_50@2x"
#define KT_Placholder_Image_Name_60_60    @"placholder_60_60@2x"
#define KT_Placholder_Image_Name_300_140  @"placholder_300_140@2x"
#define KT_Placholder_Image_Name_152_71   @"placholder_152_71@2x"
#define KT_Placholder_Image_Name_100_60   @"placholder_100_60@2x"


//IOS默认的属性
//NOTE
//old
//#define   KT_UI_NAVIGATION_BAR_HEIGHT   44.0f
//#define   KT_UI_TAB_BAR_HEIGHT          49.0f
//new
#define   KT_UI_NAVIGATION_BAR_HEIGHT   44.0f
#define   KT_UI_TAB_BAR_HEIGHT          50.0f

#define   KT_UI_SCREEN_WIDTH            320.0f
#define   KT_UI_STATUS_BAR_HEIGHT       20.0f

//分享 推送的属性
//激光推送
#define    JPUSH_APP_KEY                @"9721b93ffd36f366986fa552" //996礼盒
#define    JPUSH_APP_API_MASTER_SECRE   @"40ef1ea5f9adf92e5e616092"


//友盟
#define UMSOCIAL_APP_KEY                @"52b95feb56240b31b20117f4" //996手游网
//#define UMSOCIAL_APP_KEY       @"52b94dd156240b31a900258c"

//微信
#define WE_CHAT_APP_ID                  @"wx20adc6360e8218ec" //996手游网
#define WE_CHAT_APP_KEY                 @"50f355e1e123fce67b410bef1f6e6ac0"



#pragma mark - 新浪

#define XIN_LANG_WB_APP_KEY         @"1443913663" //996手游网
#define XIN_LANG_WB_APP_SECRET      @"0aeaf16bf6261272fe5e8a309789c45a"
#define XIN_LING_WB_REDIRECT_URI    @"http://weibo.com/996game"

#pragma mark - 腾讯

#define TEN_XUN_WB_APP_ID         @"801460999" //996手游网
#define TEN_XUN_WB_APP_KEY        @"4de99c76e5b2a412968f7a6b8dac5133"

// QQ空间

#define TEN_XUN_QZONE_APP_KEY       @"100584692" //996手游网
#define TEN_XUN_QZONE_APP_SECRET    @"7c8c73e2f9f3c8e75b051120f170160a"

//区分模拟器和真机
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


#define  KT_IMPORT(Class_Name)   __KT_##Class_Name##_H__

//领取状态
typedef NS_ENUM(NSUInteger,GetGiftStatus) {
//    GetGiftStatusForNotLoggedIn     = -1,//未登录
    GetGiftStatusForEndForUnclaimed = 2,   //未领取/等待领取
    GetGiftStatusForAlreadyReceive  = 3,   //已领取
    GetGiftStatusForOrder           = 100, //预约
    GetGiftStatusForReservations    = 101, //已预约
    GetGiftStatusForOutOfDate       = 102, //已过期
    GetGiftStatusForHasBrought      = 103, //已领完
};



//MakEID ===TRUser
#define TR_USER_MAKE_ID @"996UserCenter"

//documentsDirectory + Name
// 缓存的存储文件名  和地址
#define kHOME_PAGE_ARCHIVING_FILE_KEY                   @"homePage.archiving"
#define kACTIVITY_CENTER_LIST_ARCHIVING_FILE_KEY        @"activityCenterList.archiving"
#define kACTIVITIES_DETAILS_ARCHIVING_FILE_KEY          @"activitiesDetails.archiving"
#define kGIFT_HAIR_ARCHIVING_FILE_KEY                   @"giftHair.archiving"
#define kPACKAGE_RECEIVE_ARCHIVING_FILE_KEY             @"packageReceive.archiving"
#define kOPEN_SERVICE_ARCHIVING_FILE_KEY                @"openServiceAndTestChart.archiving" //测试和开服




//发送请求的参数
#define DEFAULT_WRITE_LENGHT   996 //默认数据总长度
#define DEFAULT_CLIENT_VERSION 0   //客户端的跟接口对接的版本号 ,随服务器版本加1
#define DEFAULT_CLIENT_FLAGS   0   //备用参数，用来兼容不同的客户端 接口的兼容，先暂时可以为0


// KeyChain Keys
#define kKeyChainUserNameKey                @"username"
#define kKeyChainPasswordKey                @"password"
#define kKeyChainServiceName                @"GameGifts"


//百度统计事件id
#define BAIDU_STATISTICS_EVENT_ID_LOGIN_SUCCESS         @"00001"  //登录成功
#define BAIDU_STATISTICS_EVENT_ID_REGISTER_SUCCESS      @"00002"  //注册成功
#define BAIDU_STATISTICS_EVENT_ID_GIFTGET_BUTTON        @"00003"  //点击礼包领取按钮
#define BAIDU_STATISTICS_EVENT_ID_GIFTGET_SUCCESS       @"00004"  //礼包领取成功
#define BAIDU_STATISTICS_EVENT_ID_GIFTRESERVE_BUTTON    @"00005"  //点击礼包预约按钮
#define BAIDU_STATISTICS_EVENT_ID_GIFTRESERVE_SUCCESS   @"00006"  //礼包预约成功
#define BAIDU_STATISTICS_EVENT_ID_ACTIVITY_LINK         @"00007"  //点击活动链接地址
#define BAIDU_STATISTICS_EVENT_ID_SEARCH_BUTTON         @"00008"  //点击搜索按钮
#define BAIDU_STATISTICS_EVENT_ID_LOGOUT_BUTTON         @"00009"  //点击注销登录按钮
#define BAIDU_STATISTICS_EVENT_ID_LOGOUT_SUCCESS        @"00010"  //注销成功
#define BAIDU_STATISTICS_EVENT_ID_COPY_BUTTON           @"00011"  //点击礼包码拷贝按钮
#define BAIDU_STATISTICS_EVENT_ID_SECOND_SEARCH_BUTTON  @"00012"  //点击次级搜索按钮
#define BAIDU_STATISTICS_EVENT_ID_CHECK_UPDATE_BUTTON   @"00013"  //点击检查更新按钮
#define BAIDU_STATISTICS_EVENT_ID_OPEN_SERVER_BUTTON    @"00014"  //点击开服按钮
#define BAIDU_STATISTICS_EVENT_ID_TEST_BUTTON           @"00015"  //点击测试按钮
#define BAIDU_STATISTICS_EVENT_ID_HOT_RECO_BUTTON       @"00016"  //点击热门礼包推荐按钮

//==============================================================================
//NSNotification
//==============================================================================
//登录状态改变通知
#define NOTIFICATION_GLOBAL_LOGINSTATUS_CHANGE   @"NOTIFICATION_GLOBAL_LOGINSTATUS_CHANGE"

#endif
