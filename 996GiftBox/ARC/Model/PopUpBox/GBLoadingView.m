//
//  GBLoadingView.m
//  GameGifts
//
//  Created by Teiron-37 on 14-2-12.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBLoadingView.h"

@interface GBLoadingView()

@property (nonatomic, weak) UIImageView *rotationImageView;
@property (nonatomic, weak) UIView *maskView;

@end

@implementation GBLoadingView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0.f, 0.f, 100.f, 88.f);
        self.backgroundColor = KT_UICOLOR_CLEAR;
        
        CGFloat y = 0.f;
        
        //996图标
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 57)/2, y, 57.f, 57.f)];
        logoImageView.image = KT_GET_LOCAL_PICTURE_SECOND(@"box_defalt@2x");
        [self addSubview:logoImageView];
        
        //旋转图标
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:logoImageView.frame];
        imageView.image = KT_GET_LOCAL_PICTURE_SECOND(@"box_defalt_highlighted@2x");
        [self addSubview:imageView];
        self.rotationImageView = imageView;
        
        y += (logoImageView.frame.size.height + 19);
        
        //title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, y, self.frame.size.width, 12)];
        titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
        titleLabel.textAlignment = KT_TextAlignmentCenter;
        titleLabel.textColor = KT_HEXCOLOR(0x666666);
        titleLabel.font = GB_DEFAULT_FONT(12);
        titleLabel.text = @"正在加载,请稍后...";
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)showInView:(UIView *)view offset:(CGFloat)offset
{
    //透明蒙板
    UIView *maskView = [[UIView alloc] initWithFrame:view.bounds];
    maskView.backgroundColor = KT_UICOLOR_CLEAR;
    [view addSubview:maskView];
    
    self.maskView = maskView;
    
    CGPoint center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
    center.y += offset;
    
    self.center = center;
    
    [view addSubview:self];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    
    [self.rotationImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)hidden
{
    [self.rotationImageView.layer removeAllAnimations];
    [self.maskView removeFromSuperview];
    [self removeFromSuperview];
}

@end
