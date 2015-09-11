//
//  UncaughtExceptionHandler.m
//  ZhiZhi
//
//  Created by Danny on 13-6-9.
//  Copyright (c) 2013年 Yi-Ma. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;


@implementation UncaughtExceptionHandler

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}


- (void)handleException:(NSException *)exception
{
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception Reason: %@\n\n  userInfo: %@", [exception reason], [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
    KT_DLog(@"ExceptionInfo BEGIN:<*><*><*><*><*><*><*><*><*><*><*><*><*><*>\nExceptionInfo:\n%@\nExceptionInfo END:<*><*><*><*><*><*><*><*><*><*><*><*><*><*>", exceptionInfo);
    //添加崩溃日子统计 可以上传服务器
    
    
//上传到邮件NOTE
#if GIFTBOX_DEBUG == 1
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *urlStr = [NSString stringWithFormat:@"mailto:xuxiaoyu@teiron.com?subject=GameGifts Bug Report &body=Thanks for your coorperation!<br><br><br>"
                        "AppName:GameGifts<br>"\
                        "Version:%@<br>"\
                        "Build:%@<br>"\
                        "Details1:<br>%@<br>--------------------------<br><br>---------------------<br>",
                        name,reason,[arr componentsJoinedByString:@"<br>"]];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
#endif
    

    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    } else {
        [exception raise];
    }
}

@end

NSString* getAppInfo()
{
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\nUUID :%@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion,
                         [[NSUserDefaults standardUserDefaults] objectForKey: @"open_UDID"]];

    KT_DLog(@"appInfo->Crash!>>>: %@", appInfo);
    return appInfo;
}

void CustomSignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) { return; }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    [userInfo setObject:[UncaughtExceptionHandler backtrace] forKey:UncaughtExceptionHandlerAddressesKey];
    NSString *reason = [NSString stringWithFormat: NSLocalizedString(@"Signal %d was raised.\n" @"%@", nil), signal, getAppInfo()];
    NSException *exception = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                                                     reason:reason
                                                   userInfo:userInfo];
    
    __autoreleasing UncaughtExceptionHandler *ueh = [[UncaughtExceptionHandler alloc] init];
    [ueh performSelectorOnMainThread:@selector(handleException:)
                          withObject:exception
                       waitUntilDone:YES];
}

#pragma mark - uncaughtExceptionHandler
void uncaughtExceptionHandlerNotForSignal(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }
    NSArray *callStack = [UncaughtExceptionHandler backtrace];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [[[UncaughtExceptionHandler alloc] init] performSelectorOnMainThread:@selector(handleException:)
                                                              withObject:[NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo]
                                                           waitUntilDone:YES];
}

void installUncaughtExceptionHandler()
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandlerNotForSignal);
    signal(SIGABRT, CustomSignalHandler);
    signal(SIGILL, CustomSignalHandler);
    signal(SIGSEGV, CustomSignalHandler);
    signal(SIGFPE, CustomSignalHandler);
    signal(SIGBUS, CustomSignalHandler);
    signal(SIGPIPE, CustomSignalHandler);
}

