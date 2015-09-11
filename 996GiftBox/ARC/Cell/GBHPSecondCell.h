//
//  GBHPSecondCell.h
//  GameGifts
//
//  Created by Keven on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_GB_HP_SECOND_CELL_H__
#define __KT_GB_HP_SECOND_CELL_H__
#import "BaseCell.h"

@interface GBHPSecondCell : BaseCell
KT_PROPERTY_WEAK  UIView * cellView;
KT_PROPERTY_WEAK  UIButton * leftButton;
KT_PROPERTY_WEAK  UIImageView * leftImageView;
KT_PROPERTY_WEAK  UILabel  * leftLabel;
KT_PROPERTY_WEAK  UIImageView * leftUpImageView;
KT_PROPERTY_WEAK  UIButton * rightButton;
KT_PROPERTY_WEAK  UIImageView * rightImageView;
KT_PROPERTY_WEAK  UILabel  * rightLabel;
KT_PROPERTY_WEAK UIImageView * rightUpImageView;
- (void)setupCellViewWithFirstURLString:(NSString *)firstURLString
                              firstName:(NSString *)firstName
                        secondURLString:(NSString *)secondURLString
                             secondName:(NSString *)secondName
                                    row:(NSInteger)row
                               isHeight:(BOOL)isHeight
                                 target:(id)delegate
                                 action:(SEL)action;
@end
#endif