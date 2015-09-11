//
//  LocalSettings.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-17.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalSettings : NSObject

+ (LocalSettings *)sharedInstance;

@property (nonatomic, assign) BOOL isPushOpen;
@property (nonatomic, strong) NSString* currentTheme;
@property (nonatomic, strong) NSString* latestVersion;

@end
