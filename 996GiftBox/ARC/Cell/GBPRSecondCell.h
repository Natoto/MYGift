//
//  GBPRSecondCell.h
//  GameGifts
//
//  Created by Keven on 14-1-6.
//  Copyright (c) 2014年 Keven. All rights reserved.
//
#ifndef __KT_BASE_PR_SECOND_Cell_H__
#define __KT_BASE_PR_SECOND_Cell_H__
#import "BaseCell.h"
#import "LineView.h"
@interface GBPRSecondCell : BaseCell
KT_PROPERTY_WEAK LineView * cellView;
KT_PROPERTY_WEAK UILabel  * titleLabel;
//type 0 title  1 content  2 time
- (void)setupCellViewWithTitleString:(NSString *)titleString type:(int)type;
@end
#endif