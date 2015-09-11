//
//  GBHPThirdCell.m
//  GameGifts
//
//  Created by Keven on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GBHPThirdCell.h"
#import "UIImageView+WebCache.h"
@implementation GBHPThirdCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}
- (void)setupCellVieweWtihGameName:(NSString *)gameName
                         URLString:(NSString *)URLString
                       serviceName:(NSString *)serviceName
                          giftName:(NSString *)gitfName
                       releaseTime:(NSTimeInterval)time
                      packageCount:(NSUInteger)count
                               row:(NSUInteger)row
                           isFirst:(BOOL)isFirst
                        giftStatus:(GetGiftStatus)giftStatus
                            target:(id)delegate
                            action:(SEL)action
{
    KT_DLog(@"giftStatus:%d",giftStatus);
    if (!self.cellView) {
        UIView * cellViewTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], isFirst ? 151:144)];
        cellViewTmp.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
        [self.contentView addSubview:cellViewTmp];
        self.cellView = cellViewTmp;
        
        UIImageView * backgroundImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(5, isFirst ? 13:6, 310, 138)];
        backgroundImageViewTmp.image = [KT_GET_LOCAL_PICTURE_SECOND(@"hp_list_bg@2x") stretchableImageWithLeftCapWidth:37 topCapHeight:55];
        [cellViewTmp addSubview:backgroundImageViewTmp];
        self.backgroundImageView = backgroundImageViewTmp;
        
        
        UILabel * gameNameLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(17, isFirst ? 23:16, 280, 21)];
        gameNameLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        gameNameLabelTmp.textAlignment = KT_TextAlignmentLeft;
        gameNameLabelTmp.font = GB_DEFAULT_FONT(15);
        gameNameLabelTmp.textColor = KT_HEXCOLOR(0x333333);
        [cellViewTmp addSubview:gameNameLabelTmp];
        gameNameLabelTmp.text = gameName;
        self.gameNameLabel = gameNameLabelTmp;
        
        
        
        UIImageView * iconImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(16, isFirst ? 62:55, 100, 60)];
        [cellViewTmp addSubview:iconImageViewTmp];
        [iconImageViewTmp setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_100_60)];
        KT_CORNER_RADIUS(iconImageViewTmp, KT_CORNER_RADIUS_VALUE_5);
        self.iconImageView = iconImageViewTmp;
        
        UILabel * serviceLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(127, isFirst ? 62:55, 173, 21)];
        serviceLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        serviceLabelTmp.textAlignment = KT_TextAlignmentLeft;
        serviceLabelTmp.font = GB_DEFAULT_FONT(13);
        serviceLabelTmp.textColor = KT_HEXCOLOR(0x333333);
        [cellViewTmp addSubview:serviceLabelTmp];
        serviceLabelTmp.text = serviceName;
        self.serviceLabel = serviceLabelTmp;
        
        
        UILabel * giftNameLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(127, isFirst ? 86:79, 173, 15)];
        giftNameLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        giftNameLabelTmp.textAlignment = KT_TextAlignmentLeft;
        giftNameLabelTmp.font = GB_DEFAULT_FONT(12);
        giftNameLabelTmp.textColor = KT_HEXCOLOR(0x666666);
        [cellViewTmp addSubview:giftNameLabelTmp];
        giftNameLabelTmp.text = gitfName;
        self.giftNameLabel = giftNameLabelTmp;
        
        
        
        UILabel * timeLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(127, isFirst ? 106:99, 173, 15)];
        timeLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        timeLabelTmp.textAlignment = KT_TextAlignmentLeft;
        timeLabelTmp.font = GB_DEFAULT_FONT(11);
        timeLabelTmp.textColor = KT_HEXCOLOR(0x999999);
        [cellViewTmp addSubview:timeLabelTmp];
        
        KT_DLog(@"timekkk = %f",time);
        KT_DLog(@"timekkkStr = %@",[Utils getTimeWithTimeInterval:time]);
        timeLabelTmp.text = [[NSString alloc]initWithFormat:@"发布时间：%@",[Utils getTimeWithTimeInterval:time]];
        self.timeLabel = timeLabelTmp;
        
        
        
        UILabel * countLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(16, isFirst ? 126:119, 130, 21)];
        countLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        countLabelTmp.textAlignment = KT_TextAlignmentLeft;
        countLabelTmp.font = GB_DEFAULT_FONT(12);
        countLabelTmp.textColor = KT_HEXCOLOR(0xFF8500);
        [cellViewTmp addSubview:countLabelTmp];
        countLabelTmp.text = [[NSString alloc]initWithFormat:@"剩余%u份",count];
        self.countLabel = countLabelTmp;
        
        
        
        UIButton * pressedButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
        pressedButtonTmp.frame = CGRectMake(258, isFirst ? 119:112, 48, 26);
        pressedButtonTmp.tag = row;
        pressedButtonTmp.titleLabel.font = GB_DEFAULT_FONT(12);
        KT_CORNER_RADIUS(pressedButtonTmp, KT_CORNER_RADIUS_VALUE_2);
        [pressedButtonTmp addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
        [cellViewTmp addSubview:pressedButtonTmp];
        self.pressedButton = pressedButtonTmp;
        
        if (giftStatus == GetGiftStatusForEndForUnclaimed) {//未领取
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"领取" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_BlueColor forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = YES;
        }else if(giftStatus == GetGiftStatusForAlreadyReceive){ //已领取
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已领取" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
        }else if (giftStatus == GetGiftStatusForHasBrought){//已领完
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已领完" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
        
        }else if (giftStatus == GetGiftStatusForOutOfDate){//已过期
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已过期" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
            
        }else if (giftStatus == GetGiftStatusForOrder){ //预约
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"预约" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GreenColor forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
        self.pressedButton.userInteractionEnabled = YES;
        }else if (giftStatus == GetGiftStatusForReservations){//已预约
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已预约" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_PurpleColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_already_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_already_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
        }
        
        
        
    }else{
        
        self.backgroundImageView.frame = CGRectMake(5, isFirst ? 13:6, 310, 138);
        self.backgroundImageView.image = [KT_GET_LOCAL_PICTURE_SECOND(@"hp_list_bg@2x") stretchableImageWithLeftCapWidth:37 topCapHeight:55];
        
        
        self.gameNameLabel.frame = CGRectMake(17, isFirst ? 23:16, 280, 21);
        self.gameNameLabel.text = gameName;
        
        self.iconImageView.frame = CGRectMake(16, isFirst ? 62:55, 100, 60);
        [self.iconImageView setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_100_60)];

        self.serviceLabel.frame = CGRectMake(127, isFirst ? 62:55, 173, 21);
        self.serviceLabel.text = serviceName;
        
        self.giftNameLabel.frame = CGRectMake(127, isFirst ? 86:79, 173, 15);
        self.giftNameLabel.text = gitfName;
        
        
        self.timeLabel.frame = CGRectMake(127, isFirst ? 106:99, 173, 15);
        self.timeLabel.text = [[NSString alloc]initWithFormat:@"发布时间：%@",[Utils getTimeWithTimeInterval:time]];
  
        self.countLabel.frame = CGRectMake(16, isFirst ? 126:119, 130, 21);
        self.countLabel.text = [[NSString alloc]initWithFormat:@"剩余%u份",count];
        
        
        self.pressedButton.frame = CGRectMake(258, isFirst ? 119:112, 48, 26);
        self.pressedButton.tag = row;
        [self.pressedButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.pressedButton setBackgroundImage:nil forState:UIControlStateNormal];
        if (giftStatus == GetGiftStatusForEndForUnclaimed) {//未领取
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"领取" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_BlueColor forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
             self.pressedButton.userInteractionEnabled = YES;
        }else if(giftStatus == GetGiftStatusForAlreadyReceive){ //已领取
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已领取" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
        }else if (giftStatus == GetGiftStatusForHasBrought){//已领完
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已领完" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
            
        }else if (giftStatus == GetGiftStatusForOutOfDate){//已过期
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已过期" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
            
        }else if (giftStatus == GetGiftStatusForOrder){ //预约
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"预约" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GreenColor forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = YES;
        }else if (giftStatus == GetGiftStatusForReservations){//已预约
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已预约" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_PurpleColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_already_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_already_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
        }
        
    }
}


@end
