//
//  CheckDataTool.h
//  TuLingApp
//
//  Created by hua on 16/11/17.
//  Copyright © 2016年 shensiwei. All rights reserved.
//   正则表达式

#import <Foundation/Foundation.h>
 typedef void(^resultBlock)(NSString *res);
@interface CheckDataTool : NSObject
+ (NSString *)matchUsername:(NSString *)username;
@end
