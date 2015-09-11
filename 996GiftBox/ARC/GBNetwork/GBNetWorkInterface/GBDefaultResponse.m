//
//  GBDefaultResponse.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-15.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "GBDefaultResponse.h"
#import "GBDefaultReqeust.h"
#import "GBSearchModel.h"
#import "GBGiftHairModel.h"
#import "GBPackageReceiveModel.h"
#import "GBGetPackageNumberModel.h"
#import "GBActivityCenterListModel.h"
#import "GBActivitiesDetailsModel.h"
#import "GBOpenServiceAndTestChartModel.h"
#import "GBMineGiftModel.h"
#import "GBRecommendModel.h"
#import "GBSearchRecommendModel.h"
#import "GBMineGiftGroupModel.h"
#import "GBPackageOrderModel.h"

@implementation GBDefaultResponse

@end

//=======================用户中心===================

//=======================礼包相关===================

#pragma mark - GBHomePageResponse 首页列表

@implementation GBHomePageResponse
- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        
        self.activityCount = [self readInt_32];
        
        NSMutableArray * activityArrayTmp = nil;
        if (self.activityCount > 0) {
            activityArrayTmp = [NSMutableArray arrayWithCapacity:self.activityCount];
        }

        for (int i = 0; i < self.activityCount; i++) {
            @autoreleasepool {
                GBActivityCenterListModel * model = [[GBActivityCenterListModel alloc] init];
                model.activityID = [self readInt_32];
                model.activityName = [self readString];
                model.iconURLString = [self readString];
                [activityArrayTmp addObject:model];
            }
        }
        self.activityArray = activityArrayTmp;
        
        
        self.packageCount = [self readInt_32];
        NSMutableArray * packageArrayTmp = nil;
        if (self.packageCount > 0) {
            packageArrayTmp = [NSMutableArray arrayWithCapacity:self.packageCount];
        }
        for (int i =0 ; i < self.packageCount; i++) {
            @autoreleasepool {
                GBGiftHairModel * model = [[GBGiftHairModel alloc] init];
                model.packageID = [self readInt_64];
                model.catID = [self readInt_32];
                model.gameID = [self readInt_32];
                model.iconURLString = [self readString];
                model.gameName = [self readString];
                model.packName = [self readString];
                model.subtitle = [self readString];
                model.publishTime = [self readInt_32];
                model.packcount = [self readInt_32];
                model.packStatus = [self readInt_8];
                [packageArrayTmp addObject:model];
            }
        }
        self.packageArray = packageArrayTmp;
    }
    return self;
}

@end


#pragma mark - GBGiftHairResponse 礼包列表

@implementation GBGiftHairResponse

- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        
        self.pageCount = [self readInt_32];
        self.listCount = [self readInt_32];
        if (self.listCount > 0) {
            self.listArray = [NSMutableArray arrayWithCapacity:self.listCount];
        }
        
        for (int i = 0; i < self.listCount; i++) {
            @autoreleasepool {
                GBGiftHairModel * model = [[GBGiftHairModel alloc]init];
                model.packageID = [self readInt_64];
                model.catID = [self readInt_32];
                model.gameID = [self readInt_32];
                model.gameName = [self readString];
                model.packName = [self readString];
                model.subtitle = [self readString];
                model.iconURLString = [self readString];
                model.publishTime = [self readInt_32];
                model.packcount = [self readInt_32];
                model.packStatus = [self readInt_8];
                [self.listArray addObject:model];
            }
        }
    }
    return self;
}

@end


#pragma mark - GBPackageReceiveResponse 礼包内页

@implementation GBPackageReceiveResponse

- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        @autoreleasepool {
            GBPackageReceiveModel * model = [[GBPackageReceiveModel alloc] init];
            model.packageID = [self readInt_64];
            model.catID = [self readInt_32];
            model.gameID = [self readInt_32];
            model.gameName = [self readString];
            model.publishTime = [self readInt_32];
            model.outTime = [self readInt_32];
            model.packageName = [self readString];
            model.subtitle = [self readString];
            model.iconURLString = [self readString];
            model.content = [self readString];
            model.exchange = [self readString];
            model.packageCount = [self readInt_32];
            model.packageSurplusCount = [self readInt_32];
            model.packageStatus = [self readInt_8];
            model.number = [self readString];
            self.dataModelForPR = model;
        }
    }
    return self;
}

@end


#pragma mark - GBGetPackageNumberResponse 领取礼包

@implementation GBGetPackageNumberResponse

- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        @autoreleasepool {
            GBGetPackageNumberModel * model = [[GBGetPackageNumberModel alloc] init];
            model.packageID = [self readInt_64];
            model.packageSurplus = [self readInt_32];
            model.packageStatus = [self readInt_8];
            model.packageNumber = [self readString];
            self.dataModelForPN = model;
        }
    }
    return self;
}

@end


#pragma mark - GBGetPackageOrderResponse 预约礼包

@implementation GBGetPackageOrderResponse

- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        @autoreleasepool {
            GBPackageOrderModel * model = [[GBPackageOrderModel alloc] init];
            model.package_id=[self readInt_64];
            model.package_status=[self readInt_8];
            self.dataModelForPN = model;
        }
    }
    return self;
}

@end

#pragma mark - GBDeletePackageNumber  客户端删除兑换码
@implementation GBDeletePackageNumber

- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        @autoreleasepool {
            self.delete_count=[self readInt_32];
        }
    }
    return self;
}

@end

#pragma mark - GBActivityCenterListResponse 活动列表

@implementation GBActivityCenterListResponse

- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        self.pageCount = [self readInt_32];
        self.listCount = [self readInt_32];
        if (self.listCount > 0) {
            self.listArray = [NSMutableArray arrayWithCapacity:self.listCount];
        }
        
        for (int i = 0; i < self.listCount; i++) {
            @autoreleasepool {
                GBActivityCenterListModel * model = [[GBActivityCenterListModel alloc]init];
                model.activityID = [self readInt_32];
                model.gameName = [self readString];
                model.activityName = [self readString];
                model.publishTime = [self readInt_32];
                model.popularityCount = [self readInt_32];
                model.iconURLString = [self readString];
                model.subtitle = [self readString];
                model.description = [self readString];
                [self.listArray addObject:model];
            }
        }
    }
    return self;
}
@end


#pragma mark - GBActivityCenterListResponse 活动内页

@implementation GBActivitiesDetailsResponse

- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        @autoreleasepool {
            GBActivitiesDetailsModel * model = [[GBActivitiesDetailsModel alloc] init];
            model.activityID = [self readInt_32];
            model.activityName = [self readString];
            model.gameName = [self readString];
            model.content = [self readString];
            model.address = [self readString];
            model.iconURLString = [self readString];
            model.startTime = [self readInt_32];
            model.endTime = [self readInt_32];
            model.reward = [self readString];
            self.dataModelForAD = model;
        }
    }
    return self;
}
@end

#pragma mark - GBActivitiesDetailsResponse 开服表/测试表

@implementation GBOpenServiceAndTestChartResponse

- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        self.pageCount = [self readInt_32];
        self.listCount = [self readInt_32];
        if (self.listCount > 0) {
            self.listArray = [NSMutableArray arrayWithCapacity:self.listCount];
        }
        
        for (int i = 0; i < self.listCount; i++) {
            @autoreleasepool {
                GBOpenServiceAndTestChartModel * model = [[GBOpenServiceAndTestChartModel alloc]init];
                model.packageID = [self readInt_64];
                model.gameName = [self readString];
                model.publishTime = [self readInt_32];
                model.remark = [self readString];
                model.score = [self readInt_8];
                model.iconURLString = [self readString];
                model.category = [self readString];
                [self.listArray addObject:model];
            }
        }
    }
    return self;
}
@end


#pragma mark - GBGiftSearchResponse 礼包搜索

@implementation GBGiftSearchResponse

- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        
        long long user_id = [self readInt_64];
        
        self.pageCount = [self readInt_32];
        self.listCount = [self readInt_32];
        
        if (self.listCount > 0) {
            self.modelMArray = [NSMutableArray arrayWithCapacity:self.listCount];
        }
        
        for (int i = 0; i < self.listCount; ++i) {
            GBSearchModel *model = [[GBSearchModel alloc] init];
            model.flags = [self readInt_32];
            model.remanCount = [self readInt_32];
            model.packageStatus = [self readInt_8];
            model.modelID = [self readInt_64];
            model.createTime = [self readInt_32];
            model.data_view = [self readInt_32];
            model.name = [self readString];
            model.content = [self readString];
            model.subContent = [self readString];
            model.picUrl = [self readString];
            
            [self.modelMArray addObject:model];
        }
    }
    return self;
}

@end


#pragma mark - GBGiftRecommendResponse 礼包推荐

@implementation GBGiftRecommendResponse

- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        
        int resultCount = [self readInt_32];
        
        if (resultCount > 0) {
            self.modelMArray = [NSMutableArray arrayWithCapacity:resultCount];
        }
        else{
            return self;
        }
        
        for (int i = 0; i < resultCount; ++i) {
            GBSearchRecommendModel *model = [[GBSearchRecommendModel alloc] init];
            model.rank = i+1;
            model.package_id = [self readInt_64];
            model.package_gameName = [self readString];
            model.package_name = [self readString];
            [self.modelMArray addObject:model];
        }
    }
    return self;
}

@end


#pragma mark - GBMineGiftResponse 我的礼包

@implementation GBMineGiftResponse

- (id)initWithOriginal:(NSData *)responseData
{
    self = [super initWithOriginal:responseData];
    if (self) {
        
        self.pageCount = [self readInt_32];
        int groupCount = [self readInt_32];
        
        if (groupCount > 0) {
            self.modelGroupArray = [NSMutableArray arrayWithCapacity:groupCount];
        }
        else{
            return self;
        }
        
        int packageCount = 0;
        
        for (int i = 0; i < groupCount; ++i) {
            GBMineGiftGroupModel *groupModel = [[GBMineGiftGroupModel alloc] init];
            
            groupModel.gameName = [self readString];
            
            packageCount = [self readInt_32];
            
            NSMutableArray *giftModelArray = nil;
            
            if (packageCount > 0) {
                giftModelArray = [NSMutableArray arrayWithCapacity:packageCount];
            }
            
            for (int i = 0; i < packageCount; ++i) {
                GBMineGiftModel *giftModel = [[GBMineGiftModel alloc] init];
                giftModel.packageName = [self readString];
                giftModel.iconStrUrl = [self readString];
                giftModel.expire_time = [self readInt_32];
                giftModel.package_number_id = [self readInt_64];
                giftModel.package_number = [self readString];
                giftModel.package_status = [self readInt_8];
                if (giftModel.package_status == 0) {//未过期
                    giftModel.isOut = NO;
                }
                else{
                    giftModel.isOut = YES;
                }
                
                [giftModelArray addObject:giftModel];
            }
            
            groupModel.giftModelArray = giftModelArray;
            [self.modelGroupArray addObject:groupModel];
        }
    }
    return self;
}

@end

#pragma mark - GBFeedbackResponse 意见反馈

@implementation GBFeedbackResponse

- (id)initWithResponseDictionary:(NSDictionary *)responseDictionary
{
    self = [super init];
    if (self) {
        NSNumber *status = [responseDictionary objectForKey:@"status"];
        if ([status intValue] == 0) {
            
        }
        else{
            _isError = YES;
            _errorMessage = [responseDictionary objectForKey:@"error"];
        }
    }
    return self;
}

@end

