//
//  GBAppDelegate.h
//  GameGifts
//
//  Created by Keven on 13-12-24.
//  Copyright (c) 2013年 Keven. All rights reserved.
//
#ifndef __KT_GB_APP_DELEGATE_H__
#define __KT_GB_APP_DELEGATE_H__
#import <UIKit/UIKit.h>
#import "NetworkUtils.h"
@class KTMainViewController;
@interface GBAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
KT_PROPERTY_ASSIGN  KTMainViewController * mainViewController;
KT_PROPERTY_ASSIGN BOOL workStatus;
KT_PROPERTY_STRONG NSDictionary * JPushUserInfo;
- (void)setupWorkStatus:(BOOL)status;
@end
#endif