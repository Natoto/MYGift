//
//  GBGiftCell.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-3.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBGiftCell.h"
#import "GBSearchModel.h"
#import "UIImageView+WebCache.h"

@interface GBGiftCell()

@property (nonatomic, KT_WEAK) UIImageView *tapView;
@property (nonatomic, KT_WEAK) UILabel *nameLabel;
@property (nonatomic, KT_WEAK) UIImageView *iconView;
@property (nonatomic, KT_WEAK) UILabel *fromLabel;
@property (nonatomic, KT_WEAK) UILabel *categaryLabel;
@property (nonatomic, KT_WEAK) UILabel *timeLabel;
@property (nonatomic, KT_WEAK) UILabel *countLabel;
@property (nonatomic, KT_WEAK) UIButton *pressedButton;

@end

@implementation GBGiftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
        
        UIImageView * backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, [Utils screenWidth] - 10, 140)];
        backgroundView.backgroundColor = KT_UICOLOR_CLEAR;
        backgroundView.image = [KT_GET_LOCAL_PICTURE_SECOND(@"hp_list_bg@2x") stretchableImageWithLeftCapWidth:37 topCapHeight:55];
        backgroundView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:backgroundView];
        
        //tap
        UIImageView *tapView = [[UIImageView alloc] initWithFrame:CGRectMake(backgroundView.bounds.size.width - 30, 0, 30, 31)];
        [backgroundView addSubview:tapView];
        self.tapView = tapView;
        
        CGFloat x = 12.f, y = 12.f;
        
        //name
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 265, 15)];
        nameLabel.backgroundColor = KT_UICOLOR_CLEAR;
        nameLabel.font = GB_DEFAULT_FONT(15);
        nameLabel.textColor = KT_HEXCOLOR(0x333333);
        [backgroundView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        y += (nameLabel.bounds.size.height + 12);
        
        //line
        UIImageView *lineView = [[UIImageView alloc] init];
        
        y += (lineView.bounds.size.height + 10);
        
        //icon
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 100, 60)];
        [backgroundView addSubview:iconView];
        self.iconView = iconView;
        
        x += (iconView.bounds.size.width + 12);
        y += 4;
        
        //from
        UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 265, 13)];
        fromLabel.backgroundColor = KT_UICOLOR_CLEAR;
        fromLabel.font = GB_DEFAULT_FONT(13);
        fromLabel.textColor = KT_HEXCOLOR(0x333333);
        [backgroundView addSubview:fromLabel];
        self.fromLabel = fromLabel;
        
        y += (fromLabel.bounds.size.height + 10);
        
        //category
        UILabel *categaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 265, 12)];
        categaryLabel.backgroundColor = KT_UICOLOR_CLEAR;
        categaryLabel.font = GB_DEFAULT_FONT(12);
        categaryLabel.textColor =  KT_HEXCOLOR(0x666666);
        [backgroundView addSubview:categaryLabel];
        self.categaryLabel = categaryLabel;
        
        y += (categaryLabel.bounds.size.height + 10);
        
        //time
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 265, 11)];
        timeLabel.backgroundColor = KT_UICOLOR_CLEAR;
        timeLabel.font = GB_DEFAULT_FONT(11);
        timeLabel.textColor =  KT_HEXCOLOR(0x999999);
        [backgroundView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        x = 12;
        y = (iconView.frame.origin.y + iconView.frame.size.height + 10);
        
        //count
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 265, 12)];
        countLabel.backgroundColor = KT_UICOLOR_CLEAR;
        countLabel.font = GB_DEFAULT_FONT(12);
        countLabel.textColor =  KT_HEXCOLOR(0xff8500);
        [backgroundView addSubview:countLabel];
        self.countLabel = countLabel;
        
        x = backgroundView.frame.size.width - 48 - 10;
        y = backgroundView.frame.size.height - 10 - 26;
        
        //action
        UIButton * pressedButtonTmp = [UIButton buttonWithType:UIButtonTypeCustom];
        pressedButtonTmp.frame = CGRectMake(x, y, 48, 26);
        pressedButtonTmp.backgroundColor = KT_UICOLOR_CLEAR;
        pressedButtonTmp.titleLabel.font = GB_DEFAULT_FONT(12);
        KT_CORNER_RADIUS(pressedButtonTmp, KT_CORNER_RADIUS_VALUE_2);
        [backgroundView addSubview:pressedButtonTmp];
        self.pressedButton = pressedButtonTmp;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated

{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadWithModel:(GBSearchModel *)giftModel
                    row:(NSUInteger)row
                 target:(id)delegate
                 action:(SEL)action
{
    switch (giftModel.flags) {
        case 1:{ //活动
            _tapView.image = KT_GET_LOCAL_PICTURE(@"search_activity_tag@2x");
            _nameLabel.text = giftModel.name;
            [_iconView setImageWithURL:[NSURL URLWithString:giftModel.picUrl]];
            _fromLabel.text = giftModel.subContent;
            _categaryLabel.text = @"礼包内容:";
            _timeLabel.text = giftModel.content;
            _countLabel.text = [Utils getTimeWithTimeInterval:giftModel.createTime];
            _countLabel.textColor = KT_HEXCOLOR(0x999999);
            _pressedButton.hidden = YES;
            break;
        }
        case 2:{ //礼包
            _tapView.image = KT_GET_LOCAL_PICTURE(@"search_gift_tag@2x");
            _nameLabel.text = giftModel.name;
            [_iconView setImageWithURL:[NSURL URLWithString:giftModel.picUrl]];
            _fromLabel.text = giftModel.subContent;
            _categaryLabel.text = giftModel.content;
            _timeLabel.text = [NSString stringWithFormat:@"发布时间:%@",[Utils getTimeWithTimeInterval:giftModel.createTime]];
            _countLabel.text =  [NSString stringWithFormat:@"剩余%d份",giftModel.remanCount];
            _countLabel.textColor = KT_HEXCOLOR(0xff8500);
            
            _pressedButton.hidden = NO;
            _pressedButton.tag = row;
            [_pressedButton addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
            
            if (giftModel.packageStatus == GetGiftStatusForEndForUnclaimed) {//未领取
                self.pressedButton.hidden = NO;
                [self.pressedButton setTitle:@"领取" forState:UIControlStateNormal];
                [self.pressedButton setTitleColor:KT_BlueColor forState:UIControlStateNormal];
                [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
                self.pressedButton.userInteractionEnabled = YES;
            }else if(giftModel.packageStatus == GetGiftStatusForAlreadyReceive){ //已领取
                self.pressedButton.hidden = NO;
                [self.pressedButton setTitle:@"已领取" forState:UIControlStateNormal];
                [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
                self.pressedButton.userInteractionEnabled = NO;
            }else if (giftModel.packageStatus == GetGiftStatusForHasBrought){//已领完
                self.pressedButton.hidden = NO;
                [self.pressedButton setTitle:@"已领完" forState:UIControlStateNormal];
                [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
                self.pressedButton.userInteractionEnabled = NO;
                
            }else if (giftModel.packageStatus == GetGiftStatusForOutOfDate){//已过期
                self.pressedButton.hidden = NO;
                [self.pressedButton setTitle:@"已过期" forState:UIControlStateNormal];
                [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
                self.pressedButton.userInteractionEnabled = NO;
                
            }else if (giftModel.packageStatus == GetGiftStatusForOrder){ //预约
                self.pressedButton.hidden = NO;
                [self.pressedButton setTitle:@"预约" forState:UIControlStateNormal];
                [self.pressedButton setTitleColor:KT_GreenColor forState:UIControlStateNormal];
                [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
                self.pressedButton.userInteractionEnabled = YES;
            }else if (giftModel.packageStatus == GetGiftStatusForReservations){//已预约
                self.pressedButton.hidden = NO;
                [self.pressedButton setTitle:@"已预约" forState:UIControlStateNormal];
                [self.pressedButton setTitleColor:KT_PurpleColor forState:UIControlStateNormal];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_already_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_already_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
                self.pressedButton.userInteractionEnabled = NO;
            }
            ////////////////////////////////////////////////////////////////////////////////
            
//            if([giftModel.packageStatus intValue] == GetGiftStatusForUnpublished){ //未发布
//                self.pressedButton.hidden = YES;
//            }else if ([giftModel.packageStatus intValue] == GetGiftStatusForEndForUnclaimed) {//未领取
//                self.pressedButton.hidden = NO;
//                [self.pressedButton setTitle:@"领取" forState:UIControlStateNormal];
//                [self.pressedButton setTitleColor:KT_BlueColor forState:UIControlStateNormal];
//                [self.pressedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive_highlighted@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
//                [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
//            }else if([giftModel.packageStatus intValue] == GetGiftStatusForAlreadyReceive){ //已领取
//                self.pressedButton.hidden = NO;
//                [self.pressedButton setTitle:@"已领取" forState:UIControlStateNormal];
//                [self.pressedButton setTitleColor:KT_PurpleColor forState:UIControlStateNormal];
//                //            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_already_receive@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
//                self.pressedButton.userInteractionEnabled = NO;
//            }else if ([giftModel.packageStatus intValue] == GetGiftStatusForAlreadyUse){ //已使用
//                self.pressedButton.hidden = NO;
//                [self.pressedButton setTitle:@"已使用" forState:UIControlStateNormal];
//                [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
//                //            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_end@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
//                self.pressedButton.userInteractionEnabled = NO;
//            }else if ([giftModel.packageStatus intValue] == GetGiftStatusForHasBrought){//已领完
//                self.pressedButton.hidden = NO;
//                [self.pressedButton setTitle:@"已领完" forState:UIControlStateNormal];
//                [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
//                //            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
//                self.pressedButton.userInteractionEnabled = NO;
//                
//            }else if ([giftModel.packageStatus intValue] == GetGiftStatusForOutOfDate){//已过期
//                self.pressedButton.hidden = NO;
//                [self.pressedButton setTitle:@"已过期" forState:UIControlStateNormal];
//                [self.pressedButton setTitleColor:KT_GrayColor forState:UIControlStateNormal];
//                //            [self.pressedButton setBackgroundImage:[KT_GET_LOCAL_PICTURE_SECOND(@"hp_gift_order@2x") stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
//                self.pressedButton.userInteractionEnabled = NO;
//                
//            }
            break;
        }
            
        default:
            break;
    }
}

@end
