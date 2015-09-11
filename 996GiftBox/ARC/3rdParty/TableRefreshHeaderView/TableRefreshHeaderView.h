//
//  TableRefreshHeaderView.h
//  996GameBox
//
//  Created by keven on 13-11-29.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
	KTPullRefreshPulling = 0,
	KTPullRefreshNormal,
	KTPullRefreshLoading,
} KTPullRefreshState;

@class TableRefreshHeaderView;
@protocol TableRefreshHeaderViewDelegate
@optional
- (void)refreshActionTriggered:(TableRefreshHeaderView *)refreshView;
@end

@interface TableRefreshHeaderView : UIView
{

}
@property (nonatomic,KT_WEAK)UIView  * mainContentView;
@property (nonatomic,assign)id<TableRefreshHeaderViewDelegate>delegate;
@property (nonatomic,KT_WEAK) UIScrollView *owner;

+ (TableRefreshHeaderView*)headerViewWithOwner:(UIScrollView*)_scrollView delegate:(id<TableRefreshHeaderViewDelegate>)_delegate   addNavigationBArHeight:(BOOL)flag;
- (void)tableRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)tableRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
//- (void)triggerRefreshManuallyWithScrollView:(UIScrollView *)scrollView; //自动下拉一次
- (void)tableRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
@end
