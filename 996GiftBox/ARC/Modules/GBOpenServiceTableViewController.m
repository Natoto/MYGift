//
//  GBOpenServiceTableViewController.m
//  GameGifts
//
//  Created by Keven on 14-2-13.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBOpenServiceTableViewController.h"
#import "GBOSCell.h"
#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "GBNoDataShowView.h"
#import "GBLoadingView.h"
#import "GBPopUpBox.h"

@interface GBOpenServiceTableViewController ()
@property (nonatomic,strong)NSMutableArray * listArray;
@property (nonatomic,copy)NSString * cellIndentifier;
KT_PROPERTY_ASSIGN BOOL isLoadMore;
KT_PROPERTY_ASSIGN BOOL isRefresh;
KT_PROPERTY_ASSIGN BOOL isRefreshForNoData;
KT_PROPERTY_ASSIGN int32_t pageCount;
KT_PROPERTY_WEAK GBNoDataShowView *noDataShowView;
KT_PROPERTY_WEAK GBLoadingView *loadingView;
@end

@implementation GBOpenServiceTableViewController

- (id)initWithStyle:(UITableViewStyle)style  isOpenService:(int)flag
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableViewType = flag;
        self.isLoadMore = NO;
        self.isRefresh = NO;
        self.isRefreshForNoData = NO;
        self.pageCount = 0;
        self.listArray = [NSMutableArray array];
        if (flag == 1) {
            self.cellIndentifier = @"tableView.cell.indentifier.for.OpenService";
        }else{
            self.cellIndentifier = @"tableView.cell.indentifier.for.TestChart";
        }
        
    }
    return self;
}

- (void)dealloc
{
    [_request cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupTableHeaderView];
    [self setupLoadMoreFooterView]; //点击加载更多
    [self setupRefreshHeaderView]; //下载更多
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDataFromServer
{
    [self dataRequestMothed];
}

#pragma mark - SetUp
- (void)setupTableHeaderView
{
    CGFloat height = KT_UI_NAVIGATION_BAR_HEIGHT;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        height = KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT;
    }
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], height)];
    self.tableView.tableHeaderView = tableHeaderView;
    
}

- (void)setupLoadMoreFooterView
{
    self.loadMoreFooterView= [TableLoadMoreFooterView footerViewWithOwner:self.tableView delegate:self ownerInsetBottomDefaultHeight:KT_UI_TAB_BAR_HEIGHT];
    [self.loadMoreFooterView setEnable:NO];
}
- (void)setupRefreshHeaderView
{
    self.refreshHeaderView = [TableRefreshHeaderView headerViewWithOwner:self.tableView delegate:self addNavigationBArHeight:YES];
}

///////////////////////////
#pragma mark - Request
- (void)dataRequestMothed
{
    [self.request cancel];
    self.request = [[GBRequestForKT alloc] init];
    self.request.responseClass = [GBOpenServiceAndTestChartResponse class];
  
    //空页面显示...
    if ([self.tableView numberOfRowsInSection:0] <= 0 && !self.isRefreshForNoData) {
        GBLoadingView *loadingView = [[GBLoadingView alloc] init];
        [loadingView showInView:self.view.superview offset:0];
        self.loadingView = loadingView;
        self.request.cacheResponseAvailable = YES; //返回缓存数据
    }
    
    if (self.pageCount == 0) { //只缓存最新一页数据
        self.request.shouldSynCache = YES;
        if (self.tableViewType == 1) {
            self.request.command = [NSString stringWithFormat:@"%ud-%ud",REQUEST_COMMAND_TYPE_GET_GAME,REQUEST_RES_TYPE_GAME_OPEN];
        }else{
            self.request.command = [NSString stringWithFormat:@"%ud-%ud",REQUEST_COMMAND_TYPE_GET_GAME,REQUEST_RES_TYPE_GAME_TEST];
        }
    }
    
    BaseParameter * parameter = [[BaseParameter alloc] init];
    [parameter writeInt_32:DEFAULT_WRITE_LENGHT]; //当前数据总长度(字节) 后面修正数据长度
    [parameter writeInt_32:REQUEST_COMMAND_TYPE_GET_GAME];//请求标识
    [parameter writeInt_16:DEFAULT_CLIENT_VERSION]; //客户端的跟接口对接的版本号
    [parameter writeInt_32:DEFAULT_CLIENT_FLAGS]; //备用参数，用来兼容不同的客户端 接口的兼容，先暂时可以为0
    [parameter writeString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]]; //UUID
    [parameter writeString:[Utils getDevicesInfo]]; //设备信息 比如"iphone 7.1"
    NSArray * iosVersion = [Utils getPareIOSVersion];//IOS版本
    [parameter writeInt_8:[[iosVersion objectAtIndex:2] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:1] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:0] integerValue]];
    if (self.tableViewType == 1) {
        [parameter writeInt_8:REQUEST_RES_TYPE_GAME_OPEN];//开服表 ，测试表的表示
    }else{
        [parameter writeInt_8:REQUEST_RES_TYPE_GAME_TEST];//开服表 ，测试表的表示
    }

    [parameter writeInt_32:self.pageCount];//页数  0:第一页
    [parameter writeInt_32:0];//每页显示的数量  0:为默认服务器
    //修正数据长度
    [parameter changeBufferSize:parameter.length];
    self.request.parameters = parameter;
    
    __weak typeof(self) weakSelf = self;
    
    //获取缓存回调
    [self.request setCacheResponseBlock:^(GBRequest* request, GBResponse* response){
        //关闭等待筐
        [weakSelf.loadingView hidden];
        weakSelf.loadingView = nil;
        
        //刷新界面
        GBGiftHairResponse * responseResult = (GBGiftHairResponse *)response;
        weakSelf.listArray = responseResult.listArray;
        [weakSelf.tableView reloadData];
        
        //self.pageNum < pageCount - 1判断是否是最后一页
        [weakSelf.loadMoreFooterView setEnable:weakSelf.pageCount < responseResult.pageCount - 1];
    }];
    
    //获取服务端数据
    [self.request setResponseBlock:^(GBRequest* request, GBResponse* response){
        //关闭等待筐/下拉刷新/加载更多/空页面菊花钻
        [weakSelf.loadingView hidden];
        weakSelf.loadingView = nil;
        
        weakSelf.isRefreshForNoData = NO;
        [weakSelf.noDataShowView stopIndicatorView];
        
        if (weakSelf.isLoadMore) {
            weakSelf.isLoadMore = NO;
            [weakSelf.loadMoreFooterView didFinishedLoading:weakSelf.tableView];
        }
        
        if (weakSelf.isRefresh) {
            weakSelf.isRefresh = NO;
            [weakSelf.refreshHeaderView tableRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tableView];
            [weakSelf.loadMoreFooterView hiddedFooterView:NO];
        }
        
        if (response.isError) { //出错
            if (response.netError) {
                if (weakSelf.listArray.count > 0) { //有数据
                    
                    //没有网络&&Data，弹出框提示
                    GBPopUpBox *boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeNoNetwork withAutoHidden:YES];
                    [boxTmp showInView:weakSelf.view.superview offset:0];
                    
                }else{
                    //没有网络&&NoData
                    [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoNetwork
                                                superView:weakSelf.view.superview];
                }
            }else{
                if (weakSelf.listArray.count > 0) {
                    
                    //加载出错&&Data，弹出框提示
                    GBPopUpBox *boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeLoadingError withAutoHidden:YES];
                    [boxTmp showInView:weakSelf.view.superview offset:0];
                }else{
                    //加载错误&&NoData
                    [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForServierError
                                                superView:weakSelf.view.superview];
                }
            }
            
        }else{
            GBOpenServiceAndTestChartResponse * responseResult = (GBOpenServiceAndTestChartResponse *)response;
            
            //刷新
            if (weakSelf.pageCount == 0 && [responseResult.listArray count] > 0) {
                weakSelf.listArray = responseResult.listArray;
            }
            else{ //翻页
                [weakSelf.listArray addObjectsFromArray:responseResult.listArray];
            }
            
            //判断是否有数据
            if (weakSelf.listArray.count > 0) {
                [weakSelf.tableView reloadData];
            }
            
            //没有数据，显示空页面
            if ([weakSelf.tableView numberOfRowsInSection:0] <= 0) {
                [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoData
                                            superView:weakSelf.view.superview];
            }
            
            //self.pageNum < pageCount - 1判断是否是最后一页
            [weakSelf.loadMoreFooterView setEnable:weakSelf.pageCount < responseResult.pageCount - 1];
        }
    }];
    
    [self.request sendAsynchronous];
}

/**
 *  初始化NoDataShowView
 
 *
 *  @param type     那个页面
 *  @param sView    父类视图
 *  @param delegate 父类ViewController
 *  @param action   回调事件
 */
- (void)setupNoDataShowViewWithType:(GBNoDataShowViewType)type
                          superView:(UIView *)sView

{
    KT_DLOG_SELECTOR;
    [self.noDataShowView removeFromSuperview];
    GBNoDataShowView * noDataShowViewTmp = [[GBNoDataShowView alloc] initWithType:type
                                                                           target:self
                                                                          infoTag:0];
    [sView addSubview:noDataShowViewTmp];
    self.noDataShowView = noDataShowViewTmp;
}
- (void)refreshByNoDataShowViewWithInfoTag:(int)infoTag
{
    self.isRefreshForNoData = YES;
    self.pageCount = 0;
    [self dataRequestMothed];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 109.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    GBOSCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIndentifier];
    if (cell == nil) {
        cell = [[GBOSCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:self.cellIndentifier];
    }
    GBOpenServiceAndTestChartModel * model = [self.listArray objectAtIndex:indexPath.row];
    BOOL hasGift = NO;
    if (model.packageID != 0) {
        hasGift = YES;
    }
    [cell setupCellViewWithURLString:model.iconURLString
                            gameName:model.gameName
                        scorceNumber:model.score
                            betaTime:model.publishTime
                             hasGift:hasGift
                          betaString:model.remark
                          typeString:model.category
                           tableType:self.tableViewType
                                 row:indexPath.row
                              target:self
                              action:@selector(openGift:)];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)openGift:(UIButton *)bt
{
    KT_DLOG_SELECTOR;
    //tableType*1000 + row
    int tableType = bt.tag / 1000;
    GBOpenServiceAndTestChartModel * model = [self.listArray objectAtIndex:bt.tag -  tableType *1000];

    if ([self.delegate respondsToSelector:@selector(openGift:)]) {
        [self.delegate openGift:model];
    }
}
#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Footer
    [self.loadMoreFooterView scrollViewDidScroll:scrollView];
    //Header
    [self.refreshHeaderView tableRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //Footer
    [self.loadMoreFooterView scrollViewDidEndDragging:scrollView];
    //Header
    [self.refreshHeaderView tableRefreshScrollViewDidEndDragging:scrollView];
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
    [self.loadMoreFooterView hiddedFooterView:YES]; //隐藏LoadMoreFooterView
    [self dataRequestMothed];
}
@end
