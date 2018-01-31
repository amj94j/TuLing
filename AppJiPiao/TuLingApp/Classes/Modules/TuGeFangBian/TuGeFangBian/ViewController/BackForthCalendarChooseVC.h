//
//  BackForthCalendarChooseVC.h
//  TuLingApp
//
//  Created by apple on 2017/12/6.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  往返日历

#import "TicketBaseVC.h"
#import "TicketEndorseInfo.h"

typedef void (^BackForthCalendarChooseVCBlock)(NSDate *formatTimer, NSDate *backTimer);
typedef NS_ENUM(NSInteger, BackForthType) {
    BackForthTypeDefault,
    BackForthTypeEndorse, // 改签 VUE
    BackForthTypeTicketEndorse // 改签 走本地
};

@interface BackForthCalendarChooseVC : TicketBaseVC
@property (nonatomic, copy) BackForthCalendarChooseVCBlock block;

@property (nonatomic, copy) NSDate *fortdate;
@property (nonatomic, copy) NSDate *baceDate;
@property (nonatomic, assign) BOOL isforth;
@property (nonatomic, assign) BackForthType backForthType;
@property (nonatomic, strong) EndorseModel *endorseModel;
@property (nonatomic, strong) TicketEndorseInfo *endorseInfo;
@end
