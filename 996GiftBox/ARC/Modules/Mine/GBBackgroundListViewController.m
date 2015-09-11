//
//  GBBackgroundListViewController.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-7.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBackgroundListViewController.h"
#import "GBBackgroundModel.h"
#import "LocalSettings.h"
#import "GBBackgroundPreviewController.h"
#define BG_ONE_ROW_COUNT 3
#define BG_IMG_NAME_SPACE 3

@interface GBBackgroundListViewController ()

@property (nonatomic, KT_WEAK) UIScrollView *scrollView;
@property (nonatomic, KT_WEAK) UIImageView *defaultBG;
@property (nonatomic, KT_WEAK) UIImageView *maskImageView;
@property (nonatomic, KT_WEAK) UILabel *defaultLabel;
@property (nonatomic, KT_STRONG) GBBackgroundModel *currentModel;
@property (nonatomic, KT_STRONG) GBBackgroundModel *defaultModel;
@property (nonatomic, assign) CGFloat beginY;
@property (nonatomic, KT_STRONG) NSArray *modelArray;

@end

@implementation GBBackgroundListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.customNavigationBar setNavBarTitle:@"设置背景"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = KT_UICOLOR_CLEAR;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    //测试+++++++++++++++++++++++++++++++++++++++++++
    GBBackgroundModel *defualtModel = [[GBBackgroundModel alloc] init];
    defualtModel.iconUrl = @"bg_icon_snow@2x";
    defualtModel.sourceUrl = @"bg_source_snow@2x";
    defualtModel.bgName = @"大雪初霁";
    self.defaultModel = defualtModel;
    
    GBBackgroundModel *model1 = [[GBBackgroundModel alloc] init];
    model1.iconUrl = @"bg_icon_rock@2x";
    model1.sourceUrl = @"bg_source_rock@2x";
    model1.bgName = @"安如磐石";
    
    GBBackgroundModel *model2 = [[GBBackgroundModel alloc] init];
    model2.iconUrl = @"bg_icon_sun@2x";
    model2.sourceUrl = @"bg_source_sun@2x";
    model2.bgName = @"静谧落日";

    
    GBBackgroundModel *model3 = [[GBBackgroundModel alloc] init];
    model3.iconUrl = @"bg_icon_yellowflower@2x";
    model3.sourceUrl = @"bg_source_yellowflower@2x";
    model3.bgName = @"如花似锦";
    
    GBBackgroundModel *model4 = [[GBBackgroundModel alloc] init];
    model4.iconUrl = @"bg_icon_mountains@2x";
    model4.sourceUrl = @"bg_source_mountains@2x";
    model4.bgName = @"崇山峻岭";
    
    GBBackgroundModel *model5 = [[GBBackgroundModel alloc] init];
    model5.iconUrl = @"bg_icon_redflower@2x";
    model5.sourceUrl = @"bg_source_redflower@2x";
    model5.bgName = @"群芳吐艳";
    
    GBBackgroundModel *model6 = [[GBBackgroundModel alloc] init];
    model6.iconUrl = @"bg_icon_rain@2x";
    model6.sourceUrl = @"bg_source_rain@2x";
    model6.bgName = @"春雨绵绵";
    
    GBBackgroundModel *model7 = [[GBBackgroundModel alloc] init];
    model7.iconUrl = @"bg_icon_sunset@2x";
    model7.sourceUrl = @"bg_source_sunset@2x";
    model7.bgName = @"余霞成绮";
    
    GBBackgroundModel *model8 = [[GBBackgroundModel alloc] init];
    model8.iconUrl = @"bg_icon_grass@2x";
    model8.sourceUrl = @"bg_source_grass@2x";
    model8.bgName = @"绿草如茵";
    
    GBBackgroundModel *model9 = [[GBBackgroundModel alloc] init];
    model9.iconUrl = @"bg_icon_ice@2x";
    model9.sourceUrl = @"bg_source_ice@2x";
    model9.bgName = @"冰河雪山";
    
    self.modelArray = [NSArray arrayWithObjects:model1, model2, model3, model4, model5, model6, model7, model8, model9, nil];
    
    [self layoutBgList];
    
    //+++++++++++++++++++++++++++++++++++++++++++++++
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popBack:(id)sender
{
    [self.KTNavigationController popKTViewControllerAnimated:YES];
}

- (void)setupCustomTabBarButton
{
    [self.customTabBar setTabBarButtonWithImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back@2x")
                               highlightedImage:KT_GET_LOCAL_PICTURE_SECOND(@"bar_back_highlight@2x")
                                     buttonType:CustomTabBarButtonTypeOfLeft
                                         target:self
                                         action:@selector(popBack:)];
}

//- (void)setDefaultModel:(GBBackgroundModel *)defaultModel
//{
////    _defaultModel = defaultModel;
//    self.defaultBG.image = KT_GET_LOCAL_PICTURE(defaultModel.iconUrl);
//    self.defaultLabel.text = defaultModel.bgName;
//}

- (void)layoutBgList
{
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat x = 10, y = 15 + KT_UI_NAVIGATION_BAR_HEIGHT + KT_UI_STATUS_BAR_HEIGHT;
    
    //默认背景
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 16)];
    titleLabel1.backgroundColor = KT_UICOLOR_CLEAR;
    titleLabel1.font = GB_DEFAULT_FONT(16);
    titleLabel1.textColor = KT_HEXCOLOR(0x333333);
    titleLabel1.text = @"默认背景";
    [self.scrollView addSubview:titleLabel1];
    
    y += (titleLabel1.bounds.size.height + 15);
    
//    UIImageView *defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 94, 94)];
//    defaultImageView.backgroundColor = KT_UICOLOR_CLEAR;
//    [self.scrollView addSubview:defaultImageView];
//    self.defaultBG = defaultImageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, 94, 94);
    [button setImage:KT_GET_LOCAL_PICTURE(self.defaultModel.iconUrl) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didDefaultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:button.frame];
    maskView.image = KT_GET_LOCAL_PICTURE(@"bg_icon_default@2x");
    [self.scrollView addSubview:maskView];
    
    self.maskImageView = maskView;
    
    y += (button.bounds.size.height + BG_IMG_NAME_SPACE);
    
    UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 94, 12)];
    defaultLabel.textAlignment = NSTextAlignmentCenter;
    defaultLabel.backgroundColor = KT_UICOLOR_CLEAR;
    defaultLabel.font = GB_DEFAULT_FONT(12);
    defaultLabel.textColor = KT_HEXCOLOR(0x999999);
    defaultLabel.text = self.defaultModel.bgName;
    [self.scrollView addSubview:defaultLabel];
    self.defaultLabel = defaultLabel;
    
    y += (defaultLabel.bounds.size.height + 15);
    
    //推荐背景
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 16)];
    titleLabel2.backgroundColor = KT_UICOLOR_CLEAR;
    titleLabel2.font = GB_DEFAULT_FONT(16);
    titleLabel2.textColor = KT_HEXCOLOR(0x333333);
    titleLabel2.text = @"推荐背景";
    [self.scrollView addSubview:titleLabel2];
    
    y += (titleLabel1.bounds.size.height + 15);
    
    int count = [self.modelArray count];
    int rowCount = count/BG_ONE_ROW_COUNT;
    int remainder = count%BG_ONE_ROW_COUNT;
    
    if (remainder > 0) {
        rowCount ++;
    }
    
    for (int i = 0; i < rowCount; ++i) {
        for (int j = 0; j < BG_ONE_ROW_COUNT; ++j) {
            GBBackgroundModel *model = [self.modelArray objectAtIndex:i*BG_ONE_ROW_COUNT+j];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i*BG_ONE_ROW_COUNT+j;
            button.frame = CGRectMake(x, y, 94, 94);
            [button setImage:KT_GET_LOCAL_PICTURE(model.iconUrl) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(didButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
            
            if (model.isSelected) {
                self.maskImageView.frame = button.frame;
                [self.scrollView bringSubviewToFront:self.maskImageView];
            }
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, (y + button.bounds.size.height + BG_IMG_NAME_SPACE), 94, 12)];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = KT_UICOLOR_CLEAR;
            label.font = GB_DEFAULT_FONT(12);
            label.textColor = KT_HEXCOLOR(0x999999);
            label.text = model.bgName;
            [self.scrollView addSubview:label];
            
            if (i*BG_ONE_ROW_COUNT+(j+1) >= count) {
                break;
            }
            
            x += 104;
        }
        
        y += (94 + BG_IMG_NAME_SPACE + 12 + 12);
        x = 10;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, y + 15 + KT_UI_TAB_BAR_HEIGHT);
}

- (void)didDefaultAction:(UIButton *)button
{
//    if (self.currentModel != self.defaultModel) {
//        self.currentModel.isSelected = NO;
//        self.defaultModel.isSelected = YES;
//        self.currentModel = self.defaultModel;
        
//        self.maskImageView.frame = button.frame;
//        [self.scrollView bringSubviewToFront:self.maskImageView];
//    }
    NSMutableArray *tmpArray = [NSMutableArray arrayWithObject:self.defaultModel];
    [tmpArray addObjectsFromArray:self.modelArray];
    GBBackgroundPreviewController *vc = [[GBBackgroundPreviewController alloc] initWithBackgroudList:tmpArray
                                                                      withCurIndex:0];
    [self.KTNavigationController pushKTViewController:vc animated:YES];
    
}

- (void)didButtonAction:(UIButton *)button
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithObject:self.defaultModel];
    [tmpArray addObjectsFromArray:self.modelArray];
    
    GBBackgroundPreviewController *vc = [[GBBackgroundPreviewController alloc] initWithBackgroudList:tmpArray
                                                                      withCurIndex:button.tag+1];
    [self.KTNavigationController pushKTViewController:vc animated:YES]; 
    
    
}

@end
