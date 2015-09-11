//
//  GBSearchDefaultViewCell.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-3.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBSearchDefaultViewCell.h"
#import "GBSearchRecommendModel.h"

@implementation GBSearchDefaultViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGFloat x = 12;
        
        //rank
        UIImageView *rankView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 15, 15, 15)];
        rankView.tag = 1;
        [self.contentView addSubview:rankView];
        
        x += (rankView.frame.size.width + 12);
        
        //rankNum
        UILabel *rankNumLabel = [[UILabel alloc] initWithFrame:rankView.frame];
        rankNumLabel.tag = 2;
        rankNumLabel.textAlignment = NSTextAlignmentCenter;
        rankNumLabel.font = GB_DEFAULT_FONT(8);
        rankNumLabel.textColor = KT_HEXCOLOR(0xffffff);
        rankNumLabel.backgroundColor = KT_UICOLOR_CLEAR;
        [self.contentView addSubview:rankNumLabel];
        
        //name
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 16, ([Utils screenWidth] - 2*x), 13)];
        nameLabel.tag = 3;
        nameLabel.font = GB_DEFAULT_FONT(13);
        nameLabel.textColor = KT_HEXCOLOR(0x333333);
        nameLabel.backgroundColor = KT_UICOLOR_CLEAR;
        [self.contentView addSubview:nameLabel];
        
        x += (nameLabel.frame.size.width + 12);
        
        //Trend
//        UIImageView *trendView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 15, 15, 15)];
//        trendView.tag = 4;
//        [self.contentView addSubview:trendView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadWithModel:(GBSearchRecommendModel *)model
{
    UIImageView *rankView = (UIImageView *)[self.contentView viewWithTag:1];
    UILabel *rankNumLabel = (UILabel *)[self.contentView viewWithTag:2];
    UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:3];
    
    switch (model.rank) {
        case 1:{
            rankView.image = KT_GET_LOCAL_PICTURE(@"search_number_1@2x");
            rankNumLabel.textColor = KT_HEXCOLOR(0xffffff);
            break;
        }
        case 2:{
            rankView.image = KT_GET_LOCAL_PICTURE(@"search_number_2@2x");
            rankNumLabel.textColor = KT_HEXCOLOR(0xffffff);
            break;
        }
        case 3:{
            rankView.image = KT_GET_LOCAL_PICTURE(@"search_number_3@2x");
            rankNumLabel.textColor = KT_HEXCOLOR(0xffffff);
            break;
        }
        default:{
            rankView.image = KT_GET_LOCAL_PICTURE(@"search_number_other@2x");
            rankNumLabel.textColor = KT_HEXCOLOR(0x757575);
            break;
        }
    }
    
//    UIImageView *trendView = (UIImageView *)[self.contentView viewWithTag:4];
//    
//    switch (model.trend) {
//        case -1:{ //下降
//            trendView.image = KT_GET_LOCAL_PICTURE(@"search_rank_fall@2x");
//            break;
//        }
//        case 0:{ //持平
//            trendView.image = KT_GET_LOCAL_PICTURE(@"search_rank_fair@2x");
//            break;
//        }
//        case 1:{ //上升
//            trendView.image = KT_GET_LOCAL_PICTURE(@"search_rank_rise@2x");
//            break;
//        }
//            
//        default:
//            break;
//    }
    
    rankNumLabel.text = [NSString stringWithFormat:@"%ld",(long)model.rank];
    nameLabel.text = model.package_name;
}

@end
