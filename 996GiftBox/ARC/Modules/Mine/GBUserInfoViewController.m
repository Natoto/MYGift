//
//  GBUserInfoViewController.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-8.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBUserInfoViewController.h"
#import "GBSearchHomeViewController.h"
#import "GBEditNickNameViewController.h"
#import "GBActionSheet.h"
#import "GBUpdatePasswordViewController.h"
#import "GBAccountManager.h"
#import "GBUserInfoModel.h"
#import "UIImageView+WebCache.h"
#import "BaiduMobStat.h"


@interface GBUserInfoViewController ()

@property (nonatomic, KT_WEAK) UITableView *tableView;
@property (nonatomic, KT_STRONG) GBSearchHomeViewController *searchViewController;

@end

@implementation GBUserInfoViewController

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
    [[GBAccountManager sharedAccountManager] removeObserver:self forKeyPath:@"userInfoModel"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.customNavigationBar setNavBarTitle:@"资料修改"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, KT_UI_NAVIGATION_BAR_HEIGHT)];
    headerView.backgroundColor = KT_UICOLOR_CLEAR;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, KT_UI_TAB_BAR_HEIGHT)];
    footerView.backgroundColor = KT_UICOLOR_CLEAR;
    
    UITableView *tableViewTMP = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableViewTMP.dataSource = self;
    tableViewTMP.delegate = self;
    tableViewTMP.tableHeaderView = headerView;
    tableViewTMP.tableFooterView = footerView;
    [self addSubview:tableViewTMP];
    self.tableView = tableViewTMP;
    
    [[GBAccountManager sharedAccountManager] addObserver:self forKeyPath:@"userInfoModel" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == [GBAccountManager sharedAccountManager] && [keyPath isEqualToString:@"userInfoModel"]) {
        
        [self.tableView reloadData];
    }
}

- (void)logout:(id)sender
{
    [[GBAccountManager sharedAccountManager] logoutCallBack:^(void){
        [self popBack:nil];
    }];
}

- (void)popBack:(id)sender
{
    [self.KTNavigationController popKTViewControllerAnimated:YES];
}

- (void)showSearchView:(id)sender
{
    if (self.searchViewController == nil) {
        self.searchViewController = [[GBSearchHomeViewController alloc] initWithType:KT_KInitTypeTMP];
    }
    
    __block GBUserInfoViewController *vc = self;
    self.searchViewController.didClosedHandler = ^{
        vc.searchViewController = nil;
    };
    
    [self.searchViewController open];
}

- (void)setupCustomTabBarButton
{
    [self.customTabBar setTabBarButtonWithImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back@2x")
                               highlightedImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back_highlight@2x")
                                     buttonType:CustomTabBarButtonTypeOfLeft
                                         target:self
                                         action:@selector(popBack:)];
   
     [self.customTabBar setTabBarButtonWithImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_magnifier@2x")\
                               highlightedImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_magnifier_highlighted@2x")\
                                     buttonType:CustomTabBarButtonTypeOfRight\
                                         target:self\
                                         action:@selector(showSearchView:)];
}

#pragma mark - UITableViewDataSource AND Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:return 1;
        case 1:return 3;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:return 80;
        case 1:return 45;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:return 30;
        case 1:return 10;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 62;
    }
    else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = nil;
    if (section == 1) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, 62)];
        view.backgroundColor = KT_UICOLOR_CLEAR;
        
        UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutButton.frame = CGRectMake(15.f, 25, KT_UI_SCREEN_WIDTH - 30, 37);
        [logoutButton setBackgroundImage:[KT_GET_LOCAL_PICTURE(@"mine_logout@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
        [logoutButton setBackgroundImage:[KT_GET_LOCAL_PICTURE(@"mine_logout_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
        [logoutButton setTitle:@"退出当前帐号" forState:UIControlStateNormal];
        logoutButton.titleLabel.font = GB_DEFAULT_FONT(15);
        [logoutButton setTitleColor:KT_HEXCOLOR(0xf3273a) forState:UIControlStateNormal];
        [logoutButton setTitleColor:KT_HEXCOLOR(0xffffff) forState:UIControlStateHighlighted];
        [logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:logoutButton];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserInfoCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    switch (indexPath.section) {
        case 0:{
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 100, 80)];
            titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
            titleLabel.font = GB_DEFAULT_FONT(16);
            titleLabel.textColor = KT_HEXCOLOR(0x333333);
            titleLabel.text = @"头像";
            [cell.contentView addSubview:titleLabel];
            
            //头像
            UIImageView *portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake((KT_UI_SCREEN_WIDTH - 75), 12, 55, 55)];
            portraitImageView.tag = 100;
//            portraitImageView.image = [UIImage imageNamed:@""];
            [portraitImageView setImageWithURL:[NSURL URLWithString:[GBAccountManager sharedAccountManager].userInfoModel.avatar_middle_url]];
            
            portraitImageView.layer.cornerRadius = portraitImageView.bounds.size.width/2;
            portraitImageView.layer.masksToBounds = YES;
            
            [cell.contentView addSubview:portraitImageView];
            
            //箭头
//            UIImage *arrowImage = KT_GET_LOCAL_PICTURE(@"mine_arrow@2x");
//            UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((KT_UI_SCREEN_WIDTH - arrowImage.size.width - 30), (80 - arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
//            arrowImageView.image = arrowImage;
//            [cell.contentView addSubview:arrowImageView];
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 100, 45)];
                    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
                    titleLabel.font = GB_DEFAULT_FONT(16);
                    titleLabel.textColor = KT_HEXCOLOR(0x333333);
                    titleLabel.text = @"性别";
                    [cell.contentView addSubview:titleLabel];
                    
                    UILabel *genderValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 150.0f, cell.bounds.size.height)];
                    genderValueLabel.font = [UIFont systemFontOfSize:16];
                    genderValueLabel.textColor = KT_HEXCOLOR(0x999999);
                    genderValueLabel.textAlignment = NSTextAlignmentRight;
                    genderValueLabel.backgroundColor = KT_UICOLOR_CLEAR;
                    genderValueLabel.text = [GBAccountManager sharedAccountManager].userInfoModel.genderStr;
                    if ([genderValueLabel.text length] <= 0) {
                        genderValueLabel.text = @"保密";
                    }
                    
                    [cell.contentView addSubview:genderValueLabel];
                    
                    //箭头
//                    UIImage *arrowImage = KT_GET_LOCAL_PICTURE(@"mine_arrow@2x");
//                    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((KT_UI_SCREEN_WIDTH - arrowImage.size.width - 30), (cell.bounds.size.height - arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
//                    arrowImageView.image = arrowImage;
//                    [cell.contentView addSubview:arrowImageView];
                    break;
                }
                case 1:{
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 100, 45)];
                    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
                    titleLabel.font = GB_DEFAULT_FONT(16);
                    titleLabel.textColor = KT_HEXCOLOR(0x333333);
                    titleLabel.text = @"通行证";
                    [cell.contentView addSubview:titleLabel];
                    
                    UILabel *passValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 150.0f, cell.bounds.size.height)];
                    passValueLabel.font = [UIFont systemFontOfSize:16];
                    passValueLabel.textColor = KT_HEXCOLOR(0x999999);
                    passValueLabel.textAlignment = NSTextAlignmentRight;
                    passValueLabel.backgroundColor = KT_UICOLOR_CLEAR;
                    passValueLabel.text = [GBAccountManager sharedAccountManager].userInfoModel.userName;
                    [cell.contentView addSubview:passValueLabel];
                    break;
                }
                case 2:{
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 100, 45)];
                    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
                    titleLabel.font = GB_DEFAULT_FONT(16);
                    titleLabel.textColor = KT_HEXCOLOR(0x333333);
                    titleLabel.text = @"修改密码";
                    [cell.contentView addSubview:titleLabel];
                    
                    //箭头
                    UIImage *arrowImage = KT_GET_LOCAL_PICTURE(@"mine_arrow@2x");
                    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((KT_UI_SCREEN_WIDTH - arrowImage.size.width - 30), (cell.bounds.size.height - arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
                    arrowImageView.image = arrowImage;
                    [cell.contentView addSubview:arrowImageView];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
            
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{ // 头像
            break;
            GBActionSheet *actionSheet = [[GBActionSheet alloc] initWithType:KGBActionSheetTypePersonInfo2
                                                                  withTitles:[NSArray arrayWithObjects:@"查看头像", @"从相册选择", @"拍照", nil]
                                                                    callBack:^(int index){
                                                                        switch (index) {
                                                                            case 0:{//取消
                                                                                break;
                                                                            }
                                                                            case 1:{//查看头像
                                                                                break;
                                                                            }
                                                                            case 2:{//从相册选择
                                                                                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                                                                imagePicker.delegate = self;
                                                                                //imagePicker.allowsImageEditing = YES;    //图片可以编辑
                                                                                //需要添加委托
                                                                                [self presentViewController:imagePicker animated:YES completion:^(void){
                                                                                    
                                                                                }];
                                                                                break;
                                                                            }
                                                                            case 3:{//拍照
                                                                                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                                                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                                                                    imagePicker.delegate = self;
                                                                                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                                    [self presentViewController:imagePicker animated:YES completion:^(void){
                                                                                        
                                                                                    }];
                                                                                }
                                                                                break;
                                                                            }
                                                                                
                                                                            default:
                                                                                break;
                                                                        }
                                                                    }
                                                               selectedIndex:0];
            [actionSheet show];
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:{ //性别
                    break;
                    UILabel *genderKeyLabel = (UILabel *)[self.view viewWithTag:102];
                    GBActionSheet *actionSheet = [[GBActionSheet alloc] initWithType:KGBActionSheetTypePersonInfo1
                                                                          withTitles:[NSArray arrayWithObjects:@"男", @"女", nil]
                                                                            callBack:^(int index){
                                                                                switch (index) {
                                                                                    case 0:{//取消
                                                                                        break;
                                                                                    }
                                                                                    case 1:{//男
                                                                                        genderKeyLabel.text = @"男";
                                                                                        break;
                                                                                    }
                                                                                    case 2:{//女
                                                                                        genderKeyLabel.text = @"女";
                                                                                        break;
                                                                                    }
                                                                                        
                                                                                    default:
                                                                                        break;
                                                                                }
                                                                            }
                                                                       selectedIndex:0];
                    [actionSheet show];
                    break;
                }
                case 1:{ //通行证
                    break;
                }
                case 2:{ //修改密码
                    GBUpdatePasswordViewController *vc = [[GBUpdatePasswordViewController alloc] init];
                    [self.KTNavigationController pushKTViewController:vc animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        
    }];
    UIImageView *portraitView = (UIImageView *)[self.view viewWithTag:100];
    portraitView.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        
    }];
}

@end
