//
//  KTLoadingIndicator.m
//  996GameBox
//
//  Created by keven on 13-12-2.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "KTLoadingIndicator.h"


@interface KTLoadingIndicator () {
    float _startAngle;
    float _endAngle;
}

@end

@implementation KTLoadingIndicator


float Radian2Degree(float radian) {
    return ((radian / M_PI) * 180.0f);
}

float Degree2Radian(float degree) {
    return ((degree / 180.0f) * M_PI);
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0xFC/255.0 green:0xFC/255.0 blue:0xFC/255.0 alpha:1];
        center = self.center;
        radius = 7;
        arrowEdgeLength = 5;
        _startAngle = -90;
        _endAngle = -90;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0x44/255.0 green:0xB5/255.0 blue:0xFF/255.0 alpha:1].CGColor);
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextAddArc(ctx, center.x, center.y, radius, Degree2Radian(_startAngle), Degree2Radian(_endAngle), NO);
    CGPoint point = CGContextGetPathCurrentPoint(ctx);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //园点
    CGContextTranslateCTM(ctx, point.x, point.y);
    CGContextMoveToPoint(ctx, 0, -1.0f / sqrtf(3) * arrowEdgeLength);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0x44/255.0 green:0xB5/255.0 blue:0xFF/255.0 alpha:1].CGColor);
    CGContextFillEllipseInRect(ctx, CGRectMake(-1.5 , -1.5, 3.0, 3.0));
    
    CGContextRestoreGState(ctx);
    
}

- (void)stopLoading
{
    _endAngle = -90;
    _endAngle = -90;
 
    [self setNeedsDisplay];
}
- (void)didScroll:(float)offset {
    float deltaAngle = Radian2Degree(offset / radius);
    if (_endAngle < 200) {
        _endAngle += deltaAngle;
    }else{
        _endAngle += deltaAngle;
        _startAngle +=deltaAngle;
    }
    [self setNeedsDisplay];
}


@end

@interface KTLoadingIndicatorOver()
@property (nonatomic, KT_WEAK)KTLoadingIndicator * indicatorView;
@property (nonatomic, KT_WEAK)NSTimer * indicatorTimer;
@end

@implementation KTLoadingIndicatorOver
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupIndicatorOverViewWithFrame:self.bounds];
    }
    return self;
}

- (void)setupIndicatorOverViewWithFrame:(CGRect)frame
{
    KTLoadingIndicator * indicatiorTmp = [[KTLoadingIndicator alloc] initWithFrame:frame];
    [self addSubview:indicatiorTmp];
    self.indicatorView = indicatiorTmp;
}
- (void)stopAnimating
{
    if ([self.indicatorTimer isValid]) {
        [self.indicatorTimer invalidate];
    }
    [self.indicatorView stopLoading];
}
- (void)startAnimating
{
    //NOTE NSTimer
    self.indicatorTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/66.0f
                                                           target:self
                                                         selector:@selector(beginDidScroll)
                                                         userInfo:nil
                                                          repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.indicatorTimer forMode:NSRunLoopCommonModes];
    [self.indicatorTimer fire];
}
- (void)beginDidScroll
{
    [self.indicatorView didScroll:1.0f];
}

@end

