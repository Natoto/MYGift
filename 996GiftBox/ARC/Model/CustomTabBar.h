//
//  CustomTabBar.h
//  NetWorkTwo
//
//  Created by Keven on 13-12-21.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_CUSTOM_TAB_BAR_H__
#define __KT_CUSTOM_TAB_BAR_H__

#import <UIKit/UIKit.h>
typedef enum {
    CustomTabBarButtonTypeOfLeft = 0,
    CustomTabBarButtonTypeOfRight = 1
}CustomTabBarButtonType;

@interface CustomTabBar : UIView
KT_PROPERTY_STRONG UIButton * leftButton;
KT_PROPERTY_STRONG UIButton * rightButton;
KT_PROPERTY_STRONG UIImageView * backgroundImageView;
/**
 *  设置标签栏的左右按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param buttonType       支持button类型，左边/右边
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setTabBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                      buttonType:(CustomTabBarButtonType)buttonType
                          target:(id)target
                          action:(SEL)action;
/**
 *  设置标签栏的左右按钮
 *
 *  @param Bgimage            默认背景图片
 *  @param BghighlightedImage 点击背景高亮图片
 *  @param buttonType         支持button类型，左边/右边
 *  @param target             代理
 *  @param action             代理事件
 */
- (void)setTabBarButtonWithBgImage:(UIImage *)Bgimage
                BghighlightedImage:(UIImage *)BghighlightedImage
                        buttonType:(CustomTabBarButtonType)buttonType
                            target:(id)target
                            action:(SEL)action;
/**
 *  设置标签栏的左右按钮
 *
 *  @param image              默认图片
 *  @param highlightedImage   点击高亮图片
 *  @param bgImage            默认背景图片
 *  @param highlightedBgImage 点击背景高亮图片
 *  @param buttonType         支持button类型，左边/右边
 *  @param target             代理
 *  @param action             代理事件
 */
- (void)setTabBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                         bgImage:(UIImage *)bgImage
              highlightedBgImage:(UIImage *)highlightedBgImage
                      buttonType:(CustomTabBarButtonType)buttonType
                          target:(id)target
                          action:(SEL)action;
/**
 *  设置标签栏的左右按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param buttonType       支持button类型，左边/右边
 *  @param title            button标题
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setTabBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                      buttonType:(CustomTabBarButtonType)buttonType
                           title:(NSString *)title
                          target:(id)target
                          action:(SEL)action;
/**
 *  设置标签栏的左右按钮
 *
 *  @param title      button标题
 *  @param buttonType 支持button类型，左边/右边
 *  @param target     代理
 *  @param action     代理事件
 */
- (void)setTabBarButtonWithTitle:(NSString *)title
                      buttonType:(CustomTabBarButtonType)buttonType
                          target:(id)target
                          action:(SEL)action;
@end
#endif