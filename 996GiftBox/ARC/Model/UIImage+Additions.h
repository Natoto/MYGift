//
//  UIImage+Additions.h
//  GameGifts
//
//  Created by Teiron-37 on 14-2-25.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

/**
 *
 * 图片截取
 *
 */
- (UIImage *)clipToFrame:(CGRect)rect;

/**
 *
 * 图片拼接
 *
 */
- (UIImage *)spliceImage:(UIImage *)image withSize:(CGSize)size;

@end
