//
//  GBResponse.h
//  GameGifts
//
//  Created by Teiron-37 on 13-12-30.
//  Copyright (c) 2013年 Keven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAnalytical.h"

@interface GBResponse : BaseAnalytical {
@protected
    BOOL _isError;
    NSString *_errorMessage;
}

@property (nonatomic, assign) BOOL isError;
@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger command;
@property (nonatomic, assign) BOOL netError; //YES 网络原因, NO 服务器原因

- (id)initWithResponseDictionary:(NSDictionary *)responseDictionary;
- (id)initWithErrorMessage:(NSString *)errorMessage;
- (id)initWithOriginal:(NSData *)responseData;

@end

