//
//  GBPackageReceiveViewController.h
//  GameGifts
//
//  Created by Keven on 14-1-3.
//  Copyright (c) 2014年 Keven. All rights reserved.
//
#ifndef __KT_GB_PACKAGE_RECEIVE_VIEW_CONTROLLER_H__
#define __KT_GB_PACKAGE_RECEIVE_VIEW_CONTROLLER_H__
#import "KTViewControllerWithTabBar.h"
@protocol GBPackageReceiveViewControllerDelegate <NSObject>
- (void)changedPackageStatusWithIndex:(NSIndexPath *)indexPath newStatus:(int)status  packageSurplus:(int)surplusCount;
@end

@interface GBPackageReceiveViewController : KTViewControllerWithTabBar
<
UITableViewDataSource,
UITableViewDelegate
>
{

}
@property(nonatomic,assign)id<GBPackageReceiveViewControllerDelegate> delegate;
/*
KT_PROPERTY_COPY NSString * gameName;
- (id)initWithGameName:(NSString *)gameName;
 */
/**
 *  初始化 礼包详情
 *
 *  @param packageID 礼包ID
 *
 *  @return GBPackageReceiveViewController实例
 */
- (id)initWithPackageID:(int64_t)packageID;
- (id)initWithPackageID:(int64_t)packageID indexPath:(NSIndexPath *)indexPath;
@end
#endif