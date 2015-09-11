//
//  GBACLCell.m
//  GameGifts
//
//  Created by Keven on 14-1-2.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBACLCell.h"
#import "UIImageView+WebCache.h"
@implementation GBACLCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)setupCellVieweWtihActivityName:(NSString *)gameName
                             URLString:(NSString *)URLString
                           serviceName:(NSString *)serviceName
                              subtitle:(NSString *)subtitle
                              giftInfo:(NSString *)giftInfo
                                  time:(NSTimeInterval)time
                       popularityCount:(NSUInteger)count
{

    if (!self.cellView) {
        UIView * cellViewTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 144)];
        cellViewTmp.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
        [self.contentView addSubview:cellViewTmp];
        self.cellView = cellViewTmp;
        
        UIImageView * backgroundImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 310, 138)];
        backgroundImageViewTmp.image = [KT_GET_LOCAL_PICTURE_SECOND(@"hp_list_bg@2x") stretchableImageWithLeftCapWidth:37 topCapHeight:55];
        [cellViewTmp addSubview:backgroundImageViewTmp];
        self.backgroundImageView = backgroundImageViewTmp;
        
        
        UILabel * gameNameLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(17, 16, 280, 21)];
        gameNameLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        gameNameLabelTmp.textAlignment = KT_TextAlignmentLeft;
        gameNameLabelTmp.font = GB_DEFAULT_FONT(13);
        gameNameLabelTmp.textColor = KT_HEXCOLOR(0x333333);
        [cellViewTmp addSubview:gameNameLabelTmp];
        gameNameLabelTmp.text = gameName;
        self.gameNameLabel = gameNameLabelTmp;
        
        
        
        UIImageView * iconImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(16, 55, 100, 60)];
        [cellViewTmp addSubview:iconImageViewTmp];
        [iconImageViewTmp setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_100_60)];
        KT_CORNER_RADIUS(iconImageViewTmp, KT_CORNER_RADIUS_VALUE_5);
        self.iconImageView = iconImageViewTmp;
        
        UILabel * serviceLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(127, 55, 173, 21)];
        serviceLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        serviceLabelTmp.textAlignment = KT_TextAlignmentLeft;
        serviceLabelTmp.font = GB_DEFAULT_FONT(13);
        serviceLabelTmp.textColor = KT_HEXCOLOR(0x333333);
        [cellViewTmp addSubview:serviceLabelTmp];
        serviceLabelTmp.text = serviceName;
        self.serviceLabel = serviceLabelTmp;
        
        
        UILabel * subtitleLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(127,79, 173, 15)];
        subtitleLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        subtitleLabelTmp.textAlignment = KT_TextAlignmentLeft;
        subtitleLabelTmp.font = GB_DEFAULT_FONT(12);
        subtitleLabelTmp.textColor = KT_HEXCOLOR(0x666666);
        [cellViewTmp addSubview:subtitleLabelTmp];
        subtitleLabelTmp.text = subtitle;
        self.subtitleLabel = subtitleLabelTmp;
        
        
        UILabel * giftInfoLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(127,99, 173, 15)];
        giftInfoLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        giftInfoLabelTmp.textAlignment = KT_TextAlignmentLeft;
        giftInfoLabelTmp.font = GB_DEFAULT_FONT(11);
        giftInfoLabelTmp.textColor = KT_HEXCOLOR(0x999999);
        [cellViewTmp addSubview:giftInfoLabelTmp];
        giftInfoLabelTmp.text = giftInfo;
        self.giftInfoLabel = giftInfoLabelTmp;
        
        
        
        UILabel * timeLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(16, 119, 130, 21)];
        timeLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        timeLabelTmp.textAlignment = KT_TextAlignmentLeft;
        timeLabelTmp.font = GB_DEFAULT_FONT(11);
        timeLabelTmp.textColor = KT_HEXCOLOR(0x999999);
        [cellViewTmp addSubview:timeLabelTmp];
        timeLabelTmp.text = [Utils getTimeWithTimeInterval:time];
        self.timeLabel = timeLabelTmp;
        
        //添加人气
        UIImageView * popularityImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(232, 125, 9, 8)];
        [cellViewTmp addSubview:popularityImageViewTmp];
        popularityImageViewTmp.image = KT_GET_LOCAL_PICTURE_SECOND(@"bar_popularity@2x");
        
        UILabel * popularityLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(242, 119, 58, 21)];
        popularityLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        popularityLabelTmp.textAlignment = KT_TextAlignmentLeft;
        popularityLabelTmp.textColor = KT_HEXCOLOR(0x666666);
        popularityLabelTmp.font = GB_DEFAULT_FONT(11);
        [cellViewTmp addSubview:popularityLabelTmp];
        popularityLabelTmp.text = [[NSString alloc] initWithFormat:@"%u人气",count];
        self.popularityLabel = popularityLabelTmp;
        
        
    }else{
        self.gameNameLabel.text = gameName;
        [self.iconImageView setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_100_60)];
        self.serviceLabel.text = serviceName;
        self.subtitleLabel.text = subtitle;
        self.giftInfoLabel.text = giftInfo;
        self.timeLabel.text = [Utils getTimeWithTimeInterval:time];
        self.popularityLabel.text = [[NSString alloc] initWithFormat:@"%u人气",count];
    }
}

@end
