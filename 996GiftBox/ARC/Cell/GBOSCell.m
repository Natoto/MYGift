//
//  GBOSCell.m
//  GameGifts
//
//  Created by Keven on 14-1-7.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBOSCell.h"
#import "UIImageView+WebCache.h"
@implementation GBOSCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}
- (void)setupCellViewWithURLString:(NSString *)URLString
                          gameName:(NSString *)gameName
                      scorceNumber:(int)scorceNumber
                          betaTime:(double)time
                           hasGift:(BOOL)hasGift
                        betaString:(NSString *)betaString
                        typeString:(NSString *)typeString
                         tableType:(int)tableType
                               row:(int)row
                            target:(id)delegate
                            action:(SEL)action
{


    if (!self.cellView) {
        UIView * cellViewTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 109)];
        cellViewTmp.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
        [self.contentView addSubview:cellViewTmp];
        self.cellView = cellViewTmp;
        
        
        UIImageView * backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 104)];
        backgroundImageView.image = [KT_GET_LOCAL_PICTURE_SECOND(@"list_bg@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13];
        [cellViewTmp addSubview:backgroundImageView];
        
        //icon
        KT_DLog(@"URLString:%@",URLString);
        UIImageView * iconImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17, 50, 50)];
        [iconImageViewTmp setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_50_50)];
        [cellViewTmp addSubview:iconImageViewTmp];
        KT_CORNER_RADIUS(iconImageViewTmp, KT_CORNER_RADIUS_VALUE_5);
        self.iconImageView = iconImageViewTmp;
        
        
        //游戏名称
        UILabel * gameLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(74, 15, 176, 21)];
        gameLabelTmp.textAlignment = KT_TextAlignmentLeft;
        gameLabelTmp.textColor = KT_HEXCOLOR(0x333333);
        gameLabelTmp.font = GB_DEFAULT_FONT(13);
        gameLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        [cellViewTmp addSubview:gameLabelTmp];
        gameLabelTmp.text = gameName;
        self.gameNameLabel = gameLabelTmp;
        
        //星星
        GBStarsView * starViewTmp = [[GBStarsView alloc] initWithFrame:CGRectMake(76, 38, 68, 11)];
        starViewTmp.backgroundColor = KT_UICOLOR_CLEAR;
        [cellViewTmp addSubview:starViewTmp];
        [starViewTmp refreshWithInt:scorceNumber];
        self.starView = starViewTmp;
        
        //时间
        UILabel * timeLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(74, 51, 176, 21)];
        timeLabelTmp.textAlignment = KT_TextAlignmentLeft;
        timeLabelTmp.textColor = KT_HEXCOLOR(0x999999);
        timeLabelTmp.font = GB_DEFAULT_FONT(11);
        timeLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        [cellViewTmp addSubview:timeLabelTmp];
        NSString * timeString = nil;
        if (tableType == 1) {
            timeString = [[NSString alloc] initWithFormat:@"开服时间:%@",[Utils getTimeWithTimeInterval:time]];
        }else{
            timeString = [[NSString alloc] initWithFormat:@"开测时间:%@",[Utils getTimeWithTimeInterval:time]];
        }
        timeLabelTmp.text = timeString;
        self.timeLabel = timeLabelTmp;
        
        //礼包
        if (hasGift) {
            UIButton * pressedButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
            pressedButtonTmp.frame = CGRectMake(258, 30, 48, 26);
            pressedButtonTmp.tag = tableType * 1000 + row;
            pressedButtonTmp.backgroundColor = KT_UICOLOR_CLEAR;
            pressedButtonTmp.titleLabel.font = GB_DEFAULT_FONT(12);
            KT_CORNER_RADIUS(pressedButtonTmp, KT_CORNER_RADIUS_VALUE_2);
            [pressedButtonTmp addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
            [cellViewTmp addSubview:pressedButtonTmp];
            self.pressedButton = pressedButtonTmp;
            [self.pressedButton setTitle:@"礼包" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_BlueColor forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
        }
        
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(16, 79, 288, 0.5)];
        line.backgroundColor = KT_HEXCOLOR(0xDDDDDD);
        [cellViewTmp addSubview:line];
        
        
        UILabel * betaLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(16, 84, 200, 21)];
        betaLabelTmp.textAlignment = KT_TextAlignmentLeft;
        betaLabelTmp.textColor = KT_HEXCOLOR(0xFF8500);
        betaLabelTmp.font = GB_DEFAULT_FONT(12);
        betaLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        [cellViewTmp addSubview:betaLabelTmp];
        betaLabelTmp.text = betaString;
        self.betaLabel = betaLabelTmp;
        
        
        
        UILabel * typeLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(150, 84, 155, 21)];
        typeLabelTmp.textAlignment = KT_TextAlignmentLeft;
        typeLabelTmp.textColor = KT_HEXCOLOR(0x999999);
        typeLabelTmp.font = GB_DEFAULT_FONT(11);
        typeLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        typeLabelTmp.textAlignment=NSTextAlignmentRight;
        [cellViewTmp addSubview:typeLabelTmp];
        typeLabelTmp.text = [[NSString alloc] initWithFormat:@"类型：%@",typeString];
        self.typeLabel = typeLabelTmp;
        
        
        
    }else{
        self.gameNameLabel.text = gameName;
        NSString * timeString = nil;
        if (tableType == 1) {
            timeString = [[NSString alloc] initWithFormat:@"开服时间:%@",[Utils getTimeWithTimeInterval:time]];
        }else{
            timeString = [[NSString alloc] initWithFormat:@"开测时间:%@",[Utils getTimeWithTimeInterval:time]];
        }
        self.timeLabel.text = timeString;
        [self.starView refreshWithInt:scorceNumber];
        [self.iconImageView setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_50_50)];

        //礼包
        if (hasGift) {
            if (!self.pressedButton) {
                UIButton * pressedButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
                pressedButtonTmp.tag = tableType * 1000 + row;
                pressedButtonTmp.frame = CGRectMake(258, 30, 48, 26);
                pressedButtonTmp.backgroundColor = KT_UICOLOR_CLEAR;
                pressedButtonTmp.titleLabel.font = GB_DEFAULT_FONT(12);
                KT_CORNER_RADIUS(pressedButtonTmp, KT_CORNER_RADIUS_VALUE_2);
                [pressedButtonTmp addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
                [self.cellView addSubview:pressedButtonTmp];
                self.pressedButton = pressedButtonTmp;
                [self.pressedButton setTitle:@"礼包" forState:UIControlStateNormal];
                [self.pressedButton setTitleColor:KT_BlueColor forState:UIControlStateNormal];
                [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            }
        }
        
        
        self.betaLabel.text = betaString;
        self.typeLabel.text = [[NSString alloc] initWithFormat:@"类型：%@",typeString];
    }
}

@end
