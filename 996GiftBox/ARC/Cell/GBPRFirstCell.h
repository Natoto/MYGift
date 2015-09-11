//
//  GBPRFirstCell.h
//  GameGifts
//
//  Created by Keven on 14-1-3.
//  Copyright (c) 2014年 Keven. All rights reserved.
//
#ifndef __KT_BASE_PR_FIRST_Cell_H__
#define __KT_BASE_PR_FIRST_Cell_H__
#import "BaseCell.h"
#import "LineView.h"

@interface GBPRFirstCell : BaseCell
KT_PROPERTY_WEAK LineView * cellView;
KT_PROPERTY_WEAK UIImageView * iconImageView;
KT_PROPERTY_WEAK UILabel   * gameNameLabel;
KT_PROPERTY_WEAK UILabel   * serviceNameLabel;
KT_PROPERTY_WEAK UILabel   * giftNameLabel;
KT_PROPERTY_WEAK UILabel   * giftSurplusLabel;
KT_PROPERTY_WEAK UIImageView * giftShowImageView;
KT_PROPERTY_WEAK UIButton  *  pressedButton;

- (void)setupCellViewWithURLString:(NSString *)URLString
                          gameName:(NSString *)gameName
                       serviceName:(NSString *)serviceName
                          giftName:(NSString *)giftName
                      surplusCount:(NSUInteger)surplusCount
                          allCount:(NSUInteger)allCount
                            status:(GetGiftStatus)staus
                            target:(id)delegate
                            action:(SEL)action;
@end
#endif