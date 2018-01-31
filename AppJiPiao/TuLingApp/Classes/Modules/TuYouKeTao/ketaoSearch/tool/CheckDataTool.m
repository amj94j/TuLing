//
//  CheckDataTool.m
//  TuLingApp
//
//  Created by hua on 16/11/17.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "CheckDataTool.h"

@implementation CheckDataTool
#pragma mark - 匹配3-15位的中文或英文(用户名)
+ (NSString *)matchUsername:(NSString *)username {
         NSString *pattern = @"^[a-zA-Z一-龥]{3,15}$";
         __block NSString *result;
         [CheckDataTool matchString:username withPattern:pattern resultBlock:^(NSString *res) {
                 result = res;
             }];
        return result;
}
+ (BOOL)matchString:(NSString *)str withPattern:(NSString *)pattern resultBlock:(resultBlock)block {
             NSError *error = nil;
             NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern: pattern options: NSRegularExpressionCaseInsensitive error: &error];
             if (!error) {
                    NSTextCheckingResult *result = [regular firstMatchInString:str options:0 range:NSMakeRange(0, str.length)];
                     if (result) {
                         
                            block([str substringWithRange:result.range]);
                            return YES;
                         } else {
                             
                                return NO;
                            }
                }
           
             return NO;
        }

@end
