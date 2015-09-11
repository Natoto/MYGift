//
//  KTNavigationController.h
//  996Test
//
//  Created by Keven on 14-1-16.
//  Copyright (c) 2014年 Keven. All rights reserved.
//
#ifndef __KT_NAVIGATION_CONTROLLER_H__
#define __KT_NAVIGATION_CONTROLLER_H__
#import "KTViewController.h"
#import "objc/runtime.h"
@class KTTabBar,KTMainViewController;
@interface KTNavigationController : KTViewController
@property (nonatomic,strong,readonly) NSMutableArray   * viewControllers;
@property (nonatomic,strong,readonly) KTViewController * selectedViewController;
@property (nonatomic,assign,readonly) NSUInteger         selectedIndex;
- (void)setTabBar:(KTTabBar *)tabBar;
- (void)setTabBar:(KTTabBar *)tabBar  mainViewController:(KTMainViewController *)vc;

- (id)initWithRootKTViewController:(KTViewController *)rootViewController;

- (void)pushKTViewController:(KTViewController *)viewController animated:(BOOL)animated;
- (void)popKTViewControllerAnimated:(BOOL)animated;
- (void)popToKTViewController:(KTViewController *)viewController animated:(BOOL)animated;
- (void)popToRootKTViewControllerAnimated:(BOOL)animated;
- (void)popToKTViewControllerWithTabIndex:(NSUInteger)index animated:(BOOL)animated;
@end

@interface KTViewController (KTNavigationControllerItem)
@property(nonatomic,retain) KTNavigationController *KTNavigationController;
@end
#endif