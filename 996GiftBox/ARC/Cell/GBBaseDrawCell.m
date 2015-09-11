//
//  GBBaseDrawCell.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-10.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseDrawCell.h"
#import "UIImage+Utility.h"

@implementation GBBaseDrawCellView

- (void)drawRect:(CGRect)rect
{
    [self.contentCell drawContentView:rect];
}

@end

@implementation GBBaseDrawCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        GBBaseDrawCellView *contentView = [[GBBaseDrawCellView alloc] init];
        contentView.contentCell = self;
        contentView.opaque = YES;   //不透明，提升渲染性能
        [self addSubview:contentView];
        self.contentView1 = contentView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawContentView:(CGRect)rect
{
    
}

@end
