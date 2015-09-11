//
//  KTUIViewController.m
//  NetWork
//
//  Created by Keven on 13-12-6.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "KTViewController.h"
@interface KTViewController ()

@property (nonatomic,weak)GBNoDataShowView * noDataShowView;

@end

@implementation KTViewController\
/**
 *  初始化视图控制器
 *
 *  @return 视图控制器 对象实例
 */
- (id)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}
/**
 *  代码初始化视图
 */
- (void)loadView
{
    [super loadView];
    CGRect rootViewRect = CGRectZero;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        rootViewRect = CGRectMake(0, 0, [Utils screenWidth], [Utils screenHeight]);
    }else{
        rootViewRect = CGRectMake(0, 0, [Utils screenWidth], [Utils screenHeight] - KT_UI_STATUS_BAR_HEIGHT);
    }
    UIView * rootView = [[UIView alloc] initWithFrame:rootViewRect];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
}
/**
 *  初始化数据
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin
                                 |UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
}
/**
 *  内存溢出
 */
- (void)didReceiveMemoryWarning
{
    KT_DLOG_SELECTOR;
    [super didReceiveMemoryWarning];
}
/**
 *  数据请求(没有ToKenKey，不需要登录权限)
 */
- (void)dataRequestMothed
{
    KT_DLOG_SELECTOR;
}
/**
 *  添加视图。调整视图的显示的层次
 *
 *  @param view 要添加的视图
 */
- (void)addSubview:(UIView *)view
{
    [self.view addSubview:view];
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


/**
 *  初始化NoDataShowView
 
 *
 *  @param type     那个页面
 *  @param sView    父类视图
 *  @param delegate 父类ViewController
 *  @param action   回调事件
 *  @param animation 启用动画/不启用
 */
- (void)setupNoDataShowViewWithType:(GBNoDataShowViewType)type
                          superView:(UIView *)sView
                          animation:(BOOL)animation
{
    KT_DLOG_SELECTOR;//NOTE 待实现
}

/**
 *  设置NoDataShowView 显示隐藏
 *
 *  @param hidden  值
 */
- (void)setupNoDataShowViewHidden:(BOOL)hidden
{
    //添加动画
    self.noDataShowView.hidden = hidden;
}

/**
 *  设置NoDataShowView 显示隐藏
 *
 *  @param hidden    显示隐藏
 *  @param animation 启用动画/不启用
 */
- (void)setupNoDataShowViewHidden:(BOOL)hidden
                        animation:(BOOL)animation
{
    KT_DLOG_SELECTOR; //NOTE 待实现
    self.noDataShowView.hidden = hidden;
}

/**
 *
 *  停止NoDataShowView 加载状态
 *
 */
- (void)stopIndicatorView
{
    [self.noDataShowView stopIndicatorView];
}

/**
 *
 *  隐藏NoDataShowView
 *
 */
- (void)hidNoDataView
{
    [self.noDataShowView stopIndicatorView];
    [self.noDataShowView removeFromSuperview];
    self.noDataShowView  = nil;
}

/**
 *  视图将要显示
 *
 *  @param animated 是否支持动画
 */
- (void)viewWillAppearForKTView
{
    KT_DLOG_SELECTOR;
}
/**
 *  视图正要显示
 *
 *  @param animated 是否支持动画
 */
- (void)viewDidAppearForKTView
{
    KT_DLOG_SELECTOR;
}
/**
 *  视图将要消失
 *
 *  @param animated 是否支持动画
 */
- (void)viewWillDisappearForKTView
{
    KT_DLOG_SELECTOR;
}
/**
 *  视图正要消失
 *
 *  @param animated 是否支持动画
 */
- (void)viewDidDisappearForKTView
{
    KT_DLOG_SELECTOR;
}
/**
 *  m没有数据页面的刷新界面
 *
 *  @param infoTag 默认是0,
 */
- (void)refreshByNoDataShowViewWithInfoTag:(int)infoTag
{
    KT_DLOG_SELECTOR;
}
@end
