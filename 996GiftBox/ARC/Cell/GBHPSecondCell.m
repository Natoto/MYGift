//
//  GBHPSecondCell.m
//  GameGifts
//
//  Created by Keven on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GBHPSecondCell.h"
#import "UIImageView+WebCache.h"
@implementation GBHPSecondCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}
- (void)setupCellViewWithFirstURLString:(NSString *)firstURLString
                               firstName:(NSString *)firstName
                        secondURLString:(NSString *)secondURLString
                             secondName:(NSString *)secondName
                                    row:(NSInteger)row
                               isHeight:(BOOL)isHeight
                                 target:(id)delegate
                                 action:(SEL)action
{
    if (!self.cellView) {
        UIView * cellViewTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils screenWidth], isHeight ? 83.0f:77.0f)];
        cellViewTmp.backgroundColor = KT_HEXCOLOR(0xf5f5f5);
        [self.contentView addSubview:cellViewTmp];
        self.cellView = cellViewTmp;
        
        UIImageView * leftImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(5, isHeight ? 12 : 6, 152, 71)];
        [leftImageViewTmp setImageWithURL:[NSURL URLWithString:firstURLString]
                         placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_152_71)
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    if (!image) {
                                        self.leftImageView.image = KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_152_71);

                                    }
                                }];
        [cellViewTmp addSubview:leftImageViewTmp];
        KT_CORNER_RADIUS(leftImageViewTmp, KT_CORNER_RADIUS_VALUE_5);
        self.leftImageView = leftImageViewTmp;
        
        UIImageView *  leftUpImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(5, isHeight ? 12 : 6, 152, 71)];
        leftUpImageViewTmp.image = KT_GET_LOCAL_PICTURE_SECOND(@"hp_mask@2x");
        [cellViewTmp addSubview:leftUpImageViewTmp];
        KT_CORNER_RADIUS(leftUpImageViewTmp, KT_CORNER_RADIUS_VALUE_5);
        self.leftUpImageView = leftUpImageViewTmp;

        
        UILabel * leftLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(15, isHeight ? 68:62, 140, 12)];
        leftLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        leftLabelTmp.textAlignment = KT_TextAlignmentLeft;
        leftLabelTmp.font = GB_DEFAULT_FONT(10);
        leftLabelTmp.textColor = [UIColor whiteColor];
        [cellViewTmp addSubview:leftLabelTmp];
        leftLabelTmp.text = firstName;
        self.leftLabel = leftLabelTmp;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5, isHeight ? 12 : 6, 152, 71);
        button.tag = row * 100 + 1;
        [button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
        [cellViewTmp addSubview:button];
        self.leftButton = button;
        
        UIImageView *  rightImageView =[[UIImageView alloc] initWithFrame:CGRectMake(163, isHeight ? 12 : 6, 152, 71)];
        [rightImageView setImageWithURL:[NSURL URLWithString:secondURLString]
                         placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_152_71)
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    if (!image) {
                                        self.rightImageView.image = KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_152_71);
                                    }
                                }];
        [cellViewTmp addSubview:rightImageView];
        KT_CORNER_RADIUS(rightImageView, KT_CORNER_RADIUS_VALUE_5);
        self.rightImageView = rightImageView;
        
        UIImageView *  rightUpImageViewTmp = [[UIImageView alloc] initWithFrame:CGRectMake(163, isHeight ? 12 : 6, 152, 71)];
        rightUpImageViewTmp.image = KT_GET_LOCAL_PICTURE_SECOND(@"hp_mask@2x");
        [cellViewTmp addSubview:rightUpImageViewTmp];
         KT_CORNER_RADIUS(rightUpImageViewTmp, KT_CORNER_RADIUS_VALUE_5);
        self.rightUpImageView = rightUpImageViewTmp;
        
        UILabel * rightLabelTmp = [[UILabel alloc] initWithFrame:CGRectMake(168, isHeight ? 68:62, 140, 12)];
        rightLabelTmp.backgroundColor = KT_UICOLOR_CLEAR;
        rightLabelTmp.textAlignment = KT_TextAlignmentLeft;
        rightLabelTmp.font = GB_DEFAULT_FONT(10);
        rightLabelTmp.textColor = [UIColor whiteColor];
        [cellViewTmp addSubview:rightLabelTmp];
        rightLabelTmp.text = secondName;
        self.rightLabel = rightLabelTmp;
        
        UIButton * secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        secondButton.frame = CGRectMake(163, isHeight ? 12 : 6, 152, 71);
        secondButton.tag = row * 100 +  2;
        [secondButton addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
        [cellViewTmp addSubview:secondButton];
        self.rightButton = secondButton;
    
    }else{
        self.leftImageView.frame = CGRectMake(5, isHeight ? 12 : 6, 152, 71);
        self.leftUpImageView.frame =  CGRectMake(5, isHeight ? 12 : 6, 152, 71);
        self.leftButton.frame = CGRectMake(5, isHeight ? 12 : 6, 152, 71);
        
        self.rightImageView.frame = CGRectMake(163, isHeight ? 12 : 6, 152, 71);
        self.rightUpImageView.frame =  CGRectMake(163, isHeight ? 12 : 6, 152, 71);
        self.rightButton.frame = CGRectMake(163, isHeight ? 12 : 6, 152, 71);
        
        
        [self.leftImageView setImageWithURL:[NSURL URLWithString:firstURLString]
                         placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_152_71)
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    if (!image) {
                                        self.leftImageView.image = KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_152_71);
                                    }
                                }];
        [self.rightImageView setImageWithURL:[NSURL URLWithString:firstURLString]
                           placeholderImage:KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_152_71)
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                      if (!image) {
                                          self.rightImageView.image = KT_GET_LOCAL_PICTURE_SECOND(KT_Placholder_Image_Name_152_71);
                                      }
                                  }];
        
        
        self.leftLabel.frame=  CGRectMake(15, isHeight ? 68:62, 140, 12);
        self.leftLabel.text = firstName;
        
        self.rightLabel.frame=  CGRectMake(168, isHeight ? 68:62, 140, 12);
        self.rightLabel.text = secondName;
        
    }
}

@end
