//
//  KTViewControllerWithTabBar.m
//  NetWorkTwo
//
//  Created by Keven on 13-12-20.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "KTViewControllerWithTabBar.h"

@interface KTViewControllerWithTabBar ()
KT_PROPERTY_STRONG CustomTabBar * customTabBar;
KT_PROPERTY_ASSIGN BOOL           isTabBarHidden;
@end

@implementation KTViewControllerWithTabBar
/**
 *  初始化子类视图
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupCustomTabBar];
    [self setupCustomTabBarButton];
}
/**
 *  内存溢出
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  设置下标签视图
 */
- (void)setupCustomTabBar
{
    CustomTabBar * tabBarTmp = [[CustomTabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - KT_UI_TAB_BAR_HEIGHT , KT_UI_SCREEN_WIDTH, KT_UI_TAB_BAR_HEIGHT)];
    [self.view addSubview:tabBarTmp];
     tabBarTmp.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.customTabBar = tabBarTmp;
    self.isTabBarHidden = NO;
}
/**
 *  设置下标签button
 */
- (void)setupCustomTabBarButton
{
    KT_DLog(@"设置下标签Button");
}
/**
 *  设置下标签显示/隐藏
 *
 *  @param hidden 支持 显示/隐藏
 */
- (void)setTabBarHidden:(BOOL)hidden
{
    if (self.isTabBarHidden && hidden) {
        //要求隐藏，而本身已隐藏
    } else if (!self.isTabBarHidden && !hidden) {
        //要求显示，而本身已显示
    } else if (self.isTabBarHidden && !hidden) {
        //要求显示，而本身已隐藏
        self.isTabBarHidden = NO;
        self.customTabBar.hidden = NO;
    } else if (!self.isTabBarHidden && hidden) {
        //要求隐藏，而本身已显示
        self.isTabBarHidden = YES;
        self.customTabBar.hidden = YES;
    }
}
/**
 *  添加视图。调整视图的显示的层次
 *
 *  @param view 要添加的视图
 */
- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    [self.view bringSubviewToFront:self.customTabBar];
}
/**
 *  初始化NoDataShowView
 
 *
 *  @param type     那个页面
 *  @param sView    父类视图
 *  @param delegate 父类ViewController
 *  @param action   回调事件
 */
- (void)setupNoDataShowViewWithType:(GBNoDataShowViewType)type
                          superView:(UIView *)sView
{
    KT_DLOG_SELECTOR;
    [super setupNoDataShowViewWithType:type superView:sView];
    [self.view bringSubviewToFront:self.customTabBar];
}
/**
 *  m没有数据页面的刷新界面
 *
 *  @param infoTag 默认是0,
 */
- (void)refreshByNoDataShowViewWithInfoTag:(int)infoTag
{
    KT_DLOG_SELECTOR;
}
@end
