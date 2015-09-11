//
//  GBSearchProgressHUD.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-6.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBSearchProgressHUD.h"

#define CIRCLE_DIAMETER_DEFAULT 5
#define PI 3.14159265358979323846

@interface CircleView : UIView

@property (nonatomic, assign)BOOL isHeighLight;

@end

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.isHeighLight) {
        CGContextSetFillColorWithColor(context, KT_HEXCOLOR(0x44b5ff).CGColor);
    }
    else{
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:76.0f/255.0f green:199.0f/255.0f blue:239.0f/255.0f alpha:1.0f].CGColor);
    }
    
    CGContextFillEllipseInRect(context, rect);
}

@end

@interface GBSearchProgressHUD()
{
    CircleView * leftCircle;
    CircleView * middleCircle;
    CircleView * rightCircle;
}

@property int pointDiameter;
@property BOOL animating;

@end

@implementation GBSearchProgressHUD

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame withPointDiameter:CIRCLE_DIAMETER_DEFAULT];
    if (self) {
        // Initialization code
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
        UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        tipLabel.center = CGPointMake(middleCircle.center.x, middleCircle.center.y + 20);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:12];
        tipLabel.textColor = [UIColor grayColor];
        tipLabel.text = [NSString stringWithFormat:@"数据加载中..."];
        [self addSubview:tipLabel];
        
        self.animating = YES;
        NSArray *circles = @[leftCircle, middleCircle, rightCircle];
        [self animateWithViews:circles index:0 offset:self.pointDiameter];
    }
    return self;
}

- (CircleView*)addCircleViewWithXOffsetFromCenter:(float)offset
{
    CGRect rect = CGRectMake(0, 0, self.pointDiameter, self.pointDiameter);
    CircleView *circle = [[CircleView alloc] initWithFrame:rect];
    circle.center = self.center;
    circle.frame = CGRectOffset(circle.frame, offset, 0);
    [self addSubview:circle];
    return circle;
}

- (void)animateWithViews:(NSArray*)circles index:(int)index offset:(float)offset
{
    CircleView *view = ((CircleView*)[circles objectAtIndex:index]);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.isHeighLight = YES;
        [view setNeedsDisplay];
        view.frame = CGRectMake(view.frame.origin.x - offset/2,
                                view.frame.origin.y - offset/2,
                                view.frame.size.width + offset,
                                view.frame.size.height + offset);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.frame = CGRectMake(view.frame.origin.x + offset/2,
                                    view.frame.origin.y + offset/2,
                                    view.frame.size.width - offset,
                                    view.frame.size.height - offset);
        } completion:^(BOOL finished) {
            view.isHeighLight = NO;
            [view setNeedsDisplay];
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

@end
