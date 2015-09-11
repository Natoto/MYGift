//
//  CustomTabBar.m
//  NetWorkTwo
//
//  Created by Keven on 13-12-21.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "CustomTabBar.h"
#define TAB_BUTTON_TITLE_FONT_SIZE                          16.0f
#define TAB_BUTTON_TILTE_COLOR                              [UIColor blackColor]
#define TAB_DEFAULT_PADDING_X                               15
#define TAB_BAR_CLICKED_BUTTON_IMAGE_NAME                   @"navbar_btn.png"
#define TAB_BAR_CLICKED_BUTTON_HIGH_LIGHTED_IMAGE_NAME      @"navbar_btn_highlighted.png"
@implementation CustomTabBar
/**
 *  初始化一个标签栏视图对象
 *
 *  @param frame 标签栏视图对象的位置和尺寸
 *
 *  @return 标签栏实例对象
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundImageViewTmp = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageViewTmp.image = [KT_GET_LOCAL_PICTURE_SECOND(@"bar_bg_white@2x") stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        [self addSubview:backgroundImageViewTmp];
        self.backgroundImageView = backgroundImageViewTmp;
        self.backgroundColor = KT_UICOLOR_CLEAR;
    }
    return self;
}
/**
 *  设置标签栏的左右按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param buttonType       支持button类型，左边/右边
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setTabBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                      buttonType:(CustomTabBarButtonType)buttonType
                          target:(id)target
                          action:(SEL)action
{
    NSAssert(image, @"set NavBarButtonWithImage no image");
    NSAssert(highlightedImage, @"set NavBarButtonWithImage no highlightedImage");
    float width = image.size.width + TAB_DEFAULT_PADDING_X * 2;
    float height = image.size.height;
    float y = 0;
    float x = 0;
    if (buttonType == CustomTabBarButtonTypeOfLeft) {
        if (self.leftButton) { [self.leftButton removeFromSuperview]; }
        
    } else if (buttonType == CustomTabBarButtonTypeOfRight) {
        if (self.rightButton) { [self.rightButton removeFromSuperview]; }
        x = KT_UI_SCREEN_WIDTH - width;
    }
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, KT_UI_TAB_BAR_HEIGHT);
    [btn setImageEdgeInsets:UIEdgeInsetsMake((KT_UI_TAB_BAR_HEIGHT - height > 0 ? KT_UI_TAB_BAR_HEIGHT - height : 0) / 2, TAB_DEFAULT_PADDING_X, (KT_UI_TAB_BAR_HEIGHT - height > 0 ? KT_UI_TAB_BAR_HEIGHT - height : 0) / 2, TAB_DEFAULT_PADDING_X)];
    [btn setImage:image forState:UIControlStateNormal];
    if (highlightedImage) {
        [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    if (buttonType == CustomTabBarButtonTypeOfLeft) {
        self.leftButton = btn;
    } else if (buttonType == CustomTabBarButtonTypeOfRight) {
        self.rightButton = btn;
    }
}
/**
 *  设置标签栏的左右按钮
 *
 *  @param Bgimage            默认背景图片
 *  @param BghighlightedImage 点击背景高亮图片
 *  @param buttonType         支持button类型，左边/右边
 *  @param target             代理
 *  @param action             代理事件
 */
- (void)setTabBarButtonWithBgImage:(UIImage *)Bgimage
                BghighlightedImage:(UIImage *)BghighlightedImage
                        buttonType:(CustomTabBarButtonType)buttonType
                            target:(id)target
                            action:(SEL)action
{
    NSAssert(Bgimage, @"set NavBarButtonWithImage no image");
    NSAssert(BghighlightedImage, @"set NavBarButtonWithImage no highlightedImage");
    float width = Bgimage.size.width;
    float height = Bgimage.size.height;
    float y = (KT_UI_TAB_BAR_HEIGHT - TAB_DEFAULT_PADDING_X - height) * 0.5;
    float x = TAB_DEFAULT_PADDING_X;
    if (buttonType == CustomTabBarButtonTypeOfLeft) {
        if (self.leftButton) { [self.leftButton removeFromSuperview]; }
        
    } else if (buttonType == CustomTabBarButtonTypeOfRight) {
        if (self.rightButton) { [self.rightButton removeFromSuperview]; }
        x = KT_UI_SCREEN_WIDTH - width - TAB_DEFAULT_PADDING_X;
    }
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, height);
    [btn setBackgroundImage:Bgimage forState:UIControlStateNormal];
    [btn setBackgroundImage:BghighlightedImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    if (buttonType == CustomTabBarButtonTypeOfLeft) {
        self.leftButton = btn;
    } else if (buttonType == CustomTabBarButtonTypeOfRight) {
        self.rightButton = btn;
    }
}
/**
 *  设置标签栏的左右按钮
 *
 *  @param image              默认图片
 *  @param highlightedImage   点击高亮图片
 *  @param bgImage            默认背景图片
 *  @param highlightedBgImage 点击背景高亮图片
 *  @param buttonType         支持button类型，左边/右边
 *  @param target             代理
 *  @param action             代理事件
 */
- (void)setTabBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                         bgImage:(UIImage *)bgImage
              highlightedBgImage:(UIImage *)highlightedBgImage
                      buttonType:(CustomTabBarButtonType)buttonType
                          target:(id)target
                          action:(SEL)action
{

    NSAssert(image, @"set NavBarButtonWithImage no image");
    NSAssert(highlightedImage, @"set NavBarButtonWithImage no highlightedImage");
    NSAssert(bgImage, @"set NavBarButtonWithImage no image");
    NSAssert(highlightedBgImage, @"set NavBarButtonWithImage no highlightedImage");
    float width = 0;
    float height = 0;
    width = image.size.width;
    height = image.size.height;
    float y = (KT_UI_TAB_BAR_HEIGHT - TAB_DEFAULT_PADDING_X - height) * 0.5;
    float x = TAB_DEFAULT_PADDING_X;
    if (buttonType == CustomTabBarButtonTypeOfLeft) {
        if (self.leftButton) { [self.leftButton removeFromSuperview]; }
        
    } else if (buttonType == CustomTabBarButtonTypeOfRight) {
        if (self.rightButton) { [self.rightButton removeFromSuperview]; }
        x = KT_UI_SCREEN_WIDTH - width - TAB_DEFAULT_PADDING_X;
    }
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, height);
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highlightedBgImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    if (buttonType == CustomTabBarButtonTypeOfLeft) {
        self.leftButton = btn;
    } else if (buttonType == CustomTabBarButtonTypeOfRight) {
        self.rightButton = btn;
    }

}
/**
 *  设置标签栏的左右按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param buttonType       支持button类型，左边/右边
 *  @param title            button标题
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setTabBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                      buttonType:(CustomTabBarButtonType)buttonType
                           title:(NSString *)title
                          target:(id)target
                          action:(SEL)action
{
    NSAssert(image, @"set NavBarButtonWithImage no image");
    NSAssert(highlightedImage, @"set NavBarButtonWithImage no highlightedImage");
    NSAssert(title, @"set NavBarButtonWithImage no title");
    float width = 0;
    float height = 0;
    width = image.size.width;
    height = image.size.height;
    float y = (KT_UI_TAB_BAR_HEIGHT - TAB_DEFAULT_PADDING_X - height) * 0.5;
    float x = TAB_DEFAULT_PADDING_X;
    if (buttonType == CustomTabBarButtonTypeOfLeft) {
        if (self.leftButton) { [self.leftButton removeFromSuperview]; }
        
    } else if (buttonType == CustomTabBarButtonTypeOfRight) {
        if (self.rightButton) { [self.rightButton removeFromSuperview]; }
        x = KT_UI_SCREEN_WIDTH - width - TAB_DEFAULT_PADDING_X;
    }
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, height);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:TAB_BUTTON_TILTE_COLOR forState:UIControlStateNormal];
    btn.titleLabel.font = GB_DEFAULT_FONT(TAB_BUTTON_TITLE_FONT_SIZE);
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    if (buttonType == CustomTabBarButtonTypeOfLeft) {
        self.leftButton = btn;
    } else if (buttonType == CustomTabBarButtonTypeOfRight) {
        self.rightButton = btn;
    }

}
/**
 *  设置标签栏的左右按钮
 *
 *  @param title      button标题
 *  @param buttonType 支持button类型，左边/右边
 *  @param target     代理
 *  @param action     代理事件
 */
- (void)setTabBarButtonWithTitle:(NSString *)title
                      buttonType:(CustomTabBarButtonType)buttonType
                          target:(id)target
                          action:(SEL)action
{

    NSAssert(title, @"set setNavBarButtonWithTitle no title");
    if (!title || title.length == 0) { return; }
    float innerLeftPadding = 10.0f;
    float innerRightPadding = 10.0f;
    float defaultTitleHeight = 31.0f;
    float padding = 10;
    
    CGSize titleSize = KT_TEXTSIZE(title, GB_DEFAULT_FONT(TAB_BUTTON_TITLE_FONT_SIZE), CGSizeMake(10000, defaultTitleHeight), NSLineBreakByCharWrapping);
    
    UIImage *buttonImageNormal = nil;
    UIImage *buttonImageHighlighted = nil;
    
    buttonImageNormal = [[UIImage imageNamed:TAB_BAR_CLICKED_BUTTON_IMAGE_NAME] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
    buttonImageHighlighted = [[UIImage imageNamed:TAB_BAR_CLICKED_BUTTON_HIGH_LIGHTED_IMAGE_NAME] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
    
    float y = (KT_UI_TAB_BAR_HEIGHT  - defaultTitleHeight)*0.5;
    float x = padding;
    float width = titleSize.width+innerLeftPadding+innerRightPadding;
    float height = defaultTitleHeight;
    float screenWidth = KT_UI_SCREEN_WIDTH;
    
    if (buttonType == CustomTabBarButtonTypeOfLeft) {
        if (self.leftButton) { [self.leftButton removeFromSuperview]; }
        
    } else if (buttonType == CustomTabBarButtonTypeOfRight) {
        if (self.rightButton) { [self.rightButton removeFromSuperview]; }
        x = screenWidth - padding - width;
    }
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, height);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = GB_DEFAULT_FONT(TAB_BUTTON_TITLE_FONT_SIZE);
    btn.titleLabel.textAlignment = KT_TextAlignmentCenter;
    [btn setTitleColor:TAB_BUTTON_TILTE_COLOR forState:UIControlStateNormal];
    [btn setBackgroundImage:buttonImageNormal forState: UIControlStateNormal];
    [btn setBackgroundImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    btn.hidden = NO;
    [self addSubview:btn];
    
    if (buttonType == CustomTabBarButtonTypeOfLeft) {
        self.leftButton = btn;
    } else if (buttonType == CustomTabBarButtonTypeOfRight) {
        self.rightButton = btn;
    }
}

@end
