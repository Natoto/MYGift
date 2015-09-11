//
//  GBNoDataShowView.m
//  GameGifts
//
//  Created by Keven on 14-1-10.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBNoDataShowView.h"

@interface GBNoDataShowView()

@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, weak) UILabel *titleLabel;

@end

@implementation GBNoDataShowView
- (id)initWithType:(GBNoDataShowViewType)type
            target:(id<GBNoDataShowViewDelegate>)delegate
           infoTag:(int)tag
{
    self = [super initWithFrame:CGRectMake(0, 0, [Utils screenWidth], [Utils screenHeight] - KT_UI_STATUS_BAR_HEIGHT)];
    if (self) {
        self.delegate = delegate;
        self.infoTag = tag;
        self.backgroundColor = [UIColor whiteColor];
        [self setupNoDataShowViewWithType:type];
    }
    return self;
}
- (void)setupNoDataShowViewWithType:(GBNoDataShowViewType)type
{
    
    if (type == GBNoDataShowViewTypeForNoNetwork) { //没有网络
        [self setupGBNoDataShowViewWithImageName:@"no_network_two@2x"
                                     titleString:@"请点击刷新"];
        UIButton * pressedBt = [UIButton buttonWithType:UIButtonTypeCustom];
        pressedBt.frame = self.bounds;
        [pressedBt addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pressedBt];
    }else if (type == GBNoDataShowViewTypeForServierError){ //加载错误
        [self setupGBNoDataShowViewWithImageName:@"no_logo@2x"
                                     titleString:@"加载失败,请点击刷新"];
        UIButton * pressedBt = [UIButton buttonWithType:UIButtonTypeCustom];
        pressedBt.frame = self.bounds;
        [pressedBt addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pressedBt];
    }else if (type == GBNoDataShowViewTypeForNoData){ //没有数据
        [self setupGBNoDataShowViewWithImageName:@"no_logo@2x"
                                     titleString:@"小编睡过头了,请点击刷新"];
        UIButton * pressedBt = [UIButton buttonWithType:UIButtonTypeCustom];
        pressedBt.frame = self.bounds;
        [pressedBt addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pressedBt];
    }else if (type == GBNoDataShowViewTypeForSearch){
        [self setupGBNoDataShowViewWithImageName:@"no_search_result@2x"
                                     titleString:@"黑夜给了我黑色的眼睛"
                                  subTitleString:@"可我什么也没找到"];
    }else if (type == GBNoDataShowViewTypeForMineGift){
        [self setupGBNoDataShowViewWithImageName:@"mine_code@2x"
                                     titleString:@"没有兑换码，感觉不会爱了～"];
    }
}

- (void)setupGBNoDataShowViewWithImageName:(NSString *)imgName
                               titleString:(NSString *)title
{
    //图片
    UIImageView * iconImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(132, 200, 57, 57)];
    [self addSubview:iconImageViewTmp];
    iconImageViewTmp.image = KT_GET_LOCAL_PICTURE_SECOND(imgName);
    
    //文字
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, 320, 21)];
    titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
    titleLabel.textAlignment = KT_TextAlignmentCenter;
    titleLabel.textColor = KT_HEXCOLOR(0x666666);
    titleLabel.font = GB_DEFAULT_FONT(12);
    titleLabel.text = title;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)setupGBNoDataShowViewWithImageName:(NSString *)imgName
                               titleString:(NSString *)title
                            subTitleString:(NSString *)subTitle
{
    
   [self setupGBNoDataShowViewWithImageName:imgName
                                titleString:title];
    //第二行文字
    UILabel * secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, 320, 21)];
    secondTitleLabel.backgroundColor = KT_UICOLOR_CLEAR;
    secondTitleLabel.textAlignment = KT_TextAlignmentCenter;
    secondTitleLabel.textColor = KT_HEXCOLOR(0x666666);
    secondTitleLabel.font = GB_DEFAULT_FONT(12);
    [self addSubview:secondTitleLabel];
    secondTitleLabel.text = subTitle;
}
- (void)buttonPressed:(id)sender
{
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    if (!self.indicatorView) {
        UIActivityIndicatorView * indicatorViewTmp = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorViewTmp.hidesWhenStopped = YES;
        indicatorViewTmp.frame = CGRectMake(110, 220, 30, 30);
        [self addSubview:indicatorViewTmp];
        [indicatorViewTmp startAnimating];
        self.indicatorView = indicatorViewTmp;
    }else{
        [self.indicatorView  startAnimating];
    }
    
    self.titleLabel.text = @"正在加载，请稍后...";
    
    if ([self.delegate respondsToSelector:@selector(refreshByNoDataShowViewWithInfoTag:)]) {
        [self.delegate refreshByNoDataShowViewWithInfoTag:self.infoTag];
    }
}
- (void)stopIndicatorView
{
    self.isLoading = NO;
    [self.indicatorView  stopAnimating];
    self.titleLabel.text = @"请点击刷新";
}
@end
