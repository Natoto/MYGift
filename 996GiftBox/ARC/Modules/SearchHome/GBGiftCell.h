//
//  GBGiftCell.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-3.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "BaseCell.h"
@class GBSearchModel;

@interface GBGiftCell : BaseCell

- (void)reloadWithModel:(GBSearchModel *)giftModel
                    row:(NSUInteger)row
                 target:(id)delegate
                 action:(SEL)action;

@end
