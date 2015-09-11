//
//  TableRefreshHeaderView.m
//  996GameBox
//
//  Created by keven on 13-11-29.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "TableRefreshHeaderView.h"
#import "KTLoadingIndicator.h"
#import "KTLogoView.h"
#define TABLEREFRESHHEADERVIEW_HEIGHT_FOR_REFRESH 65.0f
#define TABLEREFRESHHEADERVIEW_SCROLL_VIEW_INSET_ANIMATION_DURATION 0.30f


#define TABLE_REFRESH_HEADER_VIEW_STATUES_LABEL_HEIGHT 20.0f
#define TABLE_REFRESH_HEADER_VIEW_STATUES_LABEL_WIDTH  75.0f

#define TABLE_REFRESH_HEADER_VIEW_IMAGE_SIZE_WIDTH    18.0f
#define TABLE_REFRESH_HEADER_VIEW_IMAGE_SIZE_HEIGHT   21.0f
#define TABLE_REFRESH_HEADER_VIEW_LOGO_SPACEING       14.0f

@interface TableRefreshHeaderView()
@property (nonatomic ,KT_WEAK)KTLogoView * logoView;
@property (nonatomic ,assign)KTPullRefreshState state;
@property (nonatomic ,assign)BOOL isLoading;
@property (nonatomic ,assign)BOOL ignoreScrollAction;
@property (nonatomic ,KT_WEAK)UILabel * statusLabel;
//@property (nonatomic ,KT_WEAK)KTLoadingIndicatorOver  * indicatorView;
@property (nonatomic ,KT_WEAK)UIImageView * rotationImageView;
@property (nonatomic ,strong)NSTimer     * rotationTimer;
@property (nonatomic,assign)CGFloat        rotationNumber;

- (void)setState:(KTPullRefreshState)aState;
@end
@implementation TableRefreshHeaderView
+ (TableRefreshHeaderView*)headerViewWithOwner:(UIScrollView*)_scrollView delegate:(id<TableRefreshHeaderViewDelegate>)_delegate   addNavigationBArHeight:(BOOL)flag
{
    //NOTE 加了KT_UI_NAVIGATION_BAR_HEIGHT
    CGRect refreshHeaderVierRect = CGRectZero;
    if (flag) {
        CGFloat height = KT_UI_NAVIGATION_BAR_HEIGHT;
        if (KT_IOS_VERSION_7_OR_ABOVE) {
            height = KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT;
        }
        refreshHeaderVierRect  = CGRectMake(0.0f, 0.0f - _scrollView.bounds.size.height + height, _scrollView.frame.size.width, _scrollView.bounds.size.height);
    }else{
        refreshHeaderVierRect  = CGRectMake(0.0f, 0.0f - _scrollView.bounds.size.height , _scrollView.frame.size.width, _scrollView.bounds.size.height);
    }
    __autoreleasing TableRefreshHeaderView *view = [[TableRefreshHeaderView alloc] initWithFrame:refreshHeaderVierRect];
    view.delegate = _delegate;
    view.owner = _scrollView;
    [_scrollView addSubview:view];
    return view;
}
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.rotationNumber = 0.0f;
//        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
        self.ignoreScrollAction = NO;
        //初始化了mainContentView和可以显示灌水效果的logoView
        [self setupMainContentView];
        
        //在添加旁边的下拉更新的，和旋转loading 的效果
        CGFloat statusLabelOriginX = self.logoView.frame.origin.x + self.logoView.frame.size.width;
        CGFloat statusLabelOriginY = self.logoView.frame.origin.y + (self.logoView.frame.size.height / 2) - (TABLE_REFRESH_HEADER_VIEW_STATUES_LABEL_HEIGHT / 2);
        
        UILabel * statusLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(statusLabelOriginX + 4, statusLabelOriginY, TABLE_REFRESH_HEADER_VIEW_STATUES_LABEL_WIDTH, TABLE_REFRESH_HEADER_VIEW_STATUES_LABEL_HEIGHT)];
        statusLabelTmp.backgroundColor = [UIColor clearColor];
        statusLabelTmp.textColor = [UIColor colorWithRed:0x99/255.0 green:0x99/255.0 blue:0x99/255.0 alpha:1];
        statusLabelTmp.font = [UIFont systemFontOfSize:11.0f];
		statusLabelTmp.backgroundColor = [UIColor clearColor];
		statusLabelTmp.textAlignment = 0;
        [self.mainContentView addSubview:statusLabelTmp];
        self.statusLabel = statusLabelTmp;
        
        //添加旋转效果
        /*
        KTLoadingIndicatorOver * indicatorViewTmp = [[KTLoadingIndicatorOver alloc] initWithFrame:self.logoView.frame];
        [self.mainContentView addSubview:indicatorViewTmp];
        self.indicatorView = indicatorViewTmp;
         */
        UIImageView *  rotationImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 18, 18)];
        rotationImageViewTmp.center = self.logoView.center;
        [self.mainContentView addSubview:rotationImageViewTmp];
        rotationImageViewTmp.image = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"loading@2x.png" ofType:nil]];
        self.rotationImageView = rotationImageViewTmp;
        [self setState:KTPullRefreshNormal];
    }
    return self;
}
/*
 实现灌水效果的方法  （1）全部画出来 （2）上班的logo用一张图片，而要变成蓝色的的部分则用绘制出来
 */
- (void)setupMainContentView
{
    UIView * mainContentViewTmp = [[UIView alloc]initWithFrame:self.bounds];
//    mainContentViewTmp.backgroundColor =  [UIColor colorWithRed:0xFC/255.0 green:0xFC/255.0 blue:0xFC/255.0 alpha:1];
    mainContentViewTmp.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
    [self addSubview:mainContentViewTmp];
    self.mainContentView = mainContentViewTmp;
    KTLogoView * logoViewTmp = [[KTLogoView alloc] initWithFrame:CGRectMake(mainContentViewTmp.bounds.size.width  / 2 - TABLE_REFRESH_HEADER_VIEW_IMAGE_SIZE_WIDTH - 8, mainContentViewTmp.bounds.size.height - TABLE_REFRESH_HEADER_VIEW_IMAGE_SIZE_HEIGHT - TABLE_REFRESH_HEADER_VIEW_LOGO_SPACEING, TABLE_REFRESH_HEADER_VIEW_IMAGE_SIZE_WIDTH, TABLE_REFRESH_HEADER_VIEW_IMAGE_SIZE_HEIGHT)];
    [mainContentViewTmp addSubview:logoViewTmp];
    self.logoView = logoViewTmp;
}

- (void)setState:(KTPullRefreshState)aState
{
    switch (aState) {
        case KTPullRefreshNormal:{
             self.isLoading = NO;
             self.logoView.hidden = NO;
             self.rotationImageView.hidden = YES;
             [self stopAnimating];
             self.statusLabel.text = @"下拉刷新";
            break;
        }
        case KTPullRefreshPulling:{
             self.statusLabel.text = @"松开即刷新";
            break;
        }
        case KTPullRefreshLoading:{
            self.isLoading = YES;
             self.statusLabel.text = @"正在加载";
            self.logoView.hidden = YES;
            [self startAnimating];
            self.rotationImageView.hidden = NO;
            break;
        }
        default:
            break;
    }
    _state = aState;

}

#pragma mark - ScrollView Methods
- (void)tableRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
     if (self.ignoreScrollAction) { return; }
    if (self.state == KTPullRefreshLoading) {
        CGFloat offset = MAX(contentOffsetY * -1, 0);
		offset = MIN(offset, TABLEREFRESHHEADERVIEW_HEIGHT_FOR_REFRESH);
		scrollView.contentInset = UIEdgeInsetsMake(offset, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
    }else if (scrollView.isDragging){ //拖动，但是没有松开
        //灌水效果
        if (contentOffsetY < -20 && contentOffsetY >= -65.0f) {
            CGFloat logoHeight = TABLE_REFRESH_HEADER_VIEW_IMAGE_SIZE_HEIGHT * (-contentOffsetY - 20) / 43 ;
            [self.logoView changedBackgroudLineWithHeight:logoHeight];
        }
        if (_state == KTPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !self.isLoading) {
			[self setState:KTPullRefreshNormal];
		} else if (_state == KTPullRefreshNormal && scrollView.contentOffset.y < - 65.0f && !self.isLoading) {
			[self setState:KTPullRefreshPulling];
		}
        
        if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
    }
}

- (void)tableRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -TABLEREFRESHHEADERVIEW_HEIGHT_FOR_REFRESH && !self.isLoading) {
       [self setState:KTPullRefreshLoading];
        if ([((NSObject *)self.delegate) respondsToSelector:@selector(refreshActionTriggered:)]) {
            self.isLoading = YES;
			[_delegate refreshActionTriggered:self];
		}
        self.ignoreScrollAction = YES;
        [UIView animateWithDuration:TABLEREFRESHHEADERVIEW_SCROLL_VIEW_INSET_ANIMATION_DURATION animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(TABLEREFRESHHEADERVIEW_HEIGHT_FOR_REFRESH , scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
        } completion:^(BOOL finished) {
            if (finished) {
                self.ignoreScrollAction = NO;
            }
        }];
    }

}
/*
- (void)triggerRefreshManuallyWithScrollView:(UIScrollView *)scrollView
{
	
	if (!self.isLoading) {
        [self setState:KTPullRefreshLoading];
        
		if ([((NSObject *)self.delegate) respondsToSelector:@selector(refreshActionTriggered:)]) {
            self.isLoading = YES;
			[_delegate refreshActionTriggered:self];
		}
        [UIView animateWithDuration:TABLEREFRESHHEADERVIEW_SCROLL_VIEW_INSET_ANIMATION_DURATION animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(TABLEREFRESHHEADERVIEW_HEIGHT_FOR_REFRESH, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
        } completion:^(BOOL finished) {
        }];
	}
}
*/
- (void)tableRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    self.isLoading = NO;
    self.ignoreScrollAction = YES;
    [UIView animateWithDuration:0.25f animations:^{
        [scrollView setContentInset:UIEdgeInsetsMake(0, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)];
//        scrollView.contentOffset = CGPointZero; //回到顶部 NOTE
    } completion:^(BOOL finished) {
        if (finished) {
            self.ignoreScrollAction = NO;
            [self setState:KTPullRefreshNormal];
        }
    }];
}


#pragma mark - Animating
- (void)stopAnimating
{
    if ([self.rotationTimer isValid]) {
        [self.rotationTimer invalidate];
        self.rotationTimer = 0;
        self.rotationNumber = 0.0f;
    }
}
- (void)startAnimating
{
    //启动定时器
    self.rotationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 420
                                                          target:self
                                                        selector:@selector(rotation)
                                                        userInfo:nil
                                                         repeats:YES];
    //NOTE NSTimer
    [[NSRunLoop mainRunLoop] addTimer:self.rotationTimer forMode:NSRunLoopCommonModes];
    [self.rotationTimer fire];
}
- (void)rotation
{
    self.rotationNumber +=0.03f;
    CGAffineTransform at = CGAffineTransformMakeRotation(self.rotationNumber);
    [self.rotationImageView setTransform:at];
}
@end
