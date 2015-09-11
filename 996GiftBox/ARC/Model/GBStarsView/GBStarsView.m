//
//  GBStarsView.m
//  996GameBox
//
//  Created by Teiron-37 on 13-12-7.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//

#import "GBStarsView.h"

@implementation GBStarsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int x = 0;
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0.0f, 12.0f, 11.0f)];
        imageView1.tag = 200;
        imageView1.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView1];
        
        x += imageView1.bounds.size.width + 2;
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0.0f, 12.0f, 11.0f)];
        imageView2.tag = 201;
        imageView2.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView2];
        
        x += imageView2.bounds.size.width + 2;
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0.0f, 12.0f, 11.0f)];
        imageView3.tag = 202;
        imageView3.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView3];
        
        x += imageView3.bounds.size.width + 2;
        
        UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0.0f, 12.0f, 11.0f)];
        imageView4.tag = 203;
        imageView4.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView4];
        
        x += imageView4.bounds.size.width + 2;
        
        UIImageView *imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0.0f, 12.0f, 11.0f)];
        imageView5.tag = 204;
        imageView5.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView5];
    }
    return self;
}

- (void)refreshWithInt:(int )starCount
{
    
    UIImage *starlightImage = KT_GET_LOCAL_PICTURE_SECOND(@"rk_star_light@2x");
    UIImage *starDarkImage = KT_GET_LOCAL_PICTURE_SECOND(@"rk_star_dark@2x");
    
    for (int i = 0; (i < starCount && i <5); ++i) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:200+i];
        imageView.image = starlightImage;
    }
    
    for (int i = starCount; (i<5 && i>0); ++i) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:200+i];
        imageView.image = starDarkImage;
    }
}

@end
