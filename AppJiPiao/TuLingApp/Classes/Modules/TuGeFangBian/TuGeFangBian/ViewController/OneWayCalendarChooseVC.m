//
//  OneWayCalendarChooseVC.m
//  TuLingApp
//
//  Created by apple on 2017/12/6.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "OneWayCalendarChooseVC.h"
#import "FSCalendar.h"
#import <EventKit/EventKit.h>
#import "Untils.h"
#import "SelectFlightViewController.h"
#import "TicketEndorseFlightInfo.h"

@interface OneWayCalendarChooseVC () <FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSCalendar *gregorianCalendar;

@end

@implementation OneWayCalendarChooseVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.oneWayType == OneWayTypeEndorse) {
        [self addCustomTitleWithTitle:@"可改签日期"];
    } else {
        [self addCustomTitleWithTitle:@"选择日期"];
    }
    [self initWithSelectCoder:nil];
    
}

- (void)initWithSelectCoder:(NSDate *)date {
    self.calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    
    self.calendar.backgroundColor = [UIColor whiteColor];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    self.calendar.pagingEnabled = NO; // important
    self.calendar.firstWeekday = 2;
    self.calendar.appearance.weekdayFont = [UIFont systemFontOfSize:18];
    self.calendar.appearance.weekdayTextColor = [UIColor blackColor];
    self.calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
    self.calendar.appearance.titleDefaultColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.calendar.appearance.headerDateFormat = @"yyyy年MM月";
    self.calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:20];
    self.calendar.appearance.headerTitleColor = [UIColor colorWithHexString:@"#6DCB99"];
    self.calendar.appearance.todayColor = [UIColor whiteColor];
    NSLocale *chinese = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]; // 设置为中文
    self.calendar.locale = chinese;
    self.calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    self.calendar.appearance.selectionColor = [UIColor colorWithHexString:@"#6DCB99"];
    self.calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = chinese;
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
//     [self.dateFormatter dateFromString:[Untils calendarDateString:[Untils dateFormString:self.selectDate]]]
//    [self.calendar setCurrentPage:[self.dateFormatter dateFromString:[Untils calendarDateString:[Untils dateFormString:self.selectDate]]] animated:YES];
//    [self.calendar selectDate:[self.dateFormatter dateFromString:[Untils calendarDateString:[Untils dateFormString:self.selectDate]]] scrollToDate:YES];
    
    [self.view addSubview:self.calendar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSDate *seDate = [self.dateFormatter dateFromString:self.selectDate];
    [self.calendar setCurrentPage:seDate animated:YES];
}

- (void)setSelectDate:(NSString *)selectDate {
    if (![_selectDate isEqualToString:selectDate] || _selectDate != selectDate) {
        _selectDate = [Untils calendarDateString:[Untils dateFormString:selectDate]];
        [self.calendar reloadData];
    }
}

#pragma mark -
#pragma mark - FSCalendarDataSource
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comp = [gregorian components: unitFlags fromDate:dt];
    NSDateComponents *comp2 = [[NSDateComponents alloc]
                               init];
    comp2.year = comp.year;
    comp2.month = 1;
    comp2.day = 1;
    NSDate *date = [gregorian dateFromComponents:comp2];
    return date;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *dt = [NSDate date];
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *comp = [gregorian components: unitFlags fromDate:dt];
    NSDateComponents *comp2 = [[NSDateComponents alloc]
                               init];
    comp2.year = comp.year+2;
    comp2.month = 12;
    NSDate *date = [gregorian dateFromComponents:comp2];
    return date;
}

#pragma mark -
#pragma mark - FSCalendarDelegate
// 选择日期
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    if (self.oneWayType == OneWayTypeEndorse) {
        
        TLTicketModel *model = [TLTicketModel getEndorseRequestModel:[self.endorseModel.detailList firstObject]];
        model.orderType = [self.endorseModel.orderType integerValue];
        model.beginTime = [Untils getFormatDateByDate:date];
        model.backBeginTime = self.endorseModel.returnBeginTime;
        self.selectDate = [Untils getFormatDateByDate:date];
        [SearchFlightsModel asyncPostEndorseModel:model backState:self.endorseModel.backState SuccessBlock:^(NSArray *dataArray) {
            SelectFlightViewController *selectFlightVC = [SelectFlightViewController new];
            selectFlightVC.tickeModel = model;
            selectFlightVC.selecFlightType = SelectFlightEndorse;
            selectFlightVC.endorseModel = self.endorseModel;
            selectFlightVC.dataArray = dataArray;
            [self.navigationController pushViewController:selectFlightVC animated:YES];
        } errorBlock:^(NSError *errorResult) {
        }];
        
    } else if (self.oneWayType == OneWayTypeTicketEndorse) {
        TLTicketModel *model = [TLTicketModel getEndorseRequestModel:[self.endorseInfo.selectPersons firstObject]];
        model.orderType = self.endorseInfo.orderType;
        model.beginTime = [Untils getFormatDateByDate:date];
        model.backBeginTime = self.endorseInfo.beginTime;
        self.selectDate = [Untils getFormatDateByDate:date];
        NSString *isOrderType = [NSString stringWithFormat:@"%ld",self.endorseInfo.backState];
        if (self.endorseInfo.backState == 3) {
            isOrderType = @"0";
        }
        [TicketEndorseFlightInfo asyncPostNewEndorseModel:model dataDic:self.endorseInfo backState:[NSString stringWithFormat:@"%ld",self.endorseInfo.backState] isOrderType:isOrderType SuccessBlock:^(NSArray *dataArray) {
            SelectFlightViewController *selectFlightVC = [SelectFlightViewController new];
            selectFlightVC.tickeModel = model;
            selectFlightVC.selecFlightType = SelectFlightTicketEndorse;
            selectFlightVC.endorseInfo = self.endorseInfo;
            selectFlightVC.dataArray = dataArray;
            [self.navigationController pushViewController:selectFlightVC animated:YES];
        } errorBlock:^(NSError *errorResult) {
        }];
    } else {
        self.selectDate = [Untils getFormatDateByDate:date];
        OneWayCalendarChooseVCBlock block = self.block;
        if (block) {
            block(date);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    // 设置今天之前的日期不可点击
    if (date < calendar.today) {
        return NO;
    }
    if (self.oneWayType == OneWayTypeEndorse && ![self.endorseModel.backState isEqualToString:@"2"] && [self.endorseModel.orderType isEqualToString:@"2"]) {
        TLTicketModel *model = [TLTicketModel getEndorseRequestModel:[self.endorseModel.detailList firstObject]];
        model.beginTime = self.endorseModel.goBeginTime;
        model.backBeginTime = self.endorseModel.returnBeginTime;
        if ([self.endorseModel.backState isEqualToString:@"0"]) {
            if (date > [Untils dateFormString:model.backBeginTime]) {
                return NO;
            }
        }
        if ([self.endorseModel.backState isEqualToString:@"1"]) {
            if (date < [Untils dateYYMMDDFromString:[Untils calendarDateString:[Untils dateFormString:model.beginTime]]]) {
                return NO;
            }
        }
    }
    if (self.oneWayType == OneWayTypeTicketEndorse && self.endorseInfo.backState != 2 && self.endorseInfo.orderType == 2) {
        TLTicketModel *model = [TLTicketModel getEndorseRequestModel:[self.endorseInfo.selectPersons firstObject]];
        model.beginTime = self.endorseInfo.beginTime;
        model.backBeginTime = self.endorseInfo.backBeginTime;
        if (self.endorseInfo.backState == 0) {
            if (date > [Untils dateFormString:model.backBeginTime]) {
                return NO;
            }
        }
        if (self.endorseInfo.backState == 1) {
            if (date < [Untils dateYYMMDDFromString:[Untils calendarDateString:[Untils dateFormString:model.beginTime]]]) {
                return NO;
            }
        }
    }
    return YES;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    if (date < calendar.today) {
        return [UIColor colorWithHexString:@"#919191"];
    }
    if (self.oneWayType == OneWayTypeEndorse && ![self.endorseModel.backState isEqualToString:@"2"] && [self.endorseModel.orderType isEqualToString:@"2"]) {
        TLTicketModel *model = [TLTicketModel getEndorseRequestModel:[self.endorseModel.detailList firstObject]];
        model.backBeginTime = self.endorseModel.returnBeginTime;
        model.beginTime = self.endorseModel.goBeginTime;
        if ([self.endorseModel.backState isEqualToString:@"0"]) {
            if (date > [Untils dateFormString:model.backBeginTime]) {
                return [UIColor colorWithHexString:@"#919191"];
            }
        }
        if ([self.endorseModel.backState isEqualToString:@"1"]) {
            if ([Untils dateYYMMDDFromString:[Untils calendarDateString:[Untils dateFormString:model.beginTime]]] > date) {
                return [UIColor colorWithHexString:@"#919191"];
            }
        }
    }
    if (self.oneWayType == OneWayTypeTicketEndorse && self.endorseInfo.backState != 2 && self.endorseInfo.orderType == 2) {
        TLTicketModel *model = [TLTicketModel getEndorseRequestModel:[self.endorseInfo.selectPersons firstObject]];
        model.backBeginTime = self.endorseInfo.backBeginTime;
        model.beginTime = self.endorseInfo.beginTime;
        if (self.endorseInfo.backState == 0) {
            if (date > [Untils dateFormString:model.backBeginTime]) {
                return [UIColor colorWithHexString:@"#919191"];
            }
        }
        if (self.endorseInfo.backState == 1) {
            if ([Untils dateYYMMDDFromString:[Untils calendarDateString:[Untils dateFormString:model.beginTime]]] > date) {
                return [UIColor colorWithHexString:@"#919191"];
            }
        }
    }
    if ([self.dateFormatter dateFromString:self.selectDate] == date) {
        return [UIColor colorWithHexString:@"#ffffff"];
    }
    
    return [UIColor colorWithHexString:@"#434343"];
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date {
    if ([self.dateFormatter dateFromString:self.selectDate] == date) {
        return [UIColor colorWithHexString:@"#6DCB99"];
    }
    return nil;
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date {
    if ([self.calendar isDateInToday:date]) {
        return @"今";
    }
    return nil;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date {
    if ([self.dateFormatter dateFromString:self.selectDate] == date) {
        return [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return [UIColor colorWithHexString:@"#434343"];
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleSelectionColorForDate:(NSDate *)date {
    return [UIColor colorWithHexString:@"#FFFFFF"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
