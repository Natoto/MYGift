//
//  KTNavigationItem.h
//  NetWork
//
//  Created by Keven on 13-12-6.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_NAVIGATION_ITEM_H__
#define __KT_NAVIGATION_ITEM_H__

#import <Foundation/Foundation.h>
@interface KTNavigationItem : NSObject
KT_PROPERTY_STRONG_READ_ONLY  UIImage *icon;
KT_PROPERTY_STRONG_READ_ONLY  UIImage *highlightedIcon;
/**
 *  初始化存储标签栏的图片的类
 *
 *  @param iconImg            默认图片
 *  @param highlightedIconImg 点击高亮图片
 *
 *  @return 实例对象
 */
- (id)initWithIcon:(UIImage *)iconImg
   highlightedIcon:(UIImage *)highlightedIconImg;
@end

#endif