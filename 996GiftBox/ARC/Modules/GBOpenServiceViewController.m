//
//  GBOpenServiceViewController.m
//  GameGifts
//
//  Created by Keven on 13-12-24.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GBOpenServiceViewController.h"
#import "GBPackageReceiveViewController.h"
#import "GBOpenServiceAndTestChartModel.h"
#import "BaiduMobStat.h"

@interface GBOpenServiceViewController ()
KT_PROPERTY_WEAK UIButton * openServiceButton;
KT_PROPERTY_WEAK UIButton * testChartButton;
KT_PROPERTY_WEAK UIScrollView * scrollViewOS;
KT_PROPERTY_WEAK UIView * serviceContentView;
KT_PROPERTY_WEAK UIView * testContentView;
KT_PROPERTY_STRONG GBOpenServiceTableViewController * tableViewControllerForOS;
KT_PROPERTY_STRONG GBOpenServiceTableViewController * tableViewControllerForTC;
KT_PROPERTY_ASSIGN BOOL  isService;
KT_PROPERTY_ASSIGN BOOL  isFrist;
KT_PROPERTY_ASSIGN CGFloat   startOffsetX;
@end

@implementation GBOpenServiceViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.isService = YES;
        self.isFrist = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollViewOS];
    [self setupTableViewControllerForOS];
}

- (void)viewDidAppearForKTView
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"开服测试"];
}

- (void)viewWillDisappearForKTView
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"开服测试"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupTableViewControllerForOS
{
    GBOpenServiceTableViewController * tableViewControllerForOSTmp = [[GBOpenServiceTableViewController alloc] initWithStyle:UITableViewStylePlain isOpenService:1];
    tableViewControllerForOSTmp.tableView.frame = self.serviceContentView.bounds;
    tableViewControllerForOSTmp.delegate = self;
    [self.serviceContentView addSubview:tableViewControllerForOSTmp.view];
    self.tableViewControllerForOS = tableViewControllerForOSTmp;
    
    [self.tableViewControllerForOS refreshDataFromServer];
}
- (void)setupTableViewControllerForTC
{
    GBOpenServiceTableViewController * tableViewControllerForTCTmp = [[GBOpenServiceTableViewController alloc] initWithStyle:UITableViewStylePlain isOpenService:2];
    tableViewControllerForTCTmp.view.frame = self.testContentView.bounds;
    tableViewControllerForTCTmp.delegate = self;
    [self.testContentView addSubview:tableViewControllerForTCTmp.view];
    self.tableViewControllerForTC = tableViewControllerForTCTmp;
    
    [self.tableViewControllerForTC refreshDataFromServer];
}

- (void)setupScrollViewOS
{
    UIScrollView * scrollViewOSTmp = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollViewOSTmp.backgroundColor = KT_UICOLOR_CLEAR;
    scrollViewOSTmp.showsHorizontalScrollIndicator = NO;
    scrollViewOSTmp.showsVerticalScrollIndicator = NO;
    scrollViewOSTmp.bounces = NO;
    scrollViewOSTmp.delegate = self;
    scrollViewOSTmp.pagingEnabled = YES;
    scrollViewOSTmp.contentSize = CGSizeMake(2 * [Utils screenWidth], self.view.bounds.size.height);
    scrollViewOSTmp.contentOffset = CGPointMake(0, 0); //先把显示的区域往左移动viewSize。width
    scrollViewOSTmp.scrollEnabled = YES;
    [self addSubview:scrollViewOSTmp];
    self.scrollViewOS = scrollViewOSTmp;
    
    UIView *serviceContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.scrollViewOS addSubview:serviceContentView];
    self.serviceContentView = serviceContentView;
    
    CGRect newRect = self.view.bounds;
    newRect.origin.x = [Utils screenWidth];
    UIView *testContentView = [[UIView alloc] initWithFrame:newRect];
    [self.scrollViewOS addSubview:testContentView];
    self.testContentView = testContentView;
}

- (void)setupCustomNavigationBarButton
{
    CGFloat y = 7;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = KT_UI_STATUS_BAR_HEIGHT + 7;
    }
    UIButton * openServiceButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    openServiceButtonTmp.frame = CGRectMake(80, y, 80, 30);
    openServiceButtonTmp.backgroundColor = KT_UICOLOR_CLEAR;
    [openServiceButtonTmp setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_service_highlighted@2x")
                                    forState:UIControlStateNormal];
    [openServiceButtonTmp setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_service_highlighted_touchDown@2x")
                                    forState:UIControlStateHighlighted];
    [openServiceButtonTmp addTarget:self action:@selector(openService:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:openServiceButtonTmp];
    self.openServiceButton = openServiceButtonTmp;
    
    UIButton * testChartButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
    testChartButtonTmp.frame = CGRectMake(160, y, 80, 30);
    testChartButtonTmp.backgroundColor = KT_UICOLOR_CLEAR;
    [testChartButtonTmp setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_test@2x")
                                  forState:UIControlStateNormal];
    [testChartButtonTmp setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_test_touchDown@2x")
                                  forState:UIControlStateHighlighted];
    [testChartButtonTmp addTarget:self action:@selector(openTestChart:) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavigationBar addSubview:testChartButtonTmp];
    self.testChartButton = testChartButtonTmp;
}
- (void)openService:(UIButton *)bt
{
    KT_DLOG_SELECTOR;
    
    if (!self.isService) {
        self.isService = YES;
        [self.openServiceButton setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_service_highlighted@2x")
                                          forState:UIControlStateNormal];
        [self.openServiceButton setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_service_highlighted_touchDown@2x")
                                          forState:UIControlStateHighlighted];
        [self.testChartButton setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_test@2x")
                                        forState:UIControlStateNormal];
        [self.testChartButton setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_test_touchDown@2x")
                                        forState:UIControlStateHighlighted];
        [self.scrollViewOS setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_OPEN_SERVER_BUTTON eventLabel:@""];
}
- (void)openTestChart:(UIButton *)bt
{
    KT_DLOG_SELECTOR;
    if (self.isService) {
        self.isService = NO;

        [self.openServiceButton setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_service@2x")
                                          forState:UIControlStateNormal];
        [self.openServiceButton setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_service_touchDown@2x")
                                          forState:UIControlStateHighlighted];
        [self.testChartButton setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_test_highlighted@2x")
                                        forState:UIControlStateNormal];
        [self.testChartButton setBackgroundImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_test_highlighted_touchDown@2x")
                                        forState:UIControlStateHighlighted];
        [self.scrollViewOS setContentOffset:CGPointMake([Utils screenWidth], 0) animated:YES];
        
        if (self.isFrist) {
            self.isFrist = NO;
            [self setupTableViewControllerForTC];
        }
    }
    [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_TEST_BUTTON eventLabel:@""];
}

- (void)openGift:(GBOpenServiceAndTestChartModel *)model
{
    KT_DLOG_SELECTOR;
    GBPackageReceiveViewController * vc = [[GBPackageReceiveViewController alloc] initWithPackageID:model.packageID];
    [self.KTNavigationController pushKTViewController:vc animated:YES];
}

#pragma mark - UIScrollView Delegate
//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    KT_DLOG_SELECTOR;
    self.startOffsetX = scrollView.contentOffset.x;
}
//减速停止了时执行，手触摸时执行执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    KT_DLOG_SELECTOR;
    CGFloat offsetX = scrollView.contentOffset.x;
    if (self.startOffsetX != offsetX) {
        if (offsetX == 0) {
            [self openService:nil];
        }else{
            [self openTestChart:nil];
        }
    }
}
@end
