//
//  GBAlertView.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-25.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBAlertView.h"
#import "GBAppDelegate.h"

#define POP_UP_BOX_MASKVIEW_DURATION            0.2
#define POP_UP_BOX_ACTIONSHEET_DURATION         0.3

@interface GBAlertView()

@property (nonatomic, KT_STRONG) NSString *messasge;
@property (nonatomic, KT_STRONG) NSArray *titles;
@property (nonatomic, KT_WEAK) UIView    *maskView;

@end

@implementation GBAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code3
    }
    return self;
}

- (id)initWithMessage:(NSString *)message
         buttonTitles:(NSArray *)titles
             callback:(GBPopUpBoxClickHandler)block
{
    CGSize size = [message sizeWithFont:GB_DEFAULT_FONT(15)];
    if (size.width > 230) {
        self = [super initWithFrame:CGRectMake(25.0f, 0.f, 270, 144)];
    }
    else{
        self = [super initWithFrame:CGRectMake(25.0f, 0.f, 270, 124)];
    }
    
    if (self) {
        self.messasge = message;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10.0f;
        self.titles = titles;
        self.callbackBlock = block;
        self.center = CGPointMake([Utils screenWidth]/2, [Utils screenHeight]/2);
        [self setupPromptPopUpBoxView];
    }
    
    
    return self;
}

- (void)setupPromptPopUpBoxView
{
    self.backgroundColor = KT_HEXCOLOR(0xffffff);
    
    CGFloat y = 20;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, y, self.bounds.size.width, 17.5)];
    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
    titleLabel.font = GB_DEFAULT_FONT(17.5);
    titleLabel.textColor = KT_HEXCOLOR(0x333333);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"提示";
    [self addSubview:titleLabel];
    
    y += (titleLabel.bounds.size.height + 15);
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, y, self.bounds.size.width - 40, 15)];
    contentLabel.backgroundColor = KT_UICOLOR_CLEAR;
    contentLabel.font = GB_DEFAULT_FONT(15);
    contentLabel.textColor = KT_HEXCOLOR(0x666666);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.text = self.messasge;
    [self addSubview:contentLabel];
    
    y += (contentLabel.bounds.size.height + 14);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.f, y, self.bounds.size.width, 1)];
    lineView.backgroundColor = KT_HEXCOLOR(0xb4b4b4);
    [self addSubview:lineView];
    
    if ([self.titles count] <= 0) {
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        okButton.tag = 0;
        okButton.frame = CGRectMake(0.f, y, self.bounds.size.width, 44);
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton setTitleColor:KT_HEXCOLOR(0xff8500) forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:okButton];
    }
    else{
        int count = [self.titles count];
        CGFloat x = 0;
        for (int i = 0;i < count; ++i) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.frame = CGRectMake(x, y, self.bounds.size.width/count, 44);
            [button setTitle:(NSString *)[self.titles objectAtIndex:i] forState:UIControlStateNormal];
            if (i == 0) {
                [button setTitleColor:KT_HEXCOLOR(0xff8500) forState:UIControlStateNormal];
            }
            else{
                [button setTitleColor:KT_HEXCOLOR(0x44b5ff) forState:UIControlStateNormal];
            }
            
            [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            x += button.frame.size.width;
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 1, 44)];
            lineView.backgroundColor = KT_HEXCOLOR(0xb4b4b4);
            [self addSubview:lineView];
        }
    }
}

- (void)didClickButton:(UIButton *)button
{
    [self hidden];
    if (self.callbackBlock) {
        self.callbackBlock(button.tag);
    }
}

- (void)show
{
    GBAppDelegate *appDelegate = (GBAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //生成蒙板
    UIView *maskViewTMP = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskViewTMP.backgroundColor = KT_HEXCOLOR(0x000000);
    maskViewTMP.alpha = 0.0;
    
    [appDelegate.window addSubview:maskViewTMP];
    
    self.maskView = maskViewTMP;
    
    //显示蒙板
    [UIView animateWithDuration:POP_UP_BOX_MASKVIEW_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.maskView.alpha = 0.5f;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    //显示alert
    [appDelegate.window addSubview:self];
    
    self.alpha = 0.f;
    
    [UIView animateWithDuration:POP_UP_BOX_ACTIONSHEET_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //self.transform = CGAffineTransformMakeTranslation(0,-self.bounds.size.height);
                         self.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)hidden
{
    //关闭蒙板
    [UIView animateWithDuration:POP_UP_BOX_MASKVIEW_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.maskView.alpha = 0.0f;
                         
                     } completion:^(BOOL finished) {
                         [self.maskView removeFromSuperview];
                         self.maskView = nil;
                     }];
    
    //关闭ActionSheet
    [UIView animateWithDuration:POP_UP_BOX_ACTIONSHEET_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.f;
                         
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
