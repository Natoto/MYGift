//
//  KTMainViewController.h
//  996Test
//
//  Created by Keven on 14-1-16.
//  Copyright (c) 2014年 Keven. All rights reserved.
//
#ifndef __KT_MAIN_VIEW_CONTROLLER_H__
#define __KT_MAIN_VIEW_CONTROLLER_H__
typedef NS_ENUM(NSUInteger, KTTabBarControllerType){
    KTTabBarControllerTypeForFirst = 1001,
    KTTabBarControllerTypeForSecond,
    KTTabBarControllerTypeForThird,
    KTTabBarControllerTypeForFourth,
    KTTabBarControllerTypeForFifth,
};

#import <UIKit/UIKit.h>
#import "KTTabBar.h"
@class KTNavigationController;
@interface KTMainViewController : UIViewController
<KTTabBarDelegate>
@property (nonatomic,strong,readonly) KTTabBar   * tabBar;
@property (nonatomic,assign,readonly) KTTabBarControllerType   selectedTabBarControllerType;
@property (nonatomic,strong,readonly) KTNavigationController * firstRootNav;
@property (nonatomic,strong,readonly) KTNavigationController * secondRootNav;
@property (nonatomic,strong,readonly) KTNavigationController * thirdRootNav;
@property (nonatomic,strong,readonly) KTNavigationController * fourthRootNav;
@property (nonatomic,strong,readonly) KTNavigationController * fifthRootNav;
/**
 *  从一个Tab的n级页面跳转到另一个Tab的首页
 *
 *  @param index    KTNavigationController Tag
 *  @param animated 支持 效果/否
 */
- (void)popToKTViewControllerWithTabIndex:(NSUInteger)index animated:(BOOL)animated;
/**
 *  接受到推送通知后的动作事件 （从后台到前台的推送）
 *
 *  @param index KTNavigationController Tag
 */
- (void)showKTNavigationControllerForJPushWithIndex:(int)index;
/**
 *  接受到推送通知后的动作事件（用户在线）
 */
- (void)showKTNavigationControllerForJPushByOnlineWithIndex:(int)index;
@end
#endif