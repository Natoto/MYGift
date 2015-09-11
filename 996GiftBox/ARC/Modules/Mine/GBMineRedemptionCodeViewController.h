//
//  GBMineRedemptionCodeViewController.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-8.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "KTViewControllerWithTabBar.h"
#import "TableLoadMoreFooterView.h"
#import "TableRefreshHeaderView.h"

@interface GBMineRedemptionCodeViewController : KTViewControllerWithTabBar
<
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
TableLoadMoreFooterViewDelegate,
TableRefreshHeaderViewDelegate
>

@end
