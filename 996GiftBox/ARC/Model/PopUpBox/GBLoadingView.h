//
//  GBLoadingView.h
//  GameGifts
//
//  Created by Teiron-37 on 14-2-12.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBLoadingView : UIView

/**
 *
 * @abstract 在子View中显示，无蒙版
 *
 * @discussion 默认显示在view的中央，offset，垂直方向的位移（正数向下、负数向上）
 *
 */
- (void)showInView:(UIView *)view offset:(CGFloat)offset;

- (void)hidden;

@end
