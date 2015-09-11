//
//  GBAboutViewController.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-9.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBAboutViewController.h"

@interface GBAboutViewController ()

@end

@implementation GBAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.customNavigationBar setNavBarTitle:@"关于"];
    CGRect  screenRect=[UIScreen mainScreen].bounds;
    if (!KT_IOS_VERSION_7_OR_ABOVE && !KT_DEVICE_IPHONE_5) {
        screenRect.size.height=screenRect.size.height-KT_UI_STATUS_BAR_HEIGHT;
    }
//    CGFloat screenheight=CGRectGetHeight(screenRect);
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];//self.view.bounds
    [self addSubview:scrollView];
    
    CGFloat y = KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT + 29;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((KT_UI_SCREEN_WIDTH - 100)/2, y, 100, 100)];
    iconImageView.image = KT_GET_LOCAL_PICTURE(@"Icon@2x");
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 20;
    [scrollView addSubview:iconImageView];
    
    y += (iconImageView.bounds.size.height + 22);
    
    UIImageView *appImageView = [[UIImageView alloc] initWithFrame:CGRectMake((KT_UI_SCREEN_WIDTH - 100)/2, y, 100, 25)];
    appImageView.image = KT_GET_LOCAL_PICTURE(@"mine_about_GameGifts@2x");
    [scrollView addSubview:appImageView];
    
    y += (appImageView.bounds.size.height + 25);
    
    NSString *contentStr = @"996手游网成立于2013年3月，是一个专注于手机游戏行业的综合性游戏门户站点，是一个具有广泛影响力的行业站点，该平台为用户提供热点新闻、游戏评测与推荐、开服测试、热门游戏活动和论坛等服务。\n\n996手游网目前有游戏焦点新闻、厂商新闻、游戏评测、游戏攻略、游戏视频、产业新闻、游戏专区、独家专题等十多个频道，提供丰富、专业的手游资讯；同时，996手游论坛有热门游戏、新游推荐、开服测试、游戏活动等数十个板块，为用户与用户、用户与厂商之间提供便捷的交流互动方式。";
    
    CGSize size = [contentStr sizeWithFont:GB_DEFAULT_FONT(12) constrainedToSize:CGSizeMake(KT_UI_SCREEN_WIDTH-40, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    //
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, KT_UI_SCREEN_WIDTH-40, size.height)];
    contentLabel.backgroundColor = KT_UICOLOR_CLEAR;
    contentLabel.font = GB_DEFAULT_FONT(12);
    contentLabel.textColor = KT_HEXCOLOR(0x999999);
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.text = contentStr;
    [scrollView addSubview:contentLabel];
    
    y += contentLabel.frame.size.height + 30;
    
    scrollView.contentSize = CGSizeMake(KT_UI_SCREEN_WIDTH, y>scrollView.frame.size.height?y:scrollView.frame.size.height + 1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popBack:(id)sender
{
    [self.KTNavigationController popKTViewControllerAnimated:YES];
}

- (void)setupCustomTabBarButton
{
    [self.customTabBar setTabBarButtonWithImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back@2x")
                               highlightedImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back_highlight@2x")
                                     buttonType:CustomTabBarButtonTypeOfLeft
                                         target:self
                                         action:@selector(popBack:)];
}

@end
