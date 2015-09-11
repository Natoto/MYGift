//
//  KTMainViewController.m
//  996Test
//
//  Created by Keven on 14-1-16.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "KTMainViewController.h"

#import "KTNavigationController.h"

#import "GBHomePageViewController.h"
#import "GBOpenServiceViewController.h"
#import "GBSearchHomeViewController.h"
#import "GBMineViewController.h"
@interface KTMainViewController ()
@property (nonatomic,strong) KTTabBar   * tabBar;
@property (nonatomic,assign) KTTabBarControllerType   selectedTabBarControllerType;
@property (nonatomic,strong) KTNavigationController * firstRootNav;
@property (nonatomic,strong) KTNavigationController * secondRootNav;
@property (nonatomic,strong) KTNavigationController * thirdRootNav;
@property (nonatomic,strong) KTNavigationController * fourthRootNav;
@property (nonatomic,strong) KTNavigationController * fifthRootNav;
@end

@implementation KTMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTabBar];
    [self setupTabViewControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  初始化下标签栏
 */
- (void)setupTabBar
{
    KTTabBar * tabBarTmp = [[KTTabBar alloc] initWithItems:[self getTabBarIcons]];
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        tabBarTmp.frame = CGRectMake(0,   [Utils screenHeight] - KT_UI_TAB_BAR_HEIGHT, [Utils screenWidth], KT_UI_TAB_BAR_HEIGHT);
    }else{
        tabBarTmp.frame = CGRectMake(0,   [Utils screenHeight] - KT_UI_TAB_BAR_HEIGHT - KT_UI_STATUS_BAR_HEIGHT, [Utils screenWidth], KT_UI_TAB_BAR_HEIGHT);
    }
    tabBarTmp.delegate = self;
    tabBarTmp.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:tabBarTmp];
    [tabBarTmp showTabBarAtIndex:0];
    self.tabBar = tabBarTmp;
}
- (NSArray *)getTabBarIcons
{
    return  [NSArray arrayWithObjects:@"bar_home_page",@"bar_open_service",@"bar_text",@"bar_mine" ,nil];

}
- (void)setupTabViewControllers
{
    self.firstRootNav = [[KTNavigationController alloc] initWithRootKTViewController:[[GBHomePageViewController alloc] init]];
    [self.firstRootNav setTabBar:_tabBar mainViewController:self];
    
    self.secondRootNav = [[KTNavigationController alloc] initWithRootKTViewController:[[GBOpenServiceViewController alloc] init]];
    [self.secondRootNav setTabBar:_tabBar mainViewController:self];
    
    self.thirdRootNav = [[KTNavigationController alloc] initWithRootKTViewController:[[GBSearchHomeViewController alloc] initWithType:KT_KInitTypeNormal]];
    [self.thirdRootNav setTabBar:_tabBar mainViewController:self];
    
    self.fourthRootNav = [[KTNavigationController alloc] initWithRootKTViewController:[[GBMineViewController alloc] init]];
    [self.fourthRootNav setTabBar:_tabBar mainViewController:self];
    
    self.fifthRootNav = [[KTNavigationController alloc] initWithRootKTViewController:[[KTViewController alloc] init]];
    [self.fifthRootNav setTabBar:_tabBar mainViewController:self];
    
    //NOTE
    [self.view addSubview:self.firstRootNav.view];
    self.selectedTabBarControllerType = KTTabBarControllerTypeForFirst;
    [self.view bringSubviewToFront:self.tabBar];
}
#pragma mark -   KTTabBarDelegate
- (void)switchViewControllerIndex:(NSInteger)index
{
    if (index + 1001 != self.selectedTabBarControllerType) {
        switch (self.selectedTabBarControllerType) {
            case KTTabBarControllerTypeForFirst:{
                [self.firstRootNav viewWillDisappearForKTView];
                break;
            }
            case KTTabBarControllerTypeForSecond:{
                [self.secondRootNav viewWillDisappearForKTView];
                break;
            }
            case KTTabBarControllerTypeForThird:{
                [self.thirdRootNav viewWillDisappearForKTView];
                break;
            }
            case KTTabBarControllerTypeForFourth:{
                [self.fourthRootNav viewWillDisappearForKTView];
                break;
            }
            default:
                break;
        }
        KTNavigationController * nextSelectedVc = nil;
        switch (index + 1001) {
            case KTTabBarControllerTypeForFirst:{
                nextSelectedVc = self.firstRootNav;
                break;
            }
            case KTTabBarControllerTypeForSecond:{
                nextSelectedVc = self.secondRootNav;
                break;
            }
            case KTTabBarControllerTypeForThird:{
                nextSelectedVc = self.thirdRootNav;
                break;
            }
            case KTTabBarControllerTypeForFourth:{
                nextSelectedVc = self.fourthRootNav;
                [self.tabBar hiddenUpdateImageAtIndex:index];
                break;
            }
            case KTTabBarControllerTypeForFifth:{
                nextSelectedVc = self.fifthRootNav;
                break;
            }
            default:
                break;
        }
        
        
        if (![self.view.subviews containsObject:nextSelectedVc.view]) {
            [self.view addSubview:nextSelectedVc.view];
        }else{
            [self.view bringSubviewToFront:nextSelectedVc.view];
        }
        [self.view bringSubviewToFront:self.tabBar];
        self.selectedTabBarControllerType = index + 1001;
        
        [nextSelectedVc viewDidAppearForKTView];
    }
}
/**
 *  从一个Tab的n级页面跳转到另一个Tab的首页
 *
 *  @param index    KTNavigationController Tag
 *  @param animated 支持 效果/否
 */
- (void)popToKTViewControllerWithTabIndex:(NSUInteger)index animated:(BOOL)animated
{
    [self.tabBar showTabBarAtIndex:index];
    
        KTNavigationController * nextSelectedVc = nil;
        switch (index + 1001) {
            case KTTabBarControllerTypeForFirst:{
                nextSelectedVc = self.firstRootNav;
                break;
            }
            case KTTabBarControllerTypeForSecond:{
                nextSelectedVc = self.secondRootNav;
                break;
            }
            case KTTabBarControllerTypeForThird:{
                nextSelectedVc = self.thirdRootNav;
                break;
            }
            case KTTabBarControllerTypeForFourth:{
                nextSelectedVc = self.fourthRootNav;
                break;
            }
            case KTTabBarControllerTypeForFifth:{
                nextSelectedVc = self.fifthRootNav;
                break;
            }
            default:
                break;
        }
    
        if (index + 1001 == self.selectedTabBarControllerType) {
            [nextSelectedVc popToRootKTViewControllerAnimated:YES];
            
        }else{
            KTNavigationController * currentVc = nil;
            switch (self.selectedTabBarControllerType) {
                case KTTabBarControllerTypeForFirst:{
                    currentVc = self.firstRootNav;
                    break;
                }
                case KTTabBarControllerTypeForSecond:{
                    currentVc = self.secondRootNav;
                    break;
                }
                case KTTabBarControllerTypeForThird:{
                    currentVc = self.thirdRootNav;
                    break;
                }
                case KTTabBarControllerTypeForFourth:{
                    currentVc = self.fourthRootNav;
                    break;
                }
                case KTTabBarControllerTypeForFifth:{
                    currentVc = self.fifthRootNav;
                    break;
                }
                default:
                    break;
            }
            
            [nextSelectedVc popToRootKTViewControllerAnimated:YES];
            
            if ([self.view.subviews containsObject:nextSelectedVc.view]) {
                [self.view bringSubviewToFront:nextSelectedVc.view];
                [self.view bringSubviewToFront:self.tabBar];
            }else{
               
                [self.view insertSubview:nextSelectedVc.view belowSubview:self.tabBar];
            }
            [self.view bringSubviewToFront:currentVc.view];
            
            
            [self.tabBar.layer setTransform:CATransform3DMakeTranslation(-[Utils screenWidth], 0.0, 0.0)];
            [nextSelectedVc.view.layer setTransform:CATransform3DMakeTranslation(-[Utils screenWidth], 0.0, 0.0)];
            [[(KTViewController *)[currentVc.viewControllers objectAtIndex:0] view].layer setTransform:CATransform3DIdentity];
            
            [UIView
             animateWithDuration:(animated?0.3:0.0)
             delay:0.0
             options:UIViewAnimationOptionCurveEaseInOut
             animations:^{
                 currentVc.view.frame = CGRectMake(self.view.frame.size.width, currentVc.view.frame.origin.y, currentVc.view.frame.size.width, currentVc.view.frame.size.height);
                 [nextSelectedVc.view.layer setTransform:CATransform3DIdentity];
                 [self.tabBar.layer setTransform:CATransform3DIdentity];
             }
             completion:^(BOOL finished) {
                 [currentVc popToRootKTViewControllerAnimated:YES];
                 [[(KTViewController *)[currentVc.viewControllers objectAtIndex:0] view].layer setTransform:CATransform3DIdentity];
      
                 self.selectedTabBarControllerType = index + 1001;
                 [self.view bringSubviewToFront:nextSelectedVc.view];
                 [self.view bringSubviewToFront:self.tabBar];
                 
                 currentVc.view.frame = CGRectMake(0, currentVc.view.frame.origin.y, currentVc.view.frame.size.width, currentVc.view.frame.size.height);
             }];
        }
}
/**
 *  接受到推送通知后的动作事件
 *
 *  @param index KTNavigationController Tag
 */
- (void)showKTNavigationControllerForJPushWithIndex:(int)index
{
    [self.tabBar showTabBarAtIndex:index];
    [self switchViewControllerIndex:index];
    //NOTE 添加进入下一级的函数
}
/**
 *  接受到推送通知后的动作事件（用户在线）
 */
- (void)showKTNavigationControllerForJPushByOnlineWithIndex:(int)index
{
    [self.tabBar showUpdateImageAtIndex:index];
}
- (void)showSettingView
{
    
}

#pragma mark - Orientation
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
- (BOOL)shouldAutorotate
{
    KT_DLOG_SELECTOR;
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    KT_DLOG_SELECTOR;
    //    return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationLandscapeRight;
    return UIInterfaceOrientationMaskPortrait;
}

#else

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    KT_DLOG_SELECTOR;
    //    if ((orientation == UIInterfaceOrientationPortrait) ||
    //        (orientation == UIInterfaceOrientationLandscapeLeft||
    //         orientation == UIInterfaceOrientationLandscapeRight))
    if (orientation == UIInterfaceOrientationPortrait)
        return YES;
    
    return NO;
}
#endif

//将开始旋转执行
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    KT_DLOG_SELECTOR;
    KT_DLog(@"self.view.frame:%@",NSStringFromCGRect(self.view.frame));
    
}
//旋转完成后执行
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    KT_DLOG_SELECTOR;
    KT_DLog(@"self.view.frame:%@",NSStringFromCGRect(self.view.frame));
    
}

@end
