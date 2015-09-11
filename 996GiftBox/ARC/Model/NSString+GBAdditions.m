//
//  NSString+GBAdditions.m
//  GameGifts
//
//  Created by Teiron-37 on 14-1-24.
//  Copyright (c) 2014年 Keven. All rights reserved.
//

#import "NSString+GBAdditions.h"

@implementation NSString (GBAdditions)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEmail {
    NSString   *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isQQ {
    NSString   *emailRegex = @"(/^[0-9]*$/)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
