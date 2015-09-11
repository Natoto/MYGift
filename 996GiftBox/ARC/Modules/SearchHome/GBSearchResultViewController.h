//
//  GBSearchResultViewController.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-2.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableLoadMoreFooterView.h"
#import "TableRefreshHeaderView.h"

@class GBSearchModel;

@protocol GBSearchResultViewControllerDelegate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)didSelectedTableViewCellWithResultModel:(GBSearchModel *)model indexPath:(NSIndexPath*)indexPath;
- (void)dragRefreshWithKey:(NSString *)searchKey withPage:(NSInteger)page;
- (void)pushToViewController:(KTViewController *)viewController;

@end

@interface GBSearchResultViewController : UITableViewController
<
UIScrollViewDelegate,
TableLoadMoreFooterViewDelegate,
TableRefreshHeaderViewDelegate
>

@property (nonatomic, KT_WEAK) id<GBSearchResultViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *curSearchKey;

- (void)reloadWithModelArray:(NSArray *)modelArray withPageCount:(NSInteger)pageCount;

- (void)changedPackageStatusWithIndex:(NSIndexPath *)indexPath newStatus:(int)status  packageSurplus:(int)surplusCount;

@end
