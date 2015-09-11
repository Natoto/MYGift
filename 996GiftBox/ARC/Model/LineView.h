//
//  LineView.h
//  996GameBox
//
//  Created by Keven on 13-12-10.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//
#ifndef __KT_LINE_VIEW_H__
#define __KT_LINE_VIEW_H__
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LineViewType) {
    LineViewTypeForSolidLine,//实线
    LineViewTypeForDottedLine//虚线
};

@interface LineView : UIView
KT_PROPERTY_ASSIGN LineViewType         type;
KT_PROPERTY_ASSIGN  NSUInteger          lineWith;
KT_PROPERTY_ASSIGN  CGFloat             lineoriginY;
KT_PROPERTY_ASSIGN  CGFloat             lineoriginX;
KT_PROPERTY_STRONG  UIColor             * lineColor;
/**
 *  初始化一条颜色默认的直线的视图
 *
 *  @param frame  视图位置和大小
 *  @param type  支持类型，实线或者虚线
 *
 *  @return 视图对象
 */
- (id)initWithFrame:(CGRect)frame
               type:(LineViewType)type;
/**
 *  初始化一条颜色默认的直线的视图
 *
 *  @param frame    视图位置和大小
 *  @param type     支持类型，实线或者虚线
 *  @param lineWith 直线长度
 *
 *  @return 视图对象
 */
- (id)initWithFrame:(CGRect)frame
               type:(LineViewType)type
               with:(NSUInteger)lineWith;
/**
 *  初始化一条颜色默认的直线的视图
 *
 *  @param frame       视图位置和大小
 *  @param type        支持类型，实线或者虚线
 *  @param lineWith    直线长度
 *  @param LineoriginY 直线 Y坐标
 *
 *  @return 视图对象
 */
- (id)initWithFrame:(CGRect)frame
               type:(LineViewType)type
               with:(NSUInteger)lineWith
        LineoriginY:(CGFloat)LineoriginY;
/**
 *  初始化一条颜色默认的直线的视图
 *
 *  @param frame       视图位置和大小
 *  @param type        支持类型，实线或者虚线
 *  @param lineWith    直线长度
 *  @param LineoriginY 直线 Y坐标
 *  @param lineOriginX 直线 X坐标
 *
 *  @return 视图对象
 */
- (id)initWithFrame:(CGRect)frame
               type:(LineViewType)type
               with:(NSUInteger)lineWith
        LineoriginY:(CGFloat)LineoriginY
        lineOriginX:(CGFloat)lineOriginX;
/**
 *  重新渲染一条颜色默认的直线的视图
 *
 *  @param frame    视图位置和大小
 *  @param type     支持类型，实线或者虚线
 *  @param lineWith 直线长度
 */
- (void)setFrame:(CGRect)frame
            type:(LineViewType)type
            with:(NSUInteger)lineWith;
@end
#endif