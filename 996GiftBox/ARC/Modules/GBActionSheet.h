//
//  GBActionSheet.h
//  996GameBox
//
//  Created by Teiron-37 on 13-12-5.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//
#ifndef __KT_GB_ACTION_SHEET_H__
#define __KT_GB_ACTION_SHEET_H__

#import <UIKit/UIKit.h>
enum KGBActionSheetType {
    KGBActionSheetTypeSetting1 = 1,    //最大任务下载数
    KGBActionSheetTypeSetting2 = 2,    //清除缓存
    KGBActionSheetTypePersonInfo1 = 3, //性别
    KGBActionSheetTypePersonInfo2 = 4, //选择头像
    KGBActionSheetTypeLogin = 5,       //登录
    KGBActionSheetTypeRegister = 6,    //注册
    KGBActionSheetTypeShare = 7        //分享
    };

typedef void(^GBActionSheetClickHandler)(int index);
typedef void(^GBActionSheetCloseDidAnimation)(void);

@interface GBActionSheet : UIView
<UITextFieldDelegate>

@property (nonatomic, copy)GBActionSheetCloseDidAnimation handleWithColoseDidAnimation;

- (id)initWithType:(enum KGBActionSheetType)type
        withTitles:(NSArray *)titles
          callBack:(GBActionSheetClickHandler)block
     selectedIndex:(int)index;

//显示
- (void)show;
//关闭
- (void)close;

@end
#endif