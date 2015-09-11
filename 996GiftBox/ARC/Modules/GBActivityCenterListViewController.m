//
//  GBActivityCenterListViewController.m
//  GameGifts
//
//  Created by Keven on 14-1-2.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBActivityCenterListViewController.h"
#import "GBACLCell.h"
#import "GBLoadingView.h"
#import "GBActivitiesDetailsViewController.h"
#import "GBSearchHomeViewController.h"

#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "GBActivityCenterListModel.h"
#import "GBPopUpBox.h"
#import "BaiduMobStat.h"

@interface GBActivityCenterListViewController ()
KT_PROPERTY_WEAK UITableView * tableViewACL;
KT_PROPERTY_STRONG GBSearchHomeViewController *searchViewController;
KT_PROPERTY_WEAK TableLoadMoreFooterView * loadMoreFooterViewForACL;
KT_PROPERTY_WEAK TableRefreshHeaderView  * refreshHeaderViewForACL;

KT_PROPERTY_ASSIGN int32_t pageCount;//页的总数
KT_PROPERTY_STRONG NSMutableArray * listArray; //数据列表

KT_PROPERTY_ASSIGN BOOL  isLoadMore;
KT_PROPERTY_ASSIGN BOOL  isRefresh;
KT_PROPERTY_STRONG GBRequestForKT * requestForACL;
KT_PROPERTY_ASSIGN BOOL  isRefreshForNoData;

KT_PROPERTY_WEAK GBLoadingView *loadingView;
@end

@implementation GBActivityCenterListViewController
- (id)init
{
    self = [super init];
    if (self) {
        self.listArray = [NSMutableArray array];
        self.pageCount = 0;
        self.isLoadMore = NO;
        self.isRefresh = NO;
        self.isRefreshForNoData = NO;
    }
    return self;
}

- (void) dealloc
{
    [_requestForACL cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupTableViewACL];
    [self setupTableHeaderViewForTableViewACL];
    [self setupLoadMoreFooterView]; //点击加载更多
    [self setupRefreshHeaderView]; //下载更多
    [self dataRequestMothed];
}

- (void)viewDidAppearForKTView
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"活动列表"];
}

- (void)viewWillDisappearForKTView
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"活动列表"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataRequestMothed
{
    [self.requestForACL cancel];
    self.requestForACL = [[GBRequestForKT alloc] init];
    self.requestForACL.responseClass = [GBActivityCenterListResponse class];
    
    //空页面显示...
    if ([self.tableViewACL numberOfRowsInSection:0] <= 0 && !self.isRefreshForNoData) {
        GBLoadingView *loadingView = [[GBLoadingView alloc] init];
        [loadingView showInView:self.view offset:0];
        [self.view bringSubviewToFront:self.customTabBar];
        self.loadingView = loadingView;
        self.requestForACL.cacheResponseAvailable=YES;
    }
    
    self.isRefreshForNoData = NO;
    
    if (self.pageCount == 0) {//缓存页面为0 的数据
        self.requestForACL.shouldSynCache = YES;
        self.requestForACL.command = [NSString stringWithFormat:@"%ud",REQUEST_COMMAND_TYPE_GET_ACTIVITY];
    }
    
    BaseParameter * parameter = [[BaseParameter alloc] init];
    [parameter writeInt_32:DEFAULT_WRITE_LENGHT];//当前数据总长度(字节) 后面修正数据长度
    [parameter writeInt_32:REQUEST_COMMAND_TYPE_GET_ACTIVITY];//请求标识
    [parameter writeInt_16:DEFAULT_CLIENT_VERSION];//客户端的跟接口对接的版本号
    [parameter writeInt_32:DEFAULT_CLIENT_FLAGS];//备用参数，用来兼容不同的客户端 接口的兼容，先暂时可以为0
    [parameter writeString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]];//UUID
    [parameter writeString:[Utils getDevicesInfo]];//设备信息 比如"iphone 7.1"
    NSArray * iosVersion = [Utils getPareIOSVersion];//IOS版本
    [parameter writeInt_8:[[iosVersion objectAtIndex:2] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:1] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:0] integerValue]];
    if (![Utils isNilOrEmpty:[[TRUser sharedInstance] tokenKey]] ) { //没有登录
        [parameter writeInt_64:[[TRUser sharedInstance] userId]];
    }else{
        [parameter writeInt_64:0];
    }
    [parameter writeInt_32:self.pageCount];//页数  0:第一页
    [parameter writeInt_32:0];//每页显示的数量  0:为默认服务器
    //修正数据长度
    [parameter changeBufferSize:parameter.length];
    self.requestForACL.parameters = parameter;
    
    __weak typeof(self) weakSelf = self; // NOTE
    
    //缓存数据回调
    [self.requestForACL setCacheResponseBlock:^(GBRequest* request, GBResponse* response){
        //关闭等待筐
        [weakSelf.loadingView hidden];
        weakSelf.loadingView = nil;
        
        //刷新界面
        GBActivityCenterListResponse * responseResult = (GBActivityCenterListResponse *)response;
        weakSelf.listArray = responseResult.listArray;
        [weakSelf.tableViewACL reloadData];
        
        //self.pageNum < pageCount - 1判断是否是最后一页
        [weakSelf.loadMoreFooterViewForACL setEnable:weakSelf.pageCount < responseResult.pageCount - 1];
    }];
    
    //网络数据回调
    [self.requestForACL setResponseBlock:^(GBRequest* request, GBResponse* response){
        //关闭等待筐/下拉刷新/加载更多/空页面菊花钻
        [weakSelf.loadingView hidden];
        weakSelf.loadingView = nil;
        
        [weakSelf hidNoDataView];
        
        if (weakSelf.isLoadMore) {
            weakSelf.isLoadMore = NO;
            [weakSelf.loadMoreFooterViewForACL didFinishedLoading:weakSelf.tableViewACL];
        }
        
        if (weakSelf.isRefresh) {
            weakSelf.isRefresh = NO;
            [weakSelf.refreshHeaderViewForACL tableRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tableViewACL];
            [weakSelf.loadMoreFooterViewForACL hiddedFooterView:NO];
        }
        
        if (response.isError) {
            if (response.netError) {
                if (weakSelf.listArray.count > 0) { //有数据
                    
                    //没有网络&&Data，弹出框提示
                    GBPopUpBox *boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeNoNetwork withAutoHidden:YES];
                    [boxTmp showInView:weakSelf.view.superview offset:0];
                    
                }else{
                    //没有网络&&NoData
                    [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoNetwork
                                                superView:weakSelf.view];
                }
            }else{
                if (weakSelf.listArray.count > 0) {
                    
                    //加载出错&&Data，弹出框提示
                    GBPopUpBox *boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeLoadingError withAutoHidden:YES];
                    [boxTmp showInView:weakSelf.view.superview offset:0];
                }else{
                    //加载错误&&NoData
                    [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForServierError
                                                superView:weakSelf.view];
                }
            }
        }
        else{
            GBActivityCenterListResponse * responseResult = (GBActivityCenterListResponse *)response;
            //刷新
            if (weakSelf.pageCount == 0 && [responseResult.listArray count] > 0) {
                weakSelf.listArray = responseResult.listArray;
            }
            else{ //翻页
                [weakSelf.listArray addObjectsFromArray:responseResult.listArray];
            }
            
            //判断是否有数据
            if (weakSelf.listArray.count > 0) {
                [weakSelf.tableViewACL reloadData];
            }
            
            //没有数据，显示空页面
            if ([weakSelf.tableViewACL numberOfRowsInSection:0] <= 0) {
                [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoData
                                            superView:weakSelf.view];
            }
            
            //self.pageNum < pageCount - 1判断是否是最后一页
            [weakSelf.loadMoreFooterViewForACL setEnable:weakSelf.pageCount < responseResult.pageCount - 1];
        }
    }];
    [self.requestForACL sendAsynchronous];
}

/**
 *  m没有数据页面的刷新界面
 *
 *  @param infoTag 默认是0,
 */
- (void)refreshByNoDataShowViewWithInfoTag:(int)infoTag
{
    self.isRefreshForNoData = YES;
    self.pageCount = 0;
    [self dataRequestMothed];
}

- (void)setupCustomNavigationBarButton
{
    [self.customNavigationBar setNavBarTitle:@"活动中心"];
}
- (void)setupCustomTabBarButton
{
    [self.customTabBar setTabBarButtonWithImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back@2x")
                               highlightedImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back_highlighted@2x")
                                     buttonType:CustomTabBarButtonTypeOfLeft
                                         target:self
                                         action:@selector(popBack:)];
    
     [self.customTabBar setTabBarButtonWithImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_magnifier@2x")\
                               highlightedImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_magnifier_highlighted@2x")\
                                     buttonType:CustomTabBarButtonTypeOfRight\
                                         target:self\
                                         action:@selector(showSearchView:)];

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
    
    __block GBActivityCenterListViewController *vc = self;
    self.searchViewController.didClosedHandler = ^{
        vc.searchViewController = nil;
    };
    
    [self.searchViewController open];
}
- (void)setupTableViewACL
{
    UITableView * tableViewTmp = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], self.view.bounds.size.height)];
    tableViewTmp.delegate = self;
    tableViewTmp.dataSource = self;
    tableViewTmp.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
    tableViewTmp.showsHorizontalScrollIndicator = NO;
    tableViewTmp.showsVerticalScrollIndicator = YES;
    tableViewTmp.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableViewTmp];
    self.tableViewACL = tableViewTmp;
}
- (void)setupTableHeaderViewForTableViewACL
{
    
    CGFloat height = KT_UI_NAVIGATION_BAR_HEIGHT;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        height = KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT;
    }
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], height)];
    tableHeaderView.backgroundColor = KT_UICOLOR_CLEAR;
    self.tableViewACL.tableHeaderView = tableHeaderView;
}

//点击加载更多
- (void)setupLoadMoreFooterView
{
    self.loadMoreFooterViewForACL = [TableLoadMoreFooterView footerViewWithOwner:self.tableViewACL delegate:self ownerInsetBottomDefaultHeight:KT_UI_TAB_BAR_HEIGHT];
    [self.loadMoreFooterViewForACL setEnable:NO];
}
//下载更新
- (void)setupRefreshHeaderView
{
    self.refreshHeaderViewForACL = [TableRefreshHeaderView headerViewWithOwner:self.tableViewACL delegate:self addNavigationBArHeight:YES];
}
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[self listArray] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    NSString * cellIndentifier = @"tableView.cell.indentifier.for.ACL.titleAndImage";
    GBACLCell * titleAndImageCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (titleAndImageCell == nil) {
        titleAndImageCell = [[GBACLCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:cellIndentifier];
    }
    GBActivityCenterListModel * model = [self.listArray objectAtIndex:indexPath.row];
    [titleAndImageCell setupCellVieweWtihActivityName:model.gameName
                                            URLString:model.iconURLString
                                          serviceName:model.activityName
                                             subtitle:model.subtitle
                                             giftInfo:model.description
                                                 time:model.publishTime
                                      popularityCount:model.popularityCount];
    titleAndImageCell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return titleAndImageCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBActivitiesDetailsViewController * vc = [[GBActivitiesDetailsViewController alloc] initWithActivityID:[[self.listArray objectAtIndex:indexPath.row] activityID]];
    [self.KTNavigationController pushKTViewController:vc animated:YES];
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Footer
    [self.loadMoreFooterViewForACL scrollViewDidScroll:scrollView];
    //Header
    [self.refreshHeaderViewForACL tableRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //Footer
    [self.loadMoreFooterViewForACL scrollViewDidEndDragging:scrollView];
    //Header
    [self.refreshHeaderViewForACL tableRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - LoadMoreFooterView Delegate
//加载更多
- (void)loadMoreActionTriggered:(TableLoadMoreFooterView *)loadMoreView
{
    KT_DLOG_SELECTOR;
    self.isLoadMore = YES;
    self.pageCount +=1;
    [self dataRequestMothed];
}
#pragma mark - RefreshHeaderView Delegate
//下拉刷新
- (void)refreshActionTriggered:(TableRefreshHeaderView *)refreshView
{
    KT_DLOG_SELECTOR;
    self.isRefresh = YES;
    self.pageCount = 0;
    [self.loadMoreFooterViewForACL hiddedFooterView:YES]; //隐藏LoadMoreFooterView
    [self dataRequestMothed];
}
@end
