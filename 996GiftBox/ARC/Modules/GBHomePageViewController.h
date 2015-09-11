//
//  GBHomePageViewController.h
//  GameGifts
//
//  Created by Keven on 13-12-24.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_GB_HOME_PAGE_VIEW_CONTROLLER_H__
#define __KT_GB_HOME_PAGE_VIEW_CONTROLLER_H__
#import "KTViewControllerWithBar.h"
#import "TableRefreshHeaderView.h"
#import "GBPackageReceiveViewController.h"
@interface GBHomePageViewController : KTViewControllerWithBar
<
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
TableRefreshHeaderViewDelegate,
GBPackageReceiveViewControllerDelegate
>


@end

#endif



