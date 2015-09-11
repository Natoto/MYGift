//
//  GBPRFirstCell.m
//  GameGifts
//
//  Created by Keven on 14-1-3.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBPRFirstCell.h"
#import "UIImageView+WebCache.h"

#define GIFT_SHOW_IMAGE_WIDTH  84.0f
@implementation GBPRFirstCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}
- (void)setupCellViewWithURLString:(NSString *)URLString
                          gameName:(NSString *)gameName
                       serviceName:(NSString *)serviceName
                          giftName:(NSString *)giftName
                      surplusCount:(NSUInteger)surplusCount
                          allCount:(NSUInteger)allCount
                            status:(GetGiftStatus)staus
                            target:(id)delegate
                            action:(SEL)action
{

    if (!self.cellView) {
        LineView * cellViewTmp = [[LineView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 125) type:LineViewTypeForSolidLine with:320];
        cellViewTmp.backgroundColor = KT_UICOLOR_CLEAR  ;
        [self.contentView addSubview:cellViewTmp];
        self.cellView = cellViewTmp;
        
        
        //游戏名称
        
        UILabel * gameNameLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(16, 9, 284, 21)];
        gameNameLabelTmp.textColor = KT_HEXCOLOR(0x333333);
        gameNameLabelTmp.textAlignment = KT_TextAlignmentLeft;
        gameNameLabelTmp.font = GB_DEFAULT_FONT(15);
        gameNameLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        [cellViewTmp addSubview:gameNameLabelTmp];
        gameNameLabelTmp.text = gameName;
        self.gameNameLabel = gameNameLabelTmp;
        
        //分割线
        
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(15, 39, 290, 0.5)];
        line.backgroundColor = KT_HEXCOLOR(0xDDDDDD);
        [cellViewTmp addSubview:line];
        
        //游戏图片
        UIImageView * iconImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(15, 53, 60, 60)];
        [iconImageViewTmp setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_60_60)];
        [cellViewTmp addSubview:iconImageViewTmp];
         KT_CORNER_RADIUS(iconImageViewTmp, KT_CORNER_RADIUS_VALUE_5);
        self.iconImageView = iconImageViewTmp;
        
       
        
        
        //服务器名称
        
        UILabel * serviceNameLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(90, 53, 160, 21)];
        serviceNameLabelTmp.textColor = KT_HEXCOLOR(0x333333);
        serviceNameLabelTmp.textAlignment = KT_TextAlignmentLeft;
        serviceNameLabelTmp.font = GB_DEFAULT_FONT(13);
        serviceNameLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        [cellViewTmp addSubview:serviceNameLabelTmp];
        serviceNameLabelTmp.text = serviceName;
        self.serviceNameLabel = serviceNameLabelTmp;
        
        
        //礼包名
        UILabel * giftNameLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(90, 74, 160, 21)];
        giftNameLabelTmp.textColor = KT_HEXCOLOR(0x666666);
        giftNameLabelTmp.textAlignment = KT_TextAlignmentLeft;
        giftNameLabelTmp.font = GB_DEFAULT_FONT(12);
        giftNameLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        [cellViewTmp addSubview:giftNameLabelTmp];
        giftNameLabelTmp.text = giftName;
        self.giftNameLabel = giftNameLabelTmp;
        
        NSString * giftSurpluString = [[NSString alloc] initWithFormat:@"剩余%d份:",surplusCount];
        CGSize giftSurpluStringSize = KT_TEXTSIZE(giftSurpluString, GB_DEFAULT_FONT(11), CGSizeMake(200, 21), NSLineBreakByWordWrapping);
        //剩余
        UILabel * giftSurplusLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(89, 93, giftSurpluStringSize.width, 21)];
        giftSurplusLabelTmp.textColor = KT_HEXCOLOR(0x999999);
        giftSurplusLabelTmp.textAlignment = KT_TextAlignmentLeft;
        giftSurplusLabelTmp.font = GB_DEFAULT_FONT(11);
        giftSurplusLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        [cellViewTmp addSubview:giftSurplusLabelTmp];
        giftSurplusLabelTmp.text = giftSurpluString;
        self.giftSurplusLabel = giftSurplusLabelTmp;
            
            
        UIImageView * giftShowImageBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.giftSurplusLabel.frame.origin.x + self.giftSurplusLabel.frame.size.width, 99, GIFT_SHOW_IMAGE_WIDTH, 8)];
        giftShowImageBackgroundImageView.image = [KT_GET_LOCAL_PICTURE_SECOND(@"gift_all_count@2x") stretchableImageWithLeftCapWidth:3 topCapHeight:3];
        [cellViewTmp addSubview:giftShowImageBackgroundImageView];
            
        //改变的ImageViuew
        float giftShowImageViewWidth = 0.0;
        if (allCount != 0) {
            giftShowImageViewWidth = surplusCount * GIFT_SHOW_IMAGE_WIDTH / allCount;
        }
        KT_DLog(@"allCount:%d==surplusCount:%d===gif:%f",allCount,surplusCount,giftShowImageViewWidth);
        UIImageView * giftShowImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(self.giftSurplusLabel.frame.origin.x + self.giftSurplusLabel.frame.size.width, 99, giftShowImageViewWidth, 8)];
        giftShowImageViewTmp.image = [KT_GET_LOCAL_PICTURE_SECOND(@"gift_surplus_count@2x") stretchableImageWithLeftCapWidth:3 topCapHeight:3];
        [cellViewTmp addSubview:giftShowImageViewTmp];
        self.giftShowImageView = giftShowImageViewTmp;
        
        UIButton * pressedButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
        pressedButtonTmp.frame = CGRectMake(258, 70, 48, 26);
        pressedButtonTmp.backgroundColor = KT_UICOLOR_CLEAR;
        pressedButtonTmp.titleLabel.font = GB_DEFAULT_FONT(12);
        KT_CORNER_RADIUS(pressedButtonTmp, KT_CORNER_RADIUS_VALUE_2);
        [pressedButtonTmp addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
        [cellViewTmp addSubview:pressedButtonTmp];
        self.pressedButton = pressedButtonTmp;
        
        if (staus == GetGiftStatusForEndForUnclaimed) {//未领取
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"领取" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_BlueColor forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
             self.pressedButton.userInteractionEnabled = YES;
        }else if(staus == GetGiftStatusForAlreadyReceive){ //已领取
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已领取" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
        }else if (staus == GetGiftStatusForHasBrought){//已领完
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已领完" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
            
        }else if (staus == GetGiftStatusForOutOfDate){//已过期
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已过期" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
            
        }else if (staus == GetGiftStatusForOrder){ //预约
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"预约" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GreenColor forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = YES;
        }else if (staus == GetGiftStatusForReservations){//已预约
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已预约" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_PurpleColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_already_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_already_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
        }
        
    }else{
        
        self.gameNameLabel.text = gameName;
        [self.iconImageView setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_60_60)];
        self.serviceNameLabel.text = serviceName;
        self.giftNameLabel.text = giftName;
        
    
        self.giftSurplusLabel.text = [[NSString alloc] initWithFormat:@"剩余%d份:",surplusCount];
        //改变的ImageViuew
       
        float giftShowImageViewWidth = surplusCount * GIFT_SHOW_IMAGE_WIDTH / allCount;
        self.giftShowImageView.frame = CGRectMake(self.giftSurplusLabel.frame.origin.x + self.giftSurplusLabel.frame.size.width, 99, giftShowImageViewWidth, 8);
        
        
        [self.pressedButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.pressedButton setBackgroundImage:nil forState:UIControlStateNormal];
        if (staus == GetGiftStatusForEndForUnclaimed) {//未领取
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"领取" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_BlueColor forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
             self.pressedButton.userInteractionEnabled = YES;
        }else if(staus == GetGiftStatusForAlreadyReceive){ //已领取
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已领取" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
        }else if (staus == GetGiftStatusForHasBrought){//已领完
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已领完" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
            
        }else if (staus == GetGiftStatusForOutOfDate){//已过期
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已过期" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
            
        }else if (staus == GetGiftStatusForOrder){ //预约
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"预约" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_GreenColor forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = YES;
        }else if (staus == GetGiftStatusForReservations){//已预约
            self.pressedButton.hidden = NO;
            [self.pressedButton setTitle:@"已预约" forState:UIControlStateNormal];
            [self.pressedButton setTitleColor:KT_PurpleColor forState:UIControlStateNormal];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_already_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_already_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
            self.pressedButton.userInteractionEnabled = NO;
        }    }
}


@end
