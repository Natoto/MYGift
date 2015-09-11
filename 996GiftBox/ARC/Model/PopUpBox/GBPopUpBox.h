//
//  GBPopUpBox.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-25.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GBPopUpBoxType) {
    
    GBPopUpBoxTypeDefault,
    GBPopUpBoxTypeProgress,
    GBPopUpBoxTypeNoNetwork,   //网络不可用
    GBPopUpBoxTypeLoadingError,//加载出错
};

@interface GBPopUpBox : UIView

@property (nonatomic, strong) NSString *message;

- (id)initWithType:(GBPopUpBoxType)type
    withAutoHidden:(BOOL)autoHidden;

- (id)initWithType:(GBPopUpBoxType)type
       withMessage:(NSString *)message
    withAutoHidden:(BOOL)autoHidden;

/**
 *
 * @abstract 默认全屏显示，透明蒙版
 *
 * @discussion
 *
 */
- (void)show;

/**
 *
 * @abstract 全屏显示，黑色半透明蒙版
 *
 * @discussion
 *
 */
- (void)showMask;

/**
 *
 * @abstract 在子View中显示，无蒙版
 *
 * @discussion 默认显示在view的中央，offset，垂直方向的位移（正数向下、负数向上）
 *
 */
- (void)showInView:(UIView *)view offset:(CGFloat)offset;

/**
 *
 * @abstract 在子View中显示，透明蒙版
 *
 * @discussion 默认显示在view的中央，offset，垂直方向的位移（正数向下、负数向上）
 *
 */
- (void)showMaskInView:(UIView *)view offset:(CGFloat)offset;

- (void)hiddenWithAnimated:(BOOL)animated;

@end
