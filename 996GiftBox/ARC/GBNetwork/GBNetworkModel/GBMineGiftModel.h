//
//  GBMineGiftModel.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-22.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBBaseModel.h"

@interface GBMineGiftModel : GBBaseModel

@property (nonatomic, copy) NSString *packageName;       //礼包名称
@property (nonatomic, assign) NSTimeInterval expire_time;  //过期时间
@property (nonatomic, assign) long long package_number_id; //礼包ID值
@property (nonatomic, copy) NSString *package_number;      //礼包码
@property (nonatomic, assign) short package_status;        //礼包状态
@property (nonatomic, copy) NSString *iconStrUrl;             //礼包图标url
@property (nonatomic, assign) BOOL isOut;                  //是否已过期
@property (nonatomic, assign) BOOL isSelected;

@end
