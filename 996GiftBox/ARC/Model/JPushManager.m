 //
//  JPushManager.m
//  GameGifts
//
//  Created by Keven on 13-12-25.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "JPushManager.h"
#import "APService.h"
#import "NSString+MD5.h"
//设置推送的Tag 或者别名 （别名只有一个，标签可以有多个）
/*
 不然任何状态中，UUID都实作为别名来设置的
 没有注册 ，Tag 中只有 游戏的ID，时间
 注册，Tag 添加 账号，性别，年龄 游戏ID，时间
 登录，如果是不同的账号，则把这个不同的账号挂钩到UUID中
 退出， tag 添加 时间
 开启， tag 添加 时间
 tag 是增量
 这里默认会设置 UUID为 alias ，tags:设备的版本，软件版本，设备语言，设备名称
 */

@interface JPushManager()
KT_PROPERTY_STRONG NSMutableDictionary * tagsDictionary;
@end
@implementation JPushManager
//开机来设置推送
+ (void)setAPServiceByBoot
{
    //设置别名，
//    [JPushManager setAliasForAPService];
    //设置标签
//    [JPushManager setTagsForAPServiceWithTags:nil];
}
//设置别名，
+ (void)setAliasForAPService
{
   NSString * oldAlias = [[NSUserDefaults standardUserDefaults] objectForKey:@"APSerViceAlias"];
    NSString * alias = [[[NSString alloc] initWithFormat:@"UUID:%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"open_UDID"]] MD5Hash];
    KT_DLog(@"alias:%@",alias);
    if (![Utils isNilOrEmpty:oldAlias]) {
        if (![oldAlias isEqualToString:alias]) {
            [APService setAlias:alias callbackSelector:@selector(handleAliasCallback:tags:alias:) object:self];
            [[NSUserDefaults standardUserDefaults] setValue:alias forKey:@"APSerViceAlias"];
            BOOL flag = [[NSUserDefaults standardUserDefaults] synchronize];
            if (!flag) {
                KT_DLog(@"APServiceAlias 保存不存成功");
            }
        }
    }else{
        [APService setAlias:alias callbackSelector:@selector(handleAliasCallback:tags:alias:) object:self];
        [[NSUserDefaults standardUserDefaults] setValue:alias forKey:@"APSerViceAlias"];
       BOOL flag = [[NSUserDefaults standardUserDefaults] synchronize];
        if (!flag) {
            KT_DLog(@"APServiceAlias 保存不存成功");
        }
    }
}

//设置标签
+ (void)setTagsForAPServiceWithTags:(NSDictionary *)tagDictionary
{
    //添加默认的标签
    NSMutableDictionary * allTagDict = [JPushManager getCompletelyTagsDictinoaryWithPartDict:tagDictionary];
    NSMutableSet * tmpSet = [[NSMutableSet alloc] init];
    for (NSString * key in [allTagDict allKeys]) {
        NSString * completeTags = [[[NSString alloc] initWithFormat:@"%@:%@",key,[allTagDict objectForKey:key]] MD5Hash];
        [tmpSet addObject:completeTags];
        KT_DLog(@"TagsKey:%@====value:%@===completeTags:%@",key,[allTagDict objectForKey:key],completeTags);
    }
    [APService setTags:[APService filterValidTags:tmpSet] callbackSelector:@selector(handleTagsCallback:tags:alias:) object:self];
}

+ (NSMutableDictionary *)getCompletelyTagsDictinoaryWithPartDict:(NSDictionary *)tagDictionary
{
    //系统名称
    NSMutableDictionary * tmptagDict = [[NSMutableDictionary alloc] init];
    //有设置的标签
    if (![Utils isNilOrEmpty:tagDictionary]) {
        [tmptagDict addEntriesFromDictionary:tagDictionary];
    }
    //获取之前已经设置好的Tag；
    NSDictionary * oldTagDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"APSerViceTags"];
    if (![Utils isNilOrEmpty:oldTagDict]) {
        [tmptagDict addEntriesFromDictionary:oldTagDict];
    }
    [tmptagDict setObject:[UIDevice currentDevice].systemName forKey:@"系统名称"];
    [tmptagDict setObject:[UIDevice currentDevice].systemVersion forKey:@"系统版本"];
    [tmptagDict setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"软件版本"];
    [tmptagDict setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:@"内部版本"];
    [tmptagDict setObject:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"系统语言"];
    return tmptagDict;
}

//处理Tags的回调函数
- (void)handleTagsCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    KT_DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
//处理别名Alias的回调函数
- (void)handleAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    KT_DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}





//上传服务器
//上传推送设置
+ (void)uploadAliasAndTags:(NSDictionary *)tagDictionary
{
    //上传
    //NOTE  待实现

    //
    return;
    [JPushManager setTagsForAPServiceWithTags:tagDictionary];//设置激光推送

}
@end
