//
//  GBSearchDefaultViewCell.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-3.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "BaseCell.h"
@class GBSearchRecommendModel;

@interface GBSearchDefaultViewCell : BaseCell

- (void)reloadWithModel:(GBSearchRecommendModel *)model;

@end
