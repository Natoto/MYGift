//
//  GBMineViewController.m
//  GameGifts
//
//  Created by Keven on 13-12-24.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GBMineViewController.h"
#import "BaseCell.h"
#import "UIScrollView+APParallaxHeader.h"
#import "GBBackgroundListViewController.h"
#import "GBFeedbackViewController.h"
#import "GBSettingViewController.h"
#import "GBMineRedemptionCodeViewController.h"
#import "GBUserInfoViewController.h"
#import "GBActionSheet.h"
#import "GBAboutViewController.h"
#import "LineView.h"
#import "LocalSettings.h"
#import "GBAccountManager.h"
#import "UIButton+WebCache.h"
#import "GBUserInfoModel.h"
#import "UIImage+Utility.h"
#import "BaiduMobStat.h"

@interface MineCell : UITableViewCell

@property (nonatomic, KT_WEAK) UIImageView *iconImageView;
@property (nonatomic, KT_WEAK) UILabel *nameLabel;
@property (nonatomic, KT_WEAK) UIImageView *accessory;
@property (nonatomic, KT_WEAK) UIImageView *badgeImageView;

@end


@interface GBMineViewController ()

@property (nonatomic, KT_WEAK) UITableView *tableView;
@property (nonatomic, KT_WEAK) UIButton *headerButton;
@property (nonatomic, KT_WEAK) UIImageView *genderView;
@property (nonatomic, KT_WEAK) UIImageView *themeImageView;
@property (nonatomic, KT_WEAK) UILabel *loginStatusLabel;
@property (nonatomic, KT_WEAK) UILabel *loginPromptLabel;
@property (nonatomic, KT_WEAK) UILabel *userNameLabel;
@end

@implementation GBMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[LocalSettings sharedInstance] removeObserver:self forKeyPath:@"currentTheme"];
    [[LocalSettings sharedInstance] removeObserver:self forKeyPath:@"latestVersion"];
    [[GBAccountManager sharedAccountManager] removeObserver:self forKeyPath:@"userInfoModel"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavBarHidden:YES];
    
    UITableView *tableViewTMP = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableViewTMP.dataSource = self;
    tableViewTMP.delegate = self;
    tableViewTMP.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewTMP.showsHorizontalScrollIndicator = NO;
    tableViewTMP.showsVerticalScrollIndicator = NO;
    [self addSubview:tableViewTMP];
    self.tableView = tableViewTMP;
    
    CGFloat x = 20,height = 230;
    
    if (KT_DEVICE_IPHONE_5) {
        height = 250;
    }

    //背景
    UIImageView *imageView = [[UIImageView alloc] initWithImage:KT_GET_LOCAL_PICTURE([LocalSettings sharedInstance].currentTheme)];
    imageView.userInteractionEnabled = YES;
    [imageView setFrame:CGRectMake(0, 0, 320, 568)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.tableView addParallaxWithView:imageView andHeight:height];
    self.themeImageView = imageView;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.tableView.transparentView addGestureRecognizer:tapGesture];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, KT_UI_STATUS_BAR_HEIGHT + 20.0f, self.tableView.bounds.size.width, 19)];
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = GB_DEFAULT_FONT(19);
    titleLabel.textColor = KT_HEXCOLOR(0xffffff);
    titleLabel.text = @"个人中心";
    [self.tableView.transparentView addSubview:titleLabel];
    
    //换背景
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame = CGRectMake(265, KT_UI_STATUS_BAR_HEIGHT, 55, 55);
    [bgButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    [bgButton setImage:KT_GET_LOCAL_PICTURE(@"mine_bgButton@2x") forState:UIControlStateNormal];
    [bgButton setImage:KT_GET_LOCAL_PICTURE(@"mine_bgButton_highlighted@2x") forState:UIControlStateHighlighted];
    [bgButton addTarget:self action:@selector(didBgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.transparentView addSubview:bgButton];
    
    //头像
    UIImage *bgImage = KT_GET_LOCAL_PICTURE(@"mine_header_bg@2x");
    UIImageView *headerBgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, height-bgImage.size.height, bgImage.size.width, bgImage.size.height)];
    [headerBgView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    headerBgView.image = bgImage;
    [self.tableView.transparentView addSubview:headerBgView];
    
    UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    headerButton.bounds = CGRectMake(0.f, 0.f, 90, 90);
    headerButton.center = CGPointMake(headerBgView.center.x, headerBgView.center.y - 20);
    [headerButton setImage:KT_GET_LOCAL_PICTURE(@"mine_header_logout@2x") forState:UIControlStateNormal];
    [headerButton addTarget:self action:@selector(didUserInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerButton.layer setCornerRadius:(headerButton.frame.size.height/2)];
    [headerButton.layer setMasksToBounds:YES];
    [headerButton setContentMode:UIViewContentModeScaleAspectFill];
    [headerButton setClipsToBounds:YES];
    [self.tableView.transparentView addSubview:headerButton];
    self.headerButton = headerButton;
    
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
    [self.tableView.transparentView addSubview:loginStatusLabel];
    self.loginStatusLabel = loginStatusLabel;
    
    //登录提醒
    UILabel *loginPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 150 + offset_y, 100, 17)];
    [loginPromptLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    loginPromptLabel.backgroundColor = KT_UICOLOR_CLEAR;
    loginPromptLabel.font = GB_DEFAULT_FONT(12);
    loginPromptLabel.textColor = KT_HEXCOLOR(0x999999);
    loginPromptLabel.text = @"点击头像登录";
    [self.tableView.transparentView addSubview:loginPromptLabel];
    self.loginPromptLabel = loginPromptLabel;
    
    //用户名
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 150 + offset_y, 100, 17)];
    [userNameLabel setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin];
    userNameLabel.center = CGPointMake(userNameLabel.center.x, headerButton.center.y);
    userNameLabel.backgroundColor = KT_UICOLOR_CLEAR;
    userNameLabel.font = GB_DEFAULT_FONT(17);
    userNameLabel.textColor = KT_HEXCOLOR(0x333333);
    userNameLabel.hidden = YES;
    [self.tableView.transparentView addSubview:userNameLabel];
    self.userNameLabel = userNameLabel;
    
    //性别
    UIImageView *genderView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 150 + offset_y, 25, 25)];
    userNameLabel.center = CGPointMake(genderView.center.x, headerButton.center.y);
    genderView.hidden = YES;
    [self.tableView.transparentView addSubview:genderView];
    self.genderView = genderView;
    
    [self.tableView sendSubviewToBack:self.tableView.parallaxView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, KT_UI_TAB_BAR_HEIGHT)];
    footerView.backgroundColor = KT_UICOLOR_CLEAR;
    
    self.tableView.tableFooterView = footerView;
    
    [[LocalSettings sharedInstance] addObserver:self forKeyPath:@"currentTheme" options:NSKeyValueObservingOptionNew context:nil];
    [[LocalSettings sharedInstance] addObserver:self forKeyPath:@"latestVersion" options:NSKeyValueObservingOptionNew context:nil];
    [[GBAccountManager sharedAccountManager] addObserver:self forKeyPath:@"userInfoModel" options:NSKeyValueObservingOptionNew context:nil];
    
    if (!KT_IOS_VERSION_7_OR_ABOVE) {
        [self performSelector:@selector(delayExecute) withObject:nil afterDelay:0.2];
    }
    
    [self refreshHeaderView];
}

- (void)delayExecute{
    [self.tableView sendSubviewToBack:self.tableView.parallaxView];
}

- (void)viewWillAppearForKTView
{
    [self refreshHeaderView];
}

- (void)viewDidAppearForKTView
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"我的"];
}

- (void)viewWillDisappearForKTView
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"我的"];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == [LocalSettings sharedInstance] && [keyPath isEqualToString:@"currentTheme"]) {
        
        self.themeImageView.image = KT_GET_LOCAL_PICTURE([LocalSettings sharedInstance].currentTheme);
    }
    else if (object == [LocalSettings sharedInstance] && [keyPath isEqualToString:@"latestVersion"]){
        [self.tableView reloadData];
    }
    else if (object == [GBAccountManager sharedAccountManager] && [keyPath isEqualToString:@"userInfoModel"]){
        [self refreshHeaderView];
    }
}

- (void)refreshHeaderView
{
    GBUserInfoModel *userInfoModel = [GBAccountManager sharedAccountManager].userInfoModel;
    if (userInfoModel != nil) {
        
        [self.headerButton setImageWithURL:[NSURL URLWithString:userInfoModel.avatar_big_url]
                                  forState:UIControlStateNormal
                          placeholderImage:KT_GET_LOCAL_PICTURE(@"mine_header_logout@2x")];
        self.loginStatusLabel.hidden = YES;
        self.loginPromptLabel.hidden = YES;
        
        self.userNameLabel.hidden = NO;
        self.genderView.hidden = NO;
        
        self.userNameLabel.text = userInfoModel.userName;
        CGRect rect = self.userNameLabel.frame;
        rect.size.width = [userInfoModel.userName sizeWithFont:self.userNameLabel.font].width;
        rect.origin.x = self.headerButton.frame.origin.x + self.headerButton.frame.size.width + 22;
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
        [self.headerButton setImage:KT_GET_LOCAL_PICTURE(@"mine_header_logout@2x") forState:UIControlStateNormal];
        self.loginStatusLabel.hidden = NO;
        self.loginPromptLabel.hidden = NO;
        self.userNameLabel.hidden = YES;
        self.genderView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didUserInfoAction:(id)sender
{
    [[GBAccountManager sharedAccountManager] loginSuccess:^{
        GBUserInfoViewController *vc = [[GBUserInfoViewController alloc] init];
        [self.KTNavigationController pushKTViewController:vc animated:YES];
    } failure:^{
        
    }];
}

- (void)didBgButtonAction:(id)sender
{
    GBBackgroundListViewController *vc = [[GBBackgroundListViewController alloc] init];
    [self.KTNavigationController pushKTViewController:vc animated:YES];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    [self didBgButtonAction:nil];
}

#pragma mark - UITableViewDataSource And Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MineCellIdentifier";
    MineCell *cell = (MineCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:{
            cell.iconImageView.image = KT_GET_LOCAL_PICTURE(@"mine_code@2x");
            cell.nameLabel.text = @"我的兑换码";
            cell.badgeImageView.hidden = YES;
            break;
        }
        case 1:{
            cell.iconImageView.image = KT_GET_LOCAL_PICTURE(@"mine_about@2x");
            cell.nameLabel.text = @"关于";
            cell.badgeImageView.hidden = YES;
            break;
        }
        case 2:{
            cell.iconImageView.image = KT_GET_LOCAL_PICTURE(@"mine_setting@2x");
            cell.nameLabel.text = @"设置";
            if ([[LocalSettings sharedInstance].latestVersion caseInsensitiveCompare:[Utils getAppVersion]] == NSOrderedDescending) {
                cell.badgeImageView.hidden = NO;
            }else{
                cell.badgeImageView.hidden = YES;
            }
            
            break;
        }
        case 3:{
            cell.iconImageView.image = KT_GET_LOCAL_PICTURE(@"mine_feedback@2x");
            cell.nameLabel.text = @"意见反馈";
            cell.badgeImageView.hidden = YES;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{ //我的兑换码
            [[GBAccountManager sharedAccountManager] loginSuccess:^{
                GBMineRedemptionCodeViewController *vc = [[GBMineRedemptionCodeViewController alloc] init];
                [self.KTNavigationController pushKTViewController:vc animated:YES];
            } failure:^{
                
            }];
            break;
        }
        case 1:{ //关于
            GBAboutViewController *vc = [[GBAboutViewController alloc] init];
            [self.KTNavigationController pushKTViewController:vc animated:YES];
            break;
        }
        case 2:{//设置
            GBSettingViewController *vc = [[GBSettingViewController alloc] init];
            [self.KTNavigationController pushKTViewController:vc animated:YES];
            break;
        }
        case 3:{//意见反馈
            GBFeedbackViewController *vc = [[GBFeedbackViewController alloc] init];
            [self.KTNavigationController pushKTViewController:vc animated:YES];
            break;
        }
            
            
        default:
            break;
    }
}

@end

@implementation MineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (KT_IOS_VERSION_7_OR_ABOVE) {
            self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.6];
        }else{
            self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.8];
        }
        
        CGFloat x = 24.f;
        
        //icon
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 20, 27, 27)];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        x += (iconImageView.bounds.size.width + 20);
        
        //name
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 200, 67)];
        nameLabel.backgroundColor = KT_UICOLOR_CLEAR;
        nameLabel.font = GB_DEFAULT_FONT(13);
        nameLabel.textColor = KT_HEXCOLOR(0x333333);
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        x += 30;
        //badgeImageView
        UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 25, 5, 5)];
        badgeImageView.image = [UIImage imageNamed:@"bar_update.png"];
        badgeImageView.hidden = YES;
        [self.contentView addSubview:badgeImageView];
        self.badgeImageView = badgeImageView;
        
        //accessory
        UIImageView *accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275, 26, 15, 15)];
        accessoryImageView.image = KT_GET_LOCAL_PICTURE(@"mine_arrow@2x");
        [self.contentView addSubview:accessoryImageView];
        self.accessory = accessoryImageView;
        
        LineView *lineView = [[LineView alloc] initWithFrame:CGRectMake(5, 66.5, [Utils screenWidth] - 5, 1)];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.accessory.image = KT_GET_LOCAL_PICTURE(@"mine_arrow_highlighted@2x");
        if (KT_IOS_VERSION_7_OR_ABOVE) {
            self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:0.6];
        }else{
            self.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:0.8];
        }
    }
    else{
        self.accessory.image = KT_GET_LOCAL_PICTURE(@"mine_arrow@2x");
        if (KT_IOS_VERSION_7_OR_ABOVE) {
            self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.6];
        }else{
            self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.8];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.accessory.image = KT_GET_LOCAL_PICTURE(@"mine_arrow@2x");
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.6];
    }else{
        self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.8];
    }
}

@end
