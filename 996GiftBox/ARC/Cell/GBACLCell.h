//
//  GBACLCell.h
//  GameGifts
//
//  Created by Keven on 14-1-2.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#ifndef __KT_BASE_ACL_Cell_H__
#define __KT_BASE_ACL_Cell_H__
#import "BaseCell.h"

@interface GBACLCell : BaseCell
KT_PROPERTY_WEAK  UIView * cellView;
KT_PROPERTY_WEAK  UIImageView * backgroundImageView;
KT_PROPERTY_WEAK  UILabel * gameNameLabel;
KT_PROPERTY_WEAK  UIImageView * iconImageView;
KT_PROPERTY_WEAK  UILabel * serviceLabel;
KT_PROPERTY_WEAK  UILabel * subtitleLabel;
KT_PROPERTY_WEAK  UILabel * giftInfoLabel;
KT_PROPERTY_WEAK  UILabel * timeLabel;
KT_PROPERTY_WEAK  UILabel  * popularityLabel;

- (void)setupCellVieweWtihActivityName:(NSString *)gameName
                             URLString:(NSString *)URLString
                           serviceName:(NSString *)serviceName
                              subtitle:(NSString *)subtitle
                              giftInfo:(NSString *)giftInfo
                                  time:(NSTimeInterval)time
                       popularityCount:(NSUInteger)count;
@end
#endif