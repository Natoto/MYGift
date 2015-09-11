//
//  GBHPThirdCell.h
//  GameGifts
//
//  Created by Keven on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_GB_HP_THIRD_CELL_H__
#define __KT_GB_HP_THIRD_CELL_H__
#import "BaseCell.h"
@interface GBHPThirdCell : BaseCell
KT_PROPERTY_WEAK  UIView * cellView;
KT_PROPERTY_WEAK  UIImageView * backgroundImageView;
KT_PROPERTY_WEAK  UILabel * gameNameLabel;
KT_PROPERTY_WEAK  UIImageView * iconImageView;
KT_PROPERTY_WEAK  UILabel * serviceLabel;
KT_PROPERTY_WEAK  UILabel * giftNameLabel;
KT_PROPERTY_WEAK  UILabel * timeLabel;
KT_PROPERTY_WEAK  UILabel * countLabel;
KT_PROPERTY_WEAK  UIButton * pressedButton;
KT_PROPERTY_ASSIGN GetGiftStatus status;

- (void)setupCellVieweWtihGameName:(NSString *)gameName
                         URLString:(NSString *)URLString
                       serviceName:(NSString *)serviceName
                          giftName:(NSString *)gitfName
                       releaseTime:(NSTimeInterval)time
                      packageCount:(NSUInteger)count
                               row:(NSUInteger)row
                           isFirst:(BOOL)isFirst
                        giftStatus:(GetGiftStatus)giftStatus
                            target:(id)delegate
                            action:(SEL)action;
@end
#endif