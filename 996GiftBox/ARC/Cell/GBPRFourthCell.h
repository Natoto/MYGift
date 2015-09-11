//
//  GBPRFourthCell.h
//  GameGifts
//
//  Created by Keven on 14-1-6.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "BaseCell.h"

@interface GBPRFourthCell : BaseCell
KT_PROPERTY_WEAK LineView * cellView;
KT_PROPERTY_WEAK UIImageView * iconImageView;
KT_PROPERTY_WEAK UILabel   * gameNameLabel;
KT_PROPERTY_WEAK UILabel   * serviceNameLabel;
KT_PROPERTY_WEAK UILabel   * statusLabel;
KT_PROPERTY_WEAK UILabel   * giftCodeLabel;
KT_PROPERTY_WEAK UIButton  * pressedButton;
- (void)setupCellViewWithURLString:(NSString *)URLString
                          gameName:(NSString *)gameName
                       serviceName:(NSString *)serviceName
                    giftCodeString:(NSString *)giftCode
                            status:(GetGiftStatus)status;
@end
