//
//  GBHPFirstCell.h
//  GameGifts
//
//  Created by Keven on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_GB_HP_FIRST_CELL_H__
#define __KT_GB_HP_FIRST_CELL_H__
#import "BaseCell.h"

@interface GBHPFirstCell : BaseCell
KT_PROPERTY_WEAK  UIView * cellView;
KT_PROPERTY_WEAK  UILabel * titleLabel;
KT_PROPERTY_WEAK  UIButton * titleBt;
- (void)setupCellViewWithTitleString:(NSString *)title
                         buttonTitle:(NSString *)buttonTitle
                    buttonTitleColor:(UIColor *)buttonTitleColor
                                 row:(NSInteger)row
                        buttonHidden:(BOOL)hidden
                              target:(id)delegate
                        buttonAction:(SEL)action;
@end
#endif