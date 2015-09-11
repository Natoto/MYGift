//
//  GBAppDelegate.m
//  GameGifts
//
//  Created by Keven on 13-12-24.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GBAppDelegate.h"
#import "OpenUDID.h"
#import "KTMainViewController.h"
#import "BaiduMobStat.h"
#import "APService.h"
#import "UncaughtExceptionHandler.h"
#import "GBAccountManager.h"
#import "LocalSettings.h"

@implementation GBAppDelegate

//-----------------------------------------------------------------程序启动，退出
/**
 *  程序将要启动
 *
 *  @param application   程序启动控制器
 *  @param launchOptions 启动相关信息
 *
 *  @return YES,NO
 */
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    KT_DLOG_SELECTOR;
    return YES;
}
/**
 *  程序启动入口
 *
 *  @param application   程序启动控制器
 *  @param launchOptions 启动相关信息
 *
 *  @return YES,NO
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    installUncaughtExceptionHandler(); // 未捕获的Objective-C异常 捕获
    [self setupUUID];//UUID
    [self setupReachAbility]; //网络类型
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    KTMainViewController * nav = [[KTMainViewController alloc] init];
    self.window.rootViewController = nav;
    self.mainViewController = nav;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    [self setupJPushAPServiceWithOptions:launchOptions]; //极光推送
    // apn 内容获取：
    self.JPushUserInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    [self showViewForJPushbyOnline:NO];
    
    //打开百度统计服务
    [self OpenServiceForBaiduMob];
    
    //自动登录
    [[TRUser sharedInstance] addLoginQueue:^(NSString *tokenKey, unsigned long long userId, NSString *userName, NSString *tmpUserName) {
        [[GBAccountManager sharedAccountManager] requestUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GLOBAL_LOGINSTATUS_CHANGE object:nil];
    } cancel:^{
        
    } markId:nil];
    
    [[LocalSettings sharedInstance] addObserver:self forKeyPath:@"isPushOpen" options:NSKeyValueObservingOptionNew context:nil];
    
    return YES;
}
/**
 *  当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作。这个需要要设置UIApplicationExitsOnSuspend的键值（自动设置）
 *
 *  @param application 程序启动控制器
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
    KT_DLOG_SELECTOR;
}
//-----------------------------------------------------------------程序启动，退出


//-----------------------------------------------------------------传入电话呼叫或SMS消息 临时中断 调用函数
/**
 *  从主动到非活动状态 （产生某些类型的临时中断，如传入电话呼叫或SMS消息） 使用此方法暂停正在进行的任务，禁用定时器，踩下油门， OpenGL ES的帧速率。游戏应该使用这种方法来暂停游戏
 *
 *  @param application 程序启动控制器
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    KT_DLOG_SELECTOR;
}
/**
 *  从非活动状态到主动，这个刚好跟上面那个方法相反
 *
 *  @param application 程序启动控制器
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    KT_DLOG_SELECTOR;
    /**
     这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
     */
//    [UMSocialSnsService  applicationDidBecomeActive];
}
//-----------------------------------------------------------------传入电话呼叫或SMS消息 临时中断 调用函数

//-----------------------------------------------------------------程序关闭进入后台挂起
/**
 *  程序正要进入后台
 *
 *  @param application 程序控制器
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    KT_DLOG_SELECTOR;
}

/**
 *  从后台将要重新回到前台
 *
 *  @param application 程序控制器
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    KT_DLOG_SELECTOR;
}
//-----------------------------------------------------------------程序关闭进入后台挂起

//-----------------------------------------------------------------iPhone设备只有有限的内存，如果为应用程序分配了太多内存操作系统会终止应用程序的运行，在终止前会执行这个方法，通常可以在这里进行内存清理工作防止程序被终止
/**
 *  进行内存清理工作
 *
 *  @param application 程序控制器
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    KT_DLOG_SELECTOR;
}

/**
 *  通过url执行
 *
 *  @param application 程序控制器
 *  @param url         URL网站链接
 *
 *  @return YES,NO
 */
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
    KT_DLOG_SELECTOR;
    return YES;
}

/**
 *   当程序载入后执行
 *
 *  @param application 程序控制器
 */
- (void)applicationDidFinishLaunching:(UIApplication*)application
{
    KT_DLOG_SELECTOR;
}

/**
 *  系统时间发生改变时执行
 *
 *  @param application 程序控制器
 */
- (void)applicationSignificantTimeChange:(UIApplication*)application
{
    KT_DLOG_SELECTOR;
}

//------------------------------------------------------------------StatusBar位置，尺寸变化
/**
 *  当StatusBar框将要变化时执行
 *
 *  @param application       程序控制器
 *  @param newStatusBarFrame statusBar 位置和尺寸
 */
- (void)application:(UIApplication*)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    KT_DLOG_SELECTOR;
}
/**
 *  当StatusBar框方向变化完成后执行
 *
 *  @param application       程序控制器
 *  @param newStatusBarFrame statusBar 位置和尺寸
 */
- (void)application:(UIApplication*)application didChangeSetStatusBarFrame:(CGRect)oldStatusBarFrame
{
    KT_DLOG_SELECTOR;
}
//------------------------------------------------------------------StatusBar位置，尺寸变化

//------------------------------------------------------------------StatusBar框方向变化
/**
 *  当StatusBar框方向将要变化时执行
 *
 *  @param application             程序控制器
 *  @param newStatusBarOrientation statusBar方向
 *  @param duration                时间
 */
- (void)application:(UIApplication*)application
willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation
           duration:(NSTimeInterval)duration

{
    KT_DLOG_SELECTOR;
}
/**
 *  当当StatusBar框变化完成后执行
 *
 *  @param application             程序控制器
 *  @param newStatusBarOrientation statusBar方向
 *  @param duration                时间
 */
- (void)application:(UIApplication*)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
{
    KT_DLOG_SELECTOR;
}
//------------------------------------------------------------------StatusBar框方向变化


/*
// 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
*/
/*
#pragma mark - JPush   APService
//支持IOS 7 打开下面的开关和capabilities->Background modes ->Remove notification
#if __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
     //NOTE IOS7以上
    KT_DLOG_SELECTOR;
    KT_DLog(@"\n\n只支持IOS 7 == this is iOS7 Remote Notification\n\n");
    
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    KT_DLog(@"content =[%@], badge=[%d], sound=[%@], customize field =[%@]",content,badge,sound,customizeField1);
    //NOTE 在这里
    // Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}
#else
*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    KT_DLOG_SELECTOR;
    // 取得 APNs 标准信息内容
    self.JPushUserInfo = userInfo;
      // Required
    [APService handleRemoteNotification:userInfo];
    //得到推送的处理事件
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) { //激活状态
        [self showViewForJPushbyOnline:YES];
    }else{
//        UIApplicationStateInactive待激活状态   UIApplicationStateBackground  后台状态
        [self showViewForJPushbyOnline:NO];
    }
}
//#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    KT_DLOG_SELECTOR;
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    KT_DLOG_SELECTOR;
    KT_DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
//------------------------------------------------------------------ JPush 激光推送
#pragma mark - JPush 激光推送
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == [LocalSettings sharedInstance] && [keyPath isEqualToString:@"isPushOpen"]) {
        
        if (![LocalSettings sharedInstance].isPushOpen) {
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }else{
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                           UIRemoteNotificationTypeSound |
                                                           UIRemoteNotificationTypeAlert)]; // 注册APNS类型,声音，提示框
        }
    }
}

- (void)showViewForJPushbyOnline:(BOOL)online
{
    if (![Utils isNilOrEmpty:self.JPushUserInfo]) {
        NSDictionary *aps = [self.JPushUserInfo valueForKey:@"aps"];
        NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
        KT_DLog(@"aps:%@",aps);
        
//        if ([[self.JPushUserInfo allKeys] containsObject:@"AppVersion"]) {
//            // contains key
//            [self.mainViewController.tabBar showUpdateImageAtIndex:KTTabBarControllerTypeForFourth - 1001];
//        }
        
        //新版本通知
        NSString *latestVersion = [self.JPushUserInfo objectForKey:@"AppVersion"];
        if (latestVersion) {
            [self.mainViewController.tabBar showUpdateImageAtIndex:KTTabBarControllerTypeForFourth - 1001];
            [LocalSettings sharedInstance].latestVersion = latestVersion;
        }
        
        // 取得自定义字段内容
//        NSArray * tmpArray = [content componentsSeparatedByString:@"---"];
//        if ([tmpArray count] > 1) {
//            int tabBarTag = [[tmpArray objectAtIndex:1] intValue];
//            if (online) { //在线接受到推送
//                switch (tabBarTag) {
//                    case 1001:{
//                        [self.mainViewController showKTNavigationControllerForJPushByOnlineWithIndex:0];
//                        break;
//                    }
//                    case 2002:{
//                        [self.mainViewController showKTNavigationControllerForJPushByOnlineWithIndex:1];
//                        break;
//                    }
//                    case 3003:{
//                        [self.mainViewController showKTNavigationControllerForJPushByOnlineWithIndex:2];
//                        break;
//                    }
//                    case 4004:{
//                        [self.mainViewController showKTNavigationControllerForJPushByOnlineWithIndex:3];
//                        break;
//                    }
//                    default:
//                        break;
//                }
//            }else{ //后台，离线 接受到推送
//                switch (tabBarTag) {
//                    case 1001:{
//                        [self.mainViewController showKTNavigationControllerForJPushWithIndex:0];
//                        break;
//                    }
//                    case 2002:{
//                        [self.mainViewController showKTNavigationControllerForJPushWithIndex:1];
//                        break;
//                    }
//                    case 3003:{
//                        [self.mainViewController showKTNavigationControllerForJPushWithIndex:2];
//                        break;
//                    }
//                    case 4004:{//不在线，4004，版本更新,直接跳转到 appStore
//                        [self.mainViewController showKTNavigationControllerForJPushWithIndex:3];
//                        [self.mainViewController showKTNavigationControllerForJPushByOnlineWithIndex:3];
//                        //NOTE 卡顿
//                        NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", [[NSBundle mainBundle] bundleIdentifier]];
//                        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
//                        [[UIApplication sharedApplication] openURL:iTunesURL];
//                        break;
//                    }
//                    default:
//                        break;
//                }
//            }
//        }
        }
        
    //对显示进行改变
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
/**
 *  设置激光推送相关
 *
 *  @param launchOptions 程序启动
 */
- (void)setupJPushAPServiceWithOptions:(NSDictionary *)launchOptions
{
    //先注册推送的6种通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(JPushAPServiceDidSetup:) name:kAPNetworkDidSetupNotification object:nil];// 建立连接
    [defaultCenter addObserver:self selector:@selector(JPushAPServiceDidClose:) name:kAPNetworkDidCloseNotification object:nil];// 关闭连接
    [defaultCenter addObserver:self selector:@selector(JPushAPServiceDidRegister:) name:kAPNetworkDidRegisterNotification object:nil];// 注册成功
    [defaultCenter addObserver:self selector:@selector(JPushAPServiceDidLogin:) name:kAPNetworkDidLoginNotification object:nil];// 登录成功
    [defaultCenter addObserver:self selector:@selector(JPushAPServiceDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];// 收到消息(非APNS)
    [defaultCenter addObserver:self selector:@selector(JPushAPServiceError:) name:kAPServiceErrorNotification object:nil];// 错误提示
    if ([LocalSettings sharedInstance].isPushOpen) {
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)]; // 注册APNS类型,声音，提示框
    }else{
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    
    [APService setupWithOption:launchOptions]; //// 初始化
    [JPushManager setAPServiceByBoot]; //程序启动时设置推送
}

// 建立连接
- (void)JPushAPServiceDidSetup:(NSNotification *)notification
{
    KT_DLOG_SELECTOR;
    
}
// 关闭连接
- (void)JPushAPServiceDidClose:(NSNotification *)notification
{
    KT_DLOG_SELECTOR;
}
// 注册成功
- (void)JPushAPServiceDidRegister:(NSNotification *)notification
{
    KT_DLOG_SELECTOR;
}
// 登录成功
- (void)JPushAPServiceDidLogin:(NSNotification *)notification
{
    KT_DLOG_SELECTOR;
}
// 收到消息(非APNS)
- (void)JPushAPServiceDidReceiveMessage:(NSNotification *)notification
{
    KT_DLOG_SELECTOR;
}
// 错误提示
- (void)JPushAPServiceError:(NSNotification *)notification
{
    KT_DLOG_SELECTOR;
}

//------------------------------------------------------------------ BaiduMob 百度统计
#pragma mark - BaiduMob 百度统计
- (void)OpenServiceForBaiduMob
{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
//    statTracker.channelId = @"AppStore";
    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;
    statTracker.logSendInterval = 1;
//    statTracker.logSendWifiOnly = YES;
    statTracker.sessionResumeInterval = 30;
    [statTracker startWithAppId:@"038ffa99ca"];
}

#pragma mark -  Other  其他方法
//------------------------------------------------------------------ Other  其他方法
/**
 *  设置此刻的网络类型 有网，无网
 *
 *  @param status YES,NO
 */
- (void)setupWorkStatus:(BOOL)status
{
    _workStatus = status;
}
/**
 *  初始化网络类型类
 */
- (void)setupReachAbility
{
    [[NetworkUtils sharedInstance] startMonitoringNetworkStatus];
}
/**
 *  初始化 OpenUDID
 */
- (void)setupOpenUDID
{
    NSString * openUDID = [OpenUDID getOpenUDID];
    if (![Utils isNilOrEmpty:openUDID]) {
        KT_DLog(@"UUID:%@",openUDID);
        [[NSUserDefaults standardUserDefaults] setObject:openUDID forKey:@"open_UDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
/**
 *  初始化 UUID
 */
- (void)setupUUID
{
    NSString * UUID = [OpenUDID getUUID];
    if (![Utils isNilOrEmpty:UUID]) {
        KT_DLog(@"UUID:%@",UUID);
        [[NSUserDefaults standardUserDefaults] setObject:UUID forKey:@"UUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/*
 //友盟分享
 - (void)setupUMSocial
 {
 //设置友盟社会化组件appkey
 [UMSocialData setAppKey:UMSOCIAL_APP_KEY];
 
 //设置微信AppId
 [UMSocialConfig setWXAppId:WE_CHAT_APP_ID url:@"www.996.com"];
 //打开Qzone的SSO开关
 [UMSocialConfig setSupportQzoneSSO:YES importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
 [UMSocialConfig setQQAppId:TEN_XUN_QZONE_APP_KEY url:@"http://sns.whalecloud.com/app/PD2U0V" importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
 //打开新浪微博的SSO开关
 [UMSocialConfig setSupportSinaSSO:YES];
 //打开调试log的开关
 [UMSocialData openLog:YES];
 
 //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
 [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
 }
 */

@end
