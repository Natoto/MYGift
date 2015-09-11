//
//  KTViewControllerWithBar.h
//  NetWorkTwo
//
//  Created by Keven on 13-12-20.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_VIEW_CONTROLLER_WITH_BAR_H__
#define __KT_VIEW_CONTROLLER_WITH_BAR_H__

#import "KTViewController.h"
#import "KTNavigationBar.h"
@interface KTViewControllerWithBar : KTViewController
KT_PROPERTY_STRONG_READ_ONLY KTNavigationBar * customNavigationBar;
KT_PROPERTY_ASSIGN_READ_ONLY BOOL              isNavBarHidden;
/**
 *  设置上导航显示/隐藏
 *
 *  @param hidden 支持 显示/隐藏
 */
- (void)setNavBarHidden:(BOOL)hidden;
/**
 *  设置上导航button
 */
- (void)setupCustomNavigationBarButton;
@end
#endif