//
//  GBNetworkDefine.h
//  GameGifts
//
//  Created by Teiron-37 on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#ifndef _96GiftBox_GBNetworkDefine_h
#define _96GiftBox_GBNetworkDefine_h
/**
 *  请求Command表识
 */
typedef NS_ENUM (NSUInteger,REQUEST_COMMAND_TYPE){
    /**
     *  获取礼包发号列表
     */
    REQUEST_COMMAND_TYPE_GET_PACKAGE                                            = 0x99600020,
    /**
     *  获取礼包详细页面
     */
    REQUEST_COMMAND_TYPE_GET_PACKAGE_INFORMATION                                = 0x99600021,
    /**
     *  获取活动列表
     */
    REQUEST_COMMAND_TYPE_GET_ACTIVITY                                           = 0x99600022,
    /**
     *  获取活动详细页面
     */
    REQUEST_COMMAND_TYPE_GET_ACTIVITY_INFORMATION                               = 0x99600023,
    /**
     *  获取游戏列表（测试表，开服表）
     */
    REQUEST_COMMAND_TYPE_GET_GAME                                               = 0x99600024,
    /**
     *  领号0x99603020
     */
    REQUEST_COMMAND_TYPE_APP_GETPACKAGENUMBER                                   = 0x99600025,
    
    /**
     *  预约 IH_REQ_ORDER	=0x99600029
     */
    REQUEST_COMMAND_TYPE_APP_PACKAGEORDER                                       = 0x99600029,
    /**
     *
     * 我的礼包
     */
    REQUEST_COMMAND_TYPE_MINE_GIFT                                              = 0x99600026,
    /**
     *  首页0x99600027
     */
    REQUEST_COMMAND_TYPE_GET_HOME                                               = 0x99600027,
    /**
     * 礼包推荐(搜索推荐)
     */
    REQUEST_COMMAND_TYPE_GIFT_RECOMMEND                                         = 0x99600028,
    /**
     *  搜索0x99603020
     */
    REQUEST_COMMAND_TYPE_SEARCH                                                 = 0x99603020,
    /**
     * 客户端批量删除  0x99600030
     */
    REQUEST_COMMAND_TYPE_DELETE_GETNUMBER                                       = 0x99600030,
};
/**
 *  请求Res_type 请求游戏的列表（测服表，开服表）
 */
typedef NS_ENUM (NSUInteger,REQUEST_RES_TYPE){
    /**
     *  测服表 Res_type
     */
    REQUEST_RES_TYPE_GAME_TEST  = 1,
    /**
     *  开服表 Res_type
     */
    REQUEST_RES_TYPE_GAME_OPEN  = 2,
};
/*
 请求服务错误码
 */

typedef NS_ENUM(NSInteger,REQUEST_SERVICES_STATUS_CODE) {
    
    REQUEST_SERVICES_STATUS_CODE_IH_E_OK                                = 0,    //结果码为0时，才取结果码后面的数据
    REQUEST_SERVICES_STATUS_CODE_IH_E_NEGATIVE_VALUE                    = 1,    //无效的页码或每页数量
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PACKAGE_LIST              = 2,    //系统错误
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PACKAGE                   = 3,    //系统错误
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_USER                      = 4,    //系统错误
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PACKAGE_ID                = 5,    //无效的礼包ID值
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_PUBLISHTIME               = 6,    //系统错误
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_ACTIVITY_LIST             = 7,    //系统错误
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_ACTIVITY                  = 8,    //系统错误
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_ACTIVITY_ID               = 9,    //无效的礼包ID值
    REQUEST_SERVICES_STATUS_CODE_IH_E_UNKNOWN                           = 10,   //未知错误
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_GAME                      = 11,   //系统错误
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_GAME_RESTYPE              = 12,   //无效res_type
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_GAME_LIST                 = 13,   //系统错误
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_USER_ID                   = 14,   //无效的userid
    REQUEST_SERVICES_STATUS_CODE_IH_E_GET_PACKAGE_ERROR                 = 15,   //获取礼包失败
    REQUEST_SERVICES_STATUS_CODE_IH_E_GET_NUMBER_ERROR                  = 16,   //获取我的兑现码失败
    REQUEST_SERVICES_STATUS_CODE_IH_E_GET_NUMBER_OUTTIME                = 17,   //获取兑现码超时
    
    REQUEST_SERVICES_STATUS_CODE_IH_E_USER_ID                           = 101,  //user_id 出错
    REQUEST_SERVICES_STATUS_CODE_IH_E_PACKAGE_ID                        = 102,  //package_id 出错
    REQUEST_SERVICES_STATUS_CODE_IH_E_NO_PACKAGE_NUMBER                 = 103,  //礼包号领完
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_SEARCH_COUNT              = 104,  //无效 搜索返回树量
    REQUEST_SERVICES_STATUS_CODE_IH_E_EMPTY_SEARCH_KEY                  = 105,  //search_key  为空“”
    REQUEST_SERVICES_STATUS_CODE_IH_E_INVALID_REQUEST                   = 110,  //无效请求request
     
};

// 礼包盒子 api 前缀
#define GIFTBOX_URL_PREFIX @"http://183.57.76.38:8008/" // 测试环境
#define GIFTBOX_URL_PREFIX_PRODUCT @"http://183.57.76.38/" // 证书环境

// 用户中心
#define USERCENTER_URL_PREFIX @"http://openapi.25pp.com/user/"

// 意见反馈
#define FEEDBACK_URL_PREFIX @"http://58.218.147.147:9968/feedback/feedbackAdd"

#endif
