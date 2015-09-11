//
//  KTViewControllerWithBar.m
//  NetWorkTwo
//
//  Created by Keven on 13-12-20.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "KTViewControllerWithBar.h"

@interface KTViewControllerWithBar ()
KT_PROPERTY_STRONG KTNavigationBar * customNavigationBar;
KT_PROPERTY_ASSIGN BOOL              isNavBarHidden;
@end

@implementation KTViewControllerWithBar
/**
 *  初始化子类视图
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCustomNavigationBar];
    [self setupCustomNavigationBarButton];
}
/**
 *  内存溢出
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  设置上导航视图
 */
- (void)setupCustomNavigationBar
{
    CGFloat barHeight = 0;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        barHeight = KT_UI_NAVIGATION_BAR_HEIGHT + 20;
    }else{
        barHeight = KT_UI_NAVIGATION_BAR_HEIGHT;
    }
    KTNavigationBar * customNavigationBarTmp = [[KTNavigationBar alloc] initWithFrame:CGRectMake(0, 0, KT_UI_SCREEN_WIDTH, barHeight)];
    [self.view addSubview:customNavigationBarTmp];
    customNavigationBarTmp.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.customNavigationBar = customNavigationBarTmp;
    self.isNavBarHidden = NO;
}
/**
 *  设置上导航button
 */
- (void)setupCustomNavigationBarButton
{
    KT_DLog(@"设置上导航Button");
}
/**
 *  设置上导航是否显示
 *
 *  @param hidden 支持 显示/隐藏
 */
- (void)setNavBarHidden:(BOOL)hidden
{
    if (self.isNavBarHidden && hidden) {
        //要求隐藏，而本身已隐藏
    } else if (!self.isNavBarHidden && !hidden) {
        //要求显示，而本身已显示
    } else if (self.isNavBarHidden && !hidden) {
        //要求显示，而本身已隐藏
        self.isNavBarHidden = NO;
        self.customNavigationBar.hidden = NO;
    } else if (!self.isNavBarHidden && hidden) {
        //要求隐藏，而本身已显示
        self.isNavBarHidden = YES;
        self.customNavigationBar.hidden = YES;
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
    [self.view bringSubviewToFront:self.customNavigationBar];
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
    [self.view bringSubviewToFront:self.customNavigationBar];

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
