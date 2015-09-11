//
//  UIViewController+BuildMBProgressHUD.m
//  WhoisSearch
//
//  Created by 曾克兵 on 13-10-17.
//  Copyright (c) 2013年 kevenTsang. All rights reserved.
//

#import "UIViewController+BuildMBProgressHUD.h"
#import "objc/runtime.h"
#import "GBAppDelegate.h"
static const void * HUDIndentiferKey = & HUDIndentiferKey;
@implementation UIViewController (BuildMBProgressHUD)
//*******************************************

- (GBAppDelegate *)getAppDelegate
{
    return (GBAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (KTProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, HUDIndentiferKey);
}
- (void)setHUD:(KTProgressHUD *)HUD
{
    objc_setAssociatedObject(self, HUDIndentiferKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark -Build HUD

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view delegate:[self getAppDelegate] mode:mode labelText:labelText];
}

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view delegate:[self getAppDelegate]  mode:mode labelText:labelText];
    [self.HUD show:animatedOfShow];
}

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow isScaleTransform:(BOOL)isScaleTransform
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view delegate:[self getAppDelegate]  mode:mode labelText:labelText];
    self.HUD.isScaleTransform = isScaleTransform;
    [self.HUD show:animatedOfShow];
}

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view delegate:[self getAppDelegate]  mode:mode labelText:labelText];
    [self.HUD show:animatedOfShow];
    [self.HUD hide:animatedOfHide afterDelay:seconds];
}

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds isScaleTransform:(BOOL)isScaleTransform
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view delegate:[self getAppDelegate]  mode:mode labelText:labelText];
    self.HUD.isScaleTransform = isScaleTransform;
    [self.HUD show:animatedOfShow];
    [self.HUD hide:animatedOfHide afterDelay:seconds];
}

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view delegate:[self getAppDelegate]  mode:mode labelText:nil];
}

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view delegate:[self getAppDelegate] mode:mode labelText:nil];
    [self.HUD show:animatedOfShow];
}

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow isScaleTransform:(BOOL)isScaleTransform
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view delegate:[self getAppDelegate]  mode:mode labelText:nil];
    self.HUD.isScaleTransform = isScaleTransform;
    [self.HUD show:animatedOfShow];
}

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view delegate:[self getAppDelegate]  mode:mode labelText:nil];
    [self.HUD show:animatedOfShow];
    [self.HUD hide:animatedOfHide afterDelay:seconds];
}

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds isScaleTransform:(BOOL)isScaleTransform
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view delegate:[self getAppDelegate]  mode:mode labelText:nil];
    self.HUD.isScaleTransform = isScaleTransform;
    [self.HUD show:animatedOfShow];
    [self.HUD hide:animatedOfHide afterDelay:seconds];
}


- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view frame:frame delegate:[self getAppDelegate]  mode:mode labelText:labelText];
}

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view frame:frame delegate:[self getAppDelegate]  mode:mode labelText:labelText];
    [self.HUD show:animatedOfShow];
}

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow isScaleTransform:(BOOL)isScaleTransform
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view frame:frame delegate:[self getAppDelegate]  mode:mode labelText:labelText];
    self.HUD.isScaleTransform = isScaleTransform;
    [self.HUD show:animatedOfShow];
}

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view frame:frame delegate:[self getAppDelegate]  mode:mode labelText:labelText];
    [self.HUD show:animatedOfShow];
    [self.HUD hide:animatedOfHide afterDelay:seconds];
}

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds isScaleTransform:(BOOL)isScaleTransform
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view frame:frame delegate:[self getAppDelegate]  mode:mode labelText:labelText];
    self.HUD.isScaleTransform = isScaleTransform;
    [self.HUD show:animatedOfShow];
    [self.HUD hide:animatedOfHide afterDelay:seconds];
}

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view frame:frame delegate:[self getAppDelegate]  mode:mode labelText:nil];
}

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view frame:frame delegate:[self getAppDelegate] mode:mode labelText:nil];
    [self.HUD show:animatedOfShow];
}

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow isScaleTransform:(BOOL)isScaleTransform
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view frame:frame delegate:[self getAppDelegate]  mode:mode labelText:nil];
    self.HUD.isScaleTransform = isScaleTransform;
    [self.HUD show:animatedOfShow];
}

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view frame:frame delegate:[self getAppDelegate]  mode:mode labelText:nil];
    [self.HUD show:animatedOfShow];
    [self.HUD hide:animatedOfHide afterDelay:seconds];
}

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds isScaleTransform:(BOOL)isScaleTransform
{
    if (self.HUD) {
        [self.HUD hide:YES];
    }
    self.HUD = [[KTProgressHUD alloc] initWithSuperView:view frame:frame delegate:[self getAppDelegate]  mode:mode labelText:nil];
    self.HUD.isScaleTransform = isScaleTransform;
    [self.HUD show:animatedOfShow];
    [self.HUD hide:animatedOfHide afterDelay:seconds];
}
//*******************************************

- (void)hideHUD
{
    if(self.HUD) {[self.HUD hide:YES];}
}

@end
