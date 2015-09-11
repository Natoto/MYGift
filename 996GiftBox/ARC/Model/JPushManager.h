//
//  JPushManager.h
//  GameGifts
//
//  Created by Keven on 13-12-25.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

//设置推送的Tag 或者别名 （别名只有一个，标签可以有多个）
/*
 alias
 nil 此次调用不设置此值。
 空字符串 （@""）表示取消之前的设置。
 每次调用设置有效的别名，覆盖之前的设置。
 有效的别名组成：字母（区分大小写）、数字、下划线、汉字。
 限制：alias 命名长度限制为 40 字节。（判断长度需采用UTF-8编码）
 
 tags
 空集合（[NSSet set]）表示取消之前的设置。
 每次调用至少设置一个 tag，覆盖之前的设置，不是新增。
 有效的标签组成：字母（区分大小写）、数字、下划线、汉字。
 限制：每个 tag 命名长度限制为 40 字节，最多支持设置 100 个 tag，但总长度不得超过1K字节。（判断长度需采用UTF-8编码）
 单个设备最多支持设置 100 个 tag。App 全局 tag 数量无限制。
 */
/*
 推送方案，覆盖逻辑（设置Alias，tags，覆盖之前的设置。）
 Alias别名（《=1）
 只有一个就是UUID，如果UUID改变，会从新上传，覆盖之前的设置
 Tags:（《=100）
 默认：系统名称 ，系统版本，软件版本，内部版本，系统语言，
 或许有：登陆名，性别，年龄，用户手机上得软件的软件名称，软件版本
 相关说明，登陆这个Tag会在退出程序时删除，登陆时添加
 所有的alias，tags 最后结果都是MD5Hash
 Alias：
 如：
 “UUID:xxxxxxxx-xxxx-xxxx-892C-3AA5D627F9D5”   进行MD5签名 得到 xxxxxxxxxxxxxxxxx ->这个是最后上传的结果
 Tag：
 如：
 “系统名称：996礼盒”                             进行MD5签名 得到 xxxxxxxxxxxxxxxxx ->这个是最后上传的结果
 
 ////////下面是Alias，tags  （正式）
 Alias：
 UUID
 Tags：（默认，必有）
 系统名称，系统版本，软件版本，内部版本，系统语言
 （add）
 登陆名，性别，年龄 等
 特别注明：
 用户手机上得软件的软件版本
 “软件名称：软件版本”                   进行MD5签名 得到 xxxxxxxxxxxxxxxxx ->这个是最后上传的结果
 
 
 前台处理4个标签，分别是
 |||首页  《==》 1001 ||| 开服测试 《 === 》 2002  ||| 搜索 《 === 》 3003  ||||  我的 《===》 4004
 推送的消息组成 ：“要推送的信息---1001”
 所有的通知都分别归为这四类，而接到通知后前端暂时只显示顶级页面
 
 关于预约礼包号《《《《 设置激光和上传服务器的
 用键值对来设置
 value 是  packageID (礼包ID值)
 key 是  “OrderPackageID + 2343252352345”
 “OrderPackageID + 2343252352345:2343252352345”  进行MD5签名 得到 xxxxxxxxxxxxxxxxx ->这个是最后上传的结果
 
 //设置领取礼包 《《《《 设置激光和上传服务器的
 用键值对来设置 游戏ID，和游戏分类
 游戏ID ：
 value 是 gameID（游戏ID）;
 key   是  “GetPackage + 23333984”
 “GetPackage + 23333984:23333984” 进行MD5签名 得到 xxxxxxxxxxxxxxxxx ->这个是最后上传的结果
 
 游戏分类
 value 是  分类对应的 数值  10000334
 key   是   @“GameClass + 10000334”
 “GameClass + 23333984:23333984” 进行MD5签名 得到 xxxxxxxxxxxxxxxxx ->这个是最后上传的结果
 
 */
#ifndef __KT_JPUSH_MANAGER_H__
#define __KT_JPUSH_MANAGER_H__

#import <Foundation/Foundation.h>

@interface JPushManager : NSObject

//开机来设置推送
+ (void)setAPServiceByBoot;
//设置标签
+ (void)setTagsForAPServiceWithTags:(NSDictionary *)tagDictionary;

//上传推送设置
+ (void)uploadAliasAndTags:(NSDictionary *)tagDictionary;

@end
#endif
