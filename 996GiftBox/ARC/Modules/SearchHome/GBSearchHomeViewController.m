//
//  GBSearchHomeViewController.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-2.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBSearchHomeViewController.h"
#import "GBAppDelegate.h"
#import "GBSearchDefaultViewCell.h"
#import "GBSearchRecommendModel.h"
#import "GBSearchProgressHUD.h"
#import "KTMainViewController.h"
#import "GBDefaultResponse.h"
#import "GBDefaultReqeust.h"
#import "GBSearchModel.h"
#import "PXAlertView.h"
#import "BaiduMobStat.h"

#define GB_SEARCH_CONTROLLER_ANIMATION_DURATION 0.35

@interface GBSearchHomeViewController ()

@property (nonatomic, assign)enum KT_KContentPanelType contentPanelType;
@property (nonatomic, assign)enum KT_KInitType type;
@property (nonatomic, strong) GBSearchResultViewController *resultViewController;
@property (nonatomic, weak) UIView *progressView;
@property (nonatomic, weak) UITableView *defaultTabelView;

@property (nonatomic, strong) NSArray *defaultArray;

@property (nonatomic, strong) GBDefaultReqeust *searchRequest;
@property (nonatomic, strong) GBDefaultReqeust *recommendRequest;

@property (nonatomic, assign) BOOL isClickNodataLoading;

@end

@implementation GBSearchHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(enum KT_KInitType)type
{
    self = [super init];
    if (self) {
        _type = type;
        if (type == KT_KInitTypeTMP) {
//            [[KTNavigationController alloc] initWithRootKTViewController:self];
        }
    }
    return self;
}

- (void)dealloc
{
    [self.searchRequest cancel];
    [self.recommendRequest cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    switch (_type) {
        case KT_KInitTypeNormal:{
//            self.view.frame = CGRectMake(0.0f, 0.f, [Utils screenWidth], [Utils screenHeight]-KT_UI_STATUS_BAR_HEIGHT);
//            break;
        }
        case KT_KInitTypeTMP:{
//            self.view.frame = CGRectMake(0.0f, [Utils screenHeight], [Utils screenWidth], [Utils screenHeight]-KT_UI_STATUS_BAR_HEIGHT);
//            break;
        }
            
        default:
            break;
    }
    
    // 测试 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
//    GBSearchRecommendModel *model1 = [[GBSearchRecommendModel alloc] init];
//    model1.rank = 1;
//    model1.trend = 1;
//    model1.name = @"[莽荒传奇]公测新手礼包";
//    
//    GBSearchRecommendModel *model2 = [[GBSearchRecommendModel alloc] init];
//    model2.rank = 2;
//    model2.trend = 0;
//    model2.name = @"[仙变]九游醉笑红尘高级礼包";
//    
//    GBSearchRecommendModel *model3 = [[GBSearchRecommendModel alloc] init];
//    model3.rank = 3;
//    model3.trend = -1;
//    model3.name = @"[刀塔女神]遗忘海湾高级礼包";
//    
//    GBSearchRecommendModel *model4 = [[GBSearchRecommendModel alloc] init];
//    model4.rank = 4;
//    model4.trend = 1;
//    model4.name = @"[格斗之皇]新服礼包";
//    
//    GBSearchRecommendModel *model5 = [[GBSearchRecommendModel alloc] init];
//    model5.rank = 5;
//    model5.trend = 1;
//    model5.name = @"[保卫萝卜]新服礼包";
//    
//    GBSearchRecommendModel *model6 = [[GBSearchRecommendModel alloc] init];
//    model6.rank = 6;
//    model6.trend = -1;
//    model6.name = @"[植物大战僵尸2]新服礼包";
//    
//    self.defaultArray = [NSArray arrayWithObjects:model1, model2, model3, model4, model5, model6, nil];
    
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    [self setContentPanelType:KT_KContentPanelTypeDefaultView];
    
    [self doRecommendRequest];
}

- (void)viewDidAppearForKTView
{
    NSString* cName = [NSString stringWithFormat:@"搜索"];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

- (void)viewWillDisappearForKTView
{
    NSString* cName = [NSString stringWithFormat:@"搜索"];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doRecommendRequest
{
    [self.recommendRequest cancel];
    self.recommendRequest = [[GBDefaultReqeust alloc] init];
    self.recommendRequest.responseClass = [GBGiftRecommendResponse class];
    self.recommendRequest.command = [NSString stringWithFormat:@"%lx",(unsigned long)REQUEST_COMMAND_TYPE_GIFT_RECOMMEND];
    self.recommendRequest.cacheResponseAvailable = YES;
    self.recommendRequest.shouldSynCache = YES;
    
    BaseParameter * parameter = [[BaseParameter alloc] init];
    [parameter writeInt_32:DEFAULT_WRITE_LENGHT];
    [parameter writeInt_32:REQUEST_COMMAND_TYPE_GIFT_RECOMMEND];
    [parameter writeInt_16:[[Utils getAppVersion] integerValue]];
    [parameter writeInt_32:0];
    [parameter writeString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]];
    [parameter writeString:[Utils getDevicesInfo]];
    NSArray * iosVersion = [Utils getPareIOSVersion];
    [parameter writeInt_8:[[iosVersion objectAtIndex:2] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:1] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:0] integerValue]];
    //修正数据长度
    [parameter changeBufferSize:parameter.length];
    self.recommendRequest.parameters = parameter;
    
    __weak GBSearchHomeViewController *vc = self;
    
    //缓存数据
    [self.recommendRequest setCacheResponseBlock:^(GBRequest* request, GBResponse* response){
        if (response.isError) { //出错
            
        }else{
            GBGiftRecommendResponse * responseResult = (GBGiftRecommendResponse *)response;
            vc.defaultArray = [NSArray arrayWithArray:responseResult.modelMArray];
            [vc.defaultTabelView reloadData];
        }
    }];
    
    //网络数据
    [self.recommendRequest setResponseBlock:^(GBRequest* request, GBResponse* response){
        if (response.isError) { //出错
            
            
        }else{
            GBGiftRecommendResponse * responseResult = (GBGiftRecommendResponse *)response;
            vc.defaultArray = [NSArray arrayWithArray:responseResult.modelMArray];
            [vc.defaultTabelView reloadData];
        }
    }];
    
    [self.recommendRequest sendAsynchronous];
}

- (void)popBack:(id)sender
{
    [self close];
}

- (void)setupCustomTabBarButton
{
    switch (_type) {
        case KT_KInitTypeNormal:{
            [self setTabBarHidden:YES];
            break;
        }
        case KT_KInitTypeTMP:{
            [self setTabBarHidden:NO];
            [self.customTabBar setTabBarButtonWithImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back@2x")
                                       highlightedImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back_highlight@2x")
                                             buttonType:CustomTabBarButtonTypeOfLeft
                                                 target:self
                                                 action:@selector(popBack:)];
            break;
        }
            
        default:
            break;
    }
}

- (void)setupCustomNavigationBarButton
{
    KT_DLog(@"设置上导航Button");
    CGFloat y = 0;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = KT_UI_STATUS_BAR_HEIGHT;
    }
    
    GBSearchBar * searchViewTmp = [[GBSearchBar alloc] initWithFrame:CGRectMake(0.f, y, KT_UI_SCREEN_WIDTH, self.customNavigationBar.bounds.size.height - KT_UI_STATUS_BAR_HEIGHT)];
    searchViewTmp.delegate = self;
    [self.customNavigationBar addSubview:searchViewTmp];
    self.searchBar = searchViewTmp;
}

//默认推荐页面
- (void)setupDefaultView
{
    CGFloat height = 39;
    CGFloat y = 0;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        height = KT_UI_STATUS_BAR_HEIGHT + 39;
        y = KT_UI_STATUS_BAR_HEIGHT;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, height)];
    headerView.backgroundColor = KT_UICOLOR_CLEAR;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, y, self.view.bounds.size.width - 12, 39)];
    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
    titleLabel.font = GB_DEFAULT_FONT(15);
    titleLabel.textColor = KT_HEXCOLOR(0x44b5ff);
    titleLabel.text = @"热门礼包推荐";
    [headerView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.bounds.size.height - 0.5, headerView.bounds.size.width, 0.5)];
    lineView.backgroundColor = KT_HEXCOLOR(0xd3d3d3);
    [headerView addSubview:lineView];
    
    UITableView *tableViewTMP =  [[UITableView alloc] initWithFrame:CGRectMake(0.0f, KT_UI_NAVIGATION_BAR_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - KT_UI_NAVIGATION_BAR_HEIGHT - KT_UI_TAB_BAR_HEIGHT) style:UITableViewStylePlain];
    tableViewTMP.dataSource = self;
    tableViewTMP.delegate = self;
    tableViewTMP.tableHeaderView = headerView;
    [self addSubview:tableViewTMP];
    self.defaultTabelView = tableViewTMP;
    
    self.defaultTabelView.hidden = YES;
}

//搜索进度页面
- (void)setupProgressView
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [self addSubview:view];
    
    GBSearchProgressHUD *progressHUD = [[GBSearchProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    progressHUD.center = view.center;
    [view addSubview:progressHUD];
    
    self.progressView = view;
    self.progressView.hidden = YES;
}

//搜索结果页面
- (void)setupResultView
{
    GBSearchResultViewController *viewController = [[GBSearchResultViewController alloc] initWithStyle:UITableViewStylePlain];
    viewController.delegate = self;
//    viewController.view.frame = CGRectMake(0.0f, KT_UI_NAVIGATION_BAR_HEIGHT, self.customNavigationView.bounds.size.width, self.customNavigationView.bounds.size.height - KT_UI_NAVIGATION_BAR_HEIGHT - KT_UI_TAB_BAR_HEIGHT);
    viewController.view.frame = self.view.bounds;
    [self addSubview:viewController.view];
    
    self.resultViewController = viewController;
    
    self.resultViewController.view.hidden = YES;
}

//打开搜索
- (void)open
{
    KTNavigationController *nav = [[KTNavigationController alloc] initWithRootKTViewController:self];
    GBAppDelegate *appDelegate = (GBAppDelegate *)[UIApplication sharedApplication].delegate;
    
    CGRect rect = nav.view.frame;
    rect.origin.y = rect.size.height;
    if (!KT_IOS_VERSION_7_OR_ABOVE) {
        rect.origin.y += KT_UI_STATUS_BAR_HEIGHT;
    }
    
    nav.view.frame = rect;
    
    
    [appDelegate.window addSubview:nav.view];
    
    if (self.willOpenHandler) {
        self.willOpenHandler();
    }
    
    [UIView animateWithDuration:GB_SEARCH_CONTROLLER_ANIMATION_DURATION
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
//                         self.view.transform = CGAffineTransformMakeTranslation(0,-self.view.bounds.size.height);
                         nav.view.transform = CGAffineTransformMakeTranslation(0,-nav.view.bounds.size.height);
                         if (self.openingHandler) {
                             self.openingHandler();
                         }
                         
                     } completion:^(BOOL finished) {
                         if (self.didOpenedHandle) {
                             self.didOpenedHandle();
                         }
                     }];
    
    
    [self.searchBar isFirstResponser:YES];
    
    [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_SECOND_SEARCH_BUTTON eventLabel:@""];
}

//关闭搜索
- (void)close
{
    if (self.willCloseHandler) {
        self.willCloseHandler();
    }
    
    CGFloat duration = 0.f;
    
//    switch (self.contentPanelType) {
//        case KT_KContentPanelTypeDefaultView:
//        case KT_KContentPanelTypeProgress:
//        case KT_KContentPanelTypeEmpty:{
//            duration = 0.f;
//            break;
//        }
//        case KT_KContentPanelTypeResultTable:{
//            duration = GB_SEARCH_CONTROLLER_ANIMATION_DURATION;
//            break;
//        }
//            
//        default:
//            break;
//    }
    
    duration = GB_SEARCH_CONTROLLER_ANIMATION_DURATION;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
//                         self.KTNavigationController.view.alpha = 0.f;
//                         self.view.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0));
                         self.KTNavigationController.view.transform = CGAffineTransformIdentity;
                         if (self.closingHandler) {
                             self.closingHandler();
                         }
                         
                     } completion:^(BOOL finished) {
                         [self.searchBar clearSearch:nil];
                         [self.KTNavigationController.view removeFromSuperview];
                         if (self.didClosedHandler) {
                             self.didClosedHandler();
                         }
                     }];
}

- (void)setContentPanelType:(enum KT_KContentPanelType)contentPanelType
{
    switch (contentPanelType) {
        case KT_KContentPanelTypeDefaultView:{
            if (self.defaultTabelView == nil) {
                [self setupDefaultView];
            }
            self.defaultTabelView.hidden = NO;
            self.progressView.hidden = YES;
            [self hidNoDataView];
            self.resultViewController.view.hidden = YES;
            break;
        }
        case KT_KContentPanelTypeProgress:{
            self.defaultTabelView.hidden = YES;
            if (self.progressView == nil) {
                [self setupProgressView];
            }
            self.progressView.hidden = NO;
            [self hidNoDataView];
            self.resultViewController.view.hidden = YES;
            break;
        }
        case KT_KContentPanelTypeResultTable:{
            self.defaultTabelView.hidden = YES;
            self.progressView.hidden = YES;
            [self hidNoDataView];
            if (self.resultViewController == nil) {
                [self setupResultView];
            }
            self.resultViewController.view.hidden = NO;
            break;
        }
        case KT_KContentPanelTypeEmpty:{
            self.defaultTabelView.hidden = YES;
            self.progressView.hidden = YES;
            [self setupNoDataShowViewWithType:GBNoDataShowViewTypeForSearch
                                    superView:self.view];
            self.resultViewController.view.hidden = YES;
            break;
        }
        case KT_KContentPanelTypeEmptyNetwork:{
            self.defaultTabelView.hidden = YES;
            self.progressView.hidden = YES;
            [self setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoNetwork
                                    superView:self.view];
            self.resultViewController.view.hidden = YES;
            break;
        }
            
        default:
            break;
    }
    
    _contentPanelType = contentPanelType;
}

//测试+++++++++++++++++++++++++++++++++++++++++++++
- (void)loadOK
{
    [self setContentPanelType:KT_KContentPanelTypeResultTable];
}
//++++++++++++++++++++++++++++++++++++++++++++++++

- (void)refreshByNoDataShowViewWithInfoTag:(int)infoTag
{
    if (![Utils isNilOrEmpty:self.searchBar.inputTextField.text]) {
        self.isClickNodataLoading = YES;
        [self searchGameWithGameHotString:self.searchBar.inputTextField.text];
    }
}

#pragma mark - GBSearchBarDelegate

- (void)searchGameWithGameHotString:(NSString *)hotString
{
    [self.searchBar isFirstResponser:NO];
    if (!self.isClickNodataLoading) {
        [self setContentPanelType:KT_KContentPanelTypeProgress];
    }
    self.isClickNodataLoading = NO;
    
    [self.searchRequest cancel];
    self.searchRequest = [[GBDefaultReqeust alloc] init];
    self.searchRequest.responseClass = [GBGiftSearchResponse class];
    
    BaseParameter * parameter = [[BaseParameter alloc] init];
    [parameter writeInt_32:DEFAULT_WRITE_LENGHT];
    [parameter writeInt_32:REQUEST_COMMAND_TYPE_SEARCH];
    [parameter writeInt_16:[[Utils getAppVersion] integerValue]];
    [parameter writeInt_32:0];
    [parameter writeString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]];
    [parameter writeString:[Utils getDevicesInfo]];
    NSArray * iosVersion = [Utils getPareIOSVersion];
    [parameter writeInt_8:[[iosVersion objectAtIndex:2] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:1] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:0] integerValue]];
    if (![Utils isNilOrEmpty:[[TRUser sharedInstance] tokenKey]]) {
        [parameter writeInt_64:[[TRUser sharedInstance] userId]];
    }else{
        [parameter writeInt_64:0]; //用户ID (未登录可以0)
    }
    [parameter writeInt_32:0];
    [parameter writeInt_32:0];
    [parameter writeString:hotString];
    //修正数据长度
    [parameter changeBufferSize:parameter.length];
    self.searchRequest.parameters = parameter;
    
    __weak GBSearchHomeViewController *vc = self;
    [self.searchRequest setResponseBlock:^(GBRequest* request, GBResponse* response){
        if (response.isError) { //出错
            if (response.netError) {
                [vc setContentPanelType:KT_KContentPanelTypeEmptyNetwork];
            }else{
                [vc setContentPanelType:KT_KContentPanelTypeEmpty];
            }
            [PXAlertView showAlertWithTitle:@"提示"
                                    message:response.errorMessage
                                cancelTitle:nil
                                 otherTitle:@"确定"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     
                                 }];
            
        }else{
            GBGiftSearchResponse * responseResult = (GBGiftSearchResponse *)response;
            if (responseResult.modelMArray == nil) { //无搜索结果
                [vc setContentPanelType:KT_KContentPanelTypeEmpty];
            }
            else{
                [vc setContentPanelType:KT_KContentPanelTypeResultTable];
                
                [vc.resultViewController reloadWithModelArray:responseResult.modelMArray withPageCount:responseResult.pageCount];
                vc.resultViewController.curSearchKey = hotString;
            }
        }
    }];
    [self.searchRequest sendAsynchronous];
}

- (void)cancelSearch
{
    switch (_type) {
        case KT_KInitTypeNormal:{
            [self setContentPanelType:KT_KContentPanelTypeDefaultView];
            break;
        }
        case KT_KInitTypeTMP:{
            [self close];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.defaultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"SearchHomeDefaultCellIdentifier";
    GBSearchDefaultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[GBSearchDefaultViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    GBSearchRecommendModel *model = [self.defaultArray objectAtIndex:indexPath.row];
    [cell reloadWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar isFirstResponser:NO];
    GBSearchRecommendModel *model = [self.defaultArray objectAtIndex:indexPath.row];
    GBPackageReceiveViewController * vc = [[GBPackageReceiveViewController alloc] initWithPackageID:model.package_id];
    [self.KTNavigationController pushKTViewController:vc animated:YES];

    vc.customTabBar.rightButton.hidden = YES;
    
    [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_HOT_RECO_BUTTON eventLabel:model.package_name];
}

#pragma mark - GBSearchResultViewControllerDelegate

- (void)didSelectedTableViewCellWithResultModel:(GBSearchModel *)model indexPath:(NSIndexPath*)indexPath
{
    switch (model.flags) {
        case 1:{ //活动
            break;
        }
        case 2:{ //礼包
            GBPackageReceiveViewController * vc = [[GBPackageReceiveViewController alloc] initWithPackageID:model.modelID indexPath:indexPath];
            vc.delegate = self;
            [self.KTNavigationController pushKTViewController:vc animated:YES];
            vc.customTabBar.rightButton.hidden = YES;
            break;
        }
            
        default:
            break;
    }
}

- (void)dragRefreshWithKey:(NSString *)searchKey withPage:(NSInteger)page
{
    
}

- (void)pushToViewController:(KTViewController *)viewController
{
    [self.KTNavigationController pushKTViewController:viewController animated:YES];
}

#pragma mark - UIScrollViewDelegate and GBSearchResultViewControllerDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar isFirstResponser:NO];
}

#pragma mark - GBPackageReceiveViewControllerDelegate

- (void)changedPackageStatusWithIndex:(NSIndexPath *)indexPath newStatus:(int)status  packageSurplus:(int)surplusCount
{
    [self.resultViewController changedPackageStatusWithIndex:indexPath newStatus:status packageSurplus:surplusCount];
}

@end
