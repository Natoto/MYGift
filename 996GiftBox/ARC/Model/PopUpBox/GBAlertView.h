//
//  GBAlertView.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-25.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GBPopUpBoxClickHandler)(int index);

@interface GBAlertView : UIView

@property (nonatomic, copy) GBPopUpBoxClickHandler callbackBlock;

- (id)initWithMessage:(NSString *)message
         buttonTitles:(NSArray *)titles
             callback:(GBPopUpBoxClickHandler)block;

- (void)show;

- (void)hidden;

@end
