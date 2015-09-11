//
//  GBGiftDetailsViewController.m
//  996GameBox
//
//  Created by Keven on 13-12-9.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "GBActivitiesDetailsViewController.h"
#import "ClickLabel.h"
#import "UIImageView+WebCache.h"
#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "GBActivitiesDetailsModel.h"
#import "GBLoadingView.h"
#import "GBPopUpBox.h"
#import "GBSearchHomeViewController.h"
#import "BaiduMobStat.h"

@interface GBActivitiesDetailsViewController ()
KT_PROPERTY_WEAK UIScrollView * scrollViewGD;
KT_PROPERTY_ASSIGN NSUInteger scrollViewHeight;
KT_PROPERTY_ASSIGN int32_t activityID;
KT_PROPERTY_STRONG GBActivitiesDetailsModel * dataModel;
KT_PROPERTY_STRONG GBRequestForKT * requestForAD;
KT_PROPERTY_ASSIGN BOOL  isRefreshForNoData;
KT_PROPERTY_STRONG GBSearchHomeViewController *searchViewController;

//下面是控件的指针
KT_PROPERTY_WEAK UILabel * gameLabel;
KT_PROPERTY_WEAK UILabel * timeLabel;
KT_PROPERTY_WEAK UILabel * timeValueLabel;
KT_PROPERTY_WEAK UILabel * rewardLabel;
KT_PROPERTY_WEAK UILabel * rewardValueLabel;
KT_PROPERTY_WEAK UILabel * contentLabel;
KT_PROPERTY_WEAK UILabel * contentValueLabel;
KT_PROPERTY_WEAK UILabel * addressLabel;
KT_PROPERTY_WEAK ClickLabel * clickedButton;
KT_PROPERTY_WEAK UIImageView * URLImageView;
KT_PROPERTY_WEAK GBLoadingView * loadingView;
@end

@implementation GBActivitiesDetailsViewController
/**
 *  初始化活动详情内页
 *
 *  @param activityID 活动ID号
 *
 *  @return GBActivitiesDetailsViewController 实例
 */
- (id)initWithActivityID:(int32_t)activityID
{
    self = [super init];
    if (self) {
        self.activityID = activityID;
        self.scrollViewHeight = 0;
        self.isRefreshForNoData = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupscrollViewGD];
    [self dataRequestMothed];
    
}

- (void)viewDidAppearForKTView
{
    NSString* cName = [NSString stringWithFormat:@"活动详情"];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
}

- (void)viewWillDisappearForKTView
{
    NSString* cName = [NSString stringWithFormat:@"活动详情"];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  断开网络连接
 */
- (void) dealloc
{
    [_requestForAD cancel];
}
/**
 *  网络请求，不需要登录权限，没有检查ToKenKey，不需要登录权限
 */
- (void)dataRequestMothed
{
    if (!self.isRefreshForNoData) {
        GBLoadingView *loadingView = [[GBLoadingView alloc] init];
        [loadingView showInView:self.view offset:0];
        [self.view bringSubviewToFront:self.customTabBar];
        self.loadingView = loadingView;
    }
    
    self.isRefreshForNoData = NO;
    
    [self.requestForAD cancel];
    self.requestForAD = [[GBRequestForKT alloc] init];
    self.requestForAD.responseClass = [GBActivitiesDetailsResponse class];
    
    BaseParameter * parameter = [[BaseParameter alloc] init];
    [parameter writeInt_32:DEFAULT_WRITE_LENGHT];//当前数据总长度(字节) 后面修正数据长度
    [parameter writeInt_32:REQUEST_COMMAND_TYPE_GET_ACTIVITY_INFORMATION];//请求标识
    [parameter writeInt_16:DEFAULT_CLIENT_VERSION];//客户端的跟接口对接的版本号
    [parameter writeInt_32:DEFAULT_CLIENT_FLAGS]; //备用参数，用来兼容不同的客户端 接口的兼容，先暂时可以为0
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
    [parameter writeInt_32:self.activityID];
    //修正数据长度
    [parameter changeBufferSize:parameter.length];
    self.requestForAD.parameters = parameter;
    
    __weak typeof(self) weakSelf = self;
    [self.requestForAD setResponseBlock:^(GBRequest* request, GBResponse* response){
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
            GBActivitiesDetailsResponse * responseResult = (GBActivitiesDetailsResponse *)response;
            weakSelf.dataModel = responseResult.dataModelForAD;
            if (![Utils isNilOrEmpty:weakSelf.dataModel]) {
                //刷新
                [weakSelf showDataView];
            }else{
                //没有数据
                [weakSelf setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoData
                                            superView:weakSelf.view];
            }
        }
    }];
    [self.requestForAD sendAsynchronous];
}

- (void)refreshByNoDataShowViewWithInfoTag:(int)infoTag
{
    self.isRefreshForNoData = YES;
    [self dataRequestMothed];
}
//显示内容
- (void)showDataView
{
     [self.customNavigationBar setNavBarTitle:[NSString stringWithFormat:@"%@-活动信息",self.dataModel.gameName]];
    //设置第一Cell 包含 活动时间 和活动奖励 活动内容
    [self setupFirstCellViewWithActivityName:self.dataModel.activityName
                                   startTime:self.dataModel.startTime
                                     endTime:self.dataModel.endTime
                                      reward:self.dataModel.reward
                                     content:self.dataModel.content];
    
    
    //设置第二cell 包含 活动地址，视图
    
    [self setupSeconCellViewWithAddress:@"点击进入"
                              URLString:self.dataModel.iconURLString];
}
- (void)setupCustomNavigationBarButton
{
    [self.customNavigationBar setNavBarTitle:@"活动信息"];
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
    KT_DLOG_SELECTOR;
    if (self.searchViewController == nil) {
        self.searchViewController = [[GBSearchHomeViewController alloc] initWithType:KT_KInitTypeTMP];
    }
    
    __block typeof(self) vc = self;
    self.searchViewController.didClosedHandler = ^{
        vc.searchViewController = nil;
    };
    
    [self.searchViewController open];
}
//添加列表
- (void) setupscrollViewGD
{
    KT_DLOG_SELECTOR;
    UIScrollView * scrollViewTmp = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollViewTmp.showsHorizontalScrollIndicator = NO;
    scrollViewTmp.showsVerticalScrollIndicator = NO;
    scrollViewTmp.bounces = YES;
    scrollViewTmp.delegate = self;
    scrollViewTmp.pagingEnabled = NO;
    scrollViewTmp.backgroundColor = KT_UIColorWithRGB(0xfc, 0xfc, 0xfc);
    scrollViewTmp.contentSize = self.view.bounds.size;
    scrollViewTmp.contentOffset = CGPointMake(0, 0); //先把显示的区域往左移动viewSize。width
    scrollViewTmp.scrollEnabled = YES;
    [self addSubview:scrollViewTmp];
    self.scrollViewGD = scrollViewTmp;
}

//设置第一Cell 包含 活动时间 和活动奖励 活动内容
- (void)setupFirstCellViewWithActivityName:(NSString *)name
                                 startTime:(double)startTime
                                   endTime:(double)endTime
                                    reward:(NSString *)rewardString
                                   content:(NSString *)contentString
{
    CGFloat y = KT_UI_NAVIGATION_BAR_HEIGHT;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT;
    }
    if (self.gameLabel) {
        self.gameLabel.text = name;
    }else{
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y + 6, 300, 21)];
        nameLabel.backgroundColor = KT_UICOLOR_CLEAR;
        nameLabel.textColor = KT_UIColorWithRGB(0x33, 0x33, 0x33);
        nameLabel.font = GB_DEFAULT_FONT(16);
        nameLabel.textAlignment = KT_TextAlignmentLeft;
        [self.scrollViewGD addSubview:nameLabel];
        nameLabel.text = name;
        self.gameLabel = nameLabel;
    }
    
    
    if (self.timeLabel) {
        self.timeLabel.text = @"活动时间:";
    }else{
        UILabel * timeLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(10, y + 49, 60, 15)];
        timeLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        timeLabelTmp.textColor = KT_UIColorWithRGB(0x33, 0x33, 0x33);
        timeLabelTmp.font = GB_DEFAULT_FONT(13);
        timeLabelTmp.textAlignment = KT_TextAlignmentLeft;
        [self.scrollViewGD addSubview:timeLabelTmp];
        timeLabelTmp.text =  @"活动时间:";
        self.timeLabel = timeLabelTmp;
    }
    
    //对时间进行处理 51- 18 = 33
    NSString * startTimeString = [Utils getThirdTimeWithTimeInterval:startTime];
    NSString * endTimeString = [Utils getThirdTimeWithTimeInterval:endTime];
    if (self.timeValueLabel) {
        self.timeValueLabel.text = [NSString stringWithFormat:@"%@-%@",startTimeString,endTimeString];
    }else{
        UILabel * timeValueLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(80, y + 49, 230, 15)];
        timeValueLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        timeValueLabelTmp.textColor = KT_UIColorWithRGB(0x99, 0x99, 0x99);
        timeValueLabelTmp.font = GB_DEFAULT_FONT(13);
        timeValueLabelTmp.textAlignment = KT_TextAlignmentLeft;
        [self.scrollViewGD addSubview:timeValueLabelTmp];
        timeValueLabelTmp.text = [NSString stringWithFormat:@"%@-%@",startTimeString,endTimeString];
        self.timeValueLabel = timeValueLabelTmp;
    }
   
    
    
    
    //133 - 64 = 69
    if (self.rewardLabel) {
        self.rewardLabel.text = @"活动奖励:";
    }else{
        UILabel * rewardLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(10,y + 69, 60, 15)];
        rewardLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        rewardLabelTmp.textColor = KT_UIColorWithRGB(0x33, 0x33, 0x33);
        rewardLabelTmp.font = GB_DEFAULT_FONT(13);
        rewardLabelTmp.textAlignment = KT_TextAlignmentLeft;
        [self.scrollViewGD addSubview:rewardLabelTmp];
        rewardLabelTmp.text =  @"活动奖励:";
        self.rewardLabel = rewardLabelTmp;
    }
    
    if (self.rewardValueLabel) {
        self.rewardValueLabel.text = rewardString;
    }else{
        UILabel * rewardValueLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(80,y + 69, 230, 15)];
        rewardValueLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        rewardValueLabelTmp.textColor = KT_UIColorWithRGB(0x99, 0x99, 0x99);
        rewardValueLabelTmp.font = GB_DEFAULT_FONT(13);
        rewardValueLabelTmp.textAlignment = KT_TextAlignmentLeft;
        [self.scrollViewGD addSubview:rewardValueLabelTmp];
        rewardValueLabelTmp.text = rewardString;
        self.rewardValueLabel = rewardValueLabelTmp;
    }
    
    
     //156-64=92
    
    if (self.contentLabel) {
        self.contentLabel.text = @"活动内容:";
    }else{
        UILabel * contentLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(10,y + 92, 60, 15)];
        contentLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        contentLabelTmp.textColor = KT_UIColorWithRGB(0x33, 0x33, 0x33);
        contentLabelTmp.font = GB_DEFAULT_FONT(13);
        contentLabelTmp.textAlignment = KT_TextAlignmentLeft;
        [self.scrollViewGD addSubview:contentLabelTmp];
        contentLabelTmp.text =  @"活动内容:";
        self.contentLabel = contentLabelTmp;
    }
   
    
    
    CGSize contentSize = [contentString sizeWithFont:GB_DEFAULT_FONT(13)
                                   constrainedToSize:CGSizeMake(230, MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping];
    
    if (self.contentValueLabel) {
        self.contentValueLabel.frame = CGRectMake(80, y + 92, 230, contentSize.height);
        self.contentValueLabel.text = contentString;
    }else{
        UILabel * contentValueLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(80, y + 92, 230, contentSize.height)];
        contentValueLabelTmp.numberOfLines = 0;
        contentValueLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        contentValueLabelTmp.textColor = KT_UIColorWithRGB(0x99, 0x99, 0x99);;
        contentValueLabelTmp.font = GB_DEFAULT_FONT(13);
        contentValueLabelTmp.textAlignment = KT_TextAlignmentLeft;
        [self.scrollViewGD addSubview:contentValueLabelTmp];
        contentValueLabelTmp.text = contentString;
        self.contentValueLabel = contentValueLabelTmp;
    }
    
    
    self.scrollViewHeight += _contentValueLabel.frame.origin.y + _contentValueLabel.frame.size.height;
    
}

//设置第二cell 包含 活动地址，视图
- (void)setupSeconCellViewWithAddress:(NSString *)addressString   URLString:(NSString *)URLString
{
    if (self.addressLabel) {
        self.addressLabel.text = @"活动地址:";
    }else{
        UILabel * addressLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(10, self.scrollViewHeight + 9, 60, 15)];
        addressLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        addressLabelTmp.textColor = KT_UIColorWithRGB(0x33, 0x33, 0x33);
        addressLabelTmp.font = GB_DEFAULT_FONT(13);
        addressLabelTmp.textAlignment = KT_TextAlignmentLeft;
        [self.scrollViewGD addSubview:addressLabelTmp];
        addressLabelTmp.text =  @"活动地址:";
        self.addressLabel = addressLabelTmp;
    }
    
    
    
    if (!self.clickedButton) {
        ClickLabel * clickedButtonTmp = [[ClickLabel alloc] initWithFrame:CGRectMake(80, self.scrollViewHeight + 6, 60, 20)
                                                                     text:addressString
                                                                 fontSize:13
                                                                textColor:KT_UIColorWithRGB(0x00, 0x7a, 0xff)
                                                                underLine:YES
                                                                   target:self
                                                                   action:@selector(changedImageButtonPressed:)];
        KT_CORNER_RADIUS(clickedButtonTmp, KT_CORNER_RADIUS_VALUE_2);
        
        [self.scrollViewGD addSubview:clickedButtonTmp];
        self.clickedButton = clickedButtonTmp;
    }
    
    KT_DLog(@"urlstring:%@",URLString);
    if (self.URLImageView) {
        [self.URLImageView setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_300_140)];
    }else{
        UIImageView * URLImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.scrollViewHeight + 35, 300, 140)];
        [self.scrollViewGD addSubview:URLImageViewTmp];
        [URLImageViewTmp setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_300_140)];
        KT_CORNER_RADIUS(URLImageViewTmp, KT_CORNER_RADIUS_VALUE_5);
        self.URLImageView = URLImageViewTmp;
    }
    
   
    
    self.scrollViewHeight +=175;
    if (self.scrollViewHeight < self.view.bounds.size.height) {
        self.scrollViewGD.contentSize = CGSizeMake([Utils screenWidth], self.view.bounds.size.height);
    }else{
        self.scrollViewGD.contentSize = CGSizeMake([Utils screenWidth], self.scrollViewHeight);
    }
}

- (void)changedImageButtonPressed:(id)sender
{
    //打印 地址 要回调程序中 要在网页中添加 启动外联
    KT_DLog(@"address:%@",self.dataModel.address);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.dataModel.address]];
    [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_ACTIVITY_LINK eventLabel:self.dataModel.activityName];
}

@end
