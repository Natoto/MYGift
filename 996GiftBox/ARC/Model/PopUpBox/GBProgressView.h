//
//  GBProgressView.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-25.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBProgressView : UIView

- (id)initWithFrame:(CGRect)frame
            message:(NSString *)message;

- (void)stop;

@end
