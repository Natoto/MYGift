//
//  TableLoadMoreFooterView.m
//  AppMaster
//
//  Created by Danny on 13-6-26.
//  Copyright (c) 2013年 GuangZhou YiYou Information Technology Co., Ltd. All rights reserved.
//



#import "TableLoadMoreFooterView.h"
#define  LoadMoreViewHeight 44.0f

@interface TableLoadMoreFooterView (Private)
- (void)setState:(TableLoadMoreFooterViewState)aState;
@end

@implementation TableLoadMoreFooterView

@synthesize delegate=_delegate;
@synthesize isLoading;
@synthesize isEnable;
@synthesize owner;
- (void)hiddedFooterView:(BOOL)flag
{
    self.hidden = flag;
}
- (void)setEnable:(BOOL)_enable
{
    self.isEnable = _enable;
    if (owner == nil) {
        KT_DLog(@"owner == nil");
    } else {
        KT_DLog(@"owner != nil");
    }
    [self setState:TableLoadMoreFooterViewNormal];
    if (self.isEnable) {
        owner.contentInset = UIEdgeInsetsMake(owner.contentInset.top, owner.contentInset.left, self.ownerInsetBottomDefaultHeight + LoadMoreViewHeight, owner.contentInset.right);
        self.hidden = NO;
    } else {
        owner.contentInset = UIEdgeInsetsMake(owner.contentInset.top, owner.contentInset.left, self.ownerInsetBottomDefaultHeight + 0.0, owner.contentInset.right);
        self.hidden = YES;
    }
    self.frame = CGRectMake(0.0f, owner.contentSize.height, self.frame.size.width, LoadMoreViewHeight);
}

+ (TableLoadMoreFooterView*)footerViewWithOwner:(UIScrollView*)_scrollView delegate:(id<TableLoadMoreFooterViewDelegate>)_delegate
{
    
    __autoreleasing TableLoadMoreFooterView *view = [[TableLoadMoreFooterView alloc] initWithFrame:CGRectMake(0.0f, _scrollView.contentSize.height, 320, LoadMoreViewHeight)];
    view.delegate = _delegate;
    view.owner = _scrollView;
    view.ownerInsetBottomDefaultHeight = 0.0f;
    [view doSetup];

    [_scrollView addSubview:view];
    _scrollView.contentInset = UIEdgeInsetsMake(_scrollView.contentInset.top, _scrollView.contentInset.left, LoadMoreViewHeight, _scrollView.contentInset.right);
    
    return view;
}

+ (TableLoadMoreFooterView*)footerViewWithOwner:(UIScrollView*)_scrollView delegate:(id<TableLoadMoreFooterViewDelegate>)_delegate ownerInsetBottomDefaultHeight:(double)ownerInsetBottomDefaultHeight
{
      __autoreleasing TableLoadMoreFooterView *view = [[TableLoadMoreFooterView alloc] initWithFrame:CGRectMake(0.0f, _scrollView.contentSize.height, 320, LoadMoreViewHeight)];
    view.delegate = _delegate;
    view.owner = _scrollView;
    view.ownerInsetBottomDefaultHeight = ownerInsetBottomDefaultHeight;
    [view doSetup];
    
    [_scrollView addSubview:view];
    _scrollView.contentInset = UIEdgeInsetsMake(_scrollView.contentInset.top, _scrollView.contentInset.left, ownerInsetBottomDefaultHeight + LoadMoreViewHeight, _scrollView.contentInset.right);
    
    return view;
}

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame: frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithRed:0xFC/255.0 green:0xFC/255.0 blue:0xFC/255.0 alpha:1];;
        self.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
        //创建TableLoadMoreFooterView
        [self setupLoadMoreFooterView];
    }
    return self;
}

//创建TableLoadMoreFooterView
- (void)setupLoadMoreFooterView
{
    //先添加可以点击的Button
    UIButton * moreLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreLoadButton.frame = self.bounds;
    [moreLoadButton setTitle:@"点击加载更多..." forState:UIControlStateNormal];
    [moreLoadButton setTitleColor:[UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1] forState:UIControlStateNormal];
    moreLoadButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [moreLoadButton addTarget:self action:@selector(triggerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreLoadButton];
    self.triggerButton = moreLoadButton;
    //在添加旋转的View
    UIPagingDeviceView * indicatorViewTmp = [[UIPagingDeviceView alloc] initWithOrigin:CGPointMake(130, 18)
                                                                           pointNumber:3
                                                                              spacingX:0
                                                                                  type:UIPagingDeviceViewTypeBlue];
    [self addSubview:indicatorViewTmp];
    self.activityView = indicatorViewTmp;
    indicatorViewTmp.hidden = YES;
    
    //正在加载的Label
    UILabel * statusLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(134, 12, 75, 20)];
    statusLabelTmp.backgroundColor = [UIColor clearColor];
    statusLabelTmp.text = @"正在加载...";
    statusLabelTmp.textAlignment = 1;
    statusLabelTmp.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
    statusLabelTmp.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:statusLabelTmp];
    statusLabelTmp.hidden = YES;
    self.statusLabel = statusLabelTmp;

}

- (void)doSetup
{
    self.isLoading = NO;
    self.isEnable = YES;
    [self setState:TableLoadMoreFooterViewNormal];
    
    [self.triggerButton addTarget:self action:@selector(triggerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)triggerButtonPressed:(UIButton *)sender
{
    if (!self.isLoading && self.isEnable) {
        [UIView animateWithDuration:0.15f animations:^{
            owner.contentInset = UIEdgeInsetsMake(owner.contentInset.top, owner.contentInset.left, self.ownerInsetBottomDefaultHeight+ LoadMoreViewHeight, owner.contentInset.right);
        } completion:^(BOOL finished) {
            if (finished) {
                [self setState:TableLoadMoreFooterViewLoading];                
                if ([((NSObject *)self.delegate) respondsToSelector:@selector(loadMoreActionTriggered:)]) {
                    self.isLoading = YES;
                    [_delegate loadMoreActionTriggered:self];
                }
            }

        }];
    }
}
//NOTE 在下拉刷新的情况，点击更多隐藏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    
}

#pragma mark -
#pragma mark Setters
- (void)setState:(TableLoadMoreFooterViewState)aState{
	
	switch (aState) {
		case TableLoadMoreFooterViewNormal:
			self.isLoading = NO;
            self.triggerButton.hidden = NO;
            self.activityView.hidden = YES;
            self.statusLabel.hidden = YES;
			[self stopAnimating];
			break;
		case TableLoadMoreFooterViewLoading:
            self.isLoading = YES;
            self.triggerButton.hidden = YES;
            self.activityView.hidden = NO;
            self.statusLabel.hidden = NO;
			[self startAnimating];

			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)stopAnimating
{
    if ([self.indicatorTimer isValid]) {
        [self.indicatorTimer invalidate];
    }

}
- (void)startAnimating
{
    //NOTE NSTimer
    self.indicatorTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                           target:self
                                                         selector:@selector(beginDidScroll)
                                                         userInfo:nil
                                                          repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.indicatorTimer forMode:NSRunLoopCommonModes];
    [self.indicatorTimer fire];
}
- (void)beginDidScroll
{
    int index = self.activityView.selectedIndex + 1;
    if (index >= self.activityView.allPointNumber) {
        index = 0;
    }
    
    [self.activityView changePageNumberHightLightedIndex:index];
}

#pragma mark -
#pragma mark ScrollView Methods


//当开发者页面页面刷新完毕调用此方法，[delegate didFinishedLoading: scrollView];
- (void)didFinishedLoading:(UIScrollView *)scrollView
{
	KT_DLog(@"%@", NSStringFromSelector(_cmd));
    if (self.isEnable) {
        [UIView animateWithDuration:0.20 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, self.ownerInsetBottomDefaultHeight+ LoadMoreViewHeight, scrollView.contentInset.right);
            
        } completion:^(BOOL finished) {
            if (finished) {
                self.frame = CGRectMake(0.0f, scrollView.contentSize.height, scrollView.frame.size.width, LoadMoreViewHeight);
                [self setState:TableLoadMoreFooterViewNormal];
            }
        }];        
    }
}


#pragma mark - Dealloc
- (void)dealloc
{
    //
}

@end
