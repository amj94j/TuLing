//
//  NSObject+TLNumberWithDouble.m
//  TuLingApp
//
//  Created by gyc on 2017/7/17.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "NSObject+TLNumberWithDouble.h"

@implementation NSObject (TLNumberWithDouble)
+(NSString *)decimalNumberWithDouble:(double)num{
    
    if (!num){
        return @"";
    }
    
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                                        scale:2
                                                        raiseOnExactness:NO
                                                        raiseOnOverflow:YES
                                                        raiseOnUnderflow:YES
                                                        raiseOnDivideByZero:YES];
    
    NSDecimalNumber * decNumber = [[NSDecimalNumber alloc] initWithDouble:num];
    [decNumber decimalNumberByRoundingAccordingToBehavior:handler];
    
    NSString * result = [decNumber stringValue];
    if ([NSString isBlankString:result]){
        return result;
    }
    
    result = [NSString stringWithFormat:@"%.2lf",num];
    return result;
}


@end
