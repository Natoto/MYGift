//
//  KTTabBar.m
//  NetWork
//
//  Created by Keven on 13-12-6.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "KTTabBar.h"

@interface KTTabBar()
@property (nonatomic,strong)  NSMutableArray * buttonDatas;
@end
@implementation KTTabBar
/**
 *  初始化一个标签栏
 *
 *  @param items 标签栏的属性信息
 *
 *  @return 标签栏实例对象
 */
- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,[Utils screenWidth], KT_UI_TAB_BAR_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        self.buttonDatas = [[NSMutableArray alloc] initWithArray:items];
        [self setupButtons];
        
    }
    return self;
}
/**
 *  标签栏显示那个Tag（不带事件）
 *
 *  @param index Tag值
 */
- (void)showTabBarAtIndex:(NSUInteger)index
{
    UIButton * bt = [self.items objectAtIndex:index];
    for (UIButton *b in self.items) {
        [b setSelected:NO];
    }
    [bt setSelected:YES];

    [self hiddenUpdateImageAtIndex:index];
}
/**
 *  标签栏显示那个Tag（带事件）
 *
 *  @param index Tag值
 */
- (void)showTabBarWithAcionAtIndex:(NSUInteger)index {
    [self showTabBarAtIndex:index];
    [self touchDownForButton:[self.items objectAtIndex:index]];
    [self touchUpForButton:[self.items objectAtIndex:index]];
}
/**
 *  标签栏有推送事件效果 显示
 *
 *  @param index Tag值
 */
- (void)showUpdateImageAtIndex:(NSUInteger)index
{
    UIImageView * updateImageView = [self.updates objectAtIndex:index];
    updateImageView.hidden = NO;
}
/**
 *  标签栏有推送事件效果 隐藏
 *
 *  @param index Tag值
 */
- (void)hiddenUpdateImageAtIndex:(NSUInteger)index
{
    UIImageView * updateImageView = [self.updates objectAtIndex:index];
    updateImageView.hidden = YES;
}
/**
 *  初始化标签栏的button
 */
- (void)setupButtons
{
    NSInteger count = 0;
    NSInteger buttonSize = floor(320 / [self.buttonDatas count]) ;
    self.items = [[NSMutableArray alloc] init];
    self.updates = [[NSMutableArray alloc] init];
    for (NSString *info in self.buttonDatas) {
        @autoreleasepool {
            NSInteger buttonX = count * buttonSize;
            NSString * imageName = [NSString stringWithFormat:@"%@@2x",info];
            NSString * imageNameHighlight = [NSString stringWithFormat:@"%@_highlighted@2x",info];
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.frame = CGRectMake(buttonX, 0, buttonSize, KT_UI_TAB_BAR_HEIGHT);
            [b setImage:KT_GET_LOCAL_PICTURE_SECOND(imageName) forState:UIControlStateNormal];
            [b setImage:KT_GET_LOCAL_PICTURE_SECOND(imageNameHighlight) forState:UIControlStateHighlighted];
            [b setImage:KT_GET_LOCAL_PICTURE_SECOND(imageNameHighlight) forState:UIControlStateSelected];
            [b addTarget:self action:@selector(touchDownForButton:) forControlEvents:UIControlEventTouchDown];
            [b addTarget:self action:@selector(touchUpForButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:b];
            [self.items addObject:b];
            
            //NOTE upDate
            CGRect buttonRect = b.frame;
            buttonRect.origin.y = 10;
            buttonRect.origin.x +=52;
            buttonRect.size.width = 5;
            buttonRect.size.height = 5;
            UIImageView * updateImageView = [[UIImageView alloc] initWithFrame:buttonRect];
            updateImageView.image = KT_GET_LOCAL_PICTURE_SECOND(@"bar_update@2x");
            [self addSubview:updateImageView];
            updateImageView.hidden = YES;
            [self.updates addObject:updateImageView];
            count++;
        }
      
    }
}
/**
 *  button按下事件
 *
 *  @param button button对象
 */
-(void)touchDownForButton:(UIButton*)button {
    [button setSelected:YES];
    NSInteger i = [self.items indexOfObject:button];
    
    [self.delegate switchViewControllerIndex:i];
}
/**
 *  button松开事件
 *
 *  @param button button对象
 */
-(void)touchUpForButton:(UIButton*)button {
    for (UIButton *b in self.items) {
        [b setSelected:NO];
    }
    [button setSelected:YES];
}
@end
