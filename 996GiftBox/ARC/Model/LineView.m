//
//  LineView.m
//  996GameBox
//
//  Created by Keven on 13-12-10.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "LineView.h"
//会移动的线的高度是1.0f，不会移动的线的高度是0.5
#define GB_GAME_BOX_LINE_HEIGHT_MOVED   1.0f
#define GB_GAME_BOX_LINE_HEIGHT_DEFAULT 0.5f
@implementation LineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KT_UICOLOR_CLEAR;
        self.lineWith = 300;
        self.type = LineViewTypeForSolidLine;
        self.lineoriginY = self.bounds.size.height - GB_GAME_BOX_LINE_HEIGHT_DEFAULT;
        self.lineoriginX = 10;
        [self setNeedsDisplay];
    }
    return self;
}
/**
 *  初始化一条颜色默认的直线的视图
 *
 *  @param frame  视图位置和大小
 *  @param type  支持类型，实线或者虚线
 *
 *  @return 视图对象
 */
- (id)initWithFrame:(CGRect)frame
               type:(LineViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KT_UICOLOR_CLEAR;
        self.lineWith = 300;
        self.type = type;
        self.lineoriginY = self.bounds.size.height - GB_GAME_BOX_LINE_HEIGHT_DEFAULT;
        self.lineoriginX = 10;
        [self setNeedsDisplay];
    }
    return self;
}
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
               with:(NSUInteger)lineWith
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KT_UICOLOR_CLEAR;
        self.type = type;
        self.lineWith = lineWith;
        self.lineoriginY = self.bounds.size.height - GB_GAME_BOX_LINE_HEIGHT_DEFAULT;
        self.lineoriginX = (320 - lineWith) / 2;
        [self setNeedsDisplay];
    }
    return self;
}
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
        LineoriginY:(CGFloat)LineoriginY
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KT_UICOLOR_CLEAR;
        self.type = type;
        self.lineWith = lineWith;
        self.lineoriginY = LineoriginY;
        self.lineoriginX = (320 - lineWith) / 2;
        [self setNeedsDisplay];
    }
    return self;
}
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
        lineOriginX:(CGFloat)lineOriginX
{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KT_UICOLOR_CLEAR;
        self.type = type;
        self.lineWith = lineWith;
        self.lineoriginY = LineoriginY;
        self.lineoriginX = lineOriginX;
        [self setNeedsDisplay];
    }
    return self;

}
/**
 *  重新渲染一条颜色默认的直线的视图
 *
 *  @param frame    视图位置和大小
 *  @param type     支持类型，实线或者虚线
 *  @param lineWith 直线长度
 */
- (void)setFrame:(CGRect)frame
            type:(LineViewType)type
            with:(NSUInteger)lineWith
{
    self.frame = frame;
    self.type = type;
    self.lineWith = lineWith;
    self.lineoriginY = self.bounds.size.height - GB_GAME_BOX_LINE_HEIGHT_DEFAULT;
    self.lineoriginX = (320 - lineWith) / 2;
    [self setNeedsDisplay];
}
/**
 *  视图渲染
 *
 *  @param rect 渲染范围
 */
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    if (self.type == LineViewTypeForSolidLine) {
        //实线
        CGContextSetRGBStrokeColor(context, 0xCA / 255.0, 0xCA / 255.0, 0xCA / 255.0, 1);//线条颜色
        CGContextSetLineWidth(context, GB_GAME_BOX_LINE_HEIGHT_DEFAULT);
        CGContextSetShouldAntialias(context, NO ); //关闭消除锯齿
        CGContextMoveToPoint(context, self.lineoriginX, self.lineoriginY);
        CGContextAddLineToPoint(context, self.lineWith + self.lineoriginX ,self.lineoriginY);
    }else{
        //虚线
        CGContextSetLineWidth(context, GB_GAME_BOX_LINE_HEIGHT_DEFAULT);
         CGContextSetShouldAntialias(context, NO ); //关闭消除锯齿
        CGContextSetStrokeColorWithColor(context, KT_UIColorWithRGB(0x99, 0x99, 0x99).CGColor);
        float lengths[] = {5,5};
        CGContextSetLineDash(context, 0, lengths, 2);
//        CGContextSetLineDash(context, 0, lengths,2);
        CGContextMoveToPoint(context,  self.lineoriginX,  self.lineoriginY);
        CGContextAddLineToPoint(context, self.lineWith + self.lineoriginX ,self.lineoriginY);
    }
     CGContextStrokePath(context);
}

@end
