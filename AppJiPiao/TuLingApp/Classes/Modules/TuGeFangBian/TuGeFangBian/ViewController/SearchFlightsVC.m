//
//  SearchFlightsVC.m
//  TuLingApp
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "SearchFlightsVC.h"
#import "Untils.h"
#import "JYCarousel.h"
#import "ChooseTankTypeViewController.h"
#import "JZZManager.h"
#import "CityListViewController.h"
#import "OneWayCalendarChooseVC.h"
#import "BackForthCalendarChooseVC.h"
#import "TLTicketModel.h"
#import "WKWebViewController.h"
#import "SelectFlightViewController.h"
#import "ZJSearchHistoryBtn.h"


@interface SearchFlightsVC ()
{
    UIButton *_oneWayBtn;
    UIView *_oneWayLine;
    UIButton *_backForthBtn;
    UIView *_backForthLine;
    UIButton *_addressBtn; // 当前地址
    UIButton *_destinationBtn; // 目的地
    UIButton *_timeBtn; // 选择时间 (默认当前时间)
    UIButton *_backForthInfoBtn;
    UIButton *_tankTypeBtn; // 舱型
    BOOL _isBackForth; // 是否为往返
    UIScrollView *_searchHistoryScrollView;
    UIButton *_clearHistoryButton;
}

// banner相关
@property (nonatomic, strong) NSMutableArray *bannerImageArray; // banner图片数组
@property (nonatomic, strong) JYCarousel *banner;
@property (nonatomic, strong) NSMutableArray *bannerListArray; // banner数组
@property (nonatomic, copy) NSArray *searchHistoryArray; // 搜索历史的数组(展示用)
@property (nonatomic, strong) TLTicketModel *ticketInfo;
@property (nonatomic, strong) CityModel *positioningCity;
@end

@implementation SearchFlightsVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 进入页面刷新搜索历史记录
    [self addSearchHistory];
    
    if (!(self.positioningCity.name.length>0)) {
        [self positioning];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isBackForth = NO;
    [self positioning];
    self.ticketInfo = [TLTicketModel new];
    [self addCustomTitleWithTitle:@"机票"];
    [self loadMainUI];
}

- (void)positioning {
    // 定位
    JZZManager *man = [JZZManager sharedManager];
    [man findCurrentLocation];
    
    if (man.currentCity.length>0) {
        NSString *cityName = [man.currentCity substringToIndex:[man.currentCity length]-1];
        [CityModel asyncPostQueryCityCodeByCityName:cityName SuccessBlock:^(CityModel *cityModel) {
            self.positioningCity = cityModel;
            if (self.ticketInfo.beginCity.name.length>0) {
            } else {
                self.ticketInfo.beginCity = cityModel;
                [_addressBtn setTitle:[NSString stringWithFormat:@"%@",cityName] forState:UIControlStateNormal];
                [_addressBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
                _addressBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
            }
        } errorBlock:^(NSError *errorResult) {
        }];
    }
    
}

- (void)loadMainUI {
    // banner
    [self loadTopBanner];
    
    [self loadMiddleView];
    
    [self loadBottomView];
    
    // 有搜索记录的时候 默认显示最新的一条记录
    if (self.searchHistoryArray.count>0) {
        for (ZJSearchHistoryBtn *searchHistoryBtn in [_searchHistoryScrollView subviews]) {
            if ([searchHistoryBtn isKindOfClass:[ZJSearchHistoryBtn class]]) {
                for (UIButton *btn in [searchHistoryBtn subviews]) {
                    if ([btn isKindOfClass:[UIButton class]]) {
                        if (btn.tag == 1233) {
                            [self searchHistoryClick:btn];
                        }
                    }
                }
            }
        }
    }
}

- (void)loadTopBanner {
    [self.view addSubview:self.banner];
    self.bannerImageArray = [[NSMutableArray alloc] initWithArray: @[@"banner",@"banner",@"banner"]];
    [self.banner startCarouselWithArray:self.bannerImageArray];
}

- (void)loadMiddleView {
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, PXChange(300), ScreenWidth, PXChange(366))];
    middleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middleView];
    
    _oneWayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _oneWayBtn.frame = CGRectMake(0, 0, (ScreenWidth-PXChange(2))/2, PXChange(115));
    [_oneWayBtn setTitle:[NSString stringWithFormat:@"单程"] forState:UIControlStateNormal];
    [_oneWayBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    [_oneWayBtn setTitleColor:[UIColor colorWithHexString:@"#008C4E"] forState:UIControlStateSelected];
    [_oneWayBtn addTarget:self action:@selector(takeNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_oneWayBtn setSelected:YES];
    _oneWayBtn.userInteractionEnabled = NO;
    _oneWayBtn.tag = 1000;
    [middleView addSubview:_oneWayBtn];
    self.ticketInfo.orderType = 1;
    
    _oneWayLine = [[UIView alloc] initWithFrame:CGRectMake(_oneWayBtn.left, _oneWayBtn.bottom, _oneWayBtn.width, PXChange(5))];
    _oneWayLine.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
    [middleView addSubview:_oneWayLine];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kColor_Line;
    [middleView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_oneWayBtn);
        make.centerX.equalTo(middleView);
        make.size.mas_equalTo(CGSizeMake(PXChange(2), PXChange(80)));
    }];
    
    // 往返
    _backForthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backForthBtn.frame = CGRectMake(ScreenWidth/2+PXChange(1), 0, (ScreenWidth-PXChange(2))/2, PXChange(115));
    [_backForthBtn setTitle:[NSString stringWithFormat:@"往返"] forState:UIControlStateNormal];
    [_backForthBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    [_backForthBtn setTitleColor:[UIColor colorWithHexString:@"#008C4E"] forState:UIControlStateSelected];
    [_backForthBtn addTarget:self action:@selector(takeNumber:) forControlEvents:UIControlEventTouchUpInside];
    _backForthBtn.tag = 2000;
    [middleView addSubview:_backForthBtn];
    
    _backForthLine = [[UIView alloc] initWithFrame:CGRectMake(_backForthBtn.left, _backForthBtn.bottom, _backForthBtn.width, PXChange(5))];
    _backForthLine.backgroundColor = [UIColor clearColor];
    [middleView addSubview:_backForthLine];
    
    // 当前地址
    _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressBtn.frame = CGRectMake(PXChange(30), PXChange(160), (ScreenWidth-PXChange(150))/2, PXChange(80));
    CityModel *model = self.ticketInfo.beginCity;
    if (model) {
        [_addressBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
        _addressBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
        [_addressBtn setTitle:[NSString stringWithFormat:@"%@", model.name] forState:UIControlStateNormal];
    } else {
        [_addressBtn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
        _addressBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(26)];
        [_addressBtn setTitle:[NSString stringWithFormat:@"请选择出发地"] forState:UIControlStateNormal];
    }
    
    [_addressBtn addTarget:self action:@selector(addressClick:) forControlEvents:UIControlEventTouchUpInside];
    _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [middleView addSubview:_addressBtn];
    
    UIView *addressLine = [[UIView alloc] initWithFrame:CGRectMake(_addressBtn.left, PXChange(242), _addressBtn.width, PXChange(2))];
    addressLine.backgroundColor = kColor_Line;
    [middleView addSubview:addressLine];
    
    // 目的地
    _destinationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _destinationBtn.frame = CGRectMake(_addressBtn.width+PXChange(120), _addressBtn.top, (ScreenWidth-PXChange(150))/2, PXChange(80));
    [_destinationBtn setTitle:[NSString stringWithFormat:@"请选择目的地"] forState:UIControlStateNormal];
    [_destinationBtn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    _destinationBtn.titleLabel.font = [UIFont fontWithName:kFont_PingFangSC size:PXChange(26)];
    [_destinationBtn addTarget:self action:@selector(destinationClick:) forControlEvents:UIControlEventTouchUpInside];
    _destinationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [middleView addSubview:_destinationBtn];
    
    UIView *destinationLine = [[UIView alloc] initWithFrame:CGRectMake(_destinationBtn.left, PXChange(242), _destinationBtn.width, PXChange(2))];
    destinationLine.backgroundColor = kColor_Line;
    [middleView addSubview:destinationLine];
    
    // 中间图片
    UIButton *huanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [huanBtn setImage:[UIImage imageNamed:@"ticket_huan"] forState:UIControlStateNormal];
    [huanBtn addTarget:self action:@selector(huanClick:) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:huanBtn];
    
    [huanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(middleView);
        make.bottom.equalTo(destinationLine);
        make.size.mas_equalTo(CGSizeMake(PXChange(60), PXChange(60)));
    }];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, PXChange(122), ScreenWidth, PXChange(2))];
    bottomLine.backgroundColor = kColor_Line;
    [middleView addSubview:bottomLine];
    
    bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, middleView.height-PXChange(2), ScreenWidth, PXChange(2))];
    bottomLine.backgroundColor = kColor_Line;
    [middleView addSubview:bottomLine];
    // 当前时间
    _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeBtn.frame = CGRectMake(PXChange(30), PXChange(280), (ScreenWidth-PXChange(150))/2, PXChange(80));
    [_timeBtn setTitle:[NSString stringWithFormat:@"%@", [Untils daraWeekdatStringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    self.ticketInfo.beginTime = [Untils getFormatDateByDate:[NSDate date]];
    [_timeBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
    _timeBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
    [_timeBtn addTarget:self action:@selector(timeClick:) forControlEvents:UIControlEventTouchUpInside];
    _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self buttonAttributed:_timeBtn titleStr:[NSString stringWithFormat:@"%@", [Untils daraWeekdatStringFromDate:[NSDate date]]]];
    [middleView addSubview:_timeBtn];
    
    // 返程信息
    _backForthInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backForthInfoBtn.frame = CGRectMake(_timeBtn.width+PXChange(120), _timeBtn.top, (ScreenWidth-PXChange(150))/2, PXChange(80));
    [_backForthInfoBtn setTitle:[NSString stringWithFormat:@"请选择返程日期"] forState:UIControlStateNormal];
    [_backForthInfoBtn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    _backForthInfoBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(26)];
    SEL extractedExpr = @selector(backForthInfoClick:);
    [_backForthInfoBtn addTarget:self action:extractedExpr forControlEvents:UIControlEventTouchUpInside];
    _backForthInfoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _backForthInfoBtn.hidden = YES;
    [middleView addSubview:_backForthInfoBtn];
    
    // 舱型
//    _tankTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _tankTypeBtn.frame = CGRectMake(PXChange(30), PXChange(400), (ScreenWidth-PXChange(150))/2, PXChange(80));
//    [_tankTypeBtn setTitle:[NSString stringWithFormat:@"经济舱"] forState:UIControlStateNormal];
//    self.ticketInfo.positionType = @"0";
//    [_tankTypeBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
//    _tankTypeBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
//    [_tankTypeBtn addTarget:self action:@selector(tankTypeClick:) forControlEvents:UIControlEventTouchUpInside];
//    _tankTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [middleView addSubview:_tankTypeBtn];
}

- (void)loadBottomView {
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake((ScreenWidth-PXChange(690))/2, PXChange(818), PXChange(690), PXChange(86));
    searchBtn.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
    [searchBtn setTitle:[NSString stringWithFormat:@"搜索"] forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(36)];
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    searchBtn.layer.cornerRadius = 3;
    searchBtn.layer.masksToBounds = YES;
    
    _searchHistoryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(searchBtn.left, searchBtn.bottom+PXChange(20), PXChange(595), PXChange(50))];
//    _searchHistoryScrollView.pagingEnabled = YES;
    _searchHistoryScrollView.showsHorizontalScrollIndicator = NO;
    _searchHistoryScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_searchHistoryScrollView];
    
    [self addSearchHistory];
    
    _clearHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearHistoryButton.frame = CGRectMake(_searchHistoryScrollView.right+5, _searchHistoryScrollView.top, PXChange(90), _searchHistoryScrollView.height);
    [_clearHistoryButton setTitle:[NSString stringWithFormat:@"清除历史"] forState:UIControlStateNormal];
    [_clearHistoryButton setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
    _clearHistoryButton.titleLabel.font = [UIFont systemFontOfSize:PXChange(22)];
    _clearHistoryButton.hidden = YES;
    [_clearHistoryButton addTarget:self action:@selector(clearHistoryClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearHistoryButton];
}

- (void)addSearchHistory {
    self.searchHistoryArray = [self readSearchHistory];
    if (self.searchHistoryArray.count>0) {
        _clearHistoryButton.hidden = NO;
    } else {
        _clearHistoryButton.hidden = YES;
    }
    _searchHistoryScrollView.contentSize =  CGSizeMake(PXChange(300)*self.searchHistoryArray.count , PXChange(50));
    [_searchHistoryScrollView removeAllSubViews];
    CGFloat macFloat = 0;
    CGFloat tempFloat = 0;
    for (int i = 0; i<self.searchHistoryArray.count; i++) {
//        UIButton *searchHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        searchHistoryButton.frame = CGRectMake(i*PXChange(300), 0, PXChange(300), _searchHistoryScrollView.height);
        
        if (i==0) {
            tempFloat = 0;
        } else {
            tempFloat += 5;
        }
        ZJSearchHistoryBtn *searchHistoryButton = [[ZJSearchHistoryBtn alloc] initWithFrame:CGRectMake(tempFloat, 0, PXChange(300), _searchHistoryScrollView.height)];
        
        
        NSDictionary *dic = self.searchHistoryArray[i];
        TLTicketModel *ticketInfo = [TLTicketModel getUserModel:dic];
        CityModel *bModel = ticketInfo.beginCity;
        CityModel *eModel = ticketInfo.endCity;
        // 时间格式 7/10周一    weekdayStringFromDate
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd"];
        NSString *dateTime = [formatter stringFromDate:[Untils dateFormString:ticketInfo.beginTime]];
        NSString *time = [dateTime stringByAppendingString:[Untils weekdayStringFromDate:[Untils dateFormString:ticketInfo.beginTime]]];
//        NSString *str = @"";
        if (ticketInfo.orderType == 1) {
//            str = [NSString stringWithFormat:@"%@ -> %@ (%@)",bModel.name,eModel.name,time];
            
            searchHistoryButton.beginCityLabel.text = bModel.name;
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
                 attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
            CGSize size =  [bModel.name boundingRectWithSize:CGSizeMake(MAXFLOAT,searchHistoryButton.beginCityLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
            searchHistoryButton.beginCityWidth.constant = size.width;
            
            searchHistoryButton.iconImageView.image = [UIImage imageNamed:@"arrow_come"];
            searchHistoryButton.endLabel.text = [NSString stringWithFormat:@"%@ (%@)",eModel.name,time];
            
            CGSize size1 =  [searchHistoryButton.endLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,searchHistoryButton.beginCityLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
            
            searchHistoryButton.width = size.width+12+size1.width;
        } else {
            NSString *dateTime = [formatter stringFromDate:[Untils dateFormString:ticketInfo.backBeginTime]];
            NSString *btime = [dateTime stringByAppendingString:[Untils weekdayStringFromDate:[Untils dateFormString:ticketInfo.backBeginTime]]];
//            str = [NSString stringWithFormat:@"%@ <-> %@ (%@-%@)",bModel.name,eModel.name,time,btime];
            
            searchHistoryButton.beginCityLabel.text = bModel.name;
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
            CGSize size =  [bModel.name boundingRectWithSize:CGSizeMake(MAXFLOAT,searchHistoryButton.beginCityLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
            searchHistoryButton.beginCityWidth.constant = size.width;
            
            searchHistoryButton.iconImageView.image = [UIImage imageNamed:@"arrow_come_back"];
            searchHistoryButton.endLabel.text = [NSString stringWithFormat:@"%@ (%@ - %@)",eModel.name,time,btime];
            
            
            CGSize size1 =  [searchHistoryButton.endLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,searchHistoryButton.beginCityLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
            
            searchHistoryButton.width = size.width+12+size1.width;
        }
//        [searchHistoryButton setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
//        searchHistoryButton.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
//        [searchHistoryButton setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
//        searchHistoryButton.titleLabel.font = [UIFont systemFontOfSize:PXChange(22)];
        [searchHistoryButton.clickSearchBtn addTarget:self action:@selector(searchHistoryClick:) forControlEvents:UIControlEventTouchUpInside];
        searchHistoryButton.clickSearchBtn.tag = 1233+i;
        [_searchHistoryScrollView addSubview:searchHistoryButton];
        if (i == self.searchHistoryArray.count-1) {
           macFloat = searchHistoryButton.right;
        }
        
        tempFloat =  searchHistoryButton.right;
    }
    
    _searchHistoryScrollView.contentSize =  CGSizeMake(macFloat , PXChange(50));
    
    
}

#pragma mark - Click
// 点击当前地址
- (void)addressClick:(UIButton *) sender {
    CityListViewController *cityList = [CityListViewController new];
    if (self.positioningCity.cityCode.length > 0) {
        cityList.positioningCity = self.positioningCity;
    }
    cityList.block = ^(CityModel *model){
        if (model) {
            self.ticketInfo.beginCity = model;
            [_addressBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
            _addressBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
            [_addressBtn setTitle:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
        }
    };
    [self.navigationController pushViewController:cityList animated:YES];
}

// 点击目的地
- (void)destinationClick:(UIButton *)sender {
    CityListViewController *cityList = [CityListViewController new];
    if (self.positioningCity.cityCode.length > 0) {
        cityList.positioningCity = self.positioningCity;
    }
    cityList.block = ^(CityModel *model){
        if (model) {
            self.ticketInfo.endCity = model;
            [_destinationBtn setTitle:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
            [_destinationBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
            _destinationBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
        }
    };
    [self.navigationController pushViewController:cityList animated:YES];
}

// 切换目的地和始发地
- (void)huanClick:(UIButton *)sender {
    if (self.ticketInfo.endCity && self.ticketInfo.beginCity) {
        CityModel *beginCity = self.ticketInfo.beginCity;
        CityModel *endCity = self.ticketInfo.endCity;
        
        [_destinationBtn setTitle:[NSString stringWithFormat:@"%@",beginCity.name] forState:UIControlStateNormal];
        [_addressBtn setTitle:[NSString stringWithFormat:@"%@",endCity.name] forState:UIControlStateNormal];
        self.ticketInfo.beginCity = endCity;
        self.ticketInfo.endCity = beginCity;
    }
}

// 当前时间
- (void)timeClick:(UIButton *)sender {
    if (_isBackForth) {
        BackForthCalendarChooseVC *backForthCalendervc = [BackForthCalendarChooseVC new];
        backForthCalendervc.isforth = YES;
        
        if ([self isToday:[Untils dateFormString:self.ticketInfo.beginTime]] && !self.ticketInfo.backBeginTime) {
            
        } else {
            backForthCalendervc.fortdate = [Untils dateFormString:self.ticketInfo.beginTime];
            backForthCalendervc.baceDate = [Untils dateFormString:self.ticketInfo.backBeginTime];
        }
        WS(ws)
        backForthCalendervc.block = ^(NSDate *formatTimer, NSDate *backTimer){
            [_timeBtn setTitle:[NSString stringWithFormat:@"%@", [Untils daraWeekdatStringFromDate:formatTimer]] forState:UIControlStateNormal];
            [self buttonAttributed:_timeBtn titleStr:[NSString stringWithFormat:@"%@", [Untils daraWeekdatStringFromDate:formatTimer]]];
            [_backForthInfoBtn setTitle:[NSString stringWithFormat:@"%@",[Untils daraWeekdatStringFromDate:backTimer]] forState:UIControlStateNormal];
            [_backForthInfoBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
            _backForthInfoBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
            [self buttonAttributed:_backForthInfoBtn titleStr:[NSString stringWithFormat:@"%@",[Untils daraWeekdatStringFromDate:backTimer]]];
            ws.ticketInfo.beginTime = [Untils getFormatDateByDate:formatTimer];
            ws.ticketInfo.backBeginTime = [Untils getFormatDateByDate:backTimer];;
        };
        [self.navigationController pushViewController:backForthCalendervc animated:YES];
    } else {
        OneWayCalendarChooseVC *oneWayCalendervc = [OneWayCalendarChooseVC new];
        oneWayCalendervc.selectDate = self.ticketInfo.beginTime;
        oneWayCalendervc.block = ^(NSDate *timer){
            if (timer) {
                if (timer) {
                    [_timeBtn setTitle:[NSString stringWithFormat:@"%@", [Untils daraWeekdatStringFromDate:timer]] forState:UIControlStateNormal];
                    [self buttonAttributed:_timeBtn titleStr:[NSString stringWithFormat:@"%@", [Untils daraWeekdatStringFromDate:timer]]];
                    self.ticketInfo.beginTime = [Untils getFormatDateByDate:timer];
                }
            }
        };
        
        [self.navigationController pushViewController:oneWayCalendervc animated:YES];
    }
}

// 返程信息
- (void)backForthInfoClick:(UIButton *)sender {
    BackForthCalendarChooseVC *backForthCalendervc = [BackForthCalendarChooseVC new];
    [self.navigationController pushViewController:backForthCalendervc animated:YES];
    backForthCalendervc.isforth = NO;
    if ([self isToday:[Untils dateFormString:self.ticketInfo.beginTime]] && !self.ticketInfo.backBeginTime) {
        
    } else {
        if (self.ticketInfo.backBeginTime.length>0) {
            backForthCalendervc.baceDate = [Untils dateFormString:self.ticketInfo.backBeginTime];
        }
        backForthCalendervc.fortdate = [Untils dateFormString:self.ticketInfo.beginTime];
    }
    
    WS(ws)
    backForthCalendervc.block = ^(NSDate *formatTimer, NSDate *backTimer){
        [_timeBtn setTitle:[NSString stringWithFormat:@"%@", [Untils daraWeekdatStringFromDate:formatTimer]] forState:UIControlStateNormal];
        [self buttonAttributed:_timeBtn titleStr:[NSString stringWithFormat:@"%@", [Untils daraWeekdatStringFromDate:formatTimer]]];
        [_backForthInfoBtn setTitle:[NSString stringWithFormat:@"%@",[Untils daraWeekdatStringFromDate:backTimer]] forState:UIControlStateNormal];
        [_backForthInfoBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
        _backForthInfoBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
        [self buttonAttributed:_backForthInfoBtn titleStr:[NSString stringWithFormat:@"%@",[Untils daraWeekdatStringFromDate:backTimer]]];
        ws.ticketInfo.beginTime = [Untils getFormatDateByDate:formatTimer];
        ws.ticketInfo.backBeginTime = [Untils getFormatDateByDate:backTimer];;
    };
}

// 选择舱型
- (void)tankTypeClick:(UIButton *)sender {
    ChooseTankTypeViewController *tankTypeVC = [ChooseTankTypeViewController new];
    tankTypeVC.positionType = self.ticketInfo.positionType;
    tankTypeVC.block = ^(NSString *type, NSInteger typeID){
        [sender setTitle:[NSString stringWithFormat:@"%@",type] forState:UIControlStateNormal];
        self.ticketInfo.positionType = [NSString stringWithFormat:@"%ld",typeID];
    };
    tankTypeVC.modalPresentationStyle = 4;
    [self presentViewController:tankTypeVC animated:NO completion:^{
    }];
}

- (void)takeNumber:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 1000)
    {
        _oneWayBtn.userInteractionEnabled = NO;
        _backForthBtn.userInteractionEnabled = YES;
        [_backForthBtn setSelected:NO];
        _oneWayLine.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
        _backForthLine.backgroundColor = [UIColor clearColor];
        _backForthInfoBtn.hidden = YES;
        _isBackForth = NO;
        self.ticketInfo.orderType = 1;
    }
    else if (sender.tag == 2000)
    {
        _backForthBtn.userInteractionEnabled = NO;
        _oneWayBtn.userInteractionEnabled = YES;
        [_oneWayBtn setSelected:NO];
        _backForthLine.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
        _oneWayLine.backgroundColor = [UIColor clearColor];
        _backForthInfoBtn.hidden = NO;
        _isBackForth = YES;
        self.ticketInfo.orderType = 2;
        if (self.ticketInfo.backBeginTime.length>0) {
            [_backForthInfoBtn setTitle:[Untils daraWeekdatStringFromDate:[Untils dateFormString:self.ticketInfo.backBeginTime]] forState:UIControlStateNormal];
            [_backForthInfoBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
            _backForthInfoBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
            [self buttonAttributed:_backForthInfoBtn titleStr:[Untils daraWeekdatStringFromDate:[Untils dateFormString:self.ticketInfo.backBeginTime]]];
        }
    }
}

// 搜索
- (void)searchClick:(UIButton *)sender {
    self.ticketInfo.isGo = YES;
    if (!(self.ticketInfo.beginTime.length>0)) {
        [self showProgress:@"请选择起程日期"];
        return;
    }
    if (!(self.ticketInfo.backBeginTime.length>0) && self.ticketInfo.orderType==2) {
        [self showProgress:@"请选择返程日期"];
        return;
    }
    NSDate *todayDate = [Untils dateYYMMDDFromString:[Untils calendarDateString:[NSDate date]]];
    NSDate *beginDate = [Untils dateYYMMDDFromString:[Untils calendarDateString:[Untils dateFormString:self.ticketInfo.beginTime]]];
    NSDate *backBeginDate = [Untils dateYYMMDDFromString:[Untils calendarDateString:[Untils dateFormString:self.ticketInfo.backBeginTime]]];
    if (beginDate<todayDate) {
        [self showProgress:@"请选择正确的启程日期"];
        return;
    }
    if ((beginDate>backBeginDate || backBeginDate<todayDate) && self.ticketInfo.orderType==2) {
        [self showProgress:@"请选择正确的返程日期"];
        return;
    }
    if (!(self.ticketInfo.beginCity.name.length>0)) {
        [self showProgress:@"请选择出发地"];
        return;
    }
    if (!(self.ticketInfo.endCity.name.length>0)) {
        [self showProgress:@"请选择目的地"];
        return;
    }
    if (([self.ticketInfo.endCity.name isEqualToString:self.ticketInfo.beginCity.name])) {
        [self showProgress:@"航线不可为同一城市"];
        return;
    }
    
    [SearchFlightsModel asyncPostTicketInfoListTicketModel:self.ticketInfo SuccessBlock:^(NSArray *dataArray) {
        [self saveSearchHistory];
        SelectFlightViewController *selectFlightVC = [SelectFlightViewController new];
        selectFlightVC.tickeModel = self.ticketInfo;
        selectFlightVC.dataArray = dataArray;
        [self.navigationController pushViewController:selectFlightVC animated:YES];

    } errorBlock:^(NSError *errorResult) {
    }];
    
}

// 点击轮播图
- (void)didClickBannerButtonClick:(NSInteger)index {
    //    XHHomeBannerModel *model = self.bannerListArray[index];
    //    XHBaseWebViewController *banWeb=[[XHBaseWebViewController alloc]initWithURL:model.jump_url];
    //    [banWeb setHidesBottomBarWhenPushed:YES];
    //    [self.navigationController pushViewController:banWeb animated:YES];
}

// 点击历史记录
- (void)searchHistoryClick:(UIButton *)sender {
    NSInteger i = sender.tag-1233;
    NSDictionary *dic = self.searchHistoryArray[i];
    TLTicketModel *ticketInfo = [TLTicketModel getUserModel:dic];
    self.ticketInfo = ticketInfo;
    CityModel *bCity = ticketInfo.beginCity;
    CityModel *eCity = ticketInfo.endCity;
    [_addressBtn setTitle:bCity.name forState:UIControlStateNormal]; // 当前地址
    [_addressBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
    _addressBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
    [_destinationBtn setTitle:eCity.name forState:UIControlStateNormal];
    [_destinationBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
    _destinationBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
    [_timeBtn setTitle:[Untils daraWeekdatStringFromDate:[Untils dateFormString:ticketInfo.beginTime]]
              forState:UIControlStateNormal];
    [self buttonAttributed:_timeBtn titleStr:[Untils daraWeekdatStringFromDate:[Untils dateFormString:ticketInfo.beginTime]]];
    if (ticketInfo.orderType == 2) {
        [_backForthInfoBtn setTitle:[Untils daraWeekdatStringFromDate:[Untils dateFormString:ticketInfo.backBeginTime]] forState:UIControlStateNormal];
        [_backForthInfoBtn setTitleColor:[UIColor colorWithHexString:@"#4E4B4B"] forState:UIControlStateNormal];
        _backForthInfoBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(40)];
        [self buttonAttributed:_backForthInfoBtn titleStr:[Untils daraWeekdatStringFromDate:[Untils dateFormString:ticketInfo.backBeginTime]]];
        [self takeNumber:_backForthBtn];
    } else {
        [self takeNumber:_oneWayBtn];
    }
    
    [self.view reloadInputViews];
}

// 清除历史记录 clearHistoryClick
- (void)clearHistoryClick:(UIButton *)sender {
    [self deleteSearchHistory];
    [_searchHistoryScrollView removeAllSubViews];
    _clearHistoryButton.hidden = YES;
    self.ticketInfo.endCity = nil;
    [_destinationBtn setTitle:[NSString stringWithFormat:@"请选择目的地"] forState:UIControlStateNormal];
    [_destinationBtn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    _destinationBtn.titleLabel.font = [UIFont fontWithName:kFont_PingFangSCSemibold size:PXChange(26)];
    self.ticketInfo.orderType = 1;
    [self takeNumber:_oneWayBtn];
    
    [_backForthInfoBtn setTitle:[NSString stringWithFormat:@"请选择返程日期"] forState:UIControlStateNormal];
    [_backForthInfoBtn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    _backForthInfoBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(26)];
    self.ticketInfo.backBeginTime = nil;
    
    if (self.positioningCity) {
        self.ticketInfo.beginCity = self.positioningCity;
         [_addressBtn setTitle:[NSString stringWithFormat:@"%@",self.positioningCity.name] forState:UIControlStateNormal];
    } else {
        self.ticketInfo.beginCity = nil;
        [_addressBtn setTitle:[NSString stringWithFormat:@"请选择出发地"] forState:UIControlStateNormal];
        [_addressBtn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
        _addressBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(26)];
    }
    
    if (![self isToday:[Untils dateFormString:self.ticketInfo.beginTime]]) {
        self.ticketInfo.beginTime = [Untils getFormatDateByDate:[NSDate date]];
        [_timeBtn setTitle:[NSString stringWithFormat:@"%@", [Untils daraWeekdatStringFromDate:[NSDate date]]] forState:UIControlStateNormal];
        [self buttonAttributed:_timeBtn titleStr:[NSString stringWithFormat:@"%@", [Untils daraWeekdatStringFromDate:[NSDate date]]]];
    }
    self.ticketInfo.positionType = @"0";
    [_tankTypeBtn setTitle:@"经济舱" forState:UIControlStateNormal];
    
    [self.view reloadInputViews];
}

#pragma mark - Setter & Getter
- (JYCarousel *)banner {
    __weak __typeof__(self) weakSelf = self;
    if(!_banner){
        _banner= [[JYCarousel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(300)) configBlock:^JYConfiguration *(JYConfiguration *carouselConfig) {
            carouselConfig.pageContollType = NonePageControl;
            carouselConfig.interValTime = 3;
            carouselConfig.pushAnimationType = PushDefault;
            carouselConfig.animationSubtype = kCATransitionFromRight;
            return carouselConfig;
        } clickBlock:^(NSInteger index) {
            [weakSelf didClickBannerButtonClick:index];
        }];
    }
    return _banner;
}

- (NSMutableArray *)bannerImageArray {
    if (!_bannerImageArray) {
        _bannerImageArray = [NSMutableArray new];
    }
    return _bannerImageArray;
}

- (NSMutableArray *)bannerListArray {
    if (!_bannerListArray) {
        _bannerListArray = [NSMutableArray new];
    }
    return _bannerListArray;
}

- (void)setticketInfo:(TLTicketModel *)ticketInfo {
    if (!_ticketInfo) {
        _ticketInfo = [TLTicketModel new];
    }
    if (![_ticketInfo isEqual:ticketInfo] || _ticketInfo != ticketInfo) {
        _ticketInfo = ticketInfo;
    }
}

// 将存在本地的搜索记录取出来 然后添加新的
- (void)saveSearchHistory {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSData *oldData = [userDefaultes dataForKey:@"searchHistory"];
    NSMutableArray *userDefaultsArr = [[NSKeyedUnarchiver unarchiveObjectWithData:oldData] mutableCopy];
    NSMutableArray *searTXT = [[NSMutableArray alloc] init];
    NSArray *oldArr = [NSArray new];
    if (userDefaultsArr.count>1) {
        oldArr = [[userDefaultsArr reverseObjectEnumerator] allObjects];
    } else {
        oldArr = [userDefaultsArr copy];
    }
    if (oldArr.count>0) {
        searTXT =  [oldArr mutableCopy];
    }
    [searTXT addObject:[self dicConversionModel:self.ticketInfo]];
    NSArray *newArr = [NSArray new];
    if (searTXT.count>1) {
        newArr = [[searTXT reverseObjectEnumerator] allObjects];
    } else {
        newArr = [searTXT copy];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newArr];
    [userDefaultes setObject:data forKey:@"searchHistory"];
    [userDefaultes synchronize];
}

- (NSDictionary *)dicConversionModel:(TLTicketModel *)ticketModel {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic = [NSMutableDictionary dictionaryWithDictionary:[Untils getObjectData:ticketModel]];
    if (ticketModel.orderType == 2) {
        [dic setObject:ticketModel.backBeginTime forKey:@"backBeginTime"];
    }
    return dic;
}

// 读取数据
- (NSArray *)readSearchHistory {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSData *oldData = [userDefaultes dataForKey:@"searchHistory"];
    NSArray *userDefaultsArr = [NSKeyedUnarchiver unarchiveObjectWithData:oldData];
    NSMutableArray *newArr = [NSMutableArray new];
    if (userDefaultsArr.count>5) {
        for (int i = 0; i<userDefaultsArr.count;i++) {
            if (i<5) {
                [newArr addObject:userDefaultsArr[i]];
            }
        }
    } else {
        newArr = [userDefaultsArr mutableCopy];
    }
    return [newArr copy];
}

// 删除数据
- (void)deleteSearchHistory {
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSData *oldData = [userDefaultes dataForKey:@"searchHistory"];
    NSMutableArray *userDefaultsArr = [[NSKeyedUnarchiver unarchiveObjectWithData:oldData] mutableCopy];
    if (userDefaultsArr.count>0) {
        [userDefaultsArr removeAllObjects];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userDefaultsArr];
        [userDefaultes setObject:data forKey:@"searchHistory"];
    }
}

- (void)buttonAttributed:(UIButton *)btn titleStr:(NSString *)titleStr {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#919191"] range:NSMakeRange(7,2)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont_PingFangSC size:PXChange(26)] range:NSMakeRange(7,2)];
    
    [btn setAttributedTitle:str forState:(UIControlStateNormal)];
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
