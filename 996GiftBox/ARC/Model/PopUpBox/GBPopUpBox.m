//
//  GBPopUpBox.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-25.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBPopUpBox.h"
#import "GBAppDelegate.h"
#import "GBProgressView.h"

#define GBPOP_UP_BOX_MASKVIEW_DURATION            0.2
#define GBPOP_UP_BOX_ACTIONSHEET_DURATION         0.3

#define GBPOP_UP_BOX_DELAY_SECONDS                1ull

@interface GBPopUpBox()

@property (nonatomic, assign) GBPopUpBoxType type;
@property (nonatomic, assign) BOOL autoHidden;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, weak) UIView *maskView;
@property (nonatomic, weak) GBProgressView *progressView;

@end

@implementation GBPopUpBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithType:(GBPopUpBoxType)type withAutoHidden:(BOOL)autoHidden
{
    self = [super init];
    if (self) {
        _type = type;
        _autoHidden = autoHidden;
        switch (type) {
            case GBPopUpBoxTypeNoNetwork:{
                self.message = @"网络不可用，请检查网络连接!";
                break;
            }
            case GBPopUpBoxTypeLoadingError:{
                self.message = @"加载错误，请刷新重试。";
                break;
            }
                
            default:
                break;
        }
        [self setup];
    }
    return self;
}

- (id)initWithType:(GBPopUpBoxType)type
       withMessage:(NSString *)message
    withAutoHidden:(BOOL)autoHidden
{
    self = [super init];
    if (self) {
        _type = type;
        _autoHidden = autoHidden;
        _message = message;
        [self setup];
    }
    return self;
}

- (void)setup
{
    switch (self.type) {
        case GBPopUpBoxTypeNoNetwork:
        case GBPopUpBoxTypeLoadingError:
        case GBPopUpBoxTypeDefault:
        {
            self.frame = CGRectMake(0.f, 0.f, 155, 50);
            self.backgroundColor = KT_HEXCOLOR(0x000000);
            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = 5;
            
            //message
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0.f, self.frame.size.width - 30, self.frame.size.height)];
            messageLabel.font = GB_DEFAULT_FONT(12.5);
            messageLabel.textColor = KT_HEXCOLOR(0xffffff);
            messageLabel.backgroundColor = [UIColor clearColor];
            messageLabel.text = self.message;
            messageLabel.textAlignment=NSTextAlignmentCenter;//居中显示
            [self addSubview:messageLabel];
            
            break;
        }
        case GBPopUpBoxTypeProgress:
        {
            self.frame = CGRectMake(0.f, 0.f, 155, 55);
            self.backgroundColor = KT_HEXCOLOR(0x000000);
            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = 5;
            
            //progress
            GBProgressView *progressView = [[GBProgressView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 20)
                                                                         message:self.message];
            [self addSubview:progressView];
            self.progressView = progressView;
            
            //message
//            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0.f, self.frame.size.width - 30, self.frame.size.height)];
//            messageLabel.font = GB_DEFAULT_FONT(12.5);
//            messageLabel.textColor = KT_HEXCOLOR(0xffffff);
//            messageLabel.backgroundColor = [UIColor clearColor];
//            [self addSubview:messageLabel];
//            self.messageLabel = messageLabel;
            
            break;
        }
            
        default:
            break;
    }
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    self.messageLabel.text = message;
}

- (void)startTimer
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, GBPOP_UP_BOX_DELAY_SECONDS*NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 1ull*NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        [self hiddenWithAnimated:YES];
        dispatch_source_cancel(timer);
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        
    });
    //启动
    dispatch_resume(timer);
}

- (void)show
{
    GBAppDelegate *appDelegate = (GBAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //生成蒙板
    UIView *maskViewTMP = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskViewTMP.backgroundColor = KT_UICOLOR_CLEAR;
    
    [appDelegate.window addSubview:maskViewTMP];
    
    self.maskView = maskViewTMP;
    
    self.center = self.maskView.center;
    
    //显示pop
    [appDelegate.window addSubview:self];
    
    self.alpha = 0.f;
    
    [UIView animateWithDuration:GBPOP_UP_BOX_ACTIONSHEET_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.6f;
                         
                     } completion:^(BOOL finished) {
                         if (self.autoHidden) {
                             [self startTimer];
                         }
                     }];
}

- (void)showMask
{
    GBAppDelegate *appDelegate = (GBAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //生成蒙板
    UIView *maskViewTMP = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskViewTMP.backgroundColor = KT_HEXCOLOR(0x000000);
    maskViewTMP.alpha = 0.0;
    
    [appDelegate.window addSubview:maskViewTMP];
    
    self.maskView = maskViewTMP;
    
    self.center = self.maskView.center;
    
    //显示蒙板
    [UIView animateWithDuration:GBPOP_UP_BOX_MASKVIEW_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.maskView.alpha = 0.6f;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    //显示pop
    [appDelegate.window addSubview:self];
    
    self.alpha = 0.f;
    
    [UIView animateWithDuration:GBPOP_UP_BOX_ACTIONSHEET_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //self.transform = CGAffineTransformMakeTranslation(0,-self.bounds.size.height);
                         self.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         if (self.autoHidden) {
                             [self startTimer];
                         }
                     }];
}

- (void)showInView:(UIView *)view offset:(CGFloat)offset
{
    CGPoint center = view.center;
    center.y += offset;
    
    self.center = center;
    self.alpha = 0.f;
    
    [view addSubview:self];
    
    [UIView animateWithDuration:GBPOP_UP_BOX_ACTIONSHEET_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.6;
                         
                     } completion:^(BOOL finished) {
                         if (self.autoHidden) {
                             [self startTimer];
                         }
                     }];
}

- (void)showMaskInView:(UIView *)view offset:(CGFloat)offset
{
    //生成蒙板
    UIView *maskViewTMP = [[UIView alloc] initWithFrame:view.bounds];
    maskViewTMP.backgroundColor = KT_UICOLOR_CLEAR;
    [view addSubview:maskViewTMP];
    self.maskView = maskViewTMP;
    
    [self showInView:view offset:offset];
}

- (void)hiddenWithAnimated:(BOOL)animated
{
    [self.progressView stop];
    
    //关闭蒙板
    [UIView animateWithDuration:animated? GBPOP_UP_BOX_MASKVIEW_DURATION:0.f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.maskView.alpha = 0.0f;
                         
                     } completion:^(BOOL finished) {
                         [self.maskView removeFromSuperview];
                         self.maskView = nil;
                     }];
    
    //关闭
    [UIView animateWithDuration:animated? GBPOP_UP_BOX_MASKVIEW_DURATION:0.f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.f;
                         
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}


@end
