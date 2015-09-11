//
//  GBMineRedemptionCodeViewController.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-8.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBMineRedemptionCodeViewController.h"
//#import "GBMineRecommendModel.h"
//#import "GBRecommendModel.h"
#import "LineView.h"
#import "UIImageView+WebCache.h"
#import "GBMineCodeCell.h"
#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "PXAlertView.h"
#import "GBMineGiftGroupModel.h"
#import "GBMineGiftModel.h"
#import "GBLoadingView.h"
#import "GBPopUpBox.h"
#import "BaiduMobStat.h"

@interface GBMineRedemptionCodeViewController ()

@property (nonatomic, weak) UITableView *tableView;
//@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) NSMutableArray *modelGroupArray;
@property (nonatomic, weak)TableLoadMoreFooterView * loadMoreFooterViewForACL;
@property (nonatomic, weak)TableRefreshHeaderView  * refreshHeaderViewForACL;
@property (nonatomic, weak)GBLoadingView *loadingView;
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isAllSelected;
@property (nonatomic, assign) BOOL isRefreshForNoData;
@property (nonatomic, assign) int pageNum;

@property (nonatomic, strong) GBDefaultReqeust *request;
@property (nonatomic, weak)GBPopUpBox * popUpBox;
@end

@implementation GBMineRedemptionCodeViewController

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
    [self.request cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.customNavigationBar setNavBarTitle:@"我的兑换码"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, KT_UI_SCREEN_WIDTH, KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT)];
    headerView.backgroundColor = KT_UICOLOR_CLEAR;
    
    UITableView *tableViewTMP = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableViewTMP.dataSource = self;
    tableViewTMP.delegate = self;
    tableViewTMP.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
    tableViewTMP.tableHeaderView = headerView;
    tableViewTMP.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableViewTMP];
    self.tableView = tableViewTMP;
    
    /*
    //测试+++++++++++++++++++++++++++++++++++++++++++++++++
    GBMineRecommendModel *mineModel1 = [[GBMineRecommendModel alloc] init];
    mineModel1.gameName = @"新梦幻之城";
    //mineModel1------------------------------------------
    GBRecommendModel *mineModel1_1 = [[GBRecommendModel alloc] init];
    mineModel1_1.iconStrUrl = @"http://img.996.com/allimg/140109/12-1401091133090-L_140x105.jpg";
    mineModel1_1.codeName = @"新服金币兑换码";
    mineModel1_1.code = @"743ssk36gm";
    mineModel1_1.validDate = 1323874;
    
    GBRecommendModel *mineModel1_2 = [[GBRecommendModel alloc] init];
    mineModel1_2.iconStrUrl = @"http://img.996.com/allimg/140109/12-1401091133090-L_140x105.jpg";
    mineModel1_2.codeName = @"双蛋超值兑换码大礼包";
    mineModel1_2.code = @"743ssk36gm";
    mineModel1_2.validDate = 1323874;
    
    mineModel1.codeModelArray = [NSArray arrayWithObjects:mineModel1_1, mineModel1_2, nil];
    //----------------------------------------------------
    
    GBMineRecommendModel *mineModel2 = [[GBMineRecommendModel alloc] init];
    mineModel2.gameName = @"我叫MT Online";
    //mineModel1------------------------------------------
    GBRecommendModel *mineModel2_1 = [[GBRecommendModel alloc] init];
    mineModel2_1.iconStrUrl = @"http://img.996.com/140109/12-140109153513M7_120x90.jpg";
    mineModel2_1.codeName = @"新服金币兑换码";
    mineModel2_1.code = @"743ssk36gm";
    mineModel2_1.validDate = 1323874;
    
    GBRecommendModel *mineModel2_2 = [[GBRecommendModel alloc] init];
    mineModel2_2.iconStrUrl = @"http://img.996.com/140109/12-140109153513M7_120x90.jpg";
    mineModel2_2.codeName = @"双蛋超值兑换码大礼包";
    mineModel2_2.code = @"743ssk36gm";
    mineModel2_2.validDate = 1323874;
    
    mineModel2.codeModelArray = [NSArray arrayWithObjects:mineModel2_1, mineModel2_2, nil];
    
    //----------------------------------------------------
    
    GBMineRecommendModel *mineModel3 = [[GBMineRecommendModel alloc] init];
    mineModel3.gameName = @"植物大战僵尸2";
    //mineModel1------------------------------------------
    GBRecommendModel *mineModel3_1 = [[GBRecommendModel alloc] init];
    mineModel3_1.iconStrUrl = @"http://img.996.com/allimg/140108/4893-14010R112050-L_180x135.jpg";
    mineModel3_1.codeName = @"新服金币兑换码";
    mineModel3_1.code = @"743ssk36gm";
    mineModel3_1.validDate = 1323874;
    
    mineModel3.codeModelArray = [NSArray arrayWithObjects:mineModel3_1, nil];
    
    //----------------------------------------------------
    
    GBMineRecommendModel *mineModel4 = [[GBMineRecommendModel alloc] init];
    mineModel4.gameName = @"保卫萝卜";
    //mineModel1------------------------------------------
    GBRecommendModel *mineModel4_1 = [[GBRecommendModel alloc] init];
    mineModel4_1.iconStrUrl = @"http://img.996.com/allimg/131213/4894-1312131139250-L_180x135.jpg";
    mineModel4_1.codeName = @"新服金币兑换码";
    mineModel4_1.code = @"743ssk36gm";
    mineModel4_1.validDate = 1323874;
    
    GBRecommendModel *mineModel4_2 = [[GBRecommendModel alloc] init];
    mineModel4_2.iconStrUrl = @"http://img.996.com/allimg/131213/4894-1312131139250-L_180x135.jpg";
    mineModel4_2.codeName = @"双蛋超值兑换码大礼包";
    mineModel4_2.code = @"743ssk36gm";
    mineModel4_2.validDate = 1323874;
    
    GBRecommendModel *mineModel4_3 = [[GBRecommendModel alloc] init];
    mineModel4_3.iconStrUrl = @"http://img.996.com/allimg/131213/4894-1312131139250-L_180x135.jpg";
    mineModel4_3.codeName = @"双蛋超值兑换码大礼包";
    mineModel4_3.code = @"743ssk36gm";
    mineModel4_3.validDate = 1323874;
    
    mineModel4.codeModelArray = [NSArray arrayWithObjects:mineModel4_1, mineModel4_2, mineModel4_3, nil];
    
    //----------------------------------------------------
    
    GBMineRecommendModel *mineModel5 = [[GBMineRecommendModel alloc] init];
    mineModel5.gameName = @"爸爸去哪儿";
    //mineModel1------------------------------------------
    GBRecommendModel *mineModel5_1 = [[GBRecommendModel alloc] init];
    mineModel5_1.iconStrUrl = @"http://img.996.com/allimg/140109/12-1401091133090-L_140x105.jpg";
    mineModel5_1.codeName = @"新服金币兑换码";
    mineModel5_1.code = @"743ssk36gm";
    mineModel5_1.validDate = 1323874;
    
    GBRecommendModel *mineModel5_2 = [[GBRecommendModel alloc] init];
    mineModel5_2.iconStrUrl = @"http://img.996.com/allimg/140109/12-1401091133090-L_140x105.jpg";
    mineModel5_2.codeName = @"双蛋超值兑换码大礼包";
    mineModel5_2.code = @"743ssk36gm";
    mineModel5_2.validDate = 1323874;
    
    GBRecommendModel *mineModel5_3 = [[GBRecommendModel alloc] init];
    mineModel5_3.iconStrUrl = @"http://img.996.com/allimg/140109/12-1401091133090-L_140x105.jpg";
    mineModel5_3.codeName = @"新服金币兑换码";
    mineModel5_3.code = @"743ssk36gm";
    mineModel5_3.validDate = 1323874;
    
    GBRecommendModel *mineModel5_4 = [[GBRecommendModel alloc] init];
    mineModel5_4.iconStrUrl = @"http://img.996.com/allimg/140109/12-1401091133090-L_140x105.jpg";
    mineModel5_4.codeName = @"双蛋超值兑换码大礼包";
    mineModel5_4.code = @"743ssk36gm";
    mineModel5_4.validDate = 1323874;
    
    mineModel5.codeModelArray = [NSArray arrayWithObjects:mineModel5_1, mineModel5_2, mineModel5_3, mineModel5_4, nil];
    
    //----------------------------------------------------
    
    self.modelArray = [NSArray arrayWithObjects:mineModel1, mineModel2, mineModel3, mineModel4, mineModel5, nil];
    */
    /*
    NSMutableArray *ARRAY = [NSMutableArray arrayWithArray:self.modelArray];
    for (int i = 0; i < 1000; ++i) {
        GBMineRecommendModel *mineModel = [[GBMineRecommendModel alloc] init];
        mineModel.gameName = @"爸爸去哪儿";
        //mineModel1------------------------------------------
        GBRecommendModel *mineModel_1 = [[GBRecommendModel alloc] init];
        mineModel_1.iconStrUrl = @"http://img.996.com/allimg/140109/12-1401091133090-L_140x105.jpg";
        mineModel_1.codeName = @"新服金币兑换码";
        mineModel_1.code = @"743ssk36gm";
        mineModel_1.validDate = 1323874;
        
        GBRecommendModel *mineModel_2 = [[GBRecommendModel alloc] init];
        mineModel_2.iconStrUrl = @"http://img.996.com/allimg/140109/12-1401091133090-L_140x105.jpg";
        mineModel_2.codeName = @"双蛋超值兑换码大礼包";
        mineModel_2.code = @"743ssk36gm";
        mineModel_2.validDate = 1323874;
        
        GBRecommendModel *mineModel_3 = [[GBRecommendModel alloc] init];
        mineModel_3.iconStrUrl = @"http://img.996.com/allimg/140109/12-1401091133090-L_140x105.jpg";
        mineModel_3.codeName = @"新服金币兑换码";
        mineModel_3.code = @"743ssk36gm";
        mineModel_3.validDate = 1323874;
        
        GBRecommendModel *mineModel_4 = [[GBRecommendModel alloc] init];
        mineModel_4.iconStrUrl = @"http://img.996.com/allimg/140109/12-1401091133090-L_140x105.jpg";
        mineModel_4.codeName = @"双蛋超值兑换码大礼包";
        mineModel_4.code = @"743ssk36gm";
        mineModel_4.validDate = 1323874;
        
        mineModel.codeModelArray = [NSArray arrayWithObjects:mineModel_1, mineModel_2, mineModel_3, mineModel_4, nil];
        
        [ARRAY addObject:mineModel];
    }
    
    self.modelArray = ARRAY;
    */
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    /*
    //初始化选中状态
    self.isAllSelected = NO;
    for (GBMineRecommendModel *model in self.modelArray) {
        model.isSelected = NO;
        for (GBRecommendModel *subModel in model.codeModelArray) {
            subModel.isSelected = NO;
        }
    }
     */
    
    [self setupLoadMoreFooterView]; //点击加载更多
    [self setupRefreshHeaderView]; //下载更多
    
    [self dataRequestMothed];
}

//点击加载更多
- (void)setupLoadMoreFooterView
{
    self.loadMoreFooterViewForACL = [TableLoadMoreFooterView footerViewWithOwner:self.tableView delegate:self ownerInsetBottomDefaultHeight:KT_UI_TAB_BAR_HEIGHT];
    [self.loadMoreFooterViewForACL setEnable:NO];
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

- (void)refreshByNoDataShowViewWithInfoTag:(int)infoTag
{
    self.isRefreshForNoData = YES;
    self.pageNum = 0;
    [self dataRequestMothed];
}

- (void)dataRequestMothed
{
    //空页面显示...
    if ([self.tableView numberOfRowsInSection:0] <= 0 && !self.isRefreshForNoData) {
        GBLoadingView *loadingView = [[GBLoadingView alloc] init];
        [loadingView showInView:self.view offset:0];
        [self.view bringSubviewToFront:self.customTabBar];
        self.loadingView = loadingView;
    }
    
    self.isRefreshForNoData = NO;
    
    [self.request cancel];
    self.request = [[GBDefaultReqeust alloc] init];
    self.request.responseClass = [GBMineGiftResponse class];
    
    BaseParameter * parameter = [[BaseParameter alloc] init];
    [parameter writeInt_32:DEFAULT_WRITE_LENGHT];
    [parameter writeInt_32:REQUEST_COMMAND_TYPE_MINE_GIFT];
    [parameter writeInt_16:[[Utils getAppVersion] integerValue]];
    [parameter writeInt_32:0];
    if (![Utils isNilOrEmpty:[[TRUser sharedInstance] tokenKey]] ) { //没有登录
        [parameter writeInt_64:[[TRUser sharedInstance] userId]];
    }else{
        [parameter writeInt_64:0];
    }
    [parameter writeInt_32:self.pageNum];
    //修正数据长度
    [parameter changeBufferSize:parameter.length];
    self.request.parameters = parameter;
    
    __weak typeof(self) vc = self;
    [self.request setResponseBlock:^(GBRequest* request, GBResponse* response){
        
        [vc.loadingView hidden];
        vc.loadingView = nil;
        
        [vc hidNoDataView];
        
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
            if (response.netError) {
                if (vc.modelGroupArray.count > 0) { //有数据
                    
                    //没有网络&&Data，弹出框提示
                    GBPopUpBox *boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeNoNetwork withAutoHidden:YES];
                    [boxTmp showInView:vc.view offset:0];
                    
                }else{
                    //没有网络&&NoData
                    [vc setupNoDataShowViewWithType:GBNoDataShowViewTypeForNoNetwork
                                                superView:vc.view];
                }
            }else{
                if (vc.modelGroupArray.count > 0) {
                    
                    //加载出错&&Data，弹出框提示
                    GBPopUpBox *boxTmp = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeLoadingError withAutoHidden:YES];
                    [boxTmp showInView:vc.view offset:0];
                }else{
                    //加载错误&&NoData
                    [vc setupNoDataShowViewWithType:GBNoDataShowViewTypeForServierError
                                                superView:vc.view];
                }
            }
            
        }else{
            GBMineGiftResponse * responseResult = (GBMineGiftResponse *)response;
            
            //刷新
            if (vc.pageNum == 0 && [responseResult.modelGroupArray count] > 0) {
                vc.modelGroupArray = responseResult.modelGroupArray;
            }
            else{ //翻页
                [vc.modelGroupArray addObjectsFromArray:responseResult.modelGroupArray];
            }
            
            //判断是否有数据
            if (vc.modelGroupArray.count > 0) {
                [vc.tableView reloadData];
            }
            
            //没有数据，显示空页面
            if ([vc.tableView numberOfRowsInSection:0] <= 0) {
                [vc setupNoDataShowViewWithType:GBNoDataShowViewTypeForMineGift
                                            superView:vc.view];
            }
            
            //self.pageNum < pageCount - 1判断是否是最后一页
            [vc.loadMoreFooterViewForACL setEnable:vc.pageNum < responseResult.pageCount - 1];
        }
    }];
    [self.request sendAsynchronous];
}

//全选
- (void)didSelectedAllAction:(id)sender
{
    self.isAllSelected = !self.isAllSelected;
    for (GBMineGiftGroupModel *model in self.modelGroupArray) {
        model.isSelected = self.isAllSelected;
        for (GBMineGiftModel *subModel in model.giftModelArray) {
            subModel.isSelected = self.isAllSelected;
        }
    }
    [self.tableView reloadData];
}

//删除
- (void)didDeleteAction:(id)sender
{
    if ([self.modelGroupArray count] <= 0) {
        return;
    }
    NSMutableArray *deleteArray = [NSMutableArray array];
    for (GBMineGiftGroupModel* groupModel in self.modelGroupArray) {
        if (groupModel.isSelected) {
            [deleteArray addObjectsFromArray:groupModel.giftModelArray];
            continue;
        }
        
        for (GBMineGiftModel* giftModle in groupModel.giftModelArray) {
            if (giftModle.isSelected) {
                [deleteArray addObject:giftModle];
            }
        }
    }
    
    if ([deleteArray count] <= 0) {
        GBPopUpBox *box = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeDefault
                                               withMessage:@"请选择要删除的礼包"
                                            withAutoHidden:YES];
        [box showInView:self.view offset:0];

        return;
    }
    
    [PXAlertView showAlertWithTitle:@"提示"
                            message:@"删除后将不能重新领取，是否继续删除？"
                        cancelTitle:@"取消"
                         otherTitle:@"确定"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (!cancelled) {
                                 GBPopUpBox *box = [[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeProgress
                                                                        withMessage:@"删除中，请稍后..."
                                                                     withAutoHidden:NO];
                                 [box show];
                                 self.popUpBox = box;
                                 
                                 self.isRefreshForNoData = NO;
                                 [self.request cancel];
                                 self.request = [[GBDefaultReqeust alloc] init];
                                 self.request.responseClass = [GBDeletePackageNumber class];
                                 
                                 BaseParameter * parameter = [[BaseParameter alloc] init];
                                 [parameter writeInt_32:DEFAULT_WRITE_LENGHT]; //当前数据总长度(字节) 后面修正数据长度
                                 [parameter writeInt_32:REQUEST_COMMAND_TYPE_DELETE_GETNUMBER];//请求标识
                                 [parameter writeInt_16:DEFAULT_CLIENT_VERSION]; //客户端的跟接口对接的版本号
                                 [parameter writeInt_32:DEFAULT_CLIENT_FLAGS]; //备用参数，用来兼容不同的客户端 接口的兼容，先暂时可以为0
                                 [parameter writeInt_32:[deleteArray count]];//删除总量
                                 
                                 if (![Utils isNilOrEmpty:[[TRUser sharedInstance] tokenKey]] ) { //没有登录
                                     [parameter writeInt_64:[[TRUser sharedInstance] userId]];
                                 }else{
                                     [parameter writeInt_64:0];
                                 }
                                 //要删除的具体礼包id和礼包好
                                 
                                 for (GBMineGiftModel* giftModel in deleteArray) {
                                     [parameter writeInt_64:giftModel.package_number_id];
                                 }
                                 
                                 //修正数据长度
                                 [parameter changeBufferSize:parameter.length];
                                 self.request.parameters = parameter;
                                 //要删除的已经存在 deletesetary里面去了
                                 
                                 __weak typeof(self) vc = self;
                                 [self.request setResponseBlock:^(GBRequest* request, GBResponse* response){
                                     [vc.popUpBox hiddenWithAnimated:YES];
                                     if (response.isError) { //失败
                                         if (response.netError) {
                                             [PXAlertView showAlertWithTitle:@"失败"
                                                                     message:@"网络不可用，请检查网络连接!"
                                                                 cancelTitle:@"确定"
                                                                  completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                                      
                                                                  }];
                                         }else{
                                             [PXAlertView showAlertWithTitle:@"失败"
                                                                     message:@"删除失败，请重试!"
                                                                 cancelTitle:@"确定"
                                                                  completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                                      
                                                                  }];
                                         }
                                     }
                                     else{
                                         GBDeletePackageNumber * responseResult = (GBDeletePackageNumber *)response;
                                         
                                         NSMutableArray *tmpArray = [NSMutableArray array];
                                         if (responseResult.delete_count > 0) {
                                             for (GBMineGiftGroupModel* groupModel in vc.modelGroupArray) {
                                                 if (groupModel.isSelected) {
                                                     [tmpArray addObject:groupModel];
                                                     continue;
                                                 }
                                                 
                                                 NSMutableArray *tmpSubArray = [NSMutableArray array];
                                                 for (GBMineGiftModel* giftModel in groupModel.giftModelArray) {
                                                     if (giftModel.isSelected) {
                                                         [tmpSubArray addObject:giftModel];
                                                     }
                                                 }
                                                 [groupModel.giftModelArray removeObjectsInArray:tmpSubArray];
                                                 
                                             }
                                             
                                             [vc.modelGroupArray removeObjectsInArray:tmpArray];
                                             
                                             [vc.tableView reloadData];
                                             
                                             //没有数据，显示空页面
                                             if ([vc.tableView numberOfRowsInSection:0] <= 0) {
                                                 [vc setupNoDataShowViewWithType:GBNoDataShowViewTypeForMineGift
                                                                       superView:vc.view];
                                             }
                                             
                                         }
                                         else{
                                             [PXAlertView showAlertWithTitle:@"失败"
                                                                     message:@"删除失败，请重试!"
                                                                 cancelTitle:@"确定"
                                                                  completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                                      
                                                                  }];
                                         }
                                         
                                     }
                                     
                                 }];
                                 [self.request sendAsynchronous];
                             }
                         }];
        
}

- (void)setupCustomNavigationBarButton
{
    KT_DLog(@"设置上导航Button");
    [self.customNavigationBar setNavBarButtonWithTitle:@"全选"
                                            buttonType:KTNavigationBarButtonTypeOfLeft
                                                target:self
                                                action:@selector(didSelectedAllAction:)];
    
    [self.customNavigationBar setNavBarButtonWithTitle:@"删除"
                                            buttonType:KTNavigationBarButtonTypeOfRight
                                                target:self
                                                action:@selector(didDeleteAction:)];
}

- (void)popBack:(id)sender
{
    [self.KTNavigationController popKTViewControllerAnimated:YES];
}

- (void)setupCustomTabBarButton
{
    [self.customTabBar setTabBarButtonWithImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back@2x")
                               highlightedImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back_highlight@2x")
                                     buttonType:CustomTabBarButtonTypeOfLeft
                                         target:self
                                         action:@selector(popBack:)];
}

- (void)didSubCheckboxAction:(UIButton *)button
{
//    int index = button.tag;
    NSInteger index = button.tag/100000 - 1;
    int subIndex = button.tag%100000;
    
    GBMineGiftGroupModel *model = [self.modelGroupArray objectAtIndex:index];
    GBMineGiftModel *subModel = [model.giftModelArray objectAtIndex:subIndex];
    subModel.isSelected = !subModel.isSelected;
    BOOL isSame = YES;
    for (GBMineGiftModel *subModel2 in model.giftModelArray) {
        if (subModel2.isSelected != subModel.isSelected) {
            isSame = NO;
        }
    }
    
    model.isSelected = isSame?subModel.isSelected:NO;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didCheckboxAction:(UIButton *)button
{
    NSInteger index = button.tag;
    GBMineGiftGroupModel *model = [self.modelGroupArray objectAtIndex:index];
    model.isSelected = !model.isSelected;
    for (GBMineGiftModel *subModel in model.giftModelArray) {
        subModel.isSelected = model.isSelected;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didCopyAction:(UIButton *)button
{   //HUANGBO ADD 复制点击 并且弹出完成提示
    NSInteger index = button.tag/100000 - 1;
    int subIndex = button.tag%100000;
    
    GBMineGiftGroupModel *model = [self.modelGroupArray objectAtIndex:index];
    GBMineGiftModel *subModel = [model.giftModelArray objectAtIndex:subIndex];
    UIPasteboard * codePasteboard = [UIPasteboard generalPasteboard];
    [codePasteboard setString:subModel.package_number];
    GBPopUpBox *popbox=[[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeDefault withMessage:@"复制成功！" withAutoHidden:YES];
    [popbox showInView:self.view offset:0];
    
    [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_COPY_BUTTON eventLabel:@""];
}

#pragma mark - UITableViewDataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.modelGroupArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CodeCellIdentifier";
    
    GBMineCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GBMineCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    GBMineRecommendModel *model = [self.modelArray objectAtIndex:indexPath.row];
    GBMineGiftGroupModel *groupModel = [self.modelGroupArray objectAtIndex:indexPath.row];
    
    [cell reloadWithModel:groupModel
                      row:indexPath.row target:self
                   action:@selector(didCheckboxAction:)
                subAction:@selector(didSubCheckboxAction:)
               copyAction:@selector(didCopyAction:)];
    return cell;
    
    ////////////////////////////////////////////////////////////
    
    /*
    static NSString *CellIdentifier = @"CodeCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    GBMineRecommendModel *model = [self.modelArray objectAtIndex:indexPath.row];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, KT_UI_SCREEN_WIDTH - 10, 45 + [model.codeModelArray count]*74)];
    bgView.backgroundColor = KT_HEXCOLOR(0xffffff);
    bgView.layer.masksToBounds = YES;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = KT_HEXCOLOR(0xdddddd).CGColor;
    bgView.layer.cornerRadius = 5;
    
    CGFloat x = 12;
    
    //选择框
    UIButton *checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkboxButton.tag = indexPath.row;
    checkboxButton.frame = CGRectMake(0.f, 0.f, 40, 40);
    if (model.isSelected) {
        [checkboxButton setImage:KT_GET_LOCAL_PICTURE(@"mine_checkbox_highlighted@2x") forState:UIControlStateNormal];
    }
    else {
        [checkboxButton setImage:KT_GET_LOCAL_PICTURE(@"mine_checkbox@2x") forState:UIControlStateNormal];
    }
    
    [checkboxButton addTarget:self action:@selector(didAllCheckboxAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:checkboxButton];
    
    x += (checkboxButton.frame.size.width + 2);
    
    //名称
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 200, 45)];
    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
    titleLabel.font = GB_DEFAULT_FONT(15);
    titleLabel.textColor = KT_HEXCOLOR(0x333333);
    titleLabel.text = model.gameName;
    [bgView addSubview:titleLabel];
    
    CGFloat y = 45;
    
    for (int i = 0; i < [model.codeModelArray count]; ++i) {
        
        GBRecommendModel *subModel = [model.codeModelArray objectAtIndex:i];
        
        LineView *lineView = [[LineView alloc] initWithFrame:CGRectMake(12, y, bgView.frame.size.width - 24, 1) type:LineViewTypeForSolidLine];
        [bgView addSubview:lineView];
        
        y = (lineView.frame.origin.y + lineView.frame.size.height);
        
        //选择框
        UIButton *checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        checkboxButton.tag = (indexPath.row+1)*100000 + i;
        checkboxButton.frame = CGRectMake(0.f, y + 17, 40, 40);
        if (subModel.isSelected) {
            [checkboxButton setImage:KT_GET_LOCAL_PICTURE(@"mine_checkbox_highlighted@2x") forState:UIControlStateNormal];
        }
        else {
            [checkboxButton setImage:KT_GET_LOCAL_PICTURE(@"mine_checkbox@2x") forState:UIControlStateNormal];
        }

        [cell.contentView addSubview:checkboxButton];
        [checkboxButton addTarget:self action:@selector(didCheckboxAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:checkboxButton];
        
        x = (checkboxButton.frame.origin.x + checkboxButton.frame.size.width + 15);
        y = (lineView.frame.origin.y + lineView.frame.size.height + 12);
        
        //图标
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 48, 48)];
        iconImageView.layer.masksToBounds = YES;
        iconImageView.layer.cornerRadius = 7.5;
        [iconImageView setImageWithURL:[NSURL URLWithString:subModel.iconStrUrl]];
        [bgView addSubview:iconImageView];
        
        x += (iconImageView.frame.size.width + 12);
        
        //类型
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 12)];
        typeLabel.backgroundColor = KT_UICOLOR_CLEAR;
        typeLabel.font = GB_DEFAULT_FONT(12);
        typeLabel.textColor = KT_HEXCOLOR(0x666666);
        typeLabel.text = subModel.codeName;
        [bgView addSubview:typeLabel];
        
        y += (typeLabel.frame.size.height + 9);
        
        //礼包码
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 12)];
        codeLabel.backgroundColor = KT_UICOLOR_CLEAR;
        codeLabel.font = GB_DEFAULT_FONT(12);
        codeLabel.textColor = KT_HEXCOLOR(0x666666);
        codeLabel.text = [NSString stringWithFormat:@"兑换码：%@",subModel.code];
        [bgView addSubview:codeLabel];
        
        y += (codeLabel.frame.size.height + 9);
        
        UILabel *validLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 12)];
        validLabel.backgroundColor = KT_UICOLOR_CLEAR;
        validLabel.font = GB_DEFAULT_FONT(12);
        validLabel.textColor = KT_HEXCOLOR(0x666666);
        validLabel.text = [NSString stringWithFormat:@"有效截至日期：2013-10-2"];
        [bgView addSubview:validLabel];
        
        y = lineView.frame.origin.y + lineView.frame.size.height;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(bgView.frame.size.width - 57, y + 24, 47, 26);
        button.titleLabel.font = GB_DEFAULT_FONT(12);
        [button setTitle:@"复制" forState:UIControlStateNormal];
        [button setTitleColor:KT_HEXCOLOR(0x44b5ff) forState:UIControlStateNormal];
        [button setTitleColor:KT_HEXCOLOR(0xffffff) forState:UIControlStateHighlighted];
        [button setBackgroundImage:[[[UIImage imageNamed:@"hp_gift_receive_highlighted.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:13] stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[[[UIImage imageNamed:@"hp_gift_receive.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:13] stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
        [bgView addSubview:button];
        
        y = 45 + (i+1)*74;
    }
    
    [cell.contentView addSubview:bgView];
    
    return cell;
     */
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBMineGiftGroupModel *model = [self.modelGroupArray objectAtIndex:indexPath.row];
//    return 45 + [model.codeModelArray count]*74 + 10;
    CGFloat subHeight = [model.giftModelArray count]*78;
    for (GBMineGiftModel *giftModel in model.giftModelArray) {
        CGSize strSize = [giftModel.package_number sizeWithFont:GB_DEFAULT_FONT(12)];
        if (strSize.width > 95) {
            subHeight += strSize.height;
        }
    }
    return 45 + subHeight + [model.giftModelArray count] + 10;
}

#pragma mark - UIScrollViewDelegate
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

@end
