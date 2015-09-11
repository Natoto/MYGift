//
//  GBHomePageViewController.m
//  GameGifts
//
//  Created by Keven on 13-12-24.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GBHomePageViewController.h"
#import "GBActionSheet.h"
#import "GBHPFirstCell.h"
#import "GBHPSecondCell.h"
#import "GBHPThirdCell.h"

#import "GBActivityCenterListViewController.h"
#import "GBPackageReceiveViewController.h"
#import "GBGiftHairViewController.h"
#import "GBActivitiesDetailsViewController.h"

#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "GBGiftHairModel.h"
#import "GBActivityCenterListModel.h"
#import "GBPackageOrderModel.h"
#import "GBAccountManager.h"
#import "GBGetPackageNumberModel.h"
#import "GBPopUpBox.h"
#import "PXAlertView.h"
#import "GBLoadingView.h"
#import "BaiduMobStat.h"

@interface GBHomePageViewController ()
KT_PROPERTY_WEAK UITableView * tableViewHP;
KT_PROPERTY_STRONG NSMutableArray * activityArray;
KT_PROPERTY_STRONG NSMutableArray * packageArray ;

KT_PROPERTY_WEAK TableRefreshHeaderView  * refreshHeaderViewForHP;
KT_PROPERTY_WEAK GBPopUpBox * popUpBox;
KT_PROPERTY_WEAK GBLoadingView * loadingView;

KT_PROPERTY_STRONG GBDefaultReqeust * requestForHP;
KT_PROPERTY_STRONG GBDefaultReqeust * request;
KT_PROPERTY_ASSIGN BOOL  isRefresh;
KT_PROPERTY_ASSIGN BOOL  isRefreshForNoData;

@end

@implementation GBHomePageViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.isRefresh = NO;
        self.isRefreshForNoData = NO;
    }
    return self;
}

- (void)dealloc
{
    [_requestForHP cancel];
    [_request cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableViewHP];
    [self setupRefreshHeaderView]; //下载更多
    [self dataRequestMothed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange:) name:NOTIFICATION_GLOBAL_LOGINSTATUS_CHANGE object:nil];
}

- (void)viewDidAppearForKTView
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"首页"];
}

- (void)viewWillDisappearForKTView
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"首页"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCustomNavigationBarButton
{
    [self.customNavigationBar setNavBarTitle:@"996手游礼盒"];
}

- (void)setupTableViewHP
{
    CGFloat y = KT_UI_NAVIGATION_BAR_HEIGHT;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT;
    }
    UITableView * tableViewTmp = [[UITableView alloc] initWithFrame:CGRectMake(0,y, [Utils screenWidth], self.view.bounds.size.height - KT_UI_NAVIGATION_BAR_HEIGHT)];
    tableViewTmp.delegate = self;
    tableViewTmp.dataSource = self;
    tableViewTmp.backgroundColor = KT_UICOLOR_CLEAR;
    tableViewTmp.showsHorizontalScrollIndicator = NO;
    tableViewTmp.showsVerticalScrollIndicator = YES;
    tableViewTmp.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableViewTmp];
    tableViewTmp.hidden = YES;
    self.tableViewHP = tableViewTmp;
}

//下载更新
- (void)setupRefreshHeaderView
{
    self.refreshHeaderViewForHP = [TableRefreshHeaderView headerViewWithOwner:self.tableViewHP delegate:self addNavigationBArHeight:NO];
}

//登录状态改变重新刷新数据
- (void)loginStatusChange:(NSNotification *)notification
{
    [self dataRequestMothed];
}

/**
 *  数据请求,不需要登录权限
 */

- (void)dataRequestMothed
{
    [self.requestForHP cancel];
    self.requestForHP = [[GBRequestForKT alloc] init];
    self.requestForHP.responseClass = [GBHomePageResponse class];
    
    //空页面显示...
    if ([self.tableViewHP numberOfRowsInSection:0] <= 0 && !self.isRefreshForNoData) {
        GBLoadingView *loadingView = [[GBLoadingView alloc] init];
        [loadingView showInView:self.view offset:0];
        self.loadingView = loadingView;
        self.requestForHP.cacheResponseAvailable = YES;
    }
    
    self.isRefreshForNoData = NO;
    
    self.requestForHP.shouldSynCache = YES;
    self.requestForHP.command = [NSString stringWithFormat:@"%lx",(unsigned long)REQUEST_COMMAND_TYPE_GET_HOME];
    
    BaseParameter * parameter = [[BaseParameter alloc] init];
    [parameter writeInt_32:DEFAULT_WRITE_LENGHT]; //当前数据总长度(字节) 后面修正数据长度
    [parameter writeInt_32:REQUEST_COMMAND_TYPE_GET_HOME];//请求标识
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
    //修正数据长度
    [parameter changeBufferSize:parameter.length];
    self.requestForHP.parameters = parameter;
    
    __weak typeof(self) weakSelf = self;
    [self.requestForHP setCacheResponseBlock:^(GBRequest* request, GBResponse* response){
        //关闭等待筐
        [weakSelf.loadingView hidden];
        weakSelf.loadingView = nil;
        
        GBHomePageResponse * responseResult = (GBHomePageResponse *)response;
        weakSelf.activityArray = responseResult.activityArray;
        weakSelf.packageArray = responseResult.packageArray;
        //判断是否有数据
        [weakSelf.tableViewHP reloadData];
    }];
    
    [self.requestForHP setResponseBlock:^(GBRequest* request, GBResponse* response){
        //关闭等待筐/下拉刷新/加载更多/空页面菊花钻
        [weakSelf.loadingView hidden];
         weakSelf.loadingView = nil;
        [weakSelf hidNoDataView];
        
        if (weakSelf.isRefresh) {
            weakSelf.isRefresh = NO;
            [weakSelf.refreshHeaderViewForHP tableRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tableViewHP];
        }
        
        if (response.isError) {
            if (response.netError) {
                if (weakSelf.activityArray.count > 0 || weakSelf.packageArray.count > 0) { //有数据
                    
                    weakSelf.tableViewHP.hidden = NO;
                    //没有网络&&Data，弹出框提示
                    GBPopUpBox *boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeNoNetwork withAutoHidden:YES];
                    [boxTmp showInView:weakSelf.view.superview offset:0];
                    
                }else{
                    weakSelf.tableViewHP.hidden = YES;
                    //没有网络&&NoData
                    [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoNetwork
                                                superView:weakSelf.view];
                }
            }else{
                if (weakSelf.activityArray.count > 0 || weakSelf.packageArray.count > 0) {
                    weakSelf.tableViewHP.hidden = NO;
                    //加载出错&&Data，弹出框提示
                    GBPopUpBox *boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeLoadingError withAutoHidden:YES];
                    [boxTmp showInView:weakSelf.view.superview offset:0];
                }else{
                    weakSelf.tableViewHP.hidden = YES;
                    //加载错误&&NoData
                    [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForServierError
                                                superView:weakSelf.view];
                }
            }
        }else{
            GBHomePageResponse * responseResult = (GBHomePageResponse *)response;
            weakSelf.activityArray = responseResult.activityArray;
            weakSelf.packageArray = responseResult.packageArray;
            
            //判断是否有数据
            if (weakSelf.activityArray.count > 0 || weakSelf.packageArray.count > 0) {
                weakSelf.tableViewHP.hidden = NO;
                [weakSelf.tableViewHP reloadData];
            }else{
                //没有数据
                weakSelf.tableViewHP.hidden = YES;
                [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoData
                                            superView:weakSelf.view];
            }
        }
    }];
    [self.requestForHP sendAsynchronous];
}

- (void)refreshByNoDataShowViewWithInfoTag:(int)infoTag
{
    self.isRefreshForNoData = YES;
    [self dataRequestMothed];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString * title = nil;
    NSString * buttonTitle = nil;
    if (section == 0) {
        title = @"热门活动";
        buttonTitle = @"更多活动";
    }else{
        title = @"热门游戏礼包";
        buttonTitle = @"更多礼包";
    }
    UIView * cellViewTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 37)];
    cellViewTmp.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 150, 21)];
    titleLabel.textAlignment = KT_TextAlignmentLeft;
    titleLabel.textColor = KT_UIColorWithRGB(0x33, 0x33, 0x33);
    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
    titleLabel.font = GB_DEFAULT_FONT(17);
    titleLabel.text = title;
    [cellViewTmp addSubview:titleLabel];
    
    UIImage * buttonImg = KT_GET_LOCAL_PICTURE_SECOND(@"hp_mor_arrow@2x");
    UIButton * pressedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pressedButton.backgroundColor = KT_UICOLOR_CLEAR;
    pressedButton.frame = CGRectMake(220, 16, 100, 20);
    [pressedButton setImage:buttonImg forState:UIControlStateNormal];
    pressedButton.titleLabel.font = GB_DEFAULT_FONT(14);
    pressedButton.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 15);
    pressedButton.imageEdgeInsets = UIEdgeInsetsMake(2.5, 80, 2.5, 0);
    pressedButton.titleLabel.textAlignment = KT_TextAlignmentCenter;
    [pressedButton setTitle:buttonTitle forState:UIControlStateNormal];
    [pressedButton setTitleColor:KT_HEXCOLOR(0xF43446) forState:UIControlStateNormal];
    [pressedButton addTarget:self action:@selector(titleCellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    pressedButton.tag = section;
    [cellViewTmp addSubview:pressedButton];
    return cellViewTmp;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.activityArray.count / 2;
    }
    return self.packageArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 83.0f;
        }else{
            return 76.0f;
        }
    }else{
        if (indexPath.row == 0) {
            return 151.0f;
        }else if (indexPath.row == self.packageArray.count){
            return KT_UI_TAB_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT;
        }else{
            return 144.0f;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        
        NSString * cellIndentifier = @"tableView.cell.indentifier.for.hp.image";
        GBHPSecondCell * imageCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (imageCell == nil) {
            imageCell = [[GBHPSecondCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellIndentifier];
        }
        BOOL flag = NO;
        if (indexPath.row == 0) {
            flag = YES;
        }
        GBActivityCenterListModel * model = [self.activityArray objectAtIndex:(indexPath.row * 2)];
        GBActivityCenterListModel * secondModel = [self.activityArray objectAtIndex:(indexPath.row * 2)+ 1];

        [imageCell setupCellViewWithFirstURLString:model.iconURLString
                                         firstName:model.activityName
                                   secondURLString:secondModel.iconURLString
                                        secondName:secondModel.activityName
                                               row:indexPath.row
                                          isHeight:flag
                                            target:self
                                            action:@selector(imageCellButtonPressed:)];
        imageCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return imageCell;
       
    }else if(indexPath.row == self.packageArray.count){ //被遮住的一Cell
        NSString * cellIndentifier = @"clearCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIndentifier];
        }
        return cell;
    }else{
        
        NSString * cellIndentifier = @"tableView.cell.indentifier.for.hp.titleAndImage";
        GBHPThirdCell * titleAndImageCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (titleAndImageCell == nil) {
            titleAndImageCell = [[GBHPThirdCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:cellIndentifier];
        }
        GBGiftHairModel * model = [self.packageArray objectAtIndex:indexPath.row];
        [titleAndImageCell setupCellVieweWtihGameName:model.gameName
                                            URLString:model.iconURLString
                                          serviceName:model.packName
                                             giftName:model.subtitle
                                          releaseTime:model.publishTime
                                         packageCount:model.packcount
                                                  row:indexPath.row
                                              isFirst:indexPath.row == 0 ? YES :NO
                                           giftStatus:model.packStatus
                                               target:self
                                               action:@selector(titleAndImageCellButtonPressed:)];

        titleAndImageCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return titleAndImageCell;
   
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1 && !(indexPath.row == self.packageArray.count)) {
        GBGiftHairModel * model = [self.packageArray objectAtIndex:indexPath.row];
        GBPackageReceiveViewController * vc = [[GBPackageReceiveViewController alloc] initWithPackageID:model.packageID indexPath:indexPath];
        vc.delegate = self;
        [self.KTNavigationController pushKTViewController:vc animated:YES];
    }
}
//更多活动，更多礼包
- (void)titleCellButtonPressed:(UIButton *)bt
{
    if (bt.tag == 0) {
        //更多活动
        GBActivityCenterListViewController * vc = [[GBActivityCenterListViewController alloc] init];
        [self.KTNavigationController pushKTViewController:vc animated:YES];
        
    }else{
        GBGiftHairViewController * vc = [[GBGiftHairViewController alloc] init];
        [self.KTNavigationController pushKTViewController:vc animated:YES];
    
    }
}

//4张热点内容  row * 100 + 1/2
- (void)imageCellButtonPressed:(UIButton *)bt
{
    //
    int row = (int)(bt.tag / 100);
    int index = (int)(bt.tag - row *100);
    GBActivityCenterListModel * model = [self.activityArray objectAtIndex:row * 2 + index - 1];
    GBActivitiesDetailsViewController * vc = [[GBActivitiesDetailsViewController alloc] initWithActivityID:model.activityID];
    [self.KTNavigationController pushKTViewController:vc animated:YES];
}

//领取
- (void)titleAndImageCellButtonPressed:(UIButton *)bt
{
    //NOTE  点击领取操作
    //先判断是否登录，已经登录则直接领取，没有登录弹出登录页面
     GBGiftHairModel * model = [self.packageArray objectAtIndex:bt.tag];
    
    switch (model.packStatus) {
        case GetGiftStatusForEndForUnclaimed:
        {
            [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_GIFTGET_BUTTON eventLabel:model.gameName];
           break;
        }
        case GetGiftStatusForOrder:
        {
            [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_GIFTRESERVE_BUTTON eventLabel:model.gameName];
            break;
        }
            
            
        default:
            break;
    }
    
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
                    
//                    if (response.netError) {//YES 网络原因, NO 服务器原因
//                        //没有网络&&Data，弹出框提示
//                        PopUpBox * boxTmp = [[PopUpBox alloc] initWithPopUpBoxType:PopUpBoxTypeForNoNetwork];
//                        [boxTmp showWithView:weakSelf.view popUpBoxType:PopUpBoxTypeForNoNetwork];
//                    }else{ // NO 服务器原因
//                        //加载出错&&Data，弹出框提示
//                        PopUpBox * boxTmp = [[PopUpBox alloc] initWithPopUpBoxType:PopUpBoxTypeForError];
//                        [boxTmp showWithView:weakSelf.view popUpBoxType:PopUpBoxTypeForError];
//                    }
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
                        vc.delegate = weakSelf;
                        [weakSelf.KTNavigationController pushKTViewController:vc animated:YES];
                        KT_DLog(@"packageStatus:%d",responseResult.dataModelForPN.packageStatus);
                        [weakSelf changedPackageStatusWithIndex:[NSIndexPath indexPathForRow:bt.tag inSection:1]
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
                        
                        [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_GIFTGET_SUCCESS eventLabel:model.gameName];
 
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
    }else if (model.packStatus == GetGiftStatusForOrder){ //可以预约
        //NOTE  判断是否登录， 预约 ，加入 JPush
        
        
        [[GBAccountManager sharedAccountManager] loginSuccess:^{
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
                                                message:@"预约失败，请重试!"
                                            cancelTitle:@"确定"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                 
                                             }];
                    }
                }else{
                    GBGetPackageOrderResponse * responseResult = (GBGetPackageOrderResponse *)response;
                    if (responseResult.dataModelForPN) {
                        
                        GBPackageReceiveViewController * vc = [[GBPackageReceiveViewController alloc] initWithPackageID:model.packageID];
                        vc.delegate = weakSelf;
                        [weakSelf.KTNavigationController pushKTViewController:vc animated:YES];
                        KT_DLog(@"packageStatus:%d",responseResult.dataModelForPN.package_status);
                        
                        [weakSelf changedPackageStatusWithIndex:[NSIndexPath indexPathForRow:bt.tag inSection:1] newStatus:responseResult.dataModelForPN.package_status packageSurplus:-1];
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                            @autoreleasepool {
//                                //NOTE 添加到推送里面和上传服务器里面，在程序退出，进入后台的时候提交 ,提交的是游戏ID
//                                NSString * orderPackageString = [[NSString alloc] initWithFormat:@"OrderPackageID + %lld",model.packageID];
//                                KT_DLog(@"orderPackageString:%@",orderPackageString);
//                                [JPushManager uploadAliasAndTags:[NSDictionary dictionaryWithObject:[NSNumber numberWithLongLong:model.packageID] forKey:orderPackageString]]; //上传到服务器 及设置激光
//                            }
//                        });
                        [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_GIFTRESERVE_SUCCESS eventLabel:model.gameName];
                        
                    }else{
                        //预约失败，从新预约
                        [PXAlertView showAlertWithTitle:@"失败"
                                                message:@"预约失败，请重试!"
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
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Header
    [self.refreshHeaderViewForHP tableRefreshScrollViewDidScroll:scrollView];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshHeaderViewForHP tableRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - RefreshHeaderView Delegate
//下拉刷新
- (void)refreshActionTriggered:(TableRefreshHeaderView *)refreshView
{
    self.isRefresh = YES;
    [self dataRequestMothed];
}

#pragma mark -  changedPackageStatus
- (void)changedPackageStatusWithIndex:(NSIndexPath *)indexPath newStatus:(int)status  packageSurplus:(int)surplusCount
{
    GBGiftHairModel * model = [self.packageArray objectAtIndex:indexPath.row];
    model.packStatus = status;
    if (surplusCount >= 0) {
        model.packcount = surplusCount;
    }
    KT_DLog(@"status:%d",status);
    [self.tableViewHP reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationNone];
}


@end

