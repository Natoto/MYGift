//
//  GBDefaultResponse.h
//  GameGifts
//
//  Created by Teiron-37 on 14-1-15.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBResponse.h"

@interface GBDefaultResponse : GBResponse

@end

//=======================用户中心===================


//======================= 礼包相关 ===================

#pragma mark - GBHomePageResponse 首页列表

@interface GBHomePageResponse : GBResponse

@property (nonatomic,assign)int32_t activityCount; //活动的个数
@property (nonatomic,assign)int32_t packageCount;
@property (nonatomic,KT_STRONG)NSMutableArray * activityArray; //活动列表
@property (nonatomic,KT_STRONG)NSMutableArray * packageArray;//礼包列表

@end


#pragma mark - GBGiftHairResponse 礼包列表

@interface GBGiftHairResponse : GBResponse

@property (nonatomic,assign)int32_t listCount; //列表的个数
@property (nonatomic,assign)int32_t pageCount; //页的总数
@property (nonatomic,KT_STRONG)NSMutableArray * listArray; //数据列表

@end


#pragma mark - GBPackageReceiveResponse 礼包内页

@class GBPackageReceiveModel;
@interface GBPackageReceiveResponse : GBResponse

@property (nonatomic,KT_STRONG)GBPackageReceiveModel * dataModelForPR;

@end


#pragma mark - GBGetPackageNumberResponse 领取礼包

@class GBGetPackageNumberModel;
@interface GBGetPackageNumberResponse : GBResponse

@property (nonatomic,KT_STRONG)GBGetPackageNumberModel * dataModelForPN;

@end


#pragma mark - GBGetPackageOrderResponse 预约礼包

@class GBPackageOrderModel;
@interface GBGetPackageOrderResponse : GBResponse

@property (nonatomic,KT_STRONG)GBPackageOrderModel * dataModelForPN;

@end

#pragma mark - GBDeletePackageNumber  客户端删除兑换码

@interface GBDeletePackageNumber : GBResponse

@property(nonatomic,assign)int32_t  delete_count;   //删除总量

@end

#pragma mark - GBActivityCenterListResponse 活动列表

@class GBActivityCenterListModel;
@interface GBActivityCenterListResponse : GBResponse

@property (nonatomic,assign)int32_t listCount; //列表的个数
@property (nonatomic,assign)int32_t pageCount; //页的总数
@property (nonatomic,KT_STRONG)NSMutableArray * listArray; //数据列表

@end


#pragma mark - GBActivitiesDetailsResponse 活动内页

@class GBActivitiesDetailsModel;
@interface GBActivitiesDetailsResponse : GBResponse

@property (nonatomic,KT_STRONG)GBActivitiesDetailsModel * dataModelForAD;

@end


#pragma mark - GBGiftSearchResponse 礼包搜索

@interface GBGiftSearchResponse : GBDefaultResponse

@property (nonatomic,assign)int32_t listCount; //列表的个数
@property (nonatomic,assign)int32_t pageCount; //页的总数
@property (nonatomic, strong) NSMutableArray *modelMArray;

@end


#pragma mark - GBGiftRecommendResponse 礼包推荐

@interface GBGiftRecommendResponse : GBDefaultResponse

@property (nonatomic, strong) NSMutableArray *modelMArray;

@end


#pragma mark - GBMineGiftResponse 我的礼包

@interface GBMineGiftResponse : GBDefaultResponse

@property (nonatomic,assign)int32_t pageCount; //页的总数
@property (nonatomic, strong) NSMutableArray *modelGroupArray;

@end


//=======================其它=======================

#pragma mark - GBActivitiesDetailsResponse 开服表/测试表

@class GBOpenServiceAndTestChartModel;
@interface GBOpenServiceAndTestChartResponse : GBResponse

@property (nonatomic,assign)int32_t listCount; //列表的个数
@property (nonatomic,assign)int32_t pageCount; //页的总数
@property (nonatomic,KT_STRONG)NSMutableArray * listArray; //数据列表

@end


#pragma mark - GBFeedbackResponse 意见反馈

@interface GBFeedbackResponse : GBResponse

@end


