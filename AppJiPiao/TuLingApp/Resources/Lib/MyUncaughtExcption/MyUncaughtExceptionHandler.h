//
//  MyUncaughtExceptionHandler.h
//  TuLingApp
//
//  Created by MacBook on 2017/5/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
// 崩溃日志
@interface MyUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;


@end
