//
//  GBNetwork.m
//  GameGifts
//
//  Created by Teiron-37 on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import "GBNetwork.h"
#import "GBNetworkDefine.h"

@implementation GBNetwork

+ (GBNetwork *) sharedNetwork {
    
    static GBNetwork *sharedMKNetworkInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedMKNetworkInstance = [[self alloc] init];
    });
    return sharedMKNetworkInstance;
}

+ (GCDNetworkEngine *) sharedNetworkEngine
{
    static GCDNetworkEngine *sharedGCDNetworkEngineInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGCDNetworkEngineInstance = [[GCDNetworkEngine alloc] initWithHostName:GIFTBOX_URL_PREFIX];
        [sharedGCDNetworkEngineInstance useCache];
    });
    return sharedGCDNetworkEngineInstance;
}

@end
