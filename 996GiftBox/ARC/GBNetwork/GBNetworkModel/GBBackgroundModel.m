//
//  GBBackgroundModel.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-7.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBackgroundModel.h"
#import "LocalSettings.h"

@implementation GBBackgroundModel

- (void)setSourceUrl:(NSString *)sourceUrl
{
    _sourceUrl = sourceUrl;
    
    if ([_sourceUrl isEqualToString:[LocalSettings sharedInstance].currentTheme]) {
        _isSelected = YES;
    }
    else{
        _isSelected = NO;
    }
}

@end
