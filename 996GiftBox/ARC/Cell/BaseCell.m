//
//  BaseCell.m
//  996GameBox
//
//  Created by Keven on 13-12-6.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "BaseCell.h"

@implementation  SlectedViewForCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KT_UIColorWithRGB(0xe9, 0xf5, 0xfc);
    }
    return self;
}
@end

@implementation BaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        SlectedViewForCell * selectedView = [[SlectedViewForCell alloc] initWithFrame:self.selectedBackgroundView.frame];
        self.selectedBackgroundView = selectedView;
    }
    return self;
}
@end
