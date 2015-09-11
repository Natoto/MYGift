//
//  GBBaseDrawCell.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-10.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GBBaseDrawCell;

@interface GBBaseDrawCellView : UIView

@property (nonatomic, KT_WEAK) GBBaseDrawCell *contentCell;

@end

@interface GBBaseDrawCell : UITableViewCell

@property (nonatomic, KT_WEAK) GBBaseDrawCellView *contentView1;

/*
 * @abstract渲染cell内容
 *
 * @discussion
 * 子类覆盖
 *
 */
- (void)drawContentView:(CGRect)rect;

@end
