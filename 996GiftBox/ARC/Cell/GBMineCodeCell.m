//
//  GBMineCodeCell.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-8.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBMineCodeCell.h"
//#import "GBRecommendModel.h"
#import "UIImage+Utility.h"
#import "UIImageView+WebCache.h"
#import "GBMineGiftModel.h"

@interface GBMineCodeCell()

@property (nonatomic, KT_WEAK) UIView *bgView;
@property (nonatomic, KT_WEAK) UIButton *checkBoxButton;
@property (nonatomic, KT_STRONG) GBMineGiftGroupModel *model;
@property (nonatomic, KT_WEAK) id target;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) SEL subAction;
@property (nonatomic, assign) SEL copyAction;

@end

@implementation GBMineCodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)didAllCheckboxAction:(UIButton *)button
{
    
}

- (void)reloadWithModel:(GBMineGiftGroupModel *)model
                    row:(NSInteger)row
                 target:(id)delegate
                 action:(SEL)action
              subAction:(SEL)subAction
             copyAction:(SEL)copyAction
{
    self.model = model;
    self.target = delegate;
    self.action = action;
    self.subAction = subAction;
    self.copyAction = copyAction;
    self.row = row;
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect b = [self bounds];
    b.size.height -= 1;     // 给分割线留出位置
    self.contentView1.frame = b;
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    for (UIView *subView in self.contentView1.subviews) {
        [subView removeFromSuperview];
    }
    [self.contentView1 setNeedsDisplay];
}

- (void)drawContentView:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect cellRect = self.frame;
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, cellRect.size.width, cellRect.size.height));
    
    KT_DLog(@"RECT.FRAME = %@",NSStringFromCGRect(rect));
    //圆角矩形
    CGFloat width = rect.size.width - 10;
    CGFloat height = rect.size.height - 10;
    CGFloat radius = 5;
    CGFloat beginx = 5;
    CGFloat beginy = 5;
    
    CGContextMoveToPoint(context, beginx + radius, beginy);
    
    //topline and right-top corner
    CGContextAddLineToPoint(context, beginx + width - radius, beginy);
    CGContextAddArc(context, beginx + width - radius, beginy + radius, radius, -0.5 * M_PI, 0.0, 0);
    
    //rightline and right-bottom corner
    CGContextAddLineToPoint(context, beginx + width, beginy + height - radius);
    CGContextAddArc(context, beginx + width - radius, beginy + height - radius, radius, 0.0, 0.5 * M_PI, 0);
    
    //bottomline and left-bottom corner
    CGContextAddLineToPoint(context, beginx + radius, beginy + height);
    CGContextAddArc(context, beginx + radius, beginy + height - radius, radius, 0.5 * M_PI, M_PI, 0);
    
    //leftline and left-top corner
    CGContextAddLineToPoint(context, beginx, beginy + radius);
    CGContextAddArc(context, beginx + radius, beginy + radius, radius, M_PI, 1.5 * M_PI, 0);
    
    // 闭合路径
    CGContextClosePath(context);
    
    CGContextSetRGBStrokeColor(context, 0xdd/255.0f, 0xdd/255.0f, 0xdd/255.0f, 1);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGFloat begin_x = beginx;
    CGFloat begin_y = beginy;
    
    //选择框
    UIButton *checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkboxButton.tag = self.row;
    [checkboxButton setImage:[UIImage imageNamed:self.model.isSelected?@"mine_checkbox_highlighted.png":@"mine_checkbox.png"] forState:UIControlStateNormal];
    checkboxButton.frame = CGRectMake(begin_x, begin_y, 40, 40);
    [checkboxButton addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
    [self.contentView1 addSubview:checkboxButton];
    
    begin_x += checkboxButton.frame.size.width + 5;
    
    //游戏名称
    CGContextSetFillColorWithColor(context, KT_HEXCOLOR(0x44b5ff).CGColor);
    [self.model.gameName drawInRect:CGRectMake(begin_x, begin_y + 15, 95, 15) withFont:GB_DEFAULT_FONT(15)];
    
    begin_y += 45;
    
    for (int i = 0; i < [self.model.giftModelArray count]; ++i){
        GBMineGiftModel *subModel = [self.model.giftModelArray objectAtIndex:i];
        //画线
        CGContextSetRGBStrokeColor(context, 0xCA / 255.0, 0xCA / 255.0, 0xCA / 255.0, 1);//线条颜色
        CGContextSetLineWidth(context, 0.5f);
        CGContextSetShouldAntialias(context, NO ); //关闭消除锯齿
        CGContextMoveToPoint(context, 17, begin_y);
        CGContextAddLineToPoint(context, [Utils screenWidth]- 17 ,begin_y);
        CGContextStrokePath(context);
        
        begin_y += 0.5;
        begin_x = beginx;
        
        //选择框
        UIButton *subCheckboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        subCheckboxButton.tag = (self.row+1)*100000 + i;
        [subCheckboxButton setImage:[UIImage imageNamed:subModel.isSelected?@"mine_checkbox_highlighted.png":@"mine_checkbox.png"] forState:UIControlStateNormal];
        subCheckboxButton.frame = CGRectMake(begin_x, begin_y + 17, 40, 40);
        [subCheckboxButton addTarget:self.target action:self.subAction forControlEvents:UIControlEventTouchUpInside];
        [self.contentView1 addSubview:subCheckboxButton];
        
        begin_x += (subCheckboxButton.frame.size.width + 5);
        
        //图标
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(begin_x, begin_y + 12, 48, 48)];
        __block UIImageView *imageView = iconImageView;
        [imageView setImageWithURL:[NSURL URLWithString:subModel.iconStrUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (imageView) {
                [self.contentView1 setNeedsDisplayInRect:imageView.frame];
            }
            imageView = nil;
        }];
        [[iconImageView.image imageResizedToSize:CGSizeMake(48, 48)
                                withCornerRadius:7.5
                                         corners:DSCornerAll
                                    transparency:NO] drawInRect:CGRectMake(begin_x, begin_y + 12, 48, 48)];
        
        begin_x += (iconImageView.frame.size.width + 12);
        begin_y += 12;
        
        //类型
        CGContextSetFillColorWithColor(context, KT_HEXCOLOR(0x666666).CGColor);
        CGContextSetShouldAntialias(context, YES ); //关闭消除锯齿
        [subModel.packageName drawInRect:CGRectMake(begin_x, begin_y, 95, 12) withFont:GB_DEFAULT_FONT(12)];
        
        begin_y += 21;
        
        //兑换码
        NSString *str = @"兑换码：";
        CGSize strSize = [str sizeWithFont:GB_DEFAULT_FONT(12)];
        [str drawInRect: CGRectMake(begin_x, begin_y, strSize.width, 12) withFont:GB_DEFAULT_FONT(12)];
        
        CGSize size = [subModel.package_number sizeWithFont:GB_DEFAULT_FONT(12) constrainedToSize:CGSizeMake(95, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        [subModel.package_number drawInRect:CGRectMake(begin_x + strSize.width, begin_y, size.width, size.height) withFont:GB_DEFAULT_FONT(12) lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
        
//        begin_y += 22;
        begin_y += (size.height+10);
        
        //有效日期
        CGContextSetFillColorWithColor(context, KT_HEXCOLOR(0x999999).CGColor);
        [[NSString stringWithFormat:@"有效截至日期：2013-10-2"] drawInRect: CGRectMake(begin_x, begin_y, 200, 11) withFont:GB_DEFAULT_FONT(11)];
        
        //复制按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = (self.row+1)*100000 + i;
        button.frame = CGRectMake(255, beginy + 24, 47, 26);
        button.center = CGPointMake(button.center.x, subCheckboxButton.center.y);
        button.titleLabel.font = GB_DEFAULT_FONT(12);
        [button setTitle:@"复制" forState:UIControlStateNormal];
        [button setTitleColor:KT_HEXCOLOR(0x44b5ff) forState:UIControlStateNormal];
        [button setTitleColor:KT_HEXCOLOR(0xffffff) forState:UIControlStateHighlighted];
        [button setBackgroundImage:[[[UIImage imageNamed:@"hp_gift_receive_highlighted.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:13] stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[[[UIImage imageNamed:@"hp_gift_receive.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:13] stretchableImageWithLeftCapWidth:13 topCapHeight:13] forState:UIControlStateNormal];
        [button addTarget:self.target action:self.copyAction forControlEvents:UIControlEventTouchUpInside];
        [self.contentView1 addSubview:button];
        
        begin_y += 23;
    }
}

@end
