//
//  GBGiftDetailsViewController.h
//  996GameBox
//
//  Created by Keven on 13-12-9.
//  Copyright (c) 2013年 KevenTsang. All rights reserved.
//
#ifndef __KT_GB_ACTUVUTUES_DETAILS_VIEW_CONTROLLER_H__
#define __KT_GB_GIFT_DETAILS_VIEW_CONTROLLER_H__
#import "KTViewControllerWithTabBar.h"
@interface GBActivitiesDetailsViewController : KTViewControllerWithTabBar
<UIScrollViewDelegate>
{
    
}
/**
 *  初始化活动详情内页
 *
 *  @param activityID 活动ID号
 *
 *  @return GBActivitiesDetailsViewController 实例
 */
- (id)initWithActivityID:(int32_t)activityID;
@end
#endif