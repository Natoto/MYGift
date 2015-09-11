//
//  KTTabBar.h
//  NetWork
//
//  Created by Keven on 13-12-6.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#ifndef __KT_TAB_BAR_H__
#define __KT_TAB_BAR_H__
#import <UIKit/UIKit.h>
@protocol KTTabBarDelegate;
@interface KTTabBar : UIView
@property (nonatomic,assign) id<KTTabBarDelegate>     delegate;
@property (nonatomic,strong) NSMutableArray           *items;
@property (nonatomic,strong) NSMutableArray           *updates;
@property (nonatomic,assign) NSUInteger               selectedIndex;
/**
 *  初始化一个标签栏
 *
 *  @param items 标签栏的属性信息
 *
 *  @return 标签栏实例对象
 */
- (id)initWithItems:(NSArray *)items;
/**
 *  标签栏显示那个Tag（不带事件）
 *
 *  @param index Tag值
 */
- (void)showTabBarAtIndex:(NSUInteger)index;
/**
 *  标签栏显示那个Tag（带事件）
 *
 *  @param index Tag值
 */
- (void)showTabBarWithAcionAtIndex:(NSUInteger)index;
/**
 *  标签栏有推送事件效果 显示
 *
 *  @param index Tag值
 */
- (void)showUpdateImageAtIndex:(NSUInteger)index;
/**
 *  标签栏有推送事件效果 隐藏
 *
 *  @param index Tag值
 */
- (void)hiddenUpdateImageAtIndex:(NSUInteger)index;
@end
#endif

#ifndef __KT_TAG_BAR_DELEGATE_H__
#define __KT_TAG_BAR_DELEGATE_H__
@protocol KTTabBarDelegate <NSObject>
/**
 *  显示那个Tag
 *
 *  @param index Tag
 */
- (void)switchViewControllerIndex:(NSInteger)index;
@end
#endif