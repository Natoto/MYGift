//
//  UIViewController+BuildMBProgressHUD.h
//  WhoisSearch
//
//  Created by 曾克兵 on 13-10-17.
//  Copyright (c) 2013年 kevenTsang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTProgressHUD.h"
@interface UIViewController (BuildMBProgressHUD)
@property (nonatomic, strong) KTProgressHUD *HUD;
- (GBAppDelegate *)getAppDelegate;
- (void)hideHUD;
#pragma mark -Build HUD

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText;

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow;

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow isScaleTransform:(BOOL)isScaleTransform;

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds;

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds isScaleTransform:(BOOL)isScaleTransform;
- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode;

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow;
- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow isScaleTransform:(BOOL)isScaleTransform;

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds;

- (void)buildHUDWithView:(UIView *)view mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds isScaleTransform:(BOOL)isScaleTransform;

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText;
- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow;

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow isScaleTransform:(BOOL)isScaleTransform;

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds;

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode labelText:(NSString *)labelText show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds isScaleTransform:(BOOL)isScaleTransform;

- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode;
- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow;
- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow isScaleTransform:(BOOL)isScaleTransform;
- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds;
- (void)buildHUDWithView:(UIView *)view frame:(CGRect)frame mode:(KTProgressHUDMode)mode show:(BOOL)animatedOfShow hide:(BOOL)animatedOfHide hideAfterDelay:(CGFloat)seconds isScaleTransform:(BOOL)isScaleTransform;
//*******************************************

@end
