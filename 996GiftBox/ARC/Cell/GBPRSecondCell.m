//
//  GBPRSecondCell.m
//  GameGifts
//
//  Created by Keven on 14-1-6.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBPRSecondCell.h"

@implementation GBPRSecondCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}
- (void)setupCellViewWithTitleString:(NSString *)titleString type:(int)type
{
    if (!self.cellView) {
        LineView * cellViewTmp = [[LineView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 36) type:LineViewTypeForSolidLine with:320];
        [self.contentView addSubview:cellViewTmp];
        self.cellView = cellViewTmp;
        
        
        UILabel * titleLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 300, 21)];
        if (type == 0) {
            titleLabelTmp.textColor = KT_HEXCOLOR(0x333333);
            titleLabelTmp.font = GB_DEFAULT_FONT(13);
            cellViewTmp.backgroundColor = KT_HEXCOLOR(0xF5F5F5);
        }else if (type == 1){
            titleLabelTmp.textColor = KT_HEXCOLOR(0x999999);
            titleLabelTmp.font = GB_DEFAULT_FONT(11);
            cellViewTmp.backgroundColor = KT_UICOLOR_CLEAR;
        }else if(type == 2){
            titleLabelTmp.textColor = KT_HEXCOLOR(0xFF8500);
            titleLabelTmp.font = GB_DEFAULT_FONT(11);
            cellViewTmp.backgroundColor = KT_UICOLOR_CLEAR;
        }
        titleLabelTmp.textAlignment = KT_TextAlignmentLeft;
        titleLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        [cellViewTmp addSubview:titleLabelTmp];
        titleLabelTmp.text = titleString;
        self.titleLabel = titleLabelTmp;
        
    }else{
    
        self.titleLabel.text = titleString;
    
    }

}
@end
