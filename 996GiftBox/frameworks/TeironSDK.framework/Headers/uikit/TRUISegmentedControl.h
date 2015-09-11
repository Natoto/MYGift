//
//  TRUISegmentedControl.h
//  PPHelper
//
//  Created by chenjunhong on 13-3-8.
//  Copyright (c) 2013年 Jun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TRUISegmentedControlButton : UIControl
{
    UIImageView *_imageView;
    UILabel *_titleLb;

    BOOL _highlighted;
    UIColor *_normalcolor;
    UIColor *_highlightedColor;
}

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel *titleLb;

- (id)initWithSize:(CGSize)size;
- (void)setImage:(UIImage*)image;
- (void)setHighlightedImage:(UIImage*)image;
- (void)setTitle:(NSString*)title;
- (void)setTitleFont:(UIFont*)font;
- (void)setTitleColor:(UIColor*)color;
- (void)setTileHighlightedColor:(UIColor*)color;
- (void)setTRHighlighted:(BOOL)highlighted;

@end


@class TRUISegmentedControl;
@protocol TRUISegmentedControlDelegate <NSObject>

- (NSInteger)numberOfIndexInSegmentedControl:(TRUISegmentedControl*)segmentedControl;
- (TRUISegmentedControlButton*)segmentedControl:(TRUISegmentedControl*)segmentedControl segmentedControlButtonForIndex:(NSInteger)index;
- (void)segmentedControl:(TRUISegmentedControl*)segmentedControl selectBt:(TRUISegmentedControlButton*)selectBt selectIndex:(NSInteger)index;


//- (CGFloat)segmentedControl:(TRUISegmentedControl*)segmentedControl heightForIndex:(NSInteger)index;
//- (CGFloat)segmentedControl:(TRUISegmentedControl*)segmentedControl widthForIndex:(NSInteger)index;
//- (NSString*)segmentedControl:(TRUISegmentedControl*)segmentedControl titleForIndex:(NSInteger)index;

@end

typedef enum {
    TRUISegmentedControlOrientation_Horizontal,
    TRUISegmentedControlOrientation_Vertical
} TRUISegmentedControlOrientation;


@interface TRUISegmentedControl : UIView
{
    TRUISegmentedControlOrientation _orientation;
    NSInteger _selectedSegmentIndex;
    NSMutableArray *_btItmes;
    id<TRUISegmentedControlDelegate> _delegate;
}

@property (nonatomic, assign) id<TRUISegmentedControlDelegate> delegate;
@property (nonatomic, readonly) NSInteger selectedSegmentIndex;


- (void)setSelectedSegmentIndex:(NSInteger)index isCallDelegate:(BOOL)b;
- (id)initWithFrame:(CGRect)frame orientation:(TRUISegmentedControlOrientation)orientation delegate:(id<TRUISegmentedControlDelegate>)deletate;

@end
