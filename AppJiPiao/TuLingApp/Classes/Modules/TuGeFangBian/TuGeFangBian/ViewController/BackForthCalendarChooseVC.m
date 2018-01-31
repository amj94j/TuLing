//
//  BackForthCalendarChooseVC.m
//  TuLingApp
//
//  Created by apple on 2017/12/6.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BackForthCalendarChooseVC.h"
#import "FSCalendar.h"
#import <EventKit/EventKit.h>
#import "Untils.h"
#import "SelectFlightViewController.h"
#import "TicketEndorseFlightInfo.h"

@interface BackForthCalendarChooseVC ()<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance>
{
    UIButton *_forthBtn;
    UIView *_forthLine;
    UIButton *_backBtn;
    UIView *_backLine;
    
    UIButton *_determineBtn;// 确定按钮
    
    UILabel *_forthTimerLabel;
    UILabel *_backTimerLabel;
}
@property (nonatomic, strong) FSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSCalendar *gregorianCalendar;

@end

@implementation BackForthCalendarChooseVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.baceDate && self.fortdate) {
        _determineBtn.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
        _determineBtn.selected = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.isforth = YES;
    
    [self addCustomTitleWithTitle:@"选择日期"];
    
    [self navigationItemLeftButtonDraw];
    
    [self layoutMainUIView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isforth) {
        [self.calendar setCurrentPage:self.baceDate animated:YES];
    } else {
        [self.calendar setCurrentPage:self.fortdate animated:YES];
    }
    
}


- (void)navigationItemLeftButtonDraw {
    UIButton *btn = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(onBackBarBtnClick) Title:@""];
    [btn setHitTestEdgeInsets:UIEdgeInsetsMake(-20, -20, -20, -20)];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backBarBtn;
}

- (void)layoutMainUIView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(92))];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    _forthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _forthBtn.frame = CGRectMake(0, 0, (ScreenWidth-PXChange(2))/2, PXChange(90));
    [_forthBtn setTitle:[NSString stringWithFormat:@"去程"] forState:UIControlStateNormal];
    [_forthBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    [_forthBtn setTitleColor:[UIColor colorWithHexString:@"#008C4E"] forState:UIControlStateSelected];
    _forthBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_forthBtn addTarget:self action:@selector(backOrForthClick:) forControlEvents:UIControlEventTouchUpInside];
    [_forthBtn setSelected:YES];
    _forthBtn.userInteractionEnabled = NO;
    _forthBtn.tag = 1000;
    [headerView addSubview:_forthBtn];
    
    _forthLine = [[UIView alloc] initWithFrame:CGRectMake(_forthBtn.left, _forthBtn.bottom, _forthBtn.width, PXChange(2))];
    _forthLine.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
    [headerView addSubview:_forthLine];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kColor_Line;
    [headerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_forthBtn);
        make.centerX.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(PXChange(1), PXChange(80)));
    }];
    
    // 往返
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(ScreenWidth/2+PXChange(1), 0, (ScreenWidth-PXChange(2))/2, PXChange(90));
    [_backBtn setTitle:[NSString stringWithFormat:@"返程"] forState:UIControlStateNormal];
    [_backBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    [_backBtn setTitleColor:[UIColor colorWithHexString:@"#008C4E"] forState:UIControlStateSelected];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_backBtn addTarget:self action:@selector(backOrForthClick:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.tag = 2000;
    [headerView addSubview:_backBtn];
    
    _backLine = [[UIView alloc] initWithFrame:CGRectMake(_backBtn.left, _backBtn.bottom, _backBtn.width, PXChange(2))];
    _backLine.backgroundColor = [UIColor clearColor];
    [headerView addSubview:_backLine];
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, PXChange(92), self.view.bounds.size.width, ScreenHeight-PXChange(92)-PXChange(98)-64)];
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.pagingEnabled = NO; // important
    calendar.firstWeekday = 2;
    calendar.appearance.weekdayFont = [UIFont systemFontOfSize:18];
    calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
    calendar.appearance.titleDefaultColor = [UIColor colorWithHexString:@"#FFFFFF"];
    calendar.appearance.weekdayTextColor = [UIColor blackColor];
    calendar.appearance.todayColor = [UIColor whiteColor];
    calendar.appearance.headerDateFormat = @"yyyy年MM月";
    calendar.appearance.headerTitleColor = [UIColor colorWithHexString:@"#6DCB99"];
    NSLocale *chinese = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    calendar.locale = chinese;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.appearance.selectionColor = [UIColor colorWithHexString:@"#6DCB99"];
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
//    [calendar selectDate:[NSDate date]];
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = chinese;
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";

    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColor_Line;
    [bottomView addSubview:line];
    
    WS(ws)
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, PXChange(98)));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.centerX.equalTo(bottomView);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, PXChange(1)));
    }];
    
    UILabel *forthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PXChange(60), PXChange(98)/2)];
    forthLabel.text = @"去:";
    forthLabel.textAlignment = NSTextAlignmentRight;
    forthLabel.font = [UIFont systemFontOfSize:11];
    forthLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    [bottomView addSubview:forthLabel];
    
    _forthTimerLabel = [[UILabel alloc] initWithFrame:CGRectMake(forthLabel.right+3, 0, PXChange(200), PXChange(98)/2)];
    _forthTimerLabel.text = @"请选择去程日期";
    _forthTimerLabel.textAlignment = NSTextAlignmentLeft;
    _forthTimerLabel.font = [UIFont systemFontOfSize:13];
    _forthTimerLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    [bottomView addSubview:_forthTimerLabel];
    if (self.fortdate) {
        _forthTimerLabel.text = [Untils daraWeekdatStringFromDate:self.fortdate];
    }
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PXChange(98)/2, PXChange(60), PXChange(98)/2)];
    backLabel.text = @"返:";
    backLabel.textAlignment = NSTextAlignmentRight;
    backLabel.font = [UIFont systemFontOfSize:11];
    backLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    [bottomView addSubview:backLabel];
    
    _backTimerLabel = [[UILabel alloc] initWithFrame:CGRectMake(backLabel.right+3, PXChange(98)/2, PXChange(200), PXChange(98)/2)];
    _backTimerLabel.text = @"请选择返程日期";
    _backTimerLabel.textAlignment = NSTextAlignmentLeft;
    _backTimerLabel.font = [UIFont systemFontOfSize:13];
    _backTimerLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    [bottomView addSubview:_backTimerLabel];
    
    if (self.baceDate) {
        _backTimerLabel.text = [Untils daraWeekdatStringFromDate:self.baceDate];
    }
    
    _determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _determineBtn.frame = CGRectMake(ScreenWidth-PXChange(240), 0, PXChange(240), bottomView.height);
    _determineBtn.backgroundColor = [UIColor lightGrayColor];
    _determineBtn.selected = NO;
    [_determineBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _determineBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_determineBtn addTarget:self action:@selector(determineClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_determineBtn];
    
    [_determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView);
        make.top.equalTo(bottomView);
        make.width.offset(PXChange(240));
        make.height.equalTo(bottomView);
    }];
    
    if (self.isforth) {
        [self backOrForthClick:_forthBtn];

    } else {
        [self backOrForthClick:_backBtn];
    }
}

#pragma mark - Click
// 确定
- (void)determineClick:(UIButton *)btn {
    if (!self.fortdate) {
        [self showProgress:@"请选择出行日期"];
        return;
    }
    if (!self.baceDate) {
        [self showProgress:@"请选择出行日期"];
        return;
    }
    if (self.baceDate<self.fortdate) {
        [self showProgress:@"去程时间不能大于返程时间"];
        return;
    }

    if (self.backForthType == BackForthTypeEndorse) {
        TLTicketModel *model = [TLTicketModel getEndorseRequestModel:[self.endorseModel.detailList firstObject]];
        model.orderType = [self.endorseModel.orderType integerValue];
        model.backState = self.endorseInfo.backState;
        model.beginTime = [Untils getFormatDateByDate:self.fortdate];
        model.backBeginTime = [Untils getFormatDateByDate:self.baceDate];
        [SearchFlightsModel asyncPostEndorseModel:model backState:self.endorseModel.backState SuccessBlock:^(NSArray *dataArray) {
            SelectFlightViewController *selectFlightVC = [SelectFlightViewController new];
            selectFlightVC.tickeModel = model;
            selectFlightVC.selecFlightType = SelectFlightEndorse;
            selectFlightVC.endorseModel = self.endorseModel;
            selectFlightVC.dataArray = dataArray;
            [self.navigationController pushViewController:selectFlightVC animated:YES];
        } errorBlock:^(NSError *errorResult) {
        }];
        
    } else if(self.backForthType == BackForthTypeTicketEndorse) {
        TLTicketModel *model = [TLTicketModel getEndorseRequestModel:[self.endorseInfo.selectPersons firstObject]];
        model.orderType = self.endorseInfo.orderType;
        model.isGo = YES;
        model.beginTime = [Untils getFormatDateByDate:self.fortdate];
        model.backBeginTime = [Untils getFormatDateByDate:self.baceDate];
        NSString *isOrderType = @"0";
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
        BackForthCalendarChooseVCBlock block = self.block;
        if (block) {
            block(self.fortdate,self.baceDate);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backOrForthClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 1000) {
        _forthBtn.userInteractionEnabled = NO;
        _backBtn.userInteractionEnabled = YES;
        [_backBtn setSelected:NO];
        _forthLine.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
        _backLine.backgroundColor = [UIColor clearColor];
        self.isforth = YES;
        [self.calendar selectDate:self.fortdate];
    }
    else if (sender.tag == 2000) {
        _backBtn.userInteractionEnabled = NO;
        _forthBtn.userInteractionEnabled = YES;
        [_forthBtn setSelected:NO];
        _backLine.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
        _forthLine.backgroundColor = [UIColor clearColor];
        self.isforth = NO;
        [self.calendar selectDate:self.baceDate];
    }
    [self.calendar reloadData];
}

#pragma mark - Setter & Getter
- (void)setIsforth:(BOOL)isforth {
    if (_isforth != isforth) {
        _isforth = isforth;
    }
}

- (void)setBaceDate:(NSDate *)baceDate {
    if (_baceDate != baceDate || ![_baceDate isEqualToDate:baceDate]) {
        _baceDate = baceDate;
        [self.calendar reloadData];
    }
}

- (void)setFortdate:(NSDate *)fortdate {
    if (_fortdate != fortdate || ![_fortdate isEqualToDate:fortdate]) {
        _fortdate = fortdate;
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
    if (self.isforth) {
        _forthTimerLabel.text = [Untils daraWeekdatStringFromDate:date];
        self.fortdate = date;
    } else {
        _backTimerLabel.text = [Untils daraWeekdatStringFromDate:date];
        self.baceDate = date;
    }
    if (self.baceDate && self.fortdate) {
        _determineBtn.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
        _determineBtn.selected = YES;
    }
    
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    // 设置今天之前的日期不可点击 如果设置当月日期之前的则是 monthPosition == FSCalendarMonthPositionPrevious
    if (date < calendar.today) {
        return NO;
    }
//    else if (self.isforth && self.baceDate && date>self.baceDate) {
//        return NO;
//    } else if (!self.isforth && self.fortdate && date<self.fortdate) {
//        return NO;
//    }
    return YES;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    if (date < calendar.today) {
        return [UIColor colorWithHexString:@"#919191"];
    }
    if (self.isforth && date == self.baceDate) {
        return [UIColor colorWithHexString:@"#FFFFFF"];
    }
    if (!self.isforth && date == self.fortdate) {
        return [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return [UIColor colorWithHexString:@"#434343"];;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date {
    return [UIColor clearColor];
}

// 点击时填充的颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date {
    return [UIColor colorWithHexString:@"#6DCB99"];
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date {
    if (self.isforth) {
        if (date == self.baceDate) {
            return [UIColor colorWithHexString:@"#6DCB99"];
        }
    } else {
        if (date == self.fortdate) {
            return [UIColor colorWithHexString:@"#6DCB99"];
        }
    }
    return nil;
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date {
    if ([self.calendar isDateInToday:date] && ![self.calendar isDateInToday:self.baceDate] && ![self.calendar isDateInToday:self.fortdate]) {
        return @"今";
    } else {
        if (self.baceDate == date && [self.calendar isDateInToday:date]) {
            return @"返";
        }
        if (self.fortdate == date && [self.calendar isDateInToday:date]) {
            return @"去";
        }
    }
    if (self.baceDate == date) {
        return @"返";
    }
    if (self.fortdate == date) {
        return @"去";
    }
    return nil;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date {
    if (_isforth) {
        if (date == self.baceDate) {
            return [UIColor colorWithHexString:@"#FFFFFF"];
        }
    } else {
        if (date == self.fortdate) {
            return [UIColor colorWithHexString:@"#FFFFFF"];
        }
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
