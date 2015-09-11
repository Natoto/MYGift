//
//  KTLogoView.m
//  NetWork
//
//  Created by keven on 13-12-2.
//  Copyright (c) 2013年 keven. All rights reserved.
//

#import "KTLogoView.h"
#import <math.h>
#define LOGO_VIEW_DEFAULT_IMAGE_NAME  @"refresh@2x.png"

#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)  //
#define SPACESING_HEIGHT    3

@interface KTLogoView()
@property (nonatomic, assign)CGFloat lineHeight;
@property (nonatomic, assign)CGFloat radius;
@end
@implementation KTLogoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineHeight = 0;
        self.backgroundColor =  [UIColor colorWithRed:0xD8/255.0 green:0xD8/255.0 blue:0xD8/255.0 alpha:1];
        [self setNeedsDisplay]; //从新绘制
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor * color = [UIColor colorWithRed:0xF2/255.0 green:0x77/255.0 blue:0x35/255.0 alpha:1];
    [color set];//设置线条颜色
    UIBezierPath * lineGraph = [UIBezierPath bezierPath];
    lineGraph.lineWidth = 5.0f; //设置线条宽度
    lineGraph.lineCapStyle = kCGLineCapRound;//设置线拐角
    lineGraph.lineJoinStyle = kCGLineCapRound;//设置终点处理
    [lineGraph moveToPoint:CGPointMake(0,self.bounds.size.height - self.lineHeight)];//设置起始点
    [lineGraph addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [lineGraph addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [lineGraph addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - self.lineHeight)];
    //下面是画弧
    [self paintingAfterCurveWithBezierPath:lineGraph];
    [lineGraph fill];
    
    //绘制图片
    UIImage* logoImg = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:LOGO_VIEW_DEFAULT_IMAGE_NAME ofType:nil]];
    [logoImg drawInRect:self.bounds];
    
}

- (void)paintingAfterCurveWithBezierPath:(UIBezierPath *)lineGraph
{
    CGFloat midPointX = self.bounds.size.width / 2;
    int spaceingNumber = fabsf(rand() % SPACESING_HEIGHT);
    CGFloat midPointY = self.bounds.size.height - self.lineHeight;
    CGFloat controlPointYOne = SPACESING_HEIGHT;
    CGFloat controlPointYTwo = SPACESING_HEIGHT;
    
    if (spaceingNumber % 2 == 0) {
        controlPointYOne +=spaceingNumber;
        controlPointYTwo -=spaceingNumber;
    }else{
        controlPointYOne -=spaceingNumber;
        controlPointYTwo +=spaceingNumber;
    }
    
    [lineGraph addQuadCurveToPoint:CGPointMake(midPointX, midPointY + spaceingNumber) controlPoint:CGPointMake(midPointX / 2 + midPointX, midPointY + controlPointYOne)];
    
    [lineGraph addQuadCurveToPoint:CGPointMake(0, midPointY) controlPoint:CGPointMake(midPointX / 2, midPointY + controlPointYTwo)];
}

- (void)changedBackgroudLineWithHeight:(CGFloat)height
{
    self.lineHeight = height;
    [self setNeedsDisplay];
}

@end
