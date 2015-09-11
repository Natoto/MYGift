//
//  KTNavigationController.m
//  996Test
//
//  Created by Keven on 14-1-16.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "KTNavigationController.h"
#import "KTTabBar.h"
#import "KTMainViewController.h"
#define DRAWER_MINIMUM_ANIMATION_DURATION  0.3  //在mainViewController 还有一个0.3
#define GB_DRAWER_DEFAULT_WIDTH       320
@interface KTNavigationController ()
//@property (nonatomic,weak)   UIView                 * rootView;
//@property (nonatomic,weak)   UIView                 * mainView;
@property (nonatomic,weak)KTMainViewController      * mainViewController;
@property (nonatomic,weak)   KTTabBar               * tabBar;
@property (nonatomic,assign) CGRect                   subViewFrame;

@property (nonatomic,strong) NSMutableArray   * viewControllers;
@property (nonatomic,strong) KTViewController * selectedViewController;
@property (nonatomic,assign) NSUInteger         selectedIndex;
@end

@implementation KTNavigationController

- (id)initWithRootKTViewController:(KTViewController *)rootViewController
{
    self = [super init];
    if (self) {
        self.viewControllers = [[NSMutableArray alloc] init];
        rootViewController.KTNavigationController = self;
        self.selectedViewController = rootViewController;
        [self.viewControllers addObject:self.selectedViewController];
        self.selectedIndex = 0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.selectedViewController.view];
    CGRect viewRect = self.selectedViewController.view.bounds;
    viewRect.origin.x = [Utils screenWidth];
    _subViewFrame = viewRect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTabBar:(KTTabBar *)tabBar  mainViewController:(KTMainViewController *)vc
{
    _tabBar = tabBar;
    _mainViewController = vc;
}
- (void)setTabBar:(KTTabBar *)tabBar
{
    _tabBar = tabBar;
}

#pragma mark - PUSH
- (void)pushKTViewController:(KTViewController *)viewController animated:(BOOL)animated
{
    __KT_WEAK KTViewController * previousViewController = self.selectedViewController;
    viewController.KTNavigationController = self;
    viewController.view.frame = _subViewFrame;
    [self.view addSubview:viewController.view];
    /**
     *  视图的显示和消失
     */
    [viewController viewWillAppearForKTView];
    [self viewWillDisappearForKTView];
    
    [UIView
     animateWithDuration:(animated?DRAWER_MINIMUM_ANIMATION_DURATION:0.0)
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         CGRect viewRect = self.subViewFrame;
         viewRect.origin.x = 0;
         viewController.view.frame = viewRect;
         CATransform3D transform;
         transform = CATransform3DMakeTranslation(- GB_DRAWER_DEFAULT_WIDTH, 0.0, 0.0);
         [previousViewController.view.layer setTransform:transform];
         if (_selectedIndex == 0) {
             [_tabBar.layer setTransform:transform];
         }
     }
     completion:^(BOOL finished) {
         
         /**
          *  视图的显示和消失
          */
         [viewController viewDidAppearForKTView];
         [self viewDidDisappearForKTView];
         
         
         [self.viewControllers addObject:viewController];
         self.selectedViewController = viewController;
         self.selectedIndex = self.viewControllers.count - 1;
     }];
}

#pragma mark - POP
- (void)popKTViewControllerAnimated:(BOOL)animated
{
    
    if (_selectedIndex <= 0) {
        return;
    }
    __KT_WEAK KTViewController * previousViewController = (KTViewController *)[self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    __KT_WEAK KTViewController * disAppearViewController = self.selectedViewController;
    /**
     *  视图的显示和消失
     */
    [disAppearViewController viewWillDisappearForKTView];
    [previousViewController viewWillAppearForKTView];

        [UIView
         animateWithDuration:(animated?DRAWER_MINIMUM_ANIMATION_DURATION:0.0)
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             disAppearViewController.view.frame = self.subViewFrame;
             [previousViewController.view.layer  setTransform:CATransform3DIdentity];
             if (_selectedIndex == 1) {
                 [_tabBar.layer setTransform:CATransform3DIdentity];
             }
         }
         completion:^(BOOL finished) {
             
             /**
              *  视图的显示和消失
              */
             [disAppearViewController viewDidDisappearForKTView];
             [previousViewController viewDidAppearForKTView];
             
             [self.selectedViewController.view removeFromSuperview];
             [self.viewControllers removeLastObject];
             self.selectedViewController = [self.viewControllers lastObject];
             self.selectedIndex = self.viewControllers.count - 1;
         }];
}
- (void)popToKTViewController:(KTViewController *)viewController animated:(BOOL)animated
{
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == NSNotFound) {//pop至的ViewController不在当前viewControllers队列中,pop动作无效
        return;
    }
    if (viewController == self.selectedViewController) {//pop至的ViewController与当前ViewController相同，pop动作无效
        return;
    }
    if (self.viewControllers.count <=1) {//只有1个ViewController,pop动作无效
        return;
        
    }else if (self.viewControllers.count == 2) {//只有2个ViewController，相当于popViewController
        [self popKTViewControllerAnimated:animated];
    }else {
        for (int i = index + 1; i < [self.viewControllers count] - 1; i++) {
            @autoreleasepool {
                KTViewController * vc = [self.viewControllers objectAtIndex:i];
                [vc.view removeFromSuperview];
                [self.viewControllers removeObjectAtIndex:i];
            }
        }
        self.selectedIndex = self.viewControllers.count - 1;
        [self popKTViewControllerAnimated:animated];
    }


}
- (void)popToRootKTViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count <=1) {
        return;
    }else {
        for (int i = 1; i < [self.viewControllers count] - 1; i++) {
            @autoreleasepool {
                KTViewController * vc = [self.viewControllers objectAtIndex:i];
                [vc.view removeFromSuperview];
                [self.viewControllers removeObjectAtIndex:i];
            }
        }
        self.selectedIndex = self.viewControllers.count-1;
    }
    
    [self popKTViewControllerAnimated:animated];
}

- (void)popToKTViewControllerWithTabIndex:(NSUInteger)index animated:(BOOL)animated
{
    [_mainViewController popToKTViewControllerWithTabIndex:index animated:animated];
}

@end



static const void * KTNavigationControllerKey = &KTNavigationControllerKey;
@implementation KTViewController (KTNavigationControllerItem)
- (KTNavigationController *)KTNavigationController
{
    return objc_getAssociatedObject(self, KTNavigationControllerKey);
}
- (void)setKTNavigationController:(KTNavigationController *)KTNavigationController
{
    objc_setAssociatedObject(self, KTNavigationControllerKey, KTNavigationController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end