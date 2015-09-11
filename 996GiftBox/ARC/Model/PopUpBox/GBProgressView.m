//
//  GBProgressView.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-25.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBProgressView.h"

@interface CircleView2 : UIView

#define GB_CIRCLE_DIAMETER_DEFAULT 5

#define innerRadius    1.5
#define outerRadius    2.5

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@property (nonatomic, assign)BOOL isHeighLight;

@end

@implementation CircleView2

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.isHeighLight) {
        [self drawSolid:context];
    }
    else{
        [self drawCircle:context];
    }
}

-(void)drawCircle:(CGContextRef)ctx {
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, self.frame.size.height/2 - 0.5, 0, M_PI *2, 0);
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
}

- (void)drawSolid:(CGContextRef)ctx
{
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    CGContextFillEllipseInRect(ctx, self.bounds);
}

@end

@interface GBProgressView()
{
    CircleView2 * leftCircle;
    CircleView2 * middleCircle;
    CircleView2 * rightCircle;
}

@property int pointDiameter;
@property BOOL animating;
@property CGFloat duration;
@property (nonatomic, weak) UILabel *tipLabel;

@end

@implementation GBProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame withPointDiameter:GB_CIRCLE_DIAMETER_DEFAULT];
    if (self) {
        // Initialization code
        self.tipLabel.text = @"加载中，请稍后...";
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame message:(NSString *)message
{
    self = [self initWithFrame:frame withPointDiameter:GB_CIRCLE_DIAMETER_DEFAULT];
    if (self) {
        if (message) {
            self.tipLabel.text = message;
        }
        else{
            self.tipLabel.text = @"加载中，请稍后...";
        }
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withPointDiameter:(int)diameter
{
    if ((self = [super initWithFrame:frame])) {
        
        self.pointDiameter = diameter;
        
        self.backgroundColor = [UIColor clearColor];
        
        leftCircle = [self addCircleViewWithXOffsetFromCenter:-12];
        middleCircle = [self addCircleViewWithXOffsetFromCenter:0];
        rightCircle = [self addCircleViewWithXOffsetFromCenter:12];
        
        //正在加载数据
        UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 12)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.center = CGPointMake(middleCircle.center.x, middleCircle.center.y + 22);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:12];
        tipLabel.textColor = [UIColor whiteColor];
        [self addSubview:tipLabel];
        self.tipLabel = tipLabel;
        
        self.animating = YES;
        self.duration = 0.2;
        NSArray *circles = @[leftCircle, middleCircle, rightCircle];
        [self animateWithViews:circles index:0 offset:self.pointDiameter];
    }
    return self;
}

- (CircleView2*)addCircleViewWithXOffsetFromCenter:(float)offset
{
    CGRect rect = CGRectMake(0, 0, self.pointDiameter, self.pointDiameter);
    CircleView2 *circle = [[CircleView2 alloc] init];
    circle.bounds = rect;
    circle.center = self.center;
    circle.frame = CGRectOffset(circle.frame, offset, 0);
    [self addSubview:circle];
    return circle;
}

- (void)animateWithViews:(NSArray*)circles index:(int)index offset:(float)offset
{
    if (!self.animating) {
        return;
    }
    CircleView2 *subLayer = ((CircleView2*)[circles objectAtIndex:index]);
    [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        subLayer.isHeighLight = YES;
        [subLayer setNeedsDisplay];
        subLayer.frame = CGRectMake(subLayer.frame.origin.x - offset/2,
                                subLayer.frame.origin.y - offset/2,
                                subLayer.frame.size.width + offset,
                                subLayer.frame.size.height + offset);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:self.duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            subLayer.frame = CGRectMake(subLayer.frame.origin.x + offset/2,
                                    subLayer.frame.origin.y + offset/2,
                                    subLayer.frame.size.width - offset,
                                    subLayer.frame.size.height - offset);
        } completion:^(BOOL finished) {
            subLayer.isHeighLight = NO;
            [subLayer setNeedsDisplay];
            if (self.animating) {
                int nextIndex = index+1;
                if (nextIndex >= [circles count]) {
                    nextIndex = 0;
                }
                [self animateWithViews:circles index:nextIndex offset:self.pointDiameter];
            }
        }];
    }];
}

- (void)stop
{
    self.duration = 0.f;
    self.animating = NO;
}


@end
