//
//  SelectFlightModel.h
//  TuLingApp
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"

@interface SelectFlightModel : TicketBaseModel
// 转成字符串类型MM月DD日
+ (NSString *)calendarMMDDString:(NSDate*)date;
// 传入今天日期 返回昨天日期
+ (NSDate *)GetYesterdayDay:(NSDate *)aDate;
//传入今天的时间，返回明天的时间
+ (NSDate *)GetTomorrowDay:(NSDate *)aDate;
@end
