//
//  NSString+GCDNetworkKitAdditions.h
//  GameGifts
//
//  Created by Teiron-37 on 13-12-27.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GCDNetworkKitAdditions)

- (NSString *) md5;
+ (NSString*) uniqueString;
- (NSString*) urlEncodedString;
- (NSString*) urlDecodedString;

@end
