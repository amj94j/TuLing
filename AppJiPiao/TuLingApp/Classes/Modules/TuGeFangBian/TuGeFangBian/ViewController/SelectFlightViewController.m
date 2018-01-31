//
//  SelectFlightViewController.m
//  TuLingApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "SelectFlightViewController.h"
#import "OneWayCalendarChooseVC.h"
#import "SelectFlightModel.h"
#import "SelectFlightCell.h"
#import "SelectFlightConditionView.h"
#import "TicketOrderViewController.h"
#import "SelectReturnCell.h"
#import "TicketOrderModel.h"
#import "WKWebViewController.h"
#import "TicketSpaceModel.h"
#import "ShowFlightInforView.h"
#import "TicketEndorseFlightInfo.h"

@interface SelectFlightViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UIView *_topView;
    UIView *_bottomView;
    
    UIButton *_yesterdayBtn;
    UIButton *_todayBtn;
    UIButton *_tomorrowBtn;
    UILabel *_yesterdayWeekLabel;
    UILabel *_todayWeekLabel;
    UILabel *_tomorrowWeekLabel;
    UILabel *_todayDateLabel; // 今天日期
    
    UIButton *_priceBtn; // 价格
    UIButton *_departureTimeBtn; // 起飞时间
    
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SelectFlightViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 单程1 往返2
    if (self.tickeModel.orderType == 1) {
//        _bottomView.hidden = YES;
        _topView.hidden = NO;
        _tableView.frame = CGRectMake(0, _topView.bottom, ScreenWidth, ScreenHeight-64-_topView.height);
    } else if (self.tickeModel.orderType == 2) {
//        _bottomView.hidden = NO;
        _topView.hidden = YES;
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.selecFlightType == SelectFlightEndorse || self.selecFlightType == SelectFlightTicketEndorse) {
        if (self.endorseInfo.backState == 0) {
            [self addCustomTitleWithTitle:@"可改签去程航班"];
        } else if (self.endorseInfo.backState == 1) {
            [self addCustomTitleWithTitle:@"可改签返程航班"];
        } else {
            if (self.endorseInfo.backState == 2 && self.tickeModel.isGo) {
                [self addCustomTitleWithTitle:@"可改签去程航班"];
            } else if (self.endorseInfo.backState == 2 && !self.tickeModel.isGo) {
                [self addCustomTitleWithTitle:@"可改签返程航班"];
            } else {
                [self addCustomTitleWithTitle:@"可改签航班"];
            }
        }
    } else {
        if (self.tickeModel.orderType == 2) {
            if (self.tickeModel.isGo) {
                [self addCustomTitleWithTitle:@"选去程航班"];
            } else {
                [self addCustomTitleWithTitle:@"选返程航班"];
            }
        } else if (self.tickeModel.orderType == 1)  {
            [self layoutNavigationItemViewGo:self.tickeModel.beginCity.name back:self.tickeModel.endCity.name];
        }
    }
    
    if (self.selecFlightType == SelectFlightTicketEndorse) {
        
    } else {
        [self layoutNavigationRightButtonItem];
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"newLowPrice" ascending:YES];
    //这个数组保存的是排序好的对象
    NSArray *tempArray = [self.dataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    self.dataArray = [tempArray copy];
    [self layoutTopView];
    [self.view addSubview:self.tableView];
    [self layoutBottomView];
    
}

- (void)layoutNavigationRightButtonItem {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, PXChange(24), PXChange(34))];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"selectflight_screening"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"selectflight_screening"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.selected = NO;
    [rightBtn setShowsTouchWhenHighlighted:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)layoutTopView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(86))];
    _topView.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
    [self.view addSubview:_topView];
    
    UIView *todayView = [[UIView alloc] initWithFrame:CGRectMake(PXChange(192), PXChange(4), PXChange(230), PXChange(82))];
    todayView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:todayView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(PXChange(4),PXChange(4))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = todayView.bounds;
    maskLayer.path = maskPath.CGPath;
    todayView.layer.mask = maskLayer;
    [_topView addSubview:todayView];
    
    // 昨天
    _yesterdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _yesterdayBtn.frame = CGRectMake(0, 0, PXChange(192), _topView.height);
    [_yesterdayBtn addTarget:self action:@selector(yesterdayClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self isToday:[Untils dateFormString:self.tickeModel.beginTime]]) {
        _yesterdayBtn.backgroundColor = [UIColor lightGrayColor];
    } else {
        _yesterdayBtn.backgroundColor = [UIColor clearColor];
    }
    [_topView addSubview:_yesterdayBtn];
    
    UILabel *yesterdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PXChange(192), _topView.height/2)];
    yesterdayLabel.text = @"前一天";
    yesterdayLabel.font = [UIFont systemFontOfSize:PXChange(20)];
    yesterdayLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    yesterdayLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:yesterdayLabel];
    
    _yesterdayWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _topView.height/2, PXChange(192), _topView.height/2)];
    _yesterdayWeekLabel.text = [Untils weekdayStringFromDate:[SelectFlightModel GetYesterdayDay:[Untils dateFormString:self.tickeModel.beginTime]]];
    _yesterdayWeekLabel.font = [UIFont systemFontOfSize:PXChange(24)];
    _yesterdayWeekLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    _yesterdayWeekLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_yesterdayWeekLabel];
    
    // 今天
    _todayDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(PXChange(192), 0, PXChange(230), _topView.height/2)];
    if ([self isToday:[Untils dateFormString:self.tickeModel.beginTime]]) {
        _todayDateLabel.text = @"当天";
    } else {
        _todayDateLabel.text = [SelectFlightModel calendarMMDDString:[Untils dateFormString:self.tickeModel.beginTime]];
    }
    
    _todayDateLabel.font = [UIFont systemFontOfSize:PXChange(20)];
    _todayDateLabel.textColor = [UIColor colorWithHexString:@"#6A6A6A"];
    _todayDateLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_todayDateLabel];
    
    _todayWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(_todayDateLabel.left, _topView.height/2, PXChange(230), _topView.height/2)];
    _todayWeekLabel.text = [Untils weekdayStringFromDate:[Untils dateFormString:self.tickeModel.beginTime]];
    _todayWeekLabel.font = [UIFont systemFontOfSize:PXChange(30)];
    _todayWeekLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    _todayWeekLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_todayWeekLabel];
    
    _todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _todayBtn.frame = CGRectMake(_yesterdayBtn.right, 0, PXChange(230), _topView.height);
    [_todayBtn addTarget:self action:@selector(todayClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_todayBtn];
    
    // 明天
    UILabel *tomorrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(PXChange(192+230), 0, PXChange(192), _topView.height/2)];
    tomorrowLabel.text = @"后一天";
    tomorrowLabel.font = [UIFont systemFontOfSize:PXChange(20)];
    tomorrowLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    tomorrowLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:tomorrowLabel];
    
    _tomorrowWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(tomorrowLabel.left, _topView.height/2, PXChange(192), _topView.height/2)];
    _tomorrowWeekLabel.text = [Untils weekdayStringFromDate:[SelectFlightModel GetTomorrowDay:[Untils dateFormString:self.tickeModel.beginTime]]];
    _tomorrowWeekLabel.font = [UIFont systemFontOfSize:PXChange(24)];
    _tomorrowWeekLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    _tomorrowWeekLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_tomorrowWeekLabel];
    
    _tomorrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tomorrowBtn.frame = CGRectMake(_todayBtn.right, 0, PXChange(192), _topView.height);
    [_tomorrowBtn addTarget:self action:@selector(tomorrowClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_tomorrowBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-PXChange(127), PXChange(13),PXChange(1), PXChange(60))];
    line.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_topView addSubview:line];
    
    UIButton *calendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    calendarBtn.frame = CGRectMake(ScreenWidth-PXChange(120), 0, PXChange(120), _topView.height);
    [calendarBtn setImage:[UIImage imageNamed:@"selectflight_calender"] forState:UIControlStateNormal];
    [calendarBtn setTitle:@"日历" forState:UIControlStateNormal];
    [calendarBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    calendarBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    CGSize imageSize = calendarBtn.imageView.frame.size;
    CGSize titleSize = calendarBtn.titleLabel.frame.size;
    CGFloat spacing = 5;
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    calendarBtn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    calendarBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
    [calendarBtn addTarget:self action:@selector(calendarClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:calendarBtn];
    
}

- (void)layoutBottomView {
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
    _bottomView.alpha = 0.8;
    [self.view addSubview:_bottomView];
    WS(ws)
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, PXChange(98)));
    }];
    
    _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _priceBtn.frame = CGRectMake(0, 0, ScreenWidth/2-1, PXChange(98));
    [_priceBtn setTitle:@"价格" forState:UIControlStateNormal];
    [_priceBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
    _priceBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(30)];
    [_priceBtn addTarget:self action:@selector(priceClick:) forControlEvents:UIControlEventTouchUpInside];
    [_priceBtn setImage:[UIImage imageNamed:@"selectflight_on"] forState:UIControlStateNormal]; // 默认低到高
    [_priceBtn setImage:[UIImage imageNamed:@"selectflight_under"] forState:UIControlStateSelected]; // 点击之后高到低
    [_priceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_priceBtn.imageView.bounds.size.width, 0, _priceBtn.imageView.bounds.size.width)];
    [_priceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _priceBtn.titleLabel.bounds.size.width+5, 0, -_priceBtn.titleLabel.bounds.size.width-5)];
    [_bottomView addSubview:_priceBtn];
//    [_priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_bottomView);
//        make.left.equalTo(_bottomView);
//        make.size.mas_equalTo(CGSizeMake(ScreenWidth/2-1, PXChange(98)));
//    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#6dc899"];
    [_bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomView);
        make.centerY.equalTo(_bottomView);
        make.size.mas_equalTo(CGSizeMake(PXChange(1), PXChange(60)));
    }];
    
    _departureTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_departureTimeBtn setTitle:@"起飞时间" forState:UIControlStateNormal];
    [_departureTimeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
    _departureTimeBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(30)];
    [_departureTimeBtn addTarget:self action:@selector(departureTimeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_departureTimeBtn];
    [_departureTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView);
        make.right.equalTo(_bottomView);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/2-1, PXChange(98)));
    }];
}

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topView.bottom, ScreenWidth, ScreenHeight-64-_topView.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"SelectFlightCell" bundle:nil] forCellReuseIdentifier:@"SelectFlightCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SelectReturnCell" bundle:nil] forCellReuseIdentifier:@"SelectReturnCell"];
    }
    return _tableView;
}

- (void)setDataArray:(NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray new];
    }
    if (![_dataArray isEqualToArray:dataArray] || _dataArray != dataArray) {
        _dataArray = [dataArray copy];
    }
}

- (void)setGoDataDic:(NSDictionary *)goDataDic {
    if (!_goDataDic) {
        _goDataDic = [NSDictionary new];
    }
    if (![_goDataDic isEqualToDictionary:goDataDic] || _goDataDic != goDataDic) {
        _goDataDic = [goDataDic copy];
    }
}

- (void)settickeModel:(TLTicketModel *)tickeModel {
    if (!_tickeModel) {
        _tickeModel = [TLTicketModel new];
    }
    if (![_tickeModel isEqual:tickeModel] || _tickeModel != tickeModel) {
        _tickeModel = tickeModel;
    }
}

- (void)setselectFlightConditionModel:(SelectFlightConditionModel *)selectFlightConditionModel {
    if (!_selectFlightConditionModel) {
        _selectFlightConditionModel = [SelectFlightConditionModel new];
    }
    if (![_selectFlightConditionModel isEqual:selectFlightConditionModel] || _selectFlightConditionModel != selectFlightConditionModel) {
        _selectFlightConditionModel = selectFlightConditionModel;
    }
}


- (void)setGoSearchFlightsInfo:(SearchFlightsModel *)goSearchFlightsInfo {
    if (!_goSearchFlightsInfo) {
        _goSearchFlightsInfo = [SearchFlightsModel new];
    }
    if (![_goSearchFlightsInfo isEqual:goSearchFlightsInfo] || _goSearchFlightsInfo != goSearchFlightsInfo) {
        _goSearchFlightsInfo = goSearchFlightsInfo;
    }
}

#pragma mark - Click
// 右上角按钮点击事件
- (void)rightItemClick:(UIButton *)btn {
    if (!self.selectFlightConditionModel) {
        self.selectFlightConditionModel = [SelectFlightConditionModel new];
    }
    WS(ws)
    if (btn.selected) {
        btn.selected = NO;
        NSArray *arr = self.view.subviews;
        BOOL isHaveView = NO;
        for (SelectFlightConditionView *view in arr) {
            if ([view isKindOfClass:[SelectFlightConditionView class]]) {
                isHaveView = YES;
                [view removeFromSuperview];
            }
        }
        if (!isHaveView) {
            self.selectFlightConditionModel.count = self.dataArray.count;
            SelectFlightConditionView *view = [[SelectFlightConditionView alloc] initWithFrame:self.view.bounds tickeModel:self.tickeModel selectFlightConditionModel:self.selectFlightConditionModel];
            view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
            view.VC = self;
            view.selectFlightConditionBlock = ^(TLTicketModel *model, SelectFlightConditionModel *selectFlightConditionModel) {
                ws.tickeModel = model;
                ws.selectFlightConditionModel = selectFlightConditionModel;
                [ws requestDataAndRefresh];
            };
            [self.view bringSubviewToFront:view];
            [self.view addSubview:view];
            btn.selected = YES;
        }
    } else {
        self.selectFlightConditionModel.count = self.dataArray.count;
       SelectFlightConditionView *view = [[SelectFlightConditionView alloc] initWithFrame:self.view.bounds tickeModel:self.tickeModel selectFlightConditionModel:self.selectFlightConditionModel];
        view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
        view.VC = self;
        view.selectFlightConditionBlock = ^(TLTicketModel *model, SelectFlightConditionModel *selectFlightConditionModel) {
            ws.tickeModel = model;
            ws.selectFlightConditionModel = selectFlightConditionModel;
            [ws requestDataAndRefresh];
        };
        [self.view bringSubviewToFront:view];
        [self.view addSubview:view];
        btn.selected = YES;
    }
}

// 昨天
- (void)yesterdayClick:(UIButton *)sender {
    
    if ([self isToday:[Untils dateFormString:self.tickeModel.beginTime]]) {
        [self showProgress:@"航班日期不可以小于当前日期"];
        return;
    }
    
    NSDate *newDate = [SelectFlightModel GetYesterdayDay:[Untils dateFormString:self.tickeModel.beginTime]];
    NSDate *newyDate = [SelectFlightModel GetYesterdayDay:newDate];
    NSDate *newtDate = [SelectFlightModel GetTomorrowDay:newDate];
    if ([self isToday:newDate]) {
        _yesterdayBtn.backgroundColor = [UIColor lightGrayColor];
    } else {
        _yesterdayBtn.backgroundColor = [UIColor clearColor];
    }
    if ([self isToday:newDate]) {
        _todayDateLabel.text = @"当天";
    } else {
        _todayDateLabel.text = [NSString stringWithFormat:@"%@", [SelectFlightModel calendarMMDDString:newDate]];
    }
    _todayWeekLabel.text = [NSString stringWithFormat:@"%@", [Untils weekdayStringFromDate:newDate]];
    _yesterdayWeekLabel.text = [NSString stringWithFormat:@"%@", [Untils weekdayStringFromDate:newyDate]];
    _tomorrowWeekLabel.text = [NSString stringWithFormat:@"%@", [Untils weekdayStringFromDate:newtDate]];
    
    self.tickeModel.beginTime = [Untils getFormatDateByDate:newDate];
    [self requestDataAtDate];
}

// 今天
- (void)todayClick:(UIButton *)sender {
    
}

// 明天
- (void)tomorrowClick:(UIButton *)sender {
    
    NSDate *newDate = [SelectFlightModel GetTomorrowDay:[Untils dateFormString:self.tickeModel.beginTime]];
    NSDate *newyDate = [SelectFlightModel GetYesterdayDay:newDate];
    NSDate *newtDate = [SelectFlightModel GetTomorrowDay:newDate];
    
    if ([self isToday:newDate]) {
        _yesterdayBtn.backgroundColor = [UIColor lightGrayColor];
    } else {
        _yesterdayBtn.backgroundColor = [UIColor clearColor];
    }
    
    if ([self isToday:newDate]) {
        _todayDateLabel.text = @"当天";
    } else {
        _todayDateLabel.text = [NSString stringWithFormat:@"%@", [SelectFlightModel calendarMMDDString:newDate]];
    }
    _todayWeekLabel.text = [NSString stringWithFormat:@"%@", [Untils weekdayStringFromDate:newDate]];
    _yesterdayWeekLabel.text = [NSString stringWithFormat:@"%@", [Untils weekdayStringFromDate:newyDate]];
    _tomorrowWeekLabel.text = [NSString stringWithFormat:@"%@", [Untils weekdayStringFromDate:newtDate]];
    
    self.tickeModel.beginTime = [Untils getFormatDateByDate:newDate];
    [self requestDataAtDate];
}

// 点击日历
- (void)calendarClick:(UIButton *)sender {
    OneWayCalendarChooseVC *oneWayCalendervc = [OneWayCalendarChooseVC new];
    oneWayCalendervc.selectDate = self.tickeModel.beginTime;
    oneWayCalendervc.block = ^(NSDate *timer){
        if (timer) {
            if (timer) {
                _todayDateLabel.text = [NSString stringWithFormat:@"%@", [SelectFlightModel calendarMMDDString:timer]];
                if ([self isToday:timer]) {
                    _todayDateLabel.text = @"当天";
                } else {
                    _todayDateLabel.text = [NSString stringWithFormat:@"%@", [SelectFlightModel calendarMMDDString:timer]];
                }
                _todayWeekLabel.text = [NSString stringWithFormat:@"%@", [Untils weekdayStringFromDate:timer]];
                _yesterdayWeekLabel.text = [NSString stringWithFormat:@"%@", [Untils weekdayStringFromDate:[SelectFlightModel GetYesterdayDay:timer]]];
                _tomorrowWeekLabel.text = [NSString stringWithFormat:@"%@", [Untils weekdayStringFromDate:[SelectFlightModel GetTomorrowDay:timer]]];
                self.tickeModel.beginTime = [Untils getFormatDateByDate:timer];
                [self requestDataAtDate];
            }
        }
    };
    
    [self.navigationController pushViewController:oneWayCalendervc animated:YES];
}

// 点击价格
- (void)priceClick:(UIButton *)sender {
    [_priceBtn setImage:[UIImage imageNamed:@"selectflight_under"] forState:UIControlStateNormal]; // 默认低到高
    [_priceBtn setImage:[UIImage imageNamed:@"selectflight_on"] forState:UIControlStateSelected]; // 点击之后高到低
    [_priceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_priceBtn.imageView.bounds.size.width, 0, _priceBtn.imageView.bounds.size.width)];
    [_priceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _priceBtn.titleLabel.bounds.size.width+5, 0, -_priceBtn.titleLabel.bounds.size.width-5)];
    [_departureTimeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_departureTimeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"newLowPrice" ascending:YES];
    //这个数组保存的是排序好的对象
    NSArray *tempArray = [self.dataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    if (sender.selected) {
        sender.selected = NO;
//        self.tickeModel.ticketSort = @"1";
        // 降序
        NSEnumerator *enumerator = [tempArray reverseObjectEnumerator];
        self.dataArray = [[NSMutableArray alloc]initWithArray: [enumerator allObjects]];
        [self.tableView reloadData];
        
    } else {
        sender.selected = YES;
//        self.tickeModel.ticketSort = @"0";
        // 升序
        self.dataArray = [tempArray mutableCopy];
        [self.tableView reloadData];
    }
//    [self requestDataAndRefresh];
}

// 点击起飞时间
- (void)departureTimeClick:(UIButton *)sender {
    [_departureTimeBtn setImage:[UIImage imageNamed:@"selectflight_under"] forState:UIControlStateNormal];
    [_departureTimeBtn setImage:[UIImage imageNamed:@"selectflight_on"] forState:UIControlStateSelected];
    [_priceBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_priceBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [_departureTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_departureTimeBtn.imageView.bounds.size.width, 0, _departureTimeBtn.imageView.bounds.size.width)];
    [_departureTimeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _departureTimeBtn.titleLabel.bounds.size.width+5, 0, -_departureTimeBtn.titleLabel.bounds.size.width-5)];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"bTime" ascending:YES];
    //这个数组保存的是排序好的对象
    NSArray *tempArray = [self.dataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    if (sender.selected) {
        sender.selected = NO;
//        self.tickeModel.ticketSort = @"3";
        
        NSEnumerator *enumerator = [tempArray reverseObjectEnumerator];
        self.dataArray = [[NSMutableArray alloc]initWithArray: [enumerator allObjects]];
        [self.tableView reloadData];
    } else {
        sender.selected = YES;
//        self.tickeModel.ticketSort = @"2";
        
        self.dataArray = [tempArray mutableCopy];
        [self.tableView reloadData];
    }
//    [self requestDataAndRefresh];
}

#pragma mark - TableViewDelegate & TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tickeModel.orderType == 2 && !self.tickeModel.isGo) {
        return self.dataArray.count+1;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SearchFlightsModel *model = [SearchFlightsModel new];
    if (self.tickeModel.orderType == 2 && !self.tickeModel.isGo) {
        if (indexPath.row == 0) {
            return 45;
        } else {
            model = self.dataArray[indexPath.row-1];
        }
    } else {
        model = self.dataArray[indexPath.row];
    }
    if (model.realCompany.length>0) {
        return 130;
    }
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return PXChange(98);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(98))];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (self.tickeModel.orderType == 2 && !self.tickeModel.isGo && indexPath.row == 0) {
        cell = (SelectReturnCell *)[tableView dequeueReusableCellWithIdentifier:@"SelectReturnCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [(SelectReturnCell *)cell refreshData:self.goSearchFlightsInfo];
    } else {
        cell = (SelectFlightCell *)[tableView dequeueReusableCellWithIdentifier:@"SelectFlightCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SearchFlightsModel *model = [SearchFlightsModel new];
        if (self.tickeModel.orderType == 2 && !self.tickeModel.isGo) {
            model = self.dataArray[indexPath.row-1];
        } else {
            model = self.dataArray[indexPath.row];
        }
        [(SelectFlightCell *)cell assignmentUISearchFlihtsModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __block TicketOrderViewController *vc = [TicketOrderViewController new];
    vc.tickeModel = self.tickeModel;
    SearchFlightsModel *model = [SearchFlightsModel new];
    if (self.tickeModel.orderType == 2 && !self.tickeModel.isGo) {
        if (indexPath.row == 0) {
            ShowFlightInforView * flightInfoView = [[ShowFlightInforView alloc]initFlightInfoWithModel:self.goSearchFlightsInfo];
            [AppDelegateWindow addSubview:flightInfoView];
            return;
        } else {
            model = self.dataArray[indexPath.row-1];
        }
        vc.goSearchFlightsInfo = self.goSearchFlightsInfo;
        vc.goDataDic = self.goDataDic;
    } else {
        model = self.dataArray[indexPath.row];
    }
    vc.searchFlightsInfo = model;
    
    NSString *bTime = @"";
    if (self.selecFlightType == SelectFlightEndorse) {
        if ([self.endorseModel.orderType isEqualToString:@"2"] && (([self.endorseModel.backState isEqualToString:@"2"] && !self.tickeModel.isGo))) {
            bTime = self.tickeModel.backBeginTime;
        } else {
            bTime = model.beginTimeOrigin;
        }
    } else if (self.selecFlightType == SelectFlightTicketEndorse) {
        if (self.endorseInfo.orderType == 2 && (self.endorseInfo.backState == 2 && !self.tickeModel.isGo)) {
            bTime = self.tickeModel.backBeginTime;
        } else {
            bTime = model.beginTimeOrigin;
        }
    } else {
        bTime = model.beginTimeOrigin;
    }
    
    if (self.selecFlightType == SelectFlightTicketEndorse) {
        WS(ws)
//        [HzTools showLoadingViewWithString:@""];
//        [TicketSpaceModel asyncPostQueryChangeFlightDeatilWithTicketModel:self.tickeModel FlightsModel:model oldSeatcode:[self.endorseInfo.selectPersons firstObject][@"cabinCode"] oldDiscount:[self.endorseInfo.selectPersons firstObject][@"discount"] SuccessBlock:^(NSArray *dataArray) {
//            [HzTools hiddenLoadingView];
            if (ws.selecFlightType == SelectFlightTicketEndorse) {
                vc.endorseInfo = ws.endorseInfo;
                vc.ticketOrderType = TicketOrderTicketEndorse;
            }
//            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"saleprice" ascending:YES];
            //这个数组保存的是排序好的对象
//            NSArray *tempArray = [dataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
//            vc.dataArr = [tempArray copy];
        vc.dataArr = [vc.searchFlightsInfo.cabinListArr copy];
            [ws.navigationController pushViewController:vc animated:YES];
//        } errorBlock:^(NSError *errorResult) {
//
//        }];
    } else {
        WS(ws)
        [TicketSpaceModel asyncQueryFlightSpaceInfoWithTicketModel:self.tickeModel flightno:model.flightNumber beginTime:bTime SuccessBlock:^(NSArray *dataArray) {
            if (ws.selecFlightType == SelectFlightEndorse) {
                vc.endorseModel = ws.endorseModel;
                vc.ticketOrderType = TicketOrderEndorse;
            } else if (ws.selecFlightType == SelectFlightTicketEndorse) {
                vc.endorseInfo = ws.endorseInfo;
                vc.ticketOrderType = TicketOrderTicketEndorse;
            }
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"saleprice" ascending:YES];
            //这个数组保存的是排序好的对象
            NSArray *tempArray = [dataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            vc.dataArr = [tempArray copy];
            [ws.navigationController pushViewController:vc animated:YES];
        } errorBlock:^(NSError *errorResult) {
        }];
    }
    
}

- (void)requestDataAndRefresh {
    [SearchFlightsModel asyncPostQueryFlightDeatilTicketModel:self.tickeModel SuccessBlock:^(NSArray *dataArray) {
        self.dataArray = [dataArray copy];
        [self.tableView reloadData];
    } errorBlock:^(NSError *errorResult) {
    }];
}

- (void)requestDataAtDate {
    if (self.selecFlightType == SelectFlightTicketEndorse) {
        NSString *isOrderType = [NSString stringWithFormat:@"%ld",self.endorseInfo.backState];
        if (self.endorseInfo.backState == 3) {
            isOrderType = @"0";
        } else if (self.endorseInfo.backState == 2) {
            if (self.tickeModel.isGo) {
                isOrderType = @"0";
            } else {
                isOrderType = @"1";
            }
        }
        [TicketEndorseFlightInfo asyncPostNewEndorseModel:self.tickeModel dataDic:self.endorseInfo backState:[NSString stringWithFormat:@"%ld",self.endorseInfo.backState] isOrderType:isOrderType SuccessBlock:^(NSArray *dataArray) {
            self.dataArray = [dataArray copy];
            [self.tableView reloadData];
        } errorBlock:^(NSError *errorResult) {
        }];
    } else {
        [SearchFlightsModel asyncPostTicketInfoListTicketModel:self.tickeModel SuccessBlock:^(NSArray *dataArray) {
            self.dataArray = [dataArray copy];
            [self.tableView reloadData];
        } errorBlock:^(NSError *errorResult) {
        }];
    }
}


- (void)onBackBarBtnClick {
    if (self.tickeModel.isGo == NO) {
        self.tickeModel.isGo = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    } else {
        if (self.tickeModel.isGo == NO) {
            self.tickeModel.isGo = YES;
        }
        return YES;
    }
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
