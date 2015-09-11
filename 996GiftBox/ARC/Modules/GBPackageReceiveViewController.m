//
//  GBPackageReceiveViewController.m
//  GameGifts
//
//  Created by Keven on 14-1-3.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBPackageReceiveViewController.h"
#import "GBPRFirstCell.h"
#import "GBPRSecondCell.h"
#import "GBPRThirdCell.h"
#import "GBPRFourthCell.h"
#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "GBPackageReceiveModel.h"
#import "GBGetPackageNumberModel.h"
#import "GBAccountManager.h"
#import "GBSearchHomeViewController.h"
#import "GBPopUpBox.h"
#import "GBPackageOrderModel.h"
#import "GBLoadingView.h"
#import "BaiduMobStat.h"

@interface GBPackageReceiveViewController ()
KT_PROPERTY_WEAK UITableView * tableViewPR;
KT_PROPERTY_ASSIGN int64_t packageID;
KT_PROPERTY_STRONG GBPackageReceiveModel * dataModel;
KT_PROPERTY_STRONG GBRequestForKT * requestForPR;
KT_PROPERTY_STRONG GBDefaultReqeust * request;
KT_PROPERTY_STRONG GBDefaultReqeust * requestForReserve;
KT_PROPERTY_ASSIGN BOOL hasData;
KT_PROPERTY_ASSIGN BOOL  isRefreshForNoData;
KT_PROPERTY_STRONG NSIndexPath *indexPath;
KT_PROPERTY_STRONG GBSearchHomeViewController *searchViewController;
KT_PROPERTY_WEAK GBPopUpBox * popUpBox;
KT_PROPERTY_WEAK GBLoadingView * loadingView;
@end

@implementation GBPackageReceiveViewController
/**
*  初始化 礼包详情
*
*  @param packageID 礼包ID
*
*  @return GBPackageReceiveViewController实例
*/

- (id)initWithPackageID:(int64_t)packageID
{
    self = [super init];
    if (self) {
        self.packageID = packageID;
        self.hasData = NO;
        self.isRefreshForNoData = NO;
    }
    return self;
}
- (id)initWithPackageID:(int64_t)packageID indexPath:(NSIndexPath *)indexPath
{
    self = [super init];
    if (self) {
        self.packageID = packageID;
        self.hasData = NO;
        self.isRefreshForNoData = NO;
        self.indexPath = indexPath;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupTableViewPR];
    [self setupTableHeaderViewForTableViewPR];
    [self dataRequestMothed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [_requestForPR cancel];
    [_requestForReserve cancel];
    [_request cancel];
}

- (void)viewDidAppearForKTView
{
    NSString* cName = [NSString stringWithFormat:@"%@",self.customNavigationBar.navBarTitleLabel.text,nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

- (void)viewWillDisappearForKTView
{
    NSString* cName = [NSString stringWithFormat:@"%@",self.customNavigationBar.navBarTitleLabel.text,nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)dataRequestMothed
{
    if (!self.isRefreshForNoData) {
        GBLoadingView *loadingView = [[GBLoadingView alloc] init];
        [loadingView showInView:self.view offset:0];
        [self.view bringSubviewToFront:self.customTabBar];
        self.loadingView = loadingView;
    }
    
    self.isRefreshForNoData = NO;
    
    [self.request cancel];
    self.request = [[GBDefaultReqeust alloc] init];
    self.request.responseClass = [GBPackageReceiveResponse class];
    BaseParameter * parameter = [[BaseParameter alloc] init];
    [parameter writeInt_32:DEFAULT_WRITE_LENGHT];//当前数据总长度(字节) 后面修正数据长度
    [parameter writeInt_32:REQUEST_COMMAND_TYPE_GET_PACKAGE_INFORMATION];//请求标识
    [parameter writeInt_16:DEFAULT_CLIENT_VERSION];//客户端的跟接口对接的版本号
    [parameter writeInt_32:DEFAULT_CLIENT_FLAGS];//备用参数，用来兼容不同的客户端 接口的兼容，先暂时可以为0
    [parameter writeString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"]];//UUID
    [parameter writeString:[Utils getDevicesInfo]]; //设备信息 比如"iphone 7.1"
    NSArray * iosVersion = [Utils getPareIOSVersion]; //IOS版本
    [parameter writeInt_8:[[iosVersion objectAtIndex:2] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:1] integerValue]];
    [parameter writeInt_8:[[iosVersion objectAtIndex:0] integerValue]];
    if (![Utils isNilOrEmpty:[[TRUser sharedInstance] tokenKey]] ) { //没有登录
        [parameter writeInt_64:[[TRUser sharedInstance] userId]];
    }else{
        [parameter writeInt_64:0];
    }
    
    [parameter writeInt_64:self.packageID];
    //修正数据长度
    [parameter changeBufferSize:parameter.length];
    self.request.parameters = parameter;
    
    __weak typeof(self) weakSelf = self;
    [self.request setResponseBlock:^(GBRequest* request, GBResponse* response){
        //关闭等待筐/下拉刷新/加载更多/空页面菊花钻
        [weakSelf.loadingView hidden];
        weakSelf.loadingView = nil;
        
        [weakSelf hidNoDataView];
        
        if (response.isError) {
            if (response.netError) {
                if (weakSelf.dataModel != nil) { //有数据
                    
                    //没有网络&&Data，弹出框提示
                    GBPopUpBox *boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeNoNetwork withAutoHidden:YES];
                    [boxTmp showInView:weakSelf.view.superview offset:0];
                    
                }else{
                    //没有网络&&NoData
                    [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoNetwork
                                                superView:weakSelf.view];
                }
            }else{
                if (weakSelf.dataModel != nil) {
                    
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
            GBPackageReceiveResponse * responseResult = (GBPackageReceiveResponse *)response;
            weakSelf.dataModel = responseResult.dataModelForPR;
            if (![Utils isNilOrEmpty:weakSelf.dataModel]) {
                weakSelf.hasData = YES;
                [weakSelf.tableViewPR reloadData];
            }else{
                weakSelf.hasData = NO;
                //没有数据
                [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoData
                                            superView:weakSelf.view];
            }
        }
    }];
    [self.request sendAsynchronous];
}

- (void)refreshByNoDataShowViewWithInfoTag:(int)infoTag
{
    self.isRefreshForNoData = YES;
    [self dataRequestMothed];
}

- (void)setupCustomNavigationBarButton
{
    [self.customNavigationBar setNavBarTitle:@"礼包领取"];
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
    KT_DLOG_SELECTOR;
    if (self.searchViewController == nil) {
        self.searchViewController = [[GBSearchHomeViewController alloc] initWithType:KT_KInitTypeTMP];
    }
    
    __block GBPackageReceiveViewController *vc = self;
    self.searchViewController.didClosedHandler = ^{
        vc.searchViewController = nil;
    };
    
    [self.searchViewController open];
}
- (void)setupTableHeaderViewForTableViewPR
{
    CGFloat height = KT_UI_NAVIGATION_BAR_HEIGHT;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        height = KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT;
    }
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], height)];
    self.tableViewPR.tableHeaderView = tableHeaderView;
}

- (void)setupTableViewPR
{
    UITableView * tableViewTmp = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableViewTmp.delegate = self;
    tableViewTmp.dataSource = self;
    tableViewTmp.backgroundColor = KT_UICOLOR_CLEAR;
    tableViewTmp.showsHorizontalScrollIndicator = NO;
    tableViewTmp.showsVerticalScrollIndicator = YES;
    tableViewTmp.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableViewTmp];
    self.tableViewPR = tableViewTmp;
}
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hasData) {
        return 7;
    }else{
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 125.0f;
    }else if (indexPath.row == 2){
        return 34 + [self getContentHeightWithContentString:_dataModel.content fontSize:12 sizeWidth:300] + 10;
    }else{
         return 36.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_dataModel.packageStatus != GetGiftStatusForAlreadyReceive) {
            NSString * cellIndentifier = @"tableView.cell.for.PR.package.info.get.gift";
            GBPRFirstCell * infoCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (infoCell == nil) {
                infoCell = [[GBPRFirstCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:cellIndentifier];
            }
         
            KT_DLog(@"url:%@==%@==%@==%@",_dataModel.iconURLString,_dataModel.gameName,_dataModel.packageName,_dataModel.subtitle);
            //领取Cell
            [infoCell setupCellViewWithURLString:_dataModel.iconURLString
                                        gameName:_dataModel.gameName
                                     serviceName:_dataModel.packageName
                                        giftName:_dataModel.subtitle
                                    surplusCount:_dataModel.packageSurplusCount
                                        allCount:_dataModel.packageCount
                                          status:_dataModel.packageStatus
                                          target:self
                                          action:@selector(getGiftButtonPressed:)];

            
            
            infoCell.selectionStyle =  UITableViewCellSelectionStyleNone;
            
            return infoCell;
        }else{
             //复制
            NSString * cellIndentifier = @"tableView.cell.for.PR.package.info.copy.giftCode";
            GBPRFourthCell * infoCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (infoCell == nil) {
                infoCell = [[GBPRFourthCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:cellIndentifier];
            }
            //领取Cell
            [infoCell setupCellViewWithURLString:_dataModel.iconURLString
                                        gameName:_dataModel.gameName
                                     serviceName:_dataModel.packageName
                                  giftCodeString:_dataModel.number
                                          status:_dataModel.packageStatus];

            
            
            infoCell.selectionStyle =  UITableViewCellSelectionStyleNone;
            
            return infoCell;
        }
        
       
    }else if (indexPath.row == 2){
    
        NSString * cellIndentifier = @"tableView.cell.for.PR.package.content";
        GBPRThirdCell * contentCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (contentCell == nil) {
            contentCell = [[GBPRThirdCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellIndentifier];
        }
        
        [contentCell setupCellViewWithContentString:_dataModel.content
                                      contentHeight:[self getContentHeightWithContentString:_dataModel.content
                                                                                   fontSize:12
                                                                                  sizeWidth:300]];
        
        contentCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return contentCell;
    }else{
        NSString * cellIndentifier = @"tableView.cell.for.PR.package.title";
        GBPRSecondCell * titleCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (titleCell == nil) {
            titleCell = [[GBPRSecondCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellIndentifier];
        }
        NSString * title = nil;
        int type = 0;
        switch (indexPath.row) {
            case 1:{
                title = @"礼包详情";
                type = 0;
                break;
            }
            case 3:{
                title = @"兑换方式";
                type = 0;
                break;
            }
            case 4:{
                title = _dataModel.exchange;
                type = 1;
                break;
            }
            case 5:{
                title = @"兑换时间";
                type = 0;
                break;
            }
            case 6:{
                title = [NSString stringWithFormat:@"%@ - %@",[Utils getSecondTypeTimeWithTimeInterval:_dataModel.publishTime],[Utils getSecondTypeTimeWithTimeInterval:_dataModel.outTime]];
                type = 2;
                break;
            }
            default:
                break;
        }
        
        [titleCell setupCellViewWithTitleString:title type:type];
        titleCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return titleCell;
    }
}

//NOTE 领取相同的会出现错误码
- (void)getGiftButtonPressed:(UIButton *)bt
{
        bt.userInteractionEnabled = NO; //防止多次点击
        KT_DLOG_SELECTOR;
        [[GBAccountManager sharedAccountManager] loginSuccess:^{
            switch (self.dataModel.packageStatus) { //等待领取
                case GetGiftStatusForEndForUnclaimed:{
                    GBPopUpBox *box = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeProgress
                                                           withMessage:@"领取中，请稍后..."
                                                        withAutoHidden:NO];
                    [box show];
                    self.popUpBox = box;
                    [self.requestForPR cancel];
                    self.requestForPR = [[GBRequestForKT alloc] init];
                    self.requestForPR.responseClass = [GBGetPackageNumberResponse class];
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
                    [parameter writeInt_64:self.packageID];//领取的是哪个礼包
                    //修正数据长度
                    [parameter changeBufferSize:parameter.length];
                    self.requestForPR.parameters = parameter;
                    __weak typeof(self) weakSelf = self;
                    [self.requestForPR setResponseBlock:^(GBRequest* request, GBResponse* response){
                        [weakSelf.popUpBox hiddenWithAnimated:YES];
                        if (response.isError) { //出错
                            
                            if (response.netError) {//YES 网络原因, NO 服务器原因
                                //没有网络&&Data，弹出框提示
                                GBPopUpBox * boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeNoNetwork withAutoHidden:YES];
                                [boxTmp showInView:weakSelf.view offset:0];
                            }else{ // NO 服务器原因
                                //加载出错&&Data，弹出框提示
                                GBPopUpBox * boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeDefault withMessage:@"领取失败!" withAutoHidden:YES];
                                [boxTmp showInView:weakSelf.view offset:0];
                            }
                        }else{
                            GBGetPackageNumberResponse * responseResult = (GBGetPackageNumberResponse *)response;
                            if (responseResult.dataModelForPN) {
                                //先修改本来的页面
                                weakSelf.dataModel.packageStatus = responseResult.dataModelForPN.packageStatus;
                                weakSelf.dataModel.number = responseResult.dataModelForPN.packageNumber;
                                [weakSelf.tableViewPR reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
                                                            withRowAnimation:UITableViewRowAnimationNone];
                                //修改上级页面的状态
                                if ([weakSelf.delegate respondsToSelector:@selector(changedPackageStatusWithIndex:newStatus: packageSurplus:)] && weakSelf.indexPath) {
                                    [weakSelf.delegate changedPackageStatusWithIndex:weakSelf.indexPath
                                                                           newStatus:responseResult.dataModelForPN.packageStatus
                                                                      packageSurplus:responseResult.dataModelForPN.packageSurplus];
                                }
                                //NOTE 添加到推送里面和上传服务器里面，在程序退出，进入后台的时候提交
                                
                            }else{
                                //加载出错&&Data，弹出框提示
                                GBPopUpBox * boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeDefault withMessage:@"领取失败!" withAutoHidden:YES];
                                [boxTmp showInView:weakSelf.view offset:0];
                            }
                            
                        }
                    }];
                    [self.requestForPR sendAsynchronous];
                    break;
                }
                case GetGiftStatusForOrder:{ //等待预约
                    GBPopUpBox *box = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeProgress
                                                           withMessage:@"预约中，请稍后..."
                                                        withAutoHidden:NO];
                    [box show];
                    self.popUpBox = box;
                    [self.requestForReserve cancel];
                    self.requestForReserve = [[GBDefaultReqeust alloc] init];
                    self.requestForReserve.responseClass = [GBGetPackageOrderResponse class];
                    
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
                    [parameter writeInt_64:self.packageID];//领取的是哪个礼包
                    //修正数据长度
                    [parameter changeBufferSize:parameter.length];
                    self.requestForReserve.parameters = parameter;
                    
                    __weak typeof(self) weakSelf = self;
                    [self.requestForReserve setResponseBlock:^(GBRequest* request, GBResponse* response){
                        [weakSelf.popUpBox hiddenWithAnimated:YES];
                        if (response.isError) { //出错
                            if (response.netError) {//YES 网络原因, NO 服务器原因
                                //没有网络&&Data，弹出框提示
                                GBPopUpBox *popbox = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeNoNetwork withAutoHidden:YES];
                                [popbox showInView:weakSelf.view offset:0];
                            }else{ // NO 服务器原因
                                //加载出错&&Data，弹出框提示
                                GBPopUpBox *popbox = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeNoNetwork withMessage:@"预约失败！" withAutoHidden:YES];
                                [popbox showInView:weakSelf.view offset:0];
                            }
                        }
                        else{
                            GBGetPackageOrderResponse *responseResult = (GBGetPackageOrderResponse *)response;
                            if (responseResult.dataModelForPN) {
                                //先修改本来的页面
                                weakSelf.dataModel.packageStatus = responseResult.dataModelForPN.package_status;
                                [weakSelf.tableViewPR reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
                                                            withRowAnimation:UITableViewRowAnimationNone];
                                //修改上级页面的状态
                                if ([weakSelf.delegate respondsToSelector:@selector(changedPackageStatusWithIndex:newStatus: packageSurplus:)] && weakSelf.indexPath) {
                                    [weakSelf.delegate changedPackageStatusWithIndex:weakSelf.indexPath
                                                                           newStatus:responseResult.dataModelForPN.package_status
                                                                      packageSurplus:-1];
                                }
                                //NOTE 添加到推送里面和上传服务器里面，在程序退出，进入后台的时候提交
                                
                            }else{
                                //加载出错&&Data，弹出框提示
                                GBPopUpBox *popbox = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeNoNetwork withMessage:@"预约失败！" withAutoHidden:YES];
                                [popbox showInView:weakSelf.view offset:0];
                            }

                        }
                    }];
                    [self.requestForReserve sendAsynchronous];
                    break;
                }
                    
                    
                default:
                    break;
            }
            
        } failure:^{
            KT_DLOG_SELECTOR;
        }];
}

- (CGFloat)getContentHeightWithContentString:(NSString *)content  fontSize:(CGFloat)fsize sizeWidth:(CGFloat)width
{
    if ([Utils isNilOrEmpty:content]) {
        return 0.0f;
    }
   CGSize contentSize =  KT_TEXTSIZE(content, GB_DEFAULT_FONT(fsize), CGSizeMake(width, 100000), NSLineBreakByWordWrapping);
    return contentSize.height;
}
@end
