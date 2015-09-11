//
//  TRBasePopView.h
//  PPHelper
//
//  Created by chenjunhong on 13-5-7.
//  Copyright (c) 2013年 Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRBasePopView : UIView
{
    UIInterfaceOrientation _previousOrientation;
    BOOL _keyBoardIsShow;
    float _rollupOffset;
    
    TRBasePopView *_superPopView;
}

@property (nonatomic, retain) TRBasePopView *superPopView;

- (void)initVerticalFrame;
- (void)initHorizontalFrame;

- (void)rollupView;
- (void)revertView;

- (void)pushChildPopView:(TRBasePopView*)childPopView;

- (void)dismissView;

//从右边展示
- (void)showViewByRight;
//从左边展示
- (void)showViewByLeft;
//显示
- (void)showView;
//消失到右边
- (void)hideViewInRight;
//消失到左边
- (void)hideViewInLeft;
//隐蔽
- (void)hideView;

//将要显示
- (void)willShowView;
//已显示
- (void)didShowView;

//将要消失
- (void)willHideView;
//已消失
- (void)didHideView;

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation;

@end
