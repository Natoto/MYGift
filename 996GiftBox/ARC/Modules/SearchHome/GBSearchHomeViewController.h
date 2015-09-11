//
//  GBSearchHomeViewController.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-2.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "KTViewControllerWithTabBar.h"
#import "GBSearchBar.h"
#import "GBSearchResultViewController.h"
#import "GBPackageReceiveViewController.h"

enum KT_KContentPanelType {
    KT_KContentPanelTypeDefaultView = 1,
    KT_KContentPanelTypeProgress = 2,
    KT_KContentPanelTypeResultTable = 3,
    KT_KContentPanelTypeEmpty = 4,
    KT_KContentPanelTypeEmptyNetwork = 5
};

enum KT_KInitType {
    KT_KInitTypeNormal = 1,
    KT_KInitTypeTMP = 2
};

typedef void(^SearchHomeWillCloseHandler)(void);
typedef void(^SearchHomeWillOpenHandler)(void);
typedef void(^SearchHomeClosingHandler)(void);
typedef void(^SearchHomeOpeningHandler)(void);
typedef void(^SearchHomeDidOpenedHandler)(void);
typedef void(^SearchHomeDidClosedHandler)(void);

@interface GBSearchHomeViewController : KTViewControllerWithTabBar
<
GBSearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate,
GBSearchResultViewControllerDelegate,
GBPackageReceiveViewControllerDelegate
>

@property (nonatomic, KT_WEAK) GBSearchBar *searchBar;

@property (nonatomic, copy) SearchHomeWillOpenHandler willOpenHandler;
@property (nonatomic, copy) SearchHomeWillCloseHandler willCloseHandler;
@property (nonatomic, copy) SearchHomeOpeningHandler openingHandler;
@property (nonatomic, copy) SearchHomeClosingHandler closingHandler;
@property (nonatomic, copy) SearchHomeDidOpenedHandler didOpenedHandle;
@property (nonatomic, copy) SearchHomeDidClosedHandler didClosedHandler;

- (id)initWithType:(enum KT_KInitType)type;

//打开搜索
- (void)open;

//关闭搜索
- (void)close;

@end
