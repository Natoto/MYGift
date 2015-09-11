//
//  GBHPFirstCell.m
//  GameGifts
//
//  Created by Keven on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GBHPFirstCell.h"

@implementation GBHPFirstCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}
- (void)setupCellViewWithTitleString:(NSString *)title
                         buttonTitle:(NSString *)buttonTitle
                    buttonTitleColor:(UIColor *)buttonTitleColor
                                 row:(NSInteger)row
                        buttonHidden:(BOOL)hidden
                              target:(id)delegate
                        buttonAction:(SEL)action
{
    if (!self.cellView) {
        UIView * cellViewTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 37)];
        cellViewTmp.backgroundColor = KT_DEFAULT_COLOR;
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 150, 21)];
        titleLabel.textAlignment = KT_TextAlignmentLeft;
        titleLabel.textColor = KT_UIColorWithRGB(0x33, 0x33, 0x33);
        titleLabel.backgroundColor = KT_UICOLOR_CLEAR;
        titleLabel.font = GB_DEFAULT_FONT(17);
        titleLabel.text = title;
        [cellViewTmp addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImage * buttonImg = KT_GET_LOCAL_PICTURE_SECOND(@"hp_mor_arrow@2x");
        UIButton * pressedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pressedButton.backgroundColor = KT_UICOLOR_CLEAR;
        pressedButton.frame = CGRectMake(220, 16, 100, 20);
        [pressedButton setImage:buttonImg forState:UIControlStateNormal];
        pressedButton.titleLabel.font = GB_DEFAULT_FONT(14);
        pressedButton.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 15);
        pressedButton.imageEdgeInsets = UIEdgeInsetsMake(2.5, 80, 2.5, 0);
        pressedButton.titleLabel.textAlignment = KT_TextAlignmentCenter;
        [pressedButton setTitle:buttonTitle forState:UIControlStateNormal];
        [pressedButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
        [pressedButton addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
        pressedButton.hidden = hidden;
        pressedButton.tag = row;
        [cellViewTmp addSubview:pressedButton];
        pressedButton.hidden = hidden;
        self.titleBt = pressedButton;
        
        [self.contentView addSubview:cellViewTmp];
        self.cellView = cellViewTmp;
    }else{
    
        self.titleLabel.text = title;
        [self.titleBt setTitle:buttonTitle forState:UIControlStateNormal];
        [self.titleBt setTitleColor:buttonTitleColor forState:UIControlStateNormal];
        self.titleBt.hidden = hidden;
    }
}
@end
