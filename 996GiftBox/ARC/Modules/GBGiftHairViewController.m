//
//  GBGiftHairViewController.m
//  GameGifts
//
//  Created by Keven on 14-1-6.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBGiftHairViewController.h"
#import "GBHPThirdCell.h"


#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "GBGiftHairModel.h"
#import "GBGetPackageNumberModel.h"
#import "GBPackageOrderModel.h"
#import "GBAccountManager.h"
#import "GBSearchHomeViewController.h"
#import "GBLoadingView.h"
#import "GBPopUpBox.h"
#import "PXAlertView.h"
#import "BaiduMobStat.h"

@interface GBGiftHairViewController ()
KT_PROPERTY_WEAK UITableView * tableViewGH;
KT_PROPERTY_WEAK TableLoadMoreFooterView * loadMoreFooterViewForGH;
KT_PROPERTY_WEAK TableRefreshHeaderView  * refreshHeaderViewForGH;
KT_PROPERTY_STRONG GBSearchHomeViewController *searchViewController;
KT_PROPERTY_WEAK GBPopUpBox * popUpBox;


KT_PROPERTY_ASSIGN int32_t pageCount;//页的总数
KT_PROPERTY_STRONG NSMutableArray * listArray; //数据列表

KT_PROPERTY_ASSIGN BOOL  isLoadMore;
KT_PROPERTY_ASSIGN BOOL  isRefresh;
KT_PROPERTY_STRONG GBRequestForKT * requestForGH;
KT_PROPERTY_STRONG GBDefaultReqeust * request;
KT_PROPERTY_ASSIGN BOOL  isRefreshForNoData;
KT_PROPERTY_WEAK GBLoadingView *loadingView;
@end

@implementation GBGiftHairViewController

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
    [_requestForGH cancel];
    [_request cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self setupTableViewGH];
    [self setupTableHeaderViewForTableViewGH];
    [self setupLoadMoreFooterView]; //点击加载更多
    [self setupRefreshHeaderView]; //下载更多
    [self dataRequestMothed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange:) name:NOTIFICATION_GLOBAL_LOGINSTATUS_CHANGE object:nil];
}

- (void)viewDidAppearForKTView
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"礼包列表"];
}

- (void)viewWillDisappearForKTView
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"礼包列表"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//登录状态改变，刷新页面
- (void)loginStatusChange:(NSNotification *)notification
{
    //[self dataRequestMothed];
}

- (void)dataRequestMothed
{
    [self.requestForGH cancel];
    self.requestForGH = [[GBRequestForKT alloc] init];
    self.requestForGH.responseClass = [GBGiftHairResponse class];
    
    //空页面显示...
    if ([self.tableViewGH numberOfRowsInSection:0] <= 0 && !self.isRefreshForNoData) {
        GBLoadingView *loadingView = [[GBLoadingView alloc] init];
        [loadingView showInView:self.view offset:0];
        [self.view bringSubviewToFront:self.customTabBar];
        self.loadingView = loadingView;
        self.requestForGH.cacheResponseAvailable=YES;
    }
    
    self.isRefreshForNoData = NO;
    
    if (self.pageCount == 0) {//缓存页面为0 的数据
        self.requestForGH.shouldSynCache = YES;
        self.requestForGH.command = [NSString stringWithFormat:@"%ud",REQUEST_COMMAND_TYPE_GET_PACKAGE];
    }
    
    BaseParameter * parameter = [[BaseParameter alloc] init];
    [parameter writeInt_32:DEFAULT_WRITE_LENGHT]; //当前数据总长度(字节) 后面修正数据长度
    [parameter writeInt_32:REQUEST_COMMAND_TYPE_GET_PACKAGE];//请求标识
    [parameter writeInt_16:DEFAULT_CLIENT_VERSION]; //客户端的跟接口对接的版本号
    [parameter writeInt_32:DEFAULT_CLIENT_FLAGS]; //备用参数，用来兼容不同的客户端 接口的兼容，先暂时可以为0
    [parameter writeString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]]; //UUID
    [parameter writeString:[Utils getDevicesInfo]]; //设备信息 比如"iphone 7.1"
    NSArray * iosVersion = [Utils getPareIOSVersion];//IOS版本
    [parameter writeInt_8:[[iosVersion objectAtIndex:2] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:1] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:0] integerValue]];
    if (![Utils isNilOrEmpty:[[TRUser sharedInstance] tokenKey]]) {
        [parameter writeInt_64:[[TRUser sharedInstance] userId]];
    }else{
        [parameter writeInt_64:0]; //用户ID (未登录可以0)
    }
    [parameter writeInt_32:self.pageCount];//页数  0:第一页
    [parameter writeInt_32:0];//每页显示的数量  0:为默认服务器
    //修正数据长度
    [parameter changeBufferSize:parameter.length];
    self.requestForGH.parameters = parameter;
    
    __weak typeof(self) weakSelf = self;
    
    //缓存数据回调
    [self.requestForGH setCacheResponseBlock:^(GBRequest* request, GBResponse* response){
        //关闭等待筐
        [weakSelf.loadingView hidden];
        weakSelf.loadingView = nil;
        
        //刷新界面
        GBGiftHairResponse * responseResult = (GBGiftHairResponse *)response;
        weakSelf.listArray = responseResult.listArray;
        [weakSelf.tableViewGH reloadData];
        
        //self.pageNum < pageCount - 1判断是否是最后一页
        [weakSelf.loadMoreFooterViewForGH setEnable:weakSelf.pageCount < responseResult.pageCount - 1];
    }];
    
    //网络数据回调
    [self.requestForGH setResponseBlock:^(GBRequest* request, GBResponse* response){
        //关闭等待筐/下拉刷新/加载更多/空页面菊花钻
        [weakSelf.loadingView hidden];
        weakSelf.loadingView = nil;
        
        [weakSelf hidNoDataView];
        
        if (weakSelf.isLoadMore) {
            weakSelf.isLoadMore = NO;
            [weakSelf.loadMoreFooterViewForGH didFinishedLoading:weakSelf.tableViewGH];
        }
        
        if (weakSelf.isRefresh) {
            weakSelf.isRefresh = NO;
            [weakSelf.refreshHeaderViewForGH tableRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tableViewGH];
            [weakSelf.loadMoreFooterViewForGH hiddedFooterView:NO];
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
        }else{
            GBGiftHairResponse * responseResult = (GBGiftHairResponse *)response;
            
            //刷新
            if (weakSelf.pageCount == 0 && [responseResult.listArray count] > 0) {
                weakSelf.listArray = [NSMutableArray arrayWithArray:responseResult.listArray];
            }
            else{ //翻页
                [weakSelf.listArray addObjectsFromArray:responseResult.listArray];
            }
            
            //判断是否有数据
            if (weakSelf.listArray.count > 0) {
                [weakSelf.tableViewGH reloadData];
            }
            
            //没有数据，显示空页面
            if ([weakSelf.tableViewGH numberOfRowsInSection:0] <= 0) {
                [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoData
                                            superView:weakSelf.view];
            }
            
            //self.pageNum < pageCount - 1判断是否是最后一页
            [weakSelf.loadMoreFooterViewForGH setEnable:weakSelf.pageCount < responseResult.pageCount - 1];
            
        }
    }];
    
    [self.requestForGH sendAsynchronous];
}

- (void)refreshByNoDataShowViewWithInfoTag:(int)infoTag
{
    self.isRefreshForNoData = YES;
    self.pageCount = 0;
    [self dataRequestMothed];
}

- (void)setupCustomNavigationBarButton
{
    [self.customNavigationBar setNavBarTitle:@"礼包发号"];
    [self.customNavigationBar setNavBarButtonWithImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_center@2x")
                                      highlightedImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_center_highlighted@2x")
                                            buttonType:KTNavigationBarButtonTypeOfRight
                                                target:self
                                                action:@selector(comeToCenter:)];
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
- (void)comeToCenter:(id)sender
{
    KT_DLOG_SELECTOR;
    [self.KTNavigationController popToKTViewControllerWithTabIndex:3 animated:YES];
}
- (void)showSearchView:(id)sender
{
    KT_DLOG_SELECTOR;
    if (self.searchViewController == nil) {
        self.searchViewController = [[GBSearchHomeViewController alloc] initWithType:KT_KInitTypeTMP];
    }
    
    __block GBGiftHairViewController *vc = self;
    self.searchViewController.didClosedHandler = ^{
        vc.searchViewController = nil;
    };
    
    [self.searchViewController open];
}
- (void)popBack:(id)sender
{
    [self.requestForGH cancel];
    [self.KTNavigationController popKTViewControllerAnimated:YES];
}
- (void)setupTableViewGH
{
    UITableView * tableViewTmp = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], self.view.bounds.size.height)];
    tableViewTmp.delegate = self;
    tableViewTmp.dataSource = self;
    tableViewTmp.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
    tableViewTmp.showsHorizontalScrollIndicator = NO;
    tableViewTmp.showsVerticalScrollIndicator = YES;
    tableViewTmp.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableViewTmp];
    self.tableViewGH = tableViewTmp;
}
- (void)setupTableHeaderViewForTableViewGH
{
    CGFloat height = KT_UI_NAVIGATION_BAR_HEIGHT;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        height = KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT;
    }
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], height)];
    self.tableViewGH.tableHeaderView = tableHeaderView;
}

//点击加载更多
- (void)setupLoadMoreFooterView
{
    self.loadMoreFooterViewForGH = [TableLoadMoreFooterView footerViewWithOwner:self.tableViewGH delegate:self ownerInsetBottomDefaultHeight:KT_UI_TAB_BAR_HEIGHT];
    [self.loadMoreFooterViewForGH setEnable:NO];
}
//下载更新
- (void)setupRefreshHeaderView
{
    self.refreshHeaderViewForGH = [TableRefreshHeaderView headerViewWithOwner:self.tableViewGH delegate:self addNavigationBArHeight:YES];
}
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIndentifier = @"tableView.cell.indentifier.for.hp.titleAndImage";
    GBHPThirdCell * titleAndImageCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (titleAndImageCell == nil) {
        titleAndImageCell = [[GBHPThirdCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:cellIndentifier];
    }
    GBGiftHairModel * model = [self.listArray objectAtIndex:indexPath.row];
    [titleAndImageCell setupCellVieweWtihGameName:model.gameName
                                        URLString:model.iconURLString
                                      serviceName:model.packName
                                         giftName:model.subtitle
                                      releaseTime:model.publishTime
                                     packageCount:model.packcount
                                              row:indexPath.row
                                          isFirst:NO
                                       giftStatus:model.packStatus
                                           target:self
                                           action:@selector(titleAndImageCellButtonPressed:)];
    
    titleAndImageCell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return titleAndImageCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     GBGiftHairModel * model = [self.listArray objectAtIndex:indexPath.row];
    GBPackageReceiveViewController * vc = [[GBPackageReceiveViewController alloc] initWithPackageID:model.packageID indexPath:indexPath];
    vc.delegate = self;
    [self.KTNavigationController pushKTViewController:vc animated:YES];
}
//领取
- (void)titleAndImageCellButtonPressed:(UIButton *)bt
{
    //NOTE  点击领取操作
    //先判断是否登录，已经登录则直接领取，没有登录弹出登录页面
    GBGiftHairModel * model = [self.listArray objectAtIndex:bt.tag];
    KT_DLog(@"status:%d",model.packStatus);
    if (model.packStatus == GetGiftStatusForEndForUnclaimed) { //等待领取
        
        [[GBAccountManager sharedAccountManager] loginSuccess:^{
            
            GBPopUpBox *box = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeProgress
                                                   withMessage:@"领取中，请稍后..."
                                                withAutoHidden:NO];
            [box show];
            self.popUpBox = box;
            
            [self.request cancel];
            self.request = [[GBDefaultReqeust alloc] init];
            self.request.responseClass = [GBGetPackageNumberResponse class];
            
            BaseParameter * parameter = [[BaseParameter alloc] init];
            [parameter writeInt_32:DEFAULT_WRITE_LENGHT]; //当前数据总长度(字节) 后面修正数据长度
            [parameter writeInt_32:REQUEST_COMMAND_TYPE_APP_GETPACKAGENUMBER];//请求标识
            [parameter writeInt_16:DEFAULT_CLIENT_VERSION]; //客户端的跟接口对接的版本号
            [parameter writeInt_32:DEFAULT_CLIENT_FLAGS]; //备用参数，用来兼容不同的客户端 接口的兼容，先暂时可以为0
            if (![Utils isNilOrEmpty:[[TRUser sharedInstance] tokenKey]] ) { //没有登录
                [parameter writeInt_64:[[TRUser sharedInstance] userId]];
            }else{
                [parameter writeInt_64:0];
            }
            [parameter writeInt_64:[model packageID]];//领取的是哪个礼包
            //修正数据长度
            [parameter changeBufferSize:parameter.length];
            self.request.parameters = parameter;
            
            __weak typeof(self) weakSelf = self;
            [self.request setResponseBlock:^(GBRequest* request, GBResponse* response){
                [weakSelf.popUpBox hiddenWithAnimated:YES];
                if (response.isError) { //出错
                    if (response.netError) {
                        [PXAlertView showAlertWithTitle:@"失败"
                                                message:@"网络不可用，请检查网络连接!"
                                            cancelTitle:@"确定"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                 
                                             }];
                    }else{
                        [PXAlertView showAlertWithTitle:@"失败"
                                                message:@"领取失败，请重试!"
                                            cancelTitle:@"确定"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                 
                                             }];
                    }
                }else{
                    GBGetPackageNumberResponse * responseResult = (GBGetPackageNumberResponse *)response;
                    if (responseResult.dataModelForPN) {
                        
                        GBPackageReceiveViewController * vc = [[GBPackageReceiveViewController alloc] initWithPackageID:model.packageID];
                        [weakSelf.KTNavigationController pushKTViewController:vc animated:YES];
                        
                        [weakSelf changedPackageStatusWithIndex:[NSIndexPath indexPathForRow:bt.tag inSection:0]
                                                      newStatus:responseResult.dataModelForPN.packageStatus
                                                 packageSurplus:responseResult.dataModelForPN.packageSurplus];
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                            @autoreleasepool {
//                                //NOTE 添加到推送里面和上传服务器里面，在程序退出，进入后台的时候提交 ,提交的是游戏ID
//                                NSString * updateGameString = [[NSString alloc] initWithFormat:@"GetPackage + %d",23434234];
//                                NSString * updateGameClassString = [[NSString alloc] initWithFormat:@"GameClass + %d",23434234];
//                                [JPushManager uploadAliasAndTags:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:23434234],updateGameString,
//                                                                  [NSNumber numberWithInt:23434234],updateGameClassString, nil]]; //上传到服务器 及设置激光
//                            }
//                        });

                    }else{
                        //加载出错&&Data，弹出框提示
                        [PXAlertView showAlertWithTitle:@"失败"
                                                message:@"领取失败，请重试!"
                                            cancelTitle:@"确定"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                 
                                             }];
                    }
                    
                }
            }];
            [self.request sendAsynchronous];
        } failure:^{
            
            KT_DLog(@"failure");
            
        }];

    }else if (model.packStatus == GetGiftStatusForOrder){
        //NOTE  判断是否登录， 预约 ，加入 JPush
        GBPopUpBox *box = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeProgress
                                               withMessage:@"预约中，请稍后..."
                                            withAutoHidden:NO];
        [box show];
        self.popUpBox = box;
        
        [self.request cancel];
        self.request = [[GBDefaultReqeust alloc] init];
        self.request.responseClass = [GBGetPackageOrderResponse class];
        
        BaseParameter * parameter = [[BaseParameter alloc] init];
        [parameter writeInt_32:DEFAULT_WRITE_LENGHT]; //当前数据总长度(字节) 后面修正数据长度
        [parameter writeInt_32:REQUEST_COMMAND_TYPE_APP_PACKAGEORDER];//请求标识
        [parameter writeInt_16:DEFAULT_CLIENT_VERSION]; //客户端的跟接口对接的版本号
        [parameter writeInt_32:DEFAULT_CLIENT_FLAGS]; //备用参数，用来兼容不同的客户端 接口的兼容，先暂时可以为0
        if (![Utils isNilOrEmpty:[[TRUser sharedInstance] tokenKey]] ) { //没有登录
            [parameter writeInt_64:[[TRUser sharedInstance] userId]];
        }else{
            [parameter writeInt_64:0];
        }
        [parameter writeInt_64:model.packageID];//预约的是哪个礼包
        
        //修正数据长度
        [parameter changeBufferSize:parameter.length];
        self.request.parameters = parameter;
        
        __weak typeof(self) weakSelf = self;
        [self.request setResponseBlock:^(GBRequest* request, GBResponse* response){
          [weakSelf.popUpBox hiddenWithAnimated:YES];
            if (response.isError) { //失败
                
                if (response.netError) {
                    [PXAlertView showAlertWithTitle:@"失败"
                                            message:@"网络不可用，请检查网络连接!"
                                        cancelTitle:@"确定"
                                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                             
                                         }];
                }else{
                    [PXAlertView showAlertWithTitle:@"失败"
                                            message:@"预约失败，请重试!"
                                        cancelTitle:@"确定"
                                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                             
                                         }];
                }
                
            }
            else{
                
                GBGetPackageOrderResponse * responseResult = (GBGetPackageOrderResponse *)response;
                if (responseResult.dataModelForPN) {
                    
                    GBPackageReceiveViewController * vc = [[GBPackageReceiveViewController alloc] initWithPackageID:model.packageID];
                    [weakSelf.KTNavigationController pushKTViewController:vc animated:YES];
                    
                    [weakSelf changedPackageStatusWithIndex:[NSIndexPath indexPathForRow:bt.tag inSection:0]
                                                  newStatus:responseResult.dataModelForPN.package_status
                                             packageSurplus:-1];
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        @autoreleasepool {
//                            //NOTE 添加到推送里面和上传服务器里面，在程序退出，进入后台的时候提交 ,提交的是游戏ID
//                            NSString * updateGameString = [[NSString alloc] initWithFormat:@"GetPackage + %d",23434234];
//                            NSString * updateGameClassString = [[NSString alloc] initWithFormat:@"GameClass + %d",23434234];
//                            [JPushManager uploadAliasAndTags:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:23434234],updateGameString,
//                                                              [NSNumber numberWithInt:23434234],updateGameClassString, nil]]; //上传到服务器 及设置激光
//                        }
//                    });
                    
                }else{
                    //加载出错&&Data，弹出框提示
                    [PXAlertView showAlertWithTitle:@"失败"
                                            message:@"预约失败，请重试!"
                                        cancelTitle:@"确定"
                                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                             
                                         }];
                }
            }}];
        
        [self.request sendAsynchronous];
    
    }
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Footer
    [self.loadMoreFooterViewForGH scrollViewDidScroll:scrollView];
    //Header
    [self.refreshHeaderViewForGH tableRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //Footer
    [self.loadMoreFooterViewForGH scrollViewDidEndDragging:scrollView];
    //Header
    [self.refreshHeaderViewForGH tableRefreshScrollViewDidEndDragging:scrollView];
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
    [self.loadMoreFooterViewForGH hiddedFooterView:YES]; //隐藏LoadMoreFooterView
    [self dataRequestMothed];
}

#pragma mark -  changedPackageStatus
- (void)changedPackageStatusWithIndex:(NSIndexPath *)indexPath newStatus:(int)status  packageSurplus:(int)surplusCount
{
    GBGiftHairModel * model = [self.listArray objectAtIndex:indexPath.row];
    model.packStatus = status; //先修改
    if (surplusCount >= 0) {
        model.packcount = surplusCount;
    }
    KT_DLog(@"status:%d",model.packStatus);
    [self.tableViewGH reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationNone];

}

@end
