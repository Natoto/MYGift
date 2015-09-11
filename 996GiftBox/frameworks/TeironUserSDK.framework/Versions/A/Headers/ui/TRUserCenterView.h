//
//  TRUserCenterView.h
//  TestSDK
//
//  Created by chenjunhong on 13-5-30.
//  Copyright (c) 2013年 Jun. All rights reserved.
//

//#import <TeironSDK/user/TRUserPopView.h>
#import <TeironUserSDK/ui/TRUserPopView.h>
#import <TeironSDK/uikit/TRUISegmentedControl.h>

@class TRUserCenterView;
@protocol TRUserCenterViewDelegate <NSObject>

@optional

- (NSInteger)numberOfCustomViewInCenterView:(TRUserCenterView *)centerView;

- (NSString *)centerView:(TRUserCenterView *)centerView customViewTitleForNumber:(NSInteger)number;

- (UIView *)centerView:(TRUserCenterView *)centerView customViewForNumber:(NSInteger)number;


@end

typedef void (^LogoutCallback) ();


@interface TRUserCenterView : TRUserPopView
<TRUISegmentedControlDelegate>
{
    UIView *_baseInfoView;
    TRUISegmentedControl *_segmentedControl;
    UIImageView *_userNameImageView;
    UILabel *_userNameLabel;
    UITextField *_userNameField;
    UIButton *_updatePassWordButton;
    UIButton *_userInfoProvingButton;
    UIButton *_logoutActiveUserButton;
    
    id<TRUserCenterViewDelegate> _delegate;
    NSMutableArray *_childViews;
    
    LogoutCallback _logoutCallback;
}

@property (nonatomic, assign) id<TRUserCenterViewDelegate> delegate;
@property (nonatomic, copy) LogoutCallback logoutCallback;

+ (TRUserCenterView*)defaultTRUserCenterView;

@end
