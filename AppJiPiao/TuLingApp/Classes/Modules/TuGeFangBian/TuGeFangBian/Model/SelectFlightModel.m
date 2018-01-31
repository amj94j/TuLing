//
//  SelectFlightModel.m
//  TuLingApp
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "SelectFlightModel.h"

@implementation SelectFlightModel

+ (NSString *)calendarMMDDString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM月dd日";
    NSString* dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

//传入今天的时间，返回明天的时间
+ (NSDate *)GetTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    return beginningOfWeek;
}

// 传入今天日期 返回昨天日期
+ (NSDate *)GetYesterdayDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]-1)];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    return beginningOfWeek;
}
@end
