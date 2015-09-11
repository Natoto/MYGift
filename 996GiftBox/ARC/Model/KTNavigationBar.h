//
//  KTNavigationBar.h
//  NetWork
//
//  Created by Keven on 13-12-6.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_NAVIGATION_BAR_H__
#define __KT_NAVIGATION_BAR_H__

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,KTNavigationBarButtonType){
    KTNavigationBarButtonTypeOfLeft = 0,
    KTNavigationBarButtonTypeOfRight,

};


@interface KTNavigationBar : UIView
KT_PROPERTY_WEAK UIButton *navBarLeftButton;
KT_PROPERTY_WEAK UIButton *navBarRightButton;
KT_PROPERTY_WEAK UILabel *navBarTitleLabel;
KT_PROPERTY_WEAK UIImageView *navBarTitleImageView;
KT_PROPERTY_WEAK UIView *navBarTitleView;
KT_PROPERTY_WEAK UIImageView *navBarBgImageView;

/**
 *  设置导航栏的左右按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param buttonType       支持button类型，左边/右边
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setNavBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                      buttonType:(KTNavigationBarButtonType)buttonType
                          target:(id)target
                          action:(SEL)action;
/**
 *  设置导航栏的左右按钮
 *
 *  @param Bgimage            默认背景图片
 *  @param BghighlightedImage 点击背景高亮图片
 *  @param buttonType         支持button类型，左边/右边
 *  @param target             代理
 *  @param action             代理事件
 */
- (void)setNavBarButtonWithBgImage:(UIImage *)Bgimage
                BghighlightedImage:(UIImage *)BghighlightedImage
                        buttonType:(KTNavigationBarButtonType)buttonType
                            target:(id)target
                            action:(SEL)action;
/**
 *  设置导航栏的左右按钮
 *
 *  @param image              默认图片
 *  @param highlightedImage   点击高亮图片
 *  @param bgImage            默认背景图片
 *  @param highlightedBgImage 点击背景高亮图片
 *  @param buttonType         支持button类型，左边/右边
 *  @param target             代理
 *  @param action             代理事件
 */
- (void)setNavBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                         bgImage:(UIImage *)bgImage
              highlightedBgImage:(UIImage *)highlightedBgImage
                      buttonType:(KTNavigationBarButtonType)buttonType
                          target:(id)target
                          action:(SEL)action;
/**
 *  设置导航栏的左右按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param buttonType       支持button类型，左边/右边
 *  @param title            button标题
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setNavBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                      buttonType:(KTNavigationBarButtonType)buttonType
                           title:(NSString *)title
                          target:(id)target
                          action:(SEL)action;
/**
 *  设置导航栏的左右按钮
 *
 *  @param title      button标题
 *  @param buttonType 支持button类型，左边/右边
 *  @param target     代理
 *  @param action     代理事件
 */
- (void)setNavBarButtonWithTitle:(NSString *)title
                      buttonType:(KTNavigationBarButtonType)buttonType
                          target:(id)target
                          action:(SEL)action;
/**
 *  设置导航栏的返回按钮
 *
 *  @param target 代理
 *  @param action 代理事件
 */
- (void)setNavBarBackButtonTarget:(id)target action:(SEL)action;
/**
 *  设置导航栏的返回按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setNavBarBackButtonWithImage:(UIImage *)image
                    highlightedImage:(UIImage *)highlightedImage
                              target:(id)target
                              action:(SEL)action;
/**
 *  设置导航栏的返回按钮
 *
 *  @param image              默认图片
 *  @param highlightedImage   点击高亮图片
 *  @param bgImage            默认背景图片
 *  @param highlightedBgImage 点击背景高亮图片
 *  @param target             代理
 *  @param action             代理事件
 */
- (void)setNavBarBackButtonWithImage:(UIImage *)image
                    highlightedImage:(UIImage *)highlightedImage
                             bgImage:(UIImage *)bgImage
                  highlightedBgImage:(UIImage *)highlightedBgImage
                              target:(id)target
                              action:(SEL)action;
/**
 *  设置导航栏的返回按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param buttonType       支持button类型，左边/右边
 *  @param title            button标题
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setNavBarBackButtonWithImage:(UIImage *)image
                    highlightedImage:(UIImage *)highlightedImage
                          buttonType:(KTNavigationBarButtonType)buttonType
                               title:(NSString *)title
                              target:(id)target
                              action:(SEL)action;
/**
 *  设置导航栏标题
 *
 *  @param title 导航栏标题
 */
- (void)setNavBarTitle:(NSString *)title;
/**
 *  设置导航栏标题
 *
 *  @param titleImage d导航栏标题图片
 */
- (void)setNavBarTitleImage:(UIImage *)titleImage;
/**
 *  设置导航栏标题
 *
 *  @param navBarTitleView 设置导航栏标题视图
 */
- (void)setNavBarTitleWithTitleView:(UIView *)navBarTitleView;
/**
 *  使导航栏的左边按钮隐藏/显示
 *
 *  @param hidden 支持 隐藏/显示
 */
- (void)setNavBarLeftButtonHidden:(BOOL)hidden;
/**
 *  使导航栏的右边按钮隐藏/显示
 *
 *  @param hidden 支持 隐藏/显示
 */
- (void)setNavBarRightButtonHidden:(BOOL)hidden;
/**
 *  使导航栏的标题隐藏/显示
 *
 *  @param hidden 支持 隐藏/显示
 */
- (void)setNavBarTitleLabelHidden:(BOOL)hidden;
/**
 *  使导航栏的标题图片隐藏/显示
 *
 *  @param hidden 支持 隐藏/显示
 */
- (void)setNavBarTitleImageViewHidden:(BOOL)hidden;
/**
 *  使导航栏的标题视图隐藏/显示
 *
 *  @param hidden 支持 隐藏/显示
 */
- (void)setNavBarTitleViewHidden:(BOOL)hidden;
/**
 *  使导航栏的背景图片隐藏/显示
 *
 *  @param navBarBgImage 支持 隐藏/显示
 */
- (void)setNavBarBgImage:(UIImage *)navBarBgImage;

@end
#endif
