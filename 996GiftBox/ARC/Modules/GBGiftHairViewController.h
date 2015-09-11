//
//  GBGiftHairViewController.h
//  GameGifts
//
//  Created by Keven on 14-1-6.
//  Copyright (c) 2014年 Keven. All rights reserved.
//
#ifndef __KT_GB_GIFT_HAIR_VIEW_CONTROLLER_H__
#define __KT_GB_GIFT_HAIR_VIEW_CONTROLLER_H__
#import "KTViewControllerWithTabBar.h"
#import "TableLoadMoreFooterView.h"
#import "TableRefreshHeaderView.h"
#import "GBPackageReceiveViewController.h"
@interface GBGiftHairViewController : KTViewControllerWithTabBar
<
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
TableLoadMoreFooterViewDelegate,
TableRefreshHeaderViewDelegate,
GBPackageReceiveViewControllerDelegate
>
@end
#endif