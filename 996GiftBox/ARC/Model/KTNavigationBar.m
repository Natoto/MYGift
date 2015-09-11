//
//  KTNavigationBar.m
//  NetWork
//
//  Created by Keven on 13-12-6.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "KTNavigationBar.h"

#define NAV_TITLE_FONT_SIZE                                 16.0f
#define NAV_TITLE_COLOR                                     [UIColor whiteColor]
#define NAV_BUTTON_TITLE_FONT_SIZE                          16.0f
#define NAV_BUTTON_TILTE_COLOR                              [UIColor blackColor]
#define NAV_MAX_TITLE_WIDTH                                 240
#define NAV_DEFAULT_PADDING_X                               15

#define NAV_BAR_CLICKED_BUTTON_IMAGE_NAME                   @"navbar_btn.png"
#define NAV_BAR_CLICKED_BUTTON_HIGH_LIGHTED_IMAGE_NAME      @"navbar_btn_highlighted.png"

#define NAV_BAR_BACK_BUTTON_IMAGE_NAME                      @"navbar_back_red.png"
#define NAV_BAR_BACK_BUTTON_HIGH_LIGHTED_IMAGE_NAME         @"navbar_btn_bg_highlighted.png"

@implementation KTNavigationBar

/**
 *  初始化一个导航栏
 *
 *  @param frame 导航栏位置和尺寸
 *
 *  @return 导航栏实例对象
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         UIImageView *navBarBgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
         [self addSubview:navBarBgImageView];
         navBarBgImageView.image = [KT_GET_LOCAL_PICTURE_SECOND(@"bar_bg_yellow@2x") stretchableImageWithLeftCapWidth:5 topCapHeight:5];
         self.navBarBgImageView = navBarBgImageView;
        self.backgroundColor = KT_UICOLOR_CLEAR;
    }
    return self;
}
/**
 *  设置导航栏的左右按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param buttonType       支持button类型，左边/右边
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setNavBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                      buttonType:(KTNavigationBarButtonType)buttonType
                          target:(id)target
                          action:(SEL)action
{
    NSAssert(image, @"set NavBarButtonWithImage no image");
    NSAssert(highlightedImage, @"set NavBarButtonWithImage no highlightedImage");
    float width = image.size.width + NAV_DEFAULT_PADDING_X * 2;
    float height = image.size.height;
    float y = 0;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = 0;
    if (buttonType == KTNavigationBarButtonTypeOfLeft) {
        if (self.navBarLeftButton) { [self.navBarLeftButton removeFromSuperview]; }
        
    } else if (buttonType == KTNavigationBarButtonTypeOfRight) {
        if (self.navBarRightButton) { [self.navBarRightButton removeFromSuperview]; }
        x = KT_UI_SCREEN_WIDTH - width;
    }
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, KT_UI_NAVIGATION_BAR_HEIGHT);
    [btn setImageEdgeInsets:UIEdgeInsetsMake((KT_UI_NAVIGATION_BAR_HEIGHT - height > 0 ? KT_UI_NAVIGATION_BAR_HEIGHT - height : 0) / 2, NAV_DEFAULT_PADDING_X, (KT_UI_NAVIGATION_BAR_HEIGHT - height > 0 ? KT_UI_NAVIGATION_BAR_HEIGHT - height : 0) / 2, NAV_DEFAULT_PADDING_X)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    if (buttonType == KTNavigationBarButtonTypeOfLeft) {
        self.navBarLeftButton = btn;
    } else if (buttonType == KTNavigationBarButtonTypeOfRight) {
        self.navBarRightButton = btn;
    }
}
/**
 *  设置导航栏的左右按钮
 *
 *  @param Bgimage            默认背景图片
 *  @param BghighlightedImage 点击背景高亮图片
 *  @param buttonType         支持button类型，左边/右边
 *  @param target             代理
 *  @param action             代理事件
 */
- (void)setNavBarButtonWithBgImage:(UIImage *)Bgimage
                BghighlightedImage:(UIImage *)BghighlightedImage
                        buttonType:(KTNavigationBarButtonType)buttonType
                            target:(id)target
                            action:(SEL)action
{
    NSAssert(Bgimage, @"set NavBarButtonWithImage no image");
    NSAssert(BghighlightedImage, @"set NavBarButtonWithImage no highlightedImage");
    float width = Bgimage.size.width;
    float height = Bgimage.size.height;
    float y = (KT_UI_NAVIGATION_BAR_HEIGHT - NAV_DEFAULT_PADDING_X - height) * 0.5;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = (KT_UI_NAVIGATION_BAR_HEIGHT  - NAV_DEFAULT_PADDING_X - height) * 0.5 + KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = NAV_DEFAULT_PADDING_X;
    if (buttonType == KTNavigationBarButtonTypeOfLeft) {
        if (self.navBarLeftButton) { [self.navBarLeftButton removeFromSuperview]; }
        
    } else if (buttonType == KTNavigationBarButtonTypeOfRight) {
        if (self.navBarRightButton) { [self.navBarRightButton removeFromSuperview]; }
        x = KT_UI_SCREEN_WIDTH - width - NAV_DEFAULT_PADDING_X;
    }
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, height);
    [btn setBackgroundImage:Bgimage forState:UIControlStateNormal];
    [btn setBackgroundImage:BghighlightedImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    if (buttonType == KTNavigationBarButtonTypeOfLeft) {
        self.navBarLeftButton = btn;
    } else if (buttonType == KTNavigationBarButtonTypeOfRight) {
        self.navBarRightButton = btn;
    }
}

/**
 *  设置导航栏的左右按钮
 *
 *  @param image              默认图片
 *  @param highlightedImage   点击高亮图片
 *  @param bgImage            默认背景图片
 *  @param highlightedBgImage 点击背景高亮图片
 *  @param buttonType         支持button类型，左边/右边
 *  @param target             代理
 *  @param action             代理事件
 */
- (void)setNavBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                         bgImage:(UIImage *)bgImage
              highlightedBgImage:(UIImage *)highlightedBgImage
                      buttonType:(KTNavigationBarButtonType)buttonType
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
    float y = (KT_UI_NAVIGATION_BAR_HEIGHT - NAV_DEFAULT_PADDING_X - height) * 0.5;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = (KT_UI_NAVIGATION_BAR_HEIGHT  - NAV_DEFAULT_PADDING_X - height) * 0.5 + KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = NAV_DEFAULT_PADDING_X;
    if (buttonType == KTNavigationBarButtonTypeOfLeft) {
        if (self.navBarLeftButton) { [self.navBarLeftButton removeFromSuperview]; }
        
    } else if (buttonType == KTNavigationBarButtonTypeOfRight) {
        if (self.navBarRightButton) { [self.navBarRightButton removeFromSuperview]; }
        x = KT_UI_SCREEN_WIDTH - width - NAV_DEFAULT_PADDING_X;
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
    if (buttonType == KTNavigationBarButtonTypeOfLeft) {
        self.navBarLeftButton = btn;
    } else if (buttonType == KTNavigationBarButtonTypeOfRight) {
        self.navBarRightButton = btn;
    }

}
/**
 *  设置导航栏的左右按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param buttonType       支持button类型，左边/右边
 *  @param title            button标题
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setNavBarButtonWithImage:(UIImage *)image
                highlightedImage:(UIImage *)highlightedImage
                      buttonType:(KTNavigationBarButtonType)buttonType
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
    float y = (KT_UI_NAVIGATION_BAR_HEIGHT - NAV_DEFAULT_PADDING_X - height) * 0.5;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = (KT_UI_NAVIGATION_BAR_HEIGHT  - NAV_DEFAULT_PADDING_X - height) * 0.5 + KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = NAV_DEFAULT_PADDING_X;
    if (buttonType == KTNavigationBarButtonTypeOfLeft) {
        if (self.navBarLeftButton) { [self.navBarLeftButton removeFromSuperview]; }
        
    } else if (buttonType == KTNavigationBarButtonTypeOfRight) {
        if (self.navBarRightButton) { [self.navBarRightButton removeFromSuperview]; }
        x = KT_UI_SCREEN_WIDTH - width - NAV_DEFAULT_PADDING_X;
    }
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, height);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:NAV_BUTTON_TILTE_COLOR forState:UIControlStateNormal];
    btn.titleLabel.font =  GB_DEFAULT_FONT(NAV_BUTTON_TITLE_FONT_SIZE);
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    if (buttonType == KTNavigationBarButtonTypeOfLeft) {
        self.navBarLeftButton = btn;
    } else if (buttonType == KTNavigationBarButtonTypeOfRight) {
        self.navBarRightButton = btn;
    }
}
/**
 *  设置导航栏的左右按钮
 *
 *  @param title      button标题
 *  @param buttonType 支持button类型，左边/右边
 *  @param target     代理
 *  @param action     代理事件
 */
- (void)setNavBarButtonWithTitle:(NSString *)title
                      buttonType:(KTNavigationBarButtonType)buttonType
                          target:(id)target
                          action:(SEL)action
{
    NSAssert(title, @"set setNavBarButtonWithTitle no title");
    if (!title || title.length == 0) { return; }
    float innerLeftPadding = 10.0f;
    float innerRightPadding = 10.0f;
    float defaultTitleHeight = 31.0f;
    float padding = 10;
    
    
    CGSize titleSize = KT_TEXTSIZE(title, GB_DEFAULT_FONT(NAV_BUTTON_TITLE_FONT_SIZE), CGSizeMake(10000, defaultTitleHeight), NSLineBreakByCharWrapping);
    
    UIImage *buttonImageNormal = nil;
    UIImage *buttonImageHighlighted = nil;
    
    
    buttonImageNormal = [[UIImage imageNamed:NAV_BAR_CLICKED_BUTTON_IMAGE_NAME] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
    buttonImageHighlighted = [[UIImage imageNamed:NAV_BAR_CLICKED_BUTTON_HIGH_LIGHTED_IMAGE_NAME] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
    
    float y = (KT_UI_NAVIGATION_BAR_HEIGHT  - defaultTitleHeight)*0.5;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = (KT_UI_NAVIGATION_BAR_HEIGHT  - defaultTitleHeight)*0.5 + KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = padding;
    float width = titleSize.width+innerLeftPadding+innerRightPadding;
    float height = defaultTitleHeight;
    float screenWidth = KT_UI_SCREEN_WIDTH;
    
    if (buttonType == KTNavigationBarButtonTypeOfLeft) {
        if (self.navBarLeftButton) { [self.navBarLeftButton removeFromSuperview]; }
        
    } else if (buttonType == KTNavigationBarButtonTypeOfRight) {
        if (self.navBarRightButton) { [self.navBarRightButton removeFromSuperview]; }
        x = screenWidth - padding - width;
    }
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, height);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = GB_DEFAULT_FONT(NAV_BUTTON_TITLE_FONT_SIZE);
    btn.titleLabel.textAlignment = KT_TextAlignmentCenter;
    [btn setTitleColor:NAV_TITLE_COLOR forState:UIControlStateNormal];
    [btn setBackgroundImage:buttonImageNormal forState: UIControlStateNormal];
    [btn setBackgroundImage:buttonImageHighlighted forState:UIControlStateHighlighted];
    btn.hidden = NO;
    [self addSubview:btn];
    
    if (buttonType == KTNavigationBarButtonTypeOfLeft) {
        self.navBarLeftButton = btn;
    } else if (buttonType == KTNavigationBarButtonTypeOfRight) {
        self.navBarRightButton = btn;
    }
}
#pragma mark -
/**
 *  设置导航栏的返回按钮
 *
 *  @param target 代理
 *  @param action 代理事件
 */
- (void)setNavBarBackButtonTarget:(id)target action:(SEL)action
{
    UIImage *bgimage = [UIImage imageNamed:NAV_BAR_BACK_BUTTON_IMAGE_NAME];
    UIImage *highlightedBgImage = [UIImage imageNamed:NAV_BAR_BACK_BUTTON_HIGH_LIGHTED_IMAGE_NAME];
    
    float width = bgimage.size.width + NAV_DEFAULT_PADDING_X * 2;
    float height = bgimage.size.height;
    float y = 0;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = 0;
    if (self.navBarLeftButton) { [self.navBarLeftButton removeFromSuperview]; }
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, KT_UI_NAVIGATION_BAR_HEIGHT);
    [btn setImageEdgeInsets:UIEdgeInsetsMake((KT_UI_NAVIGATION_BAR_HEIGHT - height) / 2, NAV_DEFAULT_PADDING_X, (KT_UI_NAVIGATION_BAR_HEIGHT - height) / 2, NAV_DEFAULT_PADDING_X)];
    [btn setImage:bgimage forState:UIControlStateNormal];
    [btn setImage:highlightedBgImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.navBarLeftButton = btn;
}
/**
 *  设置导航栏的返回按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setNavBarBackButtonWithImage:(UIImage *)image
                    highlightedImage:(UIImage *)highlightedImage
                              target:(id)target
                              action:(SEL)action
{
    NSAssert(image, @"set NavBarBackButtonWithImage  no  image");
    NSAssert(highlightedImage, @"set NavBarBackButtonWithImage  no  highlightedImage");
    float width = image.size.width + NAV_DEFAULT_PADDING_X * 2;
    float height = image.size.height;
    float y = 0;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y =  KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = 0;
    if (self.navBarLeftButton) { [self.navBarLeftButton removeFromSuperview]; }
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, KT_UI_NAVIGATION_BAR_HEIGHT);
    [btn setImageEdgeInsets:UIEdgeInsetsMake((KT_UI_NAVIGATION_BAR_HEIGHT - height) / 2, NAV_DEFAULT_PADDING_X, (KT_UI_NAVIGATION_BAR_HEIGHT - height) / 2, NAV_DEFAULT_PADDING_X)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.navBarLeftButton = btn;
}
/**
 *  设置导航栏的返回按钮
 *
 *  @param image              默认图片
 *  @param highlightedImage   点击高亮图片
 *  @param bgImage            默认背景图片
 *  @param highlightedBgImage 点击背景高亮图片
 *  @param target             代理
 *  @param action             代理事件
 */
- (void)setNavBarBackButtonWithImage:(UIImage *)image
                    highlightedImage:(UIImage *)highlightedImage
                             bgImage:(UIImage *)bgImage
                  highlightedBgImage:(UIImage *)highlightedBgImage
                              target:(id)target
                              action:(SEL)action
{
    NSAssert(image, @"set NavBarBackButtonWithImage  no  image");
    NSAssert(highlightedImage, @"set NavBarBackButtonWithImage  no  highlightedImage");
    NSAssert(bgImage, @"set NavBarBackButtonWithImage  no  bgImage");
    NSAssert(highlightedBgImage, @"set NavBarBackButtonWithImage  no  highlightedBgImage");
    float width = image.size.width;
    float height = image.size.height;
    float y = (KT_UI_NAVIGATION_BAR_HEIGHT  - height) * 0.5;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = (KT_UI_NAVIGATION_BAR_HEIGHT  - height) * 0.5 + KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = NAV_DEFAULT_PADDING_X;
    
    if (self.navBarLeftButton) { [self.navBarLeftButton removeFromSuperview]; }
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, height);
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highlightedBgImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.navBarLeftButton = btn;


}
/**
 *  设置导航栏的返回按钮
 *
 *  @param image            默认图片
 *  @param highlightedImage 点击高亮图片
 *  @param buttonType       支持button类型，左边/右边
 *  @param title            button标题
 *  @param target           代理
 *  @param action           代理事件
 */
- (void)setNavBarBackButtonWithImage:(UIImage *)image
                    highlightedImage:(UIImage *)highlightedImage
                          buttonType:(KTNavigationBarButtonType)buttonType
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
    float y = (KT_UI_NAVIGATION_BAR_HEIGHT - NAV_DEFAULT_PADDING_X - height) * 0.5;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = (KT_UI_NAVIGATION_BAR_HEIGHT - NAV_DEFAULT_PADDING_X - height) * 0.5 + KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = NAV_DEFAULT_PADDING_X;
    if (buttonType == KTNavigationBarButtonTypeOfLeft) {
        if (self.navBarLeftButton) { [self.navBarLeftButton removeFromSuperview]; }
        
    } else if (buttonType == KTNavigationBarButtonTypeOfRight) {
        if (self.navBarRightButton) { [self.navBarRightButton removeFromSuperview]; }
        x = KT_UI_SCREEN_WIDTH - width - NAV_DEFAULT_PADDING_X;
    }
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(x, y, width, height);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:NAV_BUTTON_TILTE_COLOR forState:UIControlStateNormal];
    btn.titleLabel.font = GB_DEFAULT_FONT(NAV_BUTTON_TITLE_FONT_SIZE);
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.navBarLeftButton = btn;
}

#pragma mark -
/**
 *  设置导航栏标题
 *
 *  @param title 导航栏标题
 */
- (void)setNavBarTitle:(NSString *)title
{
    if (!title || title.length == 0) { return; }
    
    float width = 0.0f;
    float height = KT_UI_NAVIGATION_BAR_HEIGHT;
    float y = 0.0f;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = 0.0f;
    
    CGSize titleSize =  KT_TEXTSIZE(title, GB_DEFAULT_FONT(NAV_TITLE_FONT_SIZE), CGSizeMake(10000, KT_UI_NAVIGATION_BAR_HEIGHT), NSLineBreakByCharWrapping);

    if (titleSize.width > NAV_MAX_TITLE_WIDTH) {
        width = NAV_MAX_TITLE_WIDTH;
    } else {
        width = titleSize.width;
    }
    x = (KT_UI_SCREEN_WIDTH - width)*0.5;
    
    if (self.navBarTitleImageView) { [self.navBarTitleImageView removeFromSuperview]; }
    if (self.navBarTitleLabel) { [self.navBarTitleLabel removeFromSuperview]; }
    if (self.navBarTitleView) { [self.navBarTitleView removeFromSuperview]; }
    
    UILabel *navBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    navBarTitleLabel.textAlignment = KT_TextAlignmentCenter;
    navBarTitleLabel.backgroundColor = [UIColor clearColor];
    navBarTitleLabel.text = title;
    navBarTitleLabel.textColor = NAV_TITLE_COLOR;
    navBarTitleLabel.font = GB_DEFAULT_FONT(NAV_TITLE_FONT_SIZE);
    [self addSubview:navBarTitleLabel];
    self.navBarTitleLabel = navBarTitleLabel;
}
/**
 *  设置导航栏标题
 *
 *  @param titleImage d导航栏标题图片
 */
- (void)setNavBarTitleImage:(UIImage *)titleImage
{
    float imageWidth = titleImage.size.width;
    float imageHeight = titleImage.size.height;
    float maxHeight = KT_UI_NAVIGATION_BAR_HEIGHT;
    float maxWidth = NAV_MAX_TITLE_WIDTH;
    if (imageHeight > maxHeight) { imageHeight = maxHeight; }
    if (imageWidth > maxWidth) { imageWidth = maxWidth; }
    float y = (maxHeight-imageHeight) * 0.5f;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = (maxHeight-imageHeight) * 0.5f +KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = (KT_UI_SCREEN_WIDTH-imageWidth) * 0.5f;
    
    if (self.navBarTitleImageView) { [self.navBarTitleImageView removeFromSuperview]; }
    if (self.navBarTitleLabel) { [self.navBarTitleLabel removeFromSuperview]; }
    if (self.navBarTitleView) { [self.navBarTitleView removeFromSuperview]; }
    
    
    UIImageView *navBarTitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageWidth, imageHeight)];
    navBarTitleImageView.image = titleImage;
    navBarTitleImageView.backgroundColor = [UIColor clearColor];
    navBarTitleImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:navBarTitleImageView];
    self.navBarTitleImageView = navBarTitleImageView;
}

/**
 *  设置导航栏标题
 *
 *  @param navBarTitleView 设置导航栏标题视图
 */
- (void)setNavBarTitleWithTitleView:(UIView *)navBarTitleView
{
    
    if (self.navBarTitleImageView) { [self.navBarTitleImageView removeFromSuperview]; }
    if (self.navBarTitleLabel) { [self.navBarTitleLabel removeFromSuperview]; }
    if (self.navBarTitleView) { [self.navBarTitleView removeFromSuperview]; }
    
    float width = navBarTitleView.frame.size.width;
    float height = navBarTitleView.frame.size.height;
    float y = (KT_UI_NAVIGATION_BAR_HEIGHT - height) * 0.5;
    if (KT_IOS_VERSION_7_OR_ABOVE) {
        y = (KT_UI_NAVIGATION_BAR_HEIGHT - height) * 0.5 +KT_UI_STATUS_BAR_HEIGHT;
    }
    float x = (self.frame.size.width - width) * 0.5;
    navBarTitleView.frame = CGRectMake(x, y, width, height);
    [self addSubview:navBarTitleView];
    self.navBarTitleView = navBarTitleView;
}

#pragma mark -
/**
 *  使导航栏的左边按钮隐藏/显示
 *
 *  @param hidden 支持 隐藏/显示
 */
- (void)setNavBarLeftButtonHidden:(BOOL)hidden
{
    if (self.navBarLeftButton) {
        self.navBarLeftButton.hidden = hidden;
    }
}
/**
 *  使导航栏的右边按钮隐藏/显示
 *
 *  @param hidden 支持 隐藏/显示
 */
- (void)setNavBarRightButtonHidden:(BOOL)hidden
{
    if (self.navBarRightButton) {
        self.navBarRightButton.hidden = hidden;
    }
}
/**
 *  使导航栏的标题隐藏/显示
 *
 *  @param hidden 支持 隐藏/显示
 */
- (void)setNavBarTitleLabelHidden:(BOOL)hidden
{
    if (self.navBarTitleLabel) {
        self.navBarTitleLabel.hidden = hidden;
    }
}
/**
 *  使导航栏的标题图片隐藏/显示
 *
 *  @param hidden 支持 隐藏/显示
 */
- (void)setNavBarTitleImageViewHidden:(BOOL)hidden
{
    if (self.navBarTitleImageView) {
        self.navBarTitleImageView.hidden = hidden;
    }
}
/**
 *  使导航栏的标题视图隐藏/显示
 *
 *  @param hidden 支持 隐藏/显示
 */
- (void)setNavBarTitleViewHidden:(BOOL)hidden
{
    if (self.navBarTitleView) {
        self.navBarTitleView.hidden = hidden;
    }
}
#pragma mark -
/**
 *  使导航栏的背景图片隐藏/显示
 *
 *  @param navBarBgImage 支持 隐藏/显示
 */
 - (void)setNavBarBgImage:(UIImage *)navBarBgImage
 {
     if (self.navBarBgImageView) {
     self.navBarBgImageView.image = navBarBgImage;
     }
 }
 

@end
