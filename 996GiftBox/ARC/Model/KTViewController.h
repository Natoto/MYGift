//
//  KTUIViewController.h
//  NetWork
//
//  Created by Keven on 13-12-6.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_VIEW_CONTROLLER_H__
#define __KT_VIEW_CONTROLLER_H__
#import <UIKit/UIKit.h>
#import "GBNoDataShowView.h"
@interface KTViewController : UIViewController <GBNoDataShowViewDelegate>
@property (nonatomic, assign) BOOL isHiddenStatusBar;
/**
 *  数据请求
 */
- (void)dataRequestMothed; //没有ToKenKey，不需要登录权限
/**
 *  添加视图。调整视图的显示的层次
 *
 *  @param view 要添加的视图
 */
- (void)addSubview:(UIView *)view;
/**
 *  初始化NoDataShowView

 *
 *  @param type     那个页面
 *  @param sView    父类视图
 *  @param delegate 父类ViewController
 *  @param action   回调事件
 */
- (void)setupNoDataShowViewWithType:(GBNoDataShowViewType)type superView:(UIView *)sView;
/**
 *  初始化NoDataShowView
 
 *
 *  @param type     那个页面
 *  @param sView    父类视图
 *  @param delegate 父类ViewController
 *  @param action   回调事件
 *  @param animation 启用动画/不启用
 */
- (void)setupNoDataShowViewWithType:(GBNoDataShowViewType)type superView:(UIView *)sView animation:(BOOL)animation;
///**
// *  设置NoDataShowView 显示隐藏
// *
// *  @param hidden  显示隐藏
// */
//- (void)setupNoDataShowViewHidden:(BOOL)hidden;
///**
// *  设置NoDataShowView 显示隐藏
// *
// *  @param hidden    显示隐藏
// *  @param animation 启用动画/不启用
// */
//- (void)setupNoDataShowViewHidden:(BOOL)hidden animation:(BOOL)animation;

/**
 *
 *  停止NoDataShowView 加载状态
 *
 */
- (void)stopIndicatorView;

/**
 *
 *  隐藏NoDataShowView
 *
 */
- (void)hidNoDataView;

/**
 *  视图将要显示
 *
 *  @param animated 是否支持动画
 */
- (void)viewWillAppearForKTView;
/**
 *  视图正要显示
 *
 *  @param animated 是否支持动画
 */
- (void)viewDidAppearForKTView;
/**
 *  视图将要消失
 *
 *  @param animated 是否支持动画
 */
- (void)viewWillDisappearForKTView;
/**
 *  视图正要消失
 *
 *  @param animated 是否支持动画
 */
- (void)viewDidDisappearForKTView;

@end
#endif