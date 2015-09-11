//
//  GBNoDataShowView.h
//  GameGifts
//
//  Created by Keven on 14-1-10.
//  Copyright (c) 2014年 Keven. All rights reserved.
//




#ifndef __KT_GB_NO_DATA_SHOW_VIEW_H__
#define __KT_GB_NO_DATA_SHOW_VIEW_H__
typedef NS_ENUM(NSUInteger, GBNoDataShowViewType) {
    GBNoDataShowViewTypeForNoNetwork,    //无网络
    GBNoDataShowViewTypeForServierError, //加载错误
    GBNoDataShowViewTypeForNoData,       //没有数据
    GBNoDataShowViewTypeForSearch,       //没有搜索结果
    GBNoDataShowViewTypeForMineGift      //我的兑换码
};
#import <UIKit/UIKit.h>
@protocol GBNoDataShowViewDelegate;
@interface GBNoDataShowView : UIView
/**
 *  没有数据或者没有网络的显示页面
 *  @默认frame       CGRectMake(0, 0, [Utils screenWidth], [Utils screenHeight] - KT_UI_STATUS_BAR_HEIGHT)
 *  @param type     分各个页面
 *  @param delegate 点击的回调
 *  @param action   代理事件
 *
 *  @return noDataShowView
 */
@property (nonatomic,assign)id<GBNoDataShowViewDelegate>delegate;
@property (nonatomic,assign)int  infoTag;
@property (nonatomic,weak)UIActivityIndicatorView * indicatorView;
- (id)initWithType:(GBNoDataShowViewType)type
            target:(id<GBNoDataShowViewDelegate>)delegate
           infoTag:(int)tag;
- (void)stopIndicatorView;
@end
#endif

#ifndef __KT_GB_NO_DATA_SHOW_VIEW_DELEGATE_H__
#define __KT_GB_NO_DATA_SHOW_VIEW_DELEGATE_H__
@protocol GBNoDataShowViewDelegate <NSObject>
- (void)refreshByNoDataShowViewWithInfoTag:(int)infoTag;
@end
#endif