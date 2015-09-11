//
//  GBNetwork.h
//  GameGifts
//
//  Created by Teiron-37 on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDNetworkKit.h"

@interface GBNetwork : NSObject

+ (GBNetwork *) sharedNetwork;

+ (GCDNetworkEngine *) sharedNetworkEngine;

@end
