//
//  GBSearchResultViewController.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-2.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBSearchResultViewController.h"
#import "GBGiftCell.h"
#import "GBSearchModel.h"
#import "GBPackageReceiveViewController.h"
#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "PXAlertView.h"
#import "GBAccountManager.h"
#import "GBPopUpBox.h"
#import "PXAlertView.h"
#import "GBGetPackageNumberModel.h"
#import "GBPackageOrderModel.h"

@interface GBSearchResultViewController ()

@property (nonatomic, strong)NSMutableArray *modeArray;
@property (nonatomic, weak)TableLoadMoreFooterView * loadMoreFooterViewForACL;
@property (nonatomic, weak)TableRefreshHeaderView  * refreshHeaderViewForACL;
@property (nonatomic, weak)GBPopUpBox * popUpBox;
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, strong) GBDefaultReqeust *searchRequest;
@property (nonatomic, strong) GBDefaultReqeust *requestForKT;

@end

@implementation GBSearchResultViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self.searchRequest cancel];
    [self.requestForKT cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.tableView.bounds.size.width, KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT)];
    self.tableView.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
//
//    //5xp留白
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.tableView.bounds.size.width, 5 + KT_UI_TAB_BAR_HEIGHT)];
    

//    //测试+++++++++++++++++++++++++++++++++++++++++++++++++
//    GBGiftModel *model1 = [[GBGiftModel alloc] init];
//    model1.categoryType = 0;
//    model1.status = GetGiftStatusForEndForUnclaimed;
//    model1.giftName = @"我叫MT Online";
//    model1.iconUrl = @"http://img.996.com/131231/982-131231104303641_320x190.jpg";
//    model1.comeFrom = @"55服铜台服";
//    model1.category = @"特权礼包";
//    model1.time = @"2013-10-25";
//    model1.surplus = 500;
//    
//    GBGiftModel *model2 = [[GBGiftModel alloc] init];
//    model2.categoryType = 0;
//    model1.status = GetGiftStatusForAlreadyReceive;
//    model2.giftName = @"我叫MT Online";
//    model2.iconUrl = @"http://img.996.com/140101/56-140101105UYB_160x120.jpg";
//    model2.comeFrom = @"260区畅游宝箱";
//    model2.category = @"论坛礼包";
//    model2.time = @"2013-10-25";
//    model2.surplus = 500;
//    
//    GBGiftModel *model3 = [[GBGiftModel alloc] init];
//    model3.categoryType = 1;
//    model3.giftName = @"我叫MT Online";
//    model3.iconUrl = @"http://img.996.com/131231/982-131231104303641_320x190.jpg";
//    model3.comeFrom = @"论坛活动独家礼包";
//    model3.category = @"礼包内容";
//    model3.content = @"3级宝石包*2，百年玄铁，千年玄铁";
//    model3.time = @"2013-10-20";
//    model3.popularity = 34211;
//    
//    GBGiftModel *model4 = [[GBGiftModel alloc] init];
//    model4.categoryType = 1;
//    model4.giftName = @"我叫MT Online";
//    model4.iconUrl = @"http://img.996.com/140103/4893-1401031G22L61_180x135.jpg";
//    model4.comeFrom = @"论坛活动独家礼包";
//    model4.category = @"礼包内容";
//    model4.content = @"3级宝石包*2，百年玄铁，千年玄铁";
//    model4.time = @"2013-10-20";
//    model4.popularity = 34211;
//    
//    self.modeArray = [NSArray arrayWithObjects:model1, model2, model3, model4, nil];
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    [self setupLoadMoreFooterView]; //点击加载更多
    [self setupRefreshHeaderView]; //下载更多
}

//点击加载更多
- (void)setupLoadMoreFooterView
{
    self.loadMoreFooterViewForACL = [TableLoadMoreFooterView footerViewWithOwner:self.tableView delegate:self ownerInsetBottomDefaultHeight:KT_UI_TAB_BAR_HEIGHT];
    [self.loadMoreFooterViewForACL setEnable:YES];
}

//下拉更新
- (void)setupRefreshHeaderView
{
    self.refreshHeaderViewForACL = [TableRefreshHeaderView headerViewWithOwner:self.tableView delegate:self addNavigationBArHeight:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToViewController:(KTViewController *)viewController;
{
    if ([self.delegate respondsToSelector:@selector(pushToViewController:)]) {
        [self.delegate pushToViewController:viewController];
    }
}

- (void)didButtonAction:(UIButton *)button
{
    GBSearchModel *model = [self.modeArray objectAtIndex:button.tag];
    
    [[GBAccountManager sharedAccountManager] loginSuccess:^{
        
        switch (model.packageStatus) {
            case GetGiftStatusForEndForUnclaimed:{ //领取
                
                GBPopUpBox *box = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeProgress
                                                       withMessage:@"领取中，请稍后..."
                                                    withAutoHidden:NO];
                [box show];
                self.popUpBox = box;
                
                [self.requestForKT cancel];
                self.requestForKT = [[GBRequestForKT alloc] init];
                self.requestForKT.responseClass = [GBGetPackageNumberResponse class];
                
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
                [parameter writeInt_64:model.modelID];//领取的是哪个礼包
                //修正数据长度
                [parameter changeBufferSize:parameter.length];
                self.requestForKT.parameters = parameter;
                __weak typeof(self) weakSelf = self;
                
                [self.requestForKT setResponseBlock:^(GBRequest* request, GBResponse* response){
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
                                                    message:@"领取失败，请重试!"
                                                cancelTitle:@"确定"
                                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                     
                                                 }];
                        }
                    }
                    else{
                        GBGetPackageNumberResponse * responseResult = (GBGetPackageNumberResponse *)response;
                        if (responseResult.dataModelForPN) {
                            
                            GBPackageReceiveViewController * vc = [[GBPackageReceiveViewController alloc] initWithPackageID:model.modelID];
                            [weakSelf pushToViewController:vc]; 
                            [weakSelf changedPackageStatusWithIndex:[NSIndexPath indexPathForRow:button.tag inSection:0]
                                                          newStatus:responseResult.dataModelForPN.packageStatus
                                                     packageSurplus:responseResult.dataModelForPN.packageSurplus];
//                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                @autoreleasepool {
//                                    //NOTE 添加到推送里面和上传服务器里面，在程序退出，进入后台的时候提交 ,提交的是游戏ID
//                                    NSString * updateGameString = [[NSString alloc] initWithFormat:@"GetPackage + %d",23434234];
//                                    NSString * updateGameClassString = [[NSString alloc] initWithFormat:@"GameClass + %d",23434234];
//                                    [JPushManager uploadAliasAndTags:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:23434234],updateGameString,
//                                                                      [NSNumber numberWithInt:23434234],updateGameClassString, nil]];
//                                    //上传到服务器 及设置激光
//                                }
//                            });
                            
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
                [self.requestForKT sendAsynchronous];
                break;
            }
            case GetGiftStatusForOrder:{ //预约 HUANGBOADD
                GBPopUpBox *box = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeProgress
                                                       withMessage:@"预约中，请稍后..."
                                                    withAutoHidden:NO];
                [box show];
                self.popUpBox = box;
                
                [self.requestForKT cancel];
                self.requestForKT = [[GBRequestForKT alloc] init];
                self.requestForKT.responseClass = [GBGetPackageOrderResponse class];
                
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
                [parameter writeInt_64:model.modelID];//预约的是哪个礼包
                
                //修正数据长度
                [parameter changeBufferSize:parameter.length];
                self.requestForKT.parameters = parameter;
                __weak typeof(self) weakSelf = self;
                [self.requestForKT setResponseBlock:^(GBRequest* request, GBResponse* response){
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
                            
                            GBPackageReceiveViewController * vc = [[GBPackageReceiveViewController alloc] initWithPackageID:model.modelID];
                            [weakSelf pushToViewController:vc];
                            [weakSelf changedPackageStatusWithIndex:[NSIndexPath indexPathForRow:button.tag inSection:0]
                                                            newStatus:responseResult.dataModelForPN.package_status
                                                      packageSurplus:-1];
                            
//                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                @autoreleasepool {
//                                    //NOTE 添加到推送里面和上传服务器里面，在程序退出，进入后台的时候提交 ,提交的是游戏ID
//                                    NSString * updateGameString = [[NSString alloc] initWithFormat:@"GetPackage + %d",23434234];
//                                    NSString * updateGameClassString = [[NSString alloc] initWithFormat:@"GameClass + %d",23434234];
//                                    [JPushManager uploadAliasAndTags:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:23434234],updateGameString,
//                                                                      [NSNumber numberWithInt:23434234],updateGameClassString, nil]]; //上传到服务器 及设置激光
//                                }
//                            });
                            
                        }else{
                            //加载出错&&Data，弹出框提示
                            [PXAlertView showAlertWithTitle:@"失败"
                                                    message:@"预约失败，请重试!"
                                                cancelTitle:@"确定"
                                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                     
                                                 }];
                        }
                    }}];
                
                 [self.requestForKT sendAsynchronous];
                break;
            }
                
            default:
                break;
        }
    } failure:^{
        
    }];
}

- (void)reloadWithModelArray:(NSArray *)modelArray withPageCount:(NSInteger)pageCount
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:modelArray];
    self.modeArray = tempArray;
    [self.tableView reloadData];
    
    //self.pageNum < pageCount - 1判断是否是最后一页
    [self.loadMoreFooterViewForACL setEnable:self.pageNum < pageCount - 1];
}

- (void)dataRequestMothed
{
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
    [parameter writeInt_32:self.pageNum];
    [parameter writeInt_32:0];
    [parameter writeString:self.curSearchKey];
    //修正数据长度
    [parameter changeBufferSize:parameter.length];
    self.searchRequest.parameters = parameter;
    
    __weak typeof(self) vc = self;
    [self.searchRequest setResponseBlock:^(GBRequest* request, GBResponse* response){
        
        if (vc.isLoadMore) {
            vc.isLoadMore = NO;
            [vc.loadMoreFooterViewForACL didFinishedLoading:vc.tableView];
        }
        
        if (vc.isRefresh) {
            vc.isRefresh = NO;
            [vc.refreshHeaderViewForACL tableRefreshScrollViewDataSourceDidFinishedLoading:vc.tableView];
            [vc.loadMoreFooterViewForACL hiddedFooterView:NO];
        }
        
        if (response.isError) { //出错
            [PXAlertView showAlertWithTitle:@"提示"
                                    message:response.errorMessage
                                cancelTitle:nil
                                 otherTitle:@"确定"
                                 completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                     
                                 }];
            
        }else{
            GBGiftSearchResponse * responseResult = (GBGiftSearchResponse *)response;
            
            if (vc.pageNum == 0 && responseResult.modelMArray != nil) {
                [vc reloadWithModelArray:responseResult.modelMArray withPageCount:responseResult.pageCount];
            }
            else{
                [vc.modeArray addObjectsFromArray:responseResult.modelMArray];
                [vc.tableView reloadData];
                
                //self.pageNum < pageCount - 1判断是否是最后一页
                [vc.loadMoreFooterViewForACL setEnable:vc.pageNum < responseResult.pageCount - 1];
            }
        }
    }];
    [self.searchRequest sendAsynchronous];
}

- (void)changedPackageStatusWithIndex:(NSIndexPath *)indexPath newStatus:(int)status  packageSurplus:(int)surplusCount
{
    GBSearchModel * model = [self.modeArray objectAtIndex:indexPath.row];
    model.packageStatus = status; //先修改
    if (surplusCount >= 0) {
        model.remanCount = surplusCount;
    }
    KT_DLog(@"status:%d",model.remanCount);
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.modeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GiftCellIdentifier";
    GBGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GBGiftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GBSearchModel *model = [self.modeArray objectAtIndex:indexPath.row];
    [cell reloadWithModel:model row:indexPath.row target:self action:@selector(didButtonAction:)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBSearchModel *model = [self.modeArray objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectedTableViewCellWithResultModel:indexPath:)]) {
        [self.delegate didSelectedTableViewCellWithResultModel:model indexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
    
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
    self.pageNum += 1;
    
    [self dataRequestMothed];
}
#pragma mark - RefreshHeaderView Delegate
//下拉刷新
- (void)refreshActionTriggered:(TableRefreshHeaderView *)refreshView
{
    KT_DLOG_SELECTOR;
    self.isRefresh = YES;
    self.pageNum = 0;
    
    //下拉刷新时，关闭加载更多入口
    [self.loadMoreFooterViewForACL hiddedFooterView:YES];
    self.isLoadMore = NO;
    
    [self dataRequestMothed];
}

//#pragma mark -  changedPackageStatus
//- (void)changedPackageStatusWithIndex:(NSIndexPath *)indexPath newStatus:(int)status  packageSurplus:(int)surplusCount
//{
//    GBSearchModel * model = [self.modeArray objectAtIndex:indexPath.row];
//    model.packageStatus = status; //先修改
//    model.remanCount = surplusCount;
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                            withRowAnimation:UITableViewRowAnimationNone];
//    
//}

@end
