//
//  TableLoadMoreFooterView.h
//  AppMaster
//
//  Created by Danny on 13-6-26.
//  Copyright (c) 2013年 GuangZhou YiYou Information Technology Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIPagingDeviceView.h"

typedef enum {
	TableLoadMoreFooterViewNormal,
	TableLoadMoreFooterViewLoading,	
} TableLoadMoreFooterViewState;


@class TableLoadMoreFooterView;
@protocol TableLoadMoreFooterViewDelegate
- (void)loadMoreActionTriggered:(TableLoadMoreFooterView*)loadMoreView;
@end


@interface TableLoadMoreFooterView : UIView
{
	TableLoadMoreFooterViewState _state;
}

@property (nonatomic, KT_WEAK)  UIButton *triggerButton;
@property (nonatomic, KT_WEAK)  UIPagingDeviceView *activityView;
@property (nonatomic, KT_WEAK) IBOutlet UILabel *statusLabel;
@property (nonatomic,assign) id<TableLoadMoreFooterViewDelegate> delegate;
@property (nonatomic,KT_WEAK) UIScrollView* owner;
@property (nonatomic,assign) double ownerInsetBottomDefaultHeight;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) BOOL isEnable;
@property (nonatomic,KT_WEAK)NSTimer * indicatorTimer;


+ (TableLoadMoreFooterView*)footerViewWithOwner:(UIScrollView*)_scrollView delegate:(id<TableLoadMoreFooterViewDelegate>)_delegate;
+ (TableLoadMoreFooterView*)footerViewWithOwner:(UIScrollView*)_scrollView delegate:(id<TableLoadMoreFooterViewDelegate>)_delegate ownerInsetBottomDefaultHeight:(double)ownerInsetBottomDefaultHeight;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)didFinishedLoading:(UIScrollView *)scrollView;
- (void)setEnable:(BOOL)_enable;
- (void)hiddedFooterView:(BOOL)flag;
@end

