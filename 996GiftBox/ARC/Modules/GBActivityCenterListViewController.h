//
//  GBActivityCenterListViewController.h
//  GameGifts
//
//  Created by Keven on 14-1-2.
//  Copyright (c) 2014年 Keven. All rights reserved.
//
#ifndef __KT_GB_ACTIVITY_CENTER_LIST_VIEW_CONTROLLER_H__
#define __KT_GB_ACTIVITY_CENTER_LIST_VIEW_CONTROLLER_H__
#import "KTViewControllerWithTabBar.h"
#import "TableLoadMoreFooterView.h"
#import "TableRefreshHeaderView.h"
@interface GBActivityCenterListViewController : KTViewControllerWithTabBar
<
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
TableLoadMoreFooterViewDelegate,
TableRefreshHeaderViewDelegate
>

@end
#endif