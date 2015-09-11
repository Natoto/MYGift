//
//  GBOpenServiceTableViewController.h
//  GameGifts
//
//  Created by Keven on 14-2-13.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableLoadMoreFooterView.h"
#import "TableRefreshHeaderView.h"
#import "GBDefaultReqeust.h"
#import "GBDefaultResponse.h"
#import "GBOpenServiceAndTestChartModel.h"
#import "GBNoDataShowView.h"
@protocol GBOpenServiceTableViewControllerDelegate <NSObject>
- (void)openGift:(GBOpenServiceAndTestChartModel *)model;
@end

@interface GBOpenServiceTableViewController : UITableViewController
<
UITableViewDataSource,
UITableViewDelegate,
TableLoadMoreFooterViewDelegate,
TableRefreshHeaderViewDelegate,
GBNoDataShowViewDelegate
>
@property (nonatomic,assign)id<GBOpenServiceTableViewControllerDelegate> delegate;
@property (nonatomic,assign)int tableViewType;
@property (nonatomic,strong)TableLoadMoreFooterView * loadMoreFooterView;
@property (nonatomic,strong)TableRefreshHeaderView * refreshHeaderView;
@property (nonatomic,strong)GBRequestForKT * request;
// 1 == YES， 2==NO；
- (id)initWithStyle:(UITableViewStyle)style  isOpenService:(int)flag;

- (void)refreshDataFromServer;

@end
