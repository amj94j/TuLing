//
//  NSString+checkNull.m
//  TuLingApp
//
//  Created by hua on 16/12/2.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "NSString+checkNull.h"

@implementation NSString (checkNull)

+(BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return NO;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if (![string isKindOfClass:[NSString class]]){
        return NO;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}


@end
