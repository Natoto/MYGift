//
//  GBPRThirdCell.h
//  GameGifts
//
//  Created by Keven on 14-1-6.
//  Copyright (c) 2014年 Keven. All rights reserved.
//
#ifndef __KT_BASE_PR_THIRD_Cell_H__
#define __KT_BASE_PR_THIRD_Cell_H__
#import "BaseCell.h"
#import "LineView.h"
@interface GBPRThirdCell : BaseCell
KT_PROPERTY_WEAK LineView * cellView;
KT_PROPERTY_WEAK UILabel  * contentLabel;

- (void)setupCellViewWithContentString:(NSString *)content  contentHeight:(CGFloat)contentHeight;

@end
#endif