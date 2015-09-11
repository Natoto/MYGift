//
//  LocalSettings.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-17.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "LocalSettings.h"

#define LOCALSETTINGS_KEY_PUSH @"lsPushKey"
#define LOCALSETTINGS_KEY_THEME @"lsThemeKey"
#define LOCALSETTINGS_KEY_VERSION @"lsVersionKey"

#define DEFAULT_THEME_NAME @"bg_source_snow@2x"

static LocalSettings *localInstance = nil;

@implementation LocalSettings

@synthesize isPushOpen = _isPushOpen;
@synthesize currentTheme = _currentTheme;
@synthesize latestVersion = _latestVersion;

+ (LocalSettings *)sharedInstance {
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localInstance = [[LocalSettings alloc] init];
    });
    
    return localInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        //推送通知
        _isPushOpen = [userDefault boolForKey:LOCALSETTINGS_KEY_PUSH];
        if ([userDefault stringForKey:LOCALSETTINGS_KEY_PUSH] == nil) {
            _isPushOpen = YES; //默认开启
            [userDefault setBool:_isPushOpen forKey:LOCALSETTINGS_KEY_PUSH];
        }
        
        //主题背景
        NSString *temp = [userDefault stringForKey:LOCALSETTINGS_KEY_THEME];
        if (temp == nil) {
            _currentTheme = DEFAULT_THEME_NAME;// default themes
            [userDefault setObject:_currentTheme forKey:LOCALSETTINGS_KEY_THEME];
        }
        else{
            _currentTheme = temp;
        }
        
        //最新版本号
        _latestVersion = [userDefault stringForKey:LOCALSETTINGS_KEY_VERSION];
        if ([userDefault stringForKey:LOCALSETTINGS_KEY_VERSION] == nil) {
            _latestVersion = [Utils getAppVersion];
            [userDefault setObject:_latestVersion forKey:LOCALSETTINGS_KEY_VERSION];
        }
        
        [userDefault synchronize];
    }
    return self;
}

- (void)setIsPushOpen:(BOOL)isPushOpen
{
    _isPushOpen = isPushOpen;
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setBool:isPushOpen forKey:LOCALSETTINGS_KEY_PUSH];
	[userDefault synchronize];
}

- (BOOL)isIsPushOpen
{
    return _isPushOpen;
}

- (void)setCurrentTheme:(NSString *)currentTheme
{
    _currentTheme = currentTheme;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setObject:_currentTheme forKey:LOCALSETTINGS_KEY_THEME];
	[userDefault synchronize];
}

- (NSString *)currentTheme
{
    return _currentTheme;
}

- (void)setLatestVersion:(NSString *)latestVersion
{
    _latestVersion = latestVersion;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
	[userDefault setObject:_latestVersion forKey:LOCALSETTINGS_KEY_VERSION];
	[userDefault synchronize];
}

- (NSString *)latestVersion
{
    return _latestVersion;
}

@end
