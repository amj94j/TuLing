//
//  OneWayCalendarChooseVC.h
//  TuLingApp
//
//  Created by apple on 2017/12/6.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  单程日历

#import "TicketBaseVC.h"
#import "FSCalendar.h"
#import "TicketEndorseInfo.h"
typedef NS_ENUM(NSInteger, OneWayType) {
    OneWayTypeDefault,
    OneWayTypeEndorse, // 改签 VUE
    OneWayTypeTicketEndorse // 改签 走本地
};

typedef void (^OneWayCalendarChooseVCBlock)(NSDate *timer);
@interface OneWayCalendarChooseVC : TicketBaseVC
@property (nonatomic, copy) OneWayCalendarChooseVCBlock block;
@property (nonatomic, copy) NSString *selectDate;
@property (nonatomic, strong) FSCalendar *calendar;
@property (nonatomic, assign) OneWayType oneWayType;
@property (nonatomic, strong) EndorseModel *endorseModel;
@property (nonatomic, strong) TicketEndorseInfo *endorseInfo;
- (void)initWithSelectCoder:(NSDate *)date;
@end
