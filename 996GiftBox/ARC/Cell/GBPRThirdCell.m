//
//  GBPRThirdCell.m
//  GameGifts
//
//  Created by Keven on 14-1-6.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBPRThirdCell.h"

@implementation GBPRThirdCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}
- (void)setupCellViewWithContentString:(NSString *)content  contentHeight:(CGFloat)contentHeight
{
    
    if (!self.cellView) {
        LineView * cellViewTmp = [[LineView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], 34 + contentHeight + 10) type:LineViewTypeForSolidLine with:320];
        cellViewTmp.backgroundColor = KT_UICOLOR_CLEAR;
        [self.contentView addSubview:cellViewTmp];
        self.cellView = cellViewTmp;
        
        UILabel * titleLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 21)];
        titleLabelTmp.textColor = KT_HEXCOLOR(0x666666);
        titleLabelTmp.textAlignment = KT_TextAlignmentLeft;
        titleLabelTmp.font = GB_DEFAULT_FONT(13);
        titleLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        
        [cellViewTmp addSubview:titleLabelTmp];
        titleLabelTmp.text = @"礼包内容：";
        
        UILabel * contentLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(10, 34, 300, contentHeight)];
        contentLabelTmp.textColor = KT_HEXCOLOR(0x999999);
        contentLabelTmp.textAlignment = KT_TextAlignmentLeft;
        contentLabelTmp.font = GB_DEFAULT_FONT(12);
        contentLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        contentLabelTmp.numberOfLines = 0;
        [cellViewTmp addSubview:contentLabelTmp];
        contentLabelTmp.text = content;
        self.contentLabel = contentLabelTmp;
        
    }else{
        [self.cellView setFrame:CGRectMake(0, 0, [Utils screenWidth], 34 + contentHeight + 10) type:LineViewTypeForSolidLine with:320];
        self.contentLabel.frame = CGRectMake(10, 34, 300, contentHeight);
        self.contentLabel.text = content;
    }
}
@end
