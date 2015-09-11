//
//  GBSettingViewController.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-9.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBSettingViewController.h"
#import "TTSwitch.h"
#import "LocalSettings.h"
#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "GBPopUpBox.h"
#import "SDWebImageManager.h"
#import "PXAlertView.h"
#import "BaiduMobStat.h"

@interface GBSettingViewController ()

@property (nonatomic, KT_WEAK) UITableView *tableView;
@property (nonatomic, KT_WEAK) UILabel *cacheLabel;
@property (nonatomic, KT_WEAK) GBPopUpBox *popupBox;

@end

@implementation GBSettingViewController

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
    [[LocalSettings sharedInstance] removeObserver:self forKeyPath:@"latestVersion"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.customNavigationBar setNavBarTitle:@"设置"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT)];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, KT_UI_TAB_BAR_HEIGHT)];
    
    UITableView *tableViewTMP = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableViewTMP.dataSource = self;
    tableViewTMP.delegate = self;
    tableViewTMP.tableHeaderView = headerView;
    tableViewTMP.tableFooterView = footerView;
    [self addSubview:tableViewTMP];
    self.tableView = tableViewTMP;
    
    [[LocalSettings sharedInstance] addObserver:self forKeyPath:@"latestVersion" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == [LocalSettings sharedInstance] && [keyPath isEqualToString:@"latestVersion"]){
        [self.tableView reloadData];
    }
}

- (void)setupCustomTabBarButton
{
    [self.customTabBar setTabBarButtonWithImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back@2x")
                               highlightedImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back_highlight@2x")
                                     buttonType:CustomTabBarButtonTypeOfLeft
                                         target:self
                                         action:@selector(popBack:)];
}

- (void)popBack:(id)sender
{
    [self.KTNavigationController popKTViewControllerAnimated:YES];
}

- (void)didClearCacheAction:(id)sender
{
    [PXAlertView showAlertWithTitle:@"提示"
                            message:[NSString stringWithFormat:@"缓存文件大小为：%@，确定是否清空？",UDFormatFileSize([[SDWebImageManager sharedManager].imageCache getSize])]
                        cancelTitle:@"取消"
                         otherTitle:@"确定"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (!cancelled) {
                                 [[SDWebImageManager sharedManager].imageCache clearDisk:^{
                                     self.cacheLabel.text = UDFormatFileSize([[SDWebImageManager sharedManager].imageCache getSize]);
                                 }];
                             }
                         }];
}

#pragma mark - UITabelViewDataSource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:return 45;
        case 1:return 70;
        case 2:return 70;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, 35)];
    bgView.backgroundColor = KT_UICOLOR_CLEAR;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.f, 200, 35)];
    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
    titleLabel.font = GB_DEFAULT_FONT(13);
    titleLabel.textColor  = KT_HEXCOLOR(0x333333);
    [bgView addSubview:titleLabel];
    
    switch (section) {
        case 0:{
            titleLabel.text = @"推送新消息";
            break;
        }
        case 1:{
            titleLabel.text = @"更新";
            break;
        }
        case 2:{
            titleLabel.text = @"缓存设置";
            break;
        }
            
        default:
            break;
    }
    
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:{ //检查更新
            [self checkVersion];
            break;
        }
        case 2:{ //清理图片缓存
            
            [self didClearCacheAction:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void)checkVersion
{
    // Asynchronously query iTunes AppStore for publically available version
    GBPopUpBox *popupBox = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeProgress
                                                withMessage:@"正在检测，请稍后..."
                                             withAutoHidden:NO];
    [popupBox show];
    self.popupBox = popupBox;
    
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", [[NSBundle mainBundle] bundleIdentifier]];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.popupBox hiddenWithAnimated:NO];
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    
                    [PXAlertView showAlertWithTitle:@"提示"
                                            message:@"未检测到版本信息!"
                                        cancelTitle:nil
                                         otherTitle:@"确定"
                                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                             
                                         }];
                    return;
                    
                } else {
                    
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    [LocalSettings sharedInstance].latestVersion = currentAppStoreVersion;
                    
                    if ([[Utils getAppVersion] compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
		                
                        [PXAlertView showAlertWithTitle:@"提示"
                                                message:[NSString stringWithFormat:@"有新版本%@，是否前往更新？",currentAppStoreVersion]
                                            cancelTitle:@"取消"
                                             otherTitle:@"确定"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                 if (!cancelled) {
                                                     NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", [[NSBundle mainBundle] bundleIdentifier]];
                                                     NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                                                     [[UIApplication sharedApplication] openURL:iTunesURL];
                                                 }
                                             }];
                        
                    }
                    else {
                        
                        // Current installed version is the newest public version or newer
                        GBPopUpBox *popupBox = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeDefault
                                                                    withMessage:@"恭喜你，当前是最新版本"
                                                                 withAutoHidden:YES];
                        [popupBox showMask];
                        
                    }
                    
                }
                
            });
        }
        else{
            [weakSelf.popupBox hiddenWithAnimated:NO];
            [PXAlertView showAlertWithTitle:@"提示"
                                    message:@"检查失败!"
                                cancelTitle:nil
                                 otherTitle:@"确定"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     
                                 }];
        }
        
    }];
    
    [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_CHECK_UPDATE_BUTTON eventLabel:@""];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    switch (indexPath.section) {
        case 0:{
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0.f, 100, 45)];
            titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
            titleLabel.font = GB_DEFAULT_FONT(13);
            titleLabel.textColor  = KT_HEXCOLOR(0x666666);
            titleLabel.text = @"推送通知";
            [cell.contentView addSubview:titleLabel];
            
            TTSwitch *trafficSwitch = [[TTSwitch alloc] initWithFrame:CGRectMake(KT_UI_SCREEN_WIDTH - 76, 9, 56, 26)];
            trafficSwitch.changeHandler = ^(BOOL on){
                [LocalSettings sharedInstance].isPushOpen = on;
            };
            
            [trafficSwitch setTrackImage:KT_GET_LOCAL_PICTURE(@"setting_switch_track@2x")];
            [trafficSwitch setOverlayImage:KT_GET_LOCAL_PICTURE(@"setting_switch_overlay@2x")];
            [trafficSwitch setTrackMaskImage:KT_GET_LOCAL_PICTURE(@"setting_switch_mask@2x")];
            [trafficSwitch setThumbImage:KT_GET_LOCAL_PICTURE(@"setting_switch_thumb@2x")];
            [trafficSwitch setThumbHighlightImage:KT_GET_LOCAL_PICTURE(@"setting_switch_thumb_highlight@2x")];
            
            [cell.contentView addSubview:trafficSwitch];
            
            trafficSwitch.on = [LocalSettings sharedInstance].isPushOpen;
            break;
        }
        case 1:{
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 100, 15)];
            titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
            titleLabel.font = GB_DEFAULT_FONT(13);
            titleLabel.textColor  = KT_HEXCOLOR(0x666666);
            titleLabel.text = @"检查更新";
            [cell.contentView addSubview:titleLabel];
            
            if ([[LocalSettings sharedInstance].latestVersion caseInsensitiveCompare:[Utils getAppVersion]] == NSOrderedDescending) {
                UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 13, 5, 5)];
                badgeImageView.image = [UIImage imageNamed:@"bar_update.png"];
                [cell.contentView addSubview:badgeImageView];
            }
            
            UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, (titleLabel.frame.origin.y + titleLabel.frame.size.height + 15), 100, 11)];
            subTitleLabel.backgroundColor = KT_UICOLOR_CLEAR;
            subTitleLabel.font = GB_DEFAULT_FONT(11);
            subTitleLabel.textColor  = KT_HEXCOLOR(0x999999);
//            subTitleLabel.text = [NSString stringWithFormat:@"V%@",[Utils getAppVersion]];
            subTitleLabel.text = @"测试1.0";
            [cell.contentView addSubview:subTitleLabel];
            
            UIImage *arrowImage = KT_GET_LOCAL_PICTURE(@"mine_arrow@2x");
            UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((KT_UI_SCREEN_WIDTH - arrowImage.size.width - 45), (70 - arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
            arrowImageView.image = arrowImage;
            [cell.contentView addSubview:arrowImageView];
            break;
        }
        case 2:{
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, 200, 15)];
            titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
            titleLabel.font = GB_DEFAULT_FONT(13);
            titleLabel.textColor  = KT_HEXCOLOR(0x666666);
            titleLabel.text = @"清理图片、图标缓存";
            [cell.contentView addSubview:titleLabel];
            
            UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, (titleLabel.frame.origin.y + titleLabel.frame.size.height + 15), 100, 11)];
            subTitleLabel.backgroundColor = KT_UICOLOR_CLEAR;
            subTitleLabel.font = GB_DEFAULT_FONT(11);
            subTitleLabel.textColor  = KT_HEXCOLOR(0x999999);
            subTitleLabel.text = UDFormatFileSize([[SDWebImageManager sharedManager].imageCache getSize]);
            [cell.contentView addSubview:subTitleLabel];
            self.cacheLabel = subTitleLabel;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((KT_UI_SCREEN_WIDTH - 68), 22, 48, 26);
            [button setTitle:@"清理" forState:UIControlStateNormal];
            [button setTitleColor:KT_BlueColor forState:UIControlStateNormal];
            [button setTitleColor:KT_HEXCOLOR(0xffffff) forState:UIControlStateHighlighted];
            button.titleLabel.font = GB_DEFAULT_FONT(12);
            [button setBackgroundImage:[[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(didClearCacheAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

@end
