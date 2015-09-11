//
//  KTNavigationItem.m
//  NetWork
//
//  Created by Keven on 13-12-6.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "KTNavigationItem.h"
@interface KTNavigationItem ()
KT_PROPERTY_STRONG  UIImage *icon;
KT_PROPERTY_STRONG  UIImage *highlightedIcon;
@end

@implementation KTNavigationItem
/**
 *  初始化存储标签栏的图片的类
 *
 *  @param iconImg            默认图片
 *  @param highlightedIconImg 点击高亮图片
 *
 *  @return 实例对象
 */
- (id)initWithIcon:(UIImage *)iconImg
   highlightedIcon:(UIImage *)highlightedIconImg
{
    self = [super init];
    if (self) {
        self.icon = iconImg;
        self.highlightedIcon = highlightedIconImg;
    }
    return self;
}

@end
