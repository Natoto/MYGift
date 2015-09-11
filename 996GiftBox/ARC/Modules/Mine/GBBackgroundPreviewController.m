//
//  GBkkkkViewController.m
//  GameGifts
//
//  Created by Teiron-37 on 14-2-26.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBackgroundPreviewController.h"
#import "GBBackgroundModel.h"
#import "GBUserInfoModel.h"
#import "GBAccountManager.h"
#import "UIImageView+WebCache.h"
#import "LocalSettings.h"

@interface GBBackgroundMaskView : UIView

@end

@interface GBBackgroundContentView : UIView

@property(nonatomic, strong) UIImage *image;

@end

@interface GBBackgroundPreviewController ()
<
UIScrollViewDelegate
>

@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger startOffsetx;

//uiview
@property (nonatomic, weak) UIImageView *genderView;
@property (nonatomic, weak) UIImageView *headerImageView;
@property (nonatomic, weak) UILabel *loginStatusLabel;
@property (nonatomic, weak) UILabel *loginPromptLabel;
@property (nonatomic, weak) UILabel *userNameLabel;
@property (nonatomic, weak) UILabel *bgNameLabel;

@property (nonatomic, weak) GBBackgroundContentView *firstContentView;
@property (nonatomic, weak) GBBackgroundContentView *secondContentView;
@property (nonatomic, weak) GBBackgroundContentView *freeContentView;

@end

@implementation GBBackgroundPreviewController

- (id)initWithBackgroudList:(NSArray *)modelArray
               withCurIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.modelArray = modelArray;
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavBarHidden:YES];
    
    GBBackgroundModel *model = [self.modelArray objectAtIndex:self.index];
    
    CGFloat x = 20,height = 230;
    
    if (KT_DEVICE_IPHONE_5) {
        height = 250;
    }
    CGRect scrollRect = self.view.bounds;
    scrollRect.size.height = 568;
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
    scrollView.backgroundColor = KT_UICOLOR_CLEAR;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.modelArray.count * [Utils screenWidth], self.view.bounds.size.height);
    scrollView.contentOffset = CGPointMake(0, 0); //先把显示的区域往左移动viewSize。width
    [self addSubview:scrollView];
    
    GBBackgroundContentView *contentView = [[GBBackgroundContentView alloc] initWithFrame:CGRectMake(self.index*320, 0, 320, scrollView.bounds.size.height)];
    contentView.image = KT_GET_LOCAL_PICTURE(model.sourceUrl);
    [contentView setNeedsDisplay];
    [scrollView addSubview:contentView];
    self.firstContentView = contentView;
    
    /********************/
    GBBackgroundContentView *tmpContenView = [[GBBackgroundContentView alloc] initWithFrame:CGRectMake(self.modelArray.count*320, 0, 320, scrollView.bounds.size.height)];
    [scrollView addSubview:tmpContenView];
    self.freeContentView = self.secondContentView = tmpContenView;
    /********************/
    
    scrollView.contentOffset = CGPointMake(320*self.index, 0);
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, KT_UI_STATUS_BAR_HEIGHT + 20.0f, self.view.bounds.size.width, 19)];
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = GB_DEFAULT_FONT(19);
    titleLabel.textColor = KT_HEXCOLOR(0xffffff);
    titleLabel.text = @"预 览";
    [self addSubview:titleLabel];
    
    //换背景
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, KT_UI_STATUS_BAR_HEIGHT + 15, 25, 25)];
    bgImageView.image = KT_GET_LOCAL_PICTURE(@"mine_bgButton@2x");
    [self addSubview:bgImageView];
    
    //头像
    UIImage *bgImage = KT_GET_LOCAL_PICTURE(@"mine_header_bg@2x");
    UIImageView *headerBgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, height-bgImage.size.height, bgImage.size.width, bgImage.size.height)];
    [headerBgView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    headerBgView.image = bgImage;
    [self addSubview:headerBgView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:KT_GET_LOCAL_PICTURE(@"mine_header_logout@2x")];
    headerImageView.bounds = CGRectMake(0.f, 0.f, 90, 90);
    headerImageView.center = CGPointMake(headerBgView.center.x, headerBgView.center.y - 20);
    [headerImageView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    [headerImageView.layer setCornerRadius:(headerImageView.frame.size.height/2)];
    [headerImageView.layer setMasksToBounds:YES];
    [headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    [headerImageView setClipsToBounds:YES];
    [self addSubview:headerImageView];
    self.headerImageView = headerImageView;
    
    x += (headerBgView.bounds.size.width + 18);
    
    CGFloat offset_y = 0;
    if (KT_DEVICE_IPHONE_5) {
        offset_y = 20;
    }
    
    //登录状态
    UILabel *loginStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 120 + offset_y, 100, 15)];
    [loginStatusLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    loginStatusLabel.backgroundColor = KT_UICOLOR_CLEAR;
    loginStatusLabel.font = GB_DEFAULT_FONT(15);
    loginStatusLabel.textColor = KT_HEXCOLOR(0x333333);
    loginStatusLabel.text = @"未登录";
    [self addSubview:loginStatusLabel];
    self.loginStatusLabel = loginStatusLabel;
    
    //登录提醒
    UILabel *loginPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 150 + offset_y, 100, 17)];
    [loginPromptLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    loginPromptLabel.backgroundColor = KT_UICOLOR_CLEAR;
    loginPromptLabel.font = GB_DEFAULT_FONT(12);
    loginPromptLabel.textColor = KT_HEXCOLOR(0x999999);
    loginPromptLabel.text = @"点击头像登录";
    [self addSubview:loginPromptLabel];
    self.loginPromptLabel = loginPromptLabel;
    
    //用户名
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 150 + offset_y, 100, 17)];
    [userNameLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    userNameLabel.center = CGPointMake(userNameLabel.center.x, headerImageView.center.y);
    userNameLabel.backgroundColor = KT_UICOLOR_CLEAR;
    userNameLabel.font = GB_DEFAULT_FONT(17);
    userNameLabel.textColor = KT_HEXCOLOR(0x333333);
    userNameLabel.hidden = YES;
    [self addSubview:userNameLabel];
    self.userNameLabel = userNameLabel;
    
    //性别
    UIImageView *genderView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 150 + offset_y, 25, 25)];
    userNameLabel.center = CGPointMake(genderView.center.x, headerImageView.center.y);
    genderView.hidden = YES;
    [self addSubview:genderView];
    self.genderView = genderView;
    
    CGFloat y = headerBgView.frame.origin.y + headerBgView.frame.size.height;
    
    GBBackgroundMaskView *maskView = [[GBBackgroundMaskView alloc] initWithFrame:CGRectMake(0.f, y, self.view.bounds.size.width, self.view.bounds.size.height - y)];
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        maskView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.7];
    }else{
        maskView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.85];
    }
    [self addSubview:maskView];
    
    UILabel *bgNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 40, maskView.bounds.size.width, 20)];
    bgNameLabel.backgroundColor = KT_UICOLOR_CLEAR;
    bgNameLabel.textAlignment = NSTextAlignmentCenter;
    bgNameLabel.textColor = KT_HEXCOLOR(0x333333);
    bgNameLabel.text = model.bgName;
    [maskView addSubview:bgNameLabel];
    self.bgNameLabel = bgNameLabel;
}

- (void)setupCustomTabBarButton
{
    UIView *barView = [[UIView alloc] initWithFrame:self.customTabBar.bounds];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0.f, 0.f, barView.bounds.size.width/2 - 0.5, barView.bounds.size.height);
    [cancelButton setBackgroundImage:KT_GET_LOCAL_PICTURE(@"mine_bg_preview_btn@2x") forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:KT_GET_LOCAL_PICTURE(@"mine_bg_preview_btn_highlighted@2x") forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = GB_DEFAULT_FONT(18);
    cancelButton.titleLabel.textAlignment = KT_TextAlignmentCenter;
    [cancelButton setTitleColor:KT_HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(handleCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:cancelButton];
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = CGRectMake(barView.bounds.size.width/2 - 1, 0.f, barView.bounds.size.width/2 - 0.5, barView.bounds.size.height);
    [okButton setBackgroundImage:KT_GET_LOCAL_PICTURE(@"mine_bg_preview_btn@2x") forState:UIControlStateNormal];
    [okButton setBackgroundImage:KT_GET_LOCAL_PICTURE(@"mine_bg_preview_btn_highlighted@2x") forState:UIControlStateHighlighted];
    okButton.titleLabel.font = GB_DEFAULT_FONT(18);
    okButton.titleLabel.textAlignment = KT_TextAlignmentCenter;
    [okButton setTitleColor:KT_HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(handleOkAction:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:okButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(barView.bounds.size.width/2 - 0.5, 0, 1, barView.bounds.size.height)];
    lineView.backgroundColor = KT_HEXCOLOR(0xbebec2);
    [barView addSubview:lineView];
    
    [self.customTabBar addSubview:barView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshHeaderView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleCancelAction:(id)sender
{
    [self.KTNavigationController popKTViewControllerAnimated:YES];
}

- (void)handleOkAction:(id)sender
{
    GBBackgroundModel *model = [self.modelArray objectAtIndex:self.index];
    [LocalSettings sharedInstance].currentTheme = model.sourceUrl;
    [self.KTNavigationController popToRootKTViewControllerAnimated:YES];
}

- (void)refreshHeaderView
{
    GBUserInfoModel *userInfoModel = [GBAccountManager sharedAccountManager].userInfoModel;
    if (userInfoModel != nil) {
        
        [self.headerImageView setImageWithURL:[NSURL URLWithString:userInfoModel.avatar_big_url]
                             placeholderImage:KT_GET_LOCAL_PICTURE(@"mine_header_logout@2x")];
        self.loginStatusLabel.hidden = YES;
        self.loginPromptLabel.hidden = YES;
        
        self.userNameLabel.hidden = NO;
        self.genderView.hidden = NO;
        
        self.userNameLabel.text = userInfoModel.userName;
        
        CGRect rect = self.userNameLabel.frame;
        rect.size.width = [userInfoModel.userName sizeWithFont:self.userNameLabel.font].width;
        rect.origin.x = self.headerImageView.frame.origin.x + self.headerImageView.frame.size.width + 22;
        self.userNameLabel.frame = rect;
        
        CGRect rect2 = self.genderView.frame;
        rect2.origin.x = self.userNameLabel.frame.origin.x + self.userNameLabel.frame.size.width + 5;
        self.genderView.frame = rect2;
        
        switch ([userInfoModel.gender intValue]) {
            case 0:{ //保密
                self.genderView.hidden = YES;
                break;
            }
            case 1:{ //男
                self.genderView.image = KT_GET_LOCAL_PICTURE(@"mine_gender_male@2x");
                break;
            }
            case 2:{ //女
                self.genderView.image = KT_GET_LOCAL_PICTURE(@"mine_gender_female@2x");
                break;
            }
                
            default:
                break;
        }
    }
    else{
        [self.headerImageView setImage:KT_GET_LOCAL_PICTURE(@"mine_header_logout@2x")];
        self.loginStatusLabel.hidden = NO;
        self.loginPromptLabel.hidden = NO;
        self.userNameLabel.hidden = YES;
        self.genderView.hidden = YES;
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startOffsetx = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    
    CGRect firstRect = self.firstContentView.frame;
    CGRect secondRect = self.secondContentView.frame;
    
    
    self.freeContentView = nil;

    if (fabs(firstRect.origin.x - scrollView.contentOffset.x) >= 320) {
        self.freeContentView = self.firstContentView;
    }
    
    if (fabs(secondRect.origin.x - scrollView.contentOffset.x) >= 320) {
        self.freeContentView = self.secondContentView;
    }
    
    if (self.freeContentView == nil) {
        self.startOffsetx = offset.x;
        return;
    }
    
    
    NSInteger pageNum = offset.x / bounds.size.width; //显示
    
    if (self.startOffsetx > offset.x && (int)(offset.x) % (int)(bounds.size.width) > 0) {//向右
        GBBackgroundModel *model = [self.modelArray objectAtIndex:pageNum];
        CGRect rect = self.freeContentView.bounds;
        rect.origin.x = 320*pageNum;
        self.freeContentView.frame = rect;
        self.freeContentView.image = KT_GET_LOCAL_PICTURE(model.sourceUrl);
        [self.freeContentView setNeedsDisplay];
        
    }else if (self.startOffsetx < offset.x && (int)(offset.x) % (int)(bounds.size.width) > 0){//向左
        CGRect rect = self.freeContentView.bounds;
        rect.origin.x = 320*(pageNum + 1);
        self.freeContentView.frame = rect;
        GBBackgroundModel *model = [self.modelArray objectAtIndex:pageNum + 1];
        self.freeContentView.image = KT_GET_LOCAL_PICTURE(model.sourceUrl);
        [self.freeContentView setNeedsDisplay];
    }else{
        
    }
    self.startOffsetx = offset.x;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    
    self.index = offset.x / bounds.size.width;
    
    GBBackgroundModel *model = [self.modelArray objectAtIndex:self.index];
    self.bgNameLabel.text = model.bgName;
}

@end

@implementation GBBackgroundMaskView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return nil;
}

@end

@implementation GBBackgroundContentView

- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:rect];
}

@end
