//
//  KTViewControllerWithTabBar.h
//  NetWorkTwo
//
//  Created by Keven on 13-12-20.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_VIEW_CONTROLLER_WITH_TAG_BAR_H__
#define __KT_VIEW_CONTROLLER_WITH_TAG_BAR_H__

#import "KTViewControllerWithBar.h"
#import "CustomTabBar.h"
@interface KTViewControllerWithTabBar : KTViewControllerWithBar
KT_PROPERTY_STRONG_READ_ONLY CustomTabBar * customTabBar;
KT_PROPERTY_ASSIGN_READ_ONLY BOOL           isTabBarHidden;
/**
 *  设置下标签显示/隐藏
 *
 *  @param hidden 支持 显示/隐藏
 */
- (void)setTabBarHidden:(BOOL)hidden;
/**
 *  设置下标签button
 */
- (void)setupCustomTabBarButton;
@end
#endif