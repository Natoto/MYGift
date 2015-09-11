//
//  TRUserPopView.h
//  PPHelper
//
//  Created by chenjunhong on 13-5-7.
//  Copyright (c) 2013年 Jun. All rights reserved.
//

typedef void (^BackCallback) ();
typedef void (^CloseCallback) ();

//#import "TRBasePopView.h"
#import <TeironUserSDK/ui/TRBasePopView.h>
#import <TeironSDK/uikit/TRUIButton.h>

#define iPadUserBgImageViewWidth 540
#define iPadUserBgImageViewHeight 620

@interface TRUserPopView : TRBasePopView
<UIGestureRecognizerDelegate>
{
    UIView *_mainView;
    UIImageView *_bgImageView;
    UIImageView *_horizontalLineView;
    UIImageView *_verticalLineView1;
    TRUIButton *_backBt;
    UIImageView *_verticalLineView2;
    TRUIButton *_closeBt;
    UIImageView *_titleImage;
    UILabel *_titleLabel;
    
    UIView *_keyBoardView;
    UITapGestureRecognizer *_singleRecognizer;
    
    CloseCallback _closeCallback;
    BackCallback _backCallback;
}

@property (nonatomic, copy) CloseCallback closeCallback;
@property (nonatomic, copy) BackCallback backCallback;

- (void)setKeyBoardViewHidden:(BOOL)hidden;
- (void)setBackBtHidden:(BOOL)hidden;
- (void)setCloseBtHidden:(BOOL)hidden;
- (void)setNaviViewHidden:(BOOL)hidden;

- (void)singleRecognizerHandler;
- (void)backBtHandler:(TRUIButton*)sender;
- (void)closeBtHandler:(TRUIButton*)sender;

@end
