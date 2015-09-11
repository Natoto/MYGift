//
//  GBOSCell.h
//  GameGifts
//
//  Created by Keven on 14-1-7.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#ifndef __KT_BASE_OS_Cell_H__
#define __KT_BASE_OS_Cell_H__
#import "BaseCell.h"
#import "GBStarsView.h"
@interface GBOSCell : BaseCell
KT_PROPERTY_WEAK UIView * cellView;
KT_PROPERTY_WEAK UIImageView * iconImageView;
KT_PROPERTY_WEAK UILabel * gameNameLabel;
KT_PROPERTY_WEAK GBStarsView * starView;
KT_PROPERTY_WEAK UILabel * timeLabel;
KT_PROPERTY_WEAK UIButton * pressedButton;
KT_PROPERTY_WEAK UILabel * betaLabel;//内测
KT_PROPERTY_WEAK UILabel * typeLabel;
//tableType 1 开服，2 测试
- (void)setupCellViewWithURLString:(NSString *)URLString
                          gameName:(NSString *)gameName
                      scorceNumber:(int)scorceNumber
                          betaTime:(double)time
                           hasGift:(BOOL)hasGift
                        betaString:(NSString *)betaString
                        typeString:(NSString *)typeString
                         tableType:(int)tableType
                               row:(int)row
                            target:(id)delegate
                            action:(SEL)action;
@end
#endif