//
//  GBMineCodeCell.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-8.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseDrawCell.h"
#import "GBMineGiftGroupModel.h"

@interface GBMineCodeCell : GBBaseDrawCell

- (void)reloadWithModel:(GBMineGiftGroupModel *)model
                    row:(NSInteger)row
                 target:(id)delegate
                 action:(SEL)action
              subAction:(SEL)subAction
             copyAction:(SEL)copyAction;

@end
