//
//  GBOpenServiceViewController.h
//  GameGifts
//
//  Created by Keven on 13-12-24.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_GB_OPEN_SERVICE_VIEW_CONTROLLER_H__
#define __KT_GB_OPEN_SERVICE_VIEW_CONTROLLER_H__

#import "KTViewControllerWithBar.h"
#import "GBOpenServiceTableViewController.h"
@interface GBOpenServiceViewController : KTViewControllerWithBar
<
UIScrollViewDelegate,
GBOpenServiceTableViewControllerDelegate
>
@end
#endif