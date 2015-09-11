//
//  GBPRFourthCell.m
//  GameGifts
//
//  Created by Keven on 14-1-6.
//  Copyright (c) 2014年 Keven. All rights reserved.
//
#import "GBPopUpBox.h"
#import "GBPRFourthCell.h"
#import "UIImageView+WebCache.h"
#import "BaiduMobStat.h"

@implementation GBPRFourthCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}
- (void)setupCellViewWithURLString:(NSString *)URLString
                          gameName:(NSString *)gameName
                       serviceName:(NSString *)serviceName
                    giftCodeString:(NSString *)giftCode
                            status:(GetGiftStatus)status
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
         iconImageViewTmp.backgroundColor = KT_UICOLOR_CLEAR;
         [iconImageViewTmp setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_60_60)];
         [cellViewTmp addSubview:iconImageViewTmp];
         KT_CORNER_RADIUS(iconImageViewTmp, KT_CORNER_RADIUS_VALUE_5);
         self.iconImageView = iconImageViewTmp;
         
         
         
         //服务器名称
         
         CGSize serviceNameSize = KT_TEXTSIZE(serviceName, GB_DEFAULT_FONT(13), CGSizeMake(160, 21), NSLineBreakByWordWrapping);
         
         UILabel * serviceNameLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(90, 53, serviceNameSize.width, 21)];
         serviceNameLabelTmp.textColor = KT_HEXCOLOR(0x333333);
         serviceNameLabelTmp.textAlignment = KT_TextAlignmentLeft;
         serviceNameLabelTmp.font = GB_DEFAULT_FONT(13);
         serviceNameLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
         [cellViewTmp addSubview:serviceNameLabelTmp];
         serviceNameLabelTmp.text = serviceName;
         self.serviceNameLabel = serviceNameLabelTmp;
         

         //状态
         UILabel * statusLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(self.serviceNameLabel.frame.origin.x + self.serviceNameLabel.frame.size.width, 53, 50, 21)];
         statusLabelTmp.textColor = KT_HEXCOLOR(0xFF8500);
         statusLabelTmp.textAlignment = KT_TextAlignmentLeft;
         statusLabelTmp.font = GB_DEFAULT_FONT(13);
         statusLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
         [cellViewTmp addSubview:statusLabelTmp];
         self.statusLabel = statusLabelTmp;
         
         
         
         
         switch (status) {
             case GetGiftStatusForAlreadyReceive:
                 self.statusLabel.text = @"[已领取]";
                 break;
             case GetGiftStatusForHasBrought:
                 self.statusLabel.text = @"[已领完]";
                 break;
             case GetGiftStatusForOutOfDate:
                 self.statusLabel.text = @"[已过期]";
                 break;
             case GetGiftStatusForReservations:
                 self.statusLabel.text = @"[已预约]";
                 break;
             case GetGiftStatusForEndForUnclaimed:
                 self.statusLabel.text = @"[未领取]";
                 break;
             case GetGiftStatusForOrder:
                 self.statusLabel.text = @"[未预约]";
                 break;
             default:
                 break;
         }
         
            
        //兑换码
        UILabel * codeLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(90, 74, 50, 21)];
        codeLabelTmp.textColor = KT_HEXCOLOR(0x666666);
        codeLabelTmp.textAlignment = KT_TextAlignmentLeft;
        codeLabelTmp.font = GB_DEFAULT_FONT(12);
        codeLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        [cellViewTmp addSubview:codeLabelTmp];
        codeLabelTmp.text = @"兑换码:";
            
         
         
         UILabel * giftCodeLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(89, 93, 160, 21)];
         giftCodeLabelTmp.textColor = KT_HEXCOLOR(0x999999);
         giftCodeLabelTmp.textAlignment = KT_TextAlignmentLeft;
         giftCodeLabelTmp.font = GB_DEFAULT_FONT(11);
         giftCodeLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
         [cellViewTmp addSubview:giftCodeLabelTmp];
         giftCodeLabelTmp.text = giftCode;
         self.giftCodeLabel = giftCodeLabelTmp;
         
         
        UIButton * pressedButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
        pressedButtonTmp.frame = CGRectMake(258, 70, 48, 26);
        pressedButtonTmp.backgroundColor = KT_UICOLOR_CLEAR;
        pressedButtonTmp.titleLabel.font = GB_DEFAULT_FONT(12);
        KT_CORNER_RADIUS(pressedButtonTmp, KT_CORNER_RADIUS_VALUE_2);
        [pressedButtonTmp addTarget:self action:@selector(copeCode:) forControlEvents:UIControlEventTouchUpInside];
        [cellViewTmp addSubview:pressedButtonTmp];
        self.pressedButton = pressedButtonTmp;
        [self.pressedButton setTitle:@"复制" forState:UIControlStateNormal];
        [self.pressedButton setTitleColor:KT_HEXCOLOR(0xFF8500) forState:UIControlStateNormal];
        [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_copy_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
        [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_copy@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
     }else{
         self.gameNameLabel.text = gameName;
         self.serviceNameLabel.text = serviceName;
         [self.iconImageView setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_60_60)];
         
         //状态
         self.statusLabel.frame =  CGRectMake(self.serviceNameLabel.frame.origin.x + self.serviceNameLabel.frame.size.width, 53, 50, 21);
         switch (status) {
             case GetGiftStatusForAlreadyReceive:
                 self.statusLabel.text = @"[已领取]";
                 break;
             case GetGiftStatusForHasBrought:
                 self.statusLabel.text = @"[已领完]";
                 break;
             case GetGiftStatusForOutOfDate:
                 self.statusLabel.text = @"[已过期]";
                 break;
             case GetGiftStatusForReservations:
                 self.statusLabel.text = @"[已预约]";
                 break;
             case GetGiftStatusForEndForUnclaimed:
                 self.statusLabel.text = @"[未领取]";
                 break;
             case GetGiftStatusForOrder:
                 self.statusLabel.text = @"[未预约]";
                 break;
             default:
                 break;
         }
         self.giftCodeLabel.text = giftCode;
         [self.pressedButton setTitle:@"复制" forState:UIControlStateNormal];
         [self.pressedButton setTitleColor:KT_HEXCOLOR(0xFF8500) forState:UIControlStateNormal];
         [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
         [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_copy_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
         [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_copy@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
     }
}

- (void)copeCode:(id)sender
{
    KT_DLOG_SELECTOR;
    UIPasteboard * codePasteboard = [UIPasteboard generalPasteboard];
    [codePasteboard setString:self.giftCodeLabel.text];
    GBPopUpBox *popbox=[[GBPopUpBox alloc] initWithType:GBPopUpBoxTypeDefault withMessage:@"复制成功！" withAutoHidden:YES];
    
    UIView *view = [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] subviews] lastObject];
    [popbox showInView:view offset:0];
    
    [[BaiduMobStat defaultStat] logEvent:BAIDU_STATISTICS_EVENT_ID_COPY_BUTTON eventLabel:@""];
}

@end
