//
//  UncaughtExceptionHandler.h
//  ZhiZhi
//
//  Created by Danny on 13-6-9.
//  Copyright (c) 2013年 Yi-Ma. All rights reserved.
//
#ifndef __KT_UN_CAUGHT_EXCEPTION_HANDLER_H__
#define __KT_UN_CAUGHT_EXCEPTION_HANDLER_H__

#import <Foundation/Foundation.h>


@interface UncaughtExceptionHandler : NSObject
{
}
@end
void CustomSignalHandler(int signal);
void uncaughtExceptionHandlerNotForSignal(NSException *exception);
void installUncaughtExceptionHandler();
#endif