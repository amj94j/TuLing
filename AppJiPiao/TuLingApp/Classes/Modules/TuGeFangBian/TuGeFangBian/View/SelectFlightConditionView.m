//
//  SelectFlightConditionView.m
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "SelectFlightConditionView.h"
#import "SelectFlightConditionCell.h"

#define kDepartureTime @[@{@"companycon":@"不限",@"select":@"1",@"real":@""},@{@"companycon":@"00:00--06:00",@"select":@"0",@"real":@"0"},@{@"companycon":@"06:00--12:00",@"select":@"0",@"real":@"1"},@{@"companycon":@"12:00--18:00",@"select":@"0",@"real":@"2"},@{@"companycon":@"18:00-24:00",@"select":@"0",@"real":@"3"}]
#define kPlaneSizeArr @[@{@"companycon":@"不限",@"select":@"1",@"real":@"0"},@{@"companycon":@"大机型",@"select":@"0",@"real":@"大"},@{@"companycon":@"中机型",@"select":@"0",@"real":@"中"},@{@"companycon":@"小机型",@"select":@"0",@"real":@"小"}]


@interface SelectFlightConditionView () <UITableViewDelegate, UITableViewDataSource>
{
//    UIButton *_directBtn; // 直达
//    UIButton *_sharedBtn; // 共享
    UIView *_selectBarView;
    
    UIButton *_resetBtn; // 重置
    UIButton *_determineBtn; // 确定
    
    UILabel *_totalRowLabel; // 总条数
    
    NSInteger _selectBtnIndex;
    
    NSString *_oldPositionType; // 旧的舱位信息
    
    NSInteger _count;
}
@property (nonatomic, strong) TLTicketModel *tickeModel;
@property (nonatomic, strong) UITableView *tableView;
@property (assign, nonatomic) NSIndexPath *selIndex;
@property (assign, nonatomic) NSIndexPath *endSelIndex;
@property (nonatomic, strong) NSMutableArray *airCompanysArr;
@property (nonatomic ,strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSArray *departureTimeArr;
@property (nonatomic, copy) NSArray *planeSizeArr;
@end


@implementation SelectFlightConditionView


- (instancetype)initWithFrame:(CGRect)frame tickeModel:(TLTicketModel *)tickeModel selectFlightConditionModel:(SelectFlightConditionModel *)selectFlightConditionModel {
    if (self = [super initWithFrame:frame]) {
        self.dataArr = [NSMutableArray new];
        self.airCompanysArr = [NSMutableArray new];
        self.tickeModel = tickeModel;
        self.selectFlightConditionModel = selectFlightConditionModel;
        self.departureTimeArr = [NSArray new];
        self.planeSizeArr = [NSArray new];
        _oldPositionType = self.tickeModel.positionType;
        
        if (self.selectFlightConditionModel.departureTimeArr.count>0) {
            self.departureTimeArr = [self.selectFlightConditionModel.departureTimeArr copy];
        }
        if (self.selectFlightConditionModel.planeSizeArr.count>0) {
            self.planeSizeArr = [self.selectFlightConditionModel.planeSizeArr copy];
        }
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(448))];
        mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:mainView];
        
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, mainView.bottom, ScreenWidth, self.height-PXChange(618))];
        grayView.backgroundColor = [UIColor clearColor];
        [self addSubview:grayView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [grayView addGestureRecognizer:tap];
        
        
//        _directBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _directBtn.frame = CGRectMake(PXChange(30), 0, PXChange(170), PXChange(80));
//        [_directBtn setTitle:[NSString stringWithFormat:@" 仅看直达"] forState:UIControlStateNormal];
//        [_directBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
//        _directBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(30)];
//        [_directBtn setImage:[UIImage imageNamed:@"selectflight_uncheck"] forState:UIControlStateNormal];
//        [_directBtn setImage:[UIImage imageNamed:@"selectflight_check"] forState:UIControlStateSelected];
//        [_directBtn addTarget:self.VC action:@selector(directClick:) forControlEvents:UIControlEventTouchUpInside];
//        [mainView addSubview:_directBtn];
//        if (tickeModel.direct.length>0) {
//            if ([tickeModel.direct isEqualToString:@"0"]) {
//                [_directBtn setSelected:YES];
//            } else {
//                [_directBtn setSelected:NO];
//            }
//        } else {
//            self.tickeModel.direct = @"";
//        }
//
//        _sharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _sharedBtn.frame = CGRectMake(_directBtn.right+PXChange(60), 0, PXChange(170), PXChange(80));
//        [_sharedBtn setTitle:[NSString stringWithFormat:@" 隐藏共享"] forState:UIControlStateNormal];
//        [_sharedBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
//        _sharedBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(30)];
//        [_sharedBtn setImage:[UIImage imageNamed:@"selectflight_uncheck"] forState:UIControlStateNormal];
//        [_sharedBtn setImage:[UIImage imageNamed:@"selectflight_check"] forState:UIControlStateSelected];
//        [_sharedBtn addTarget:self.VC action:@selector(sharedClick:) forControlEvents:UIControlEventTouchUpInside];
//        [mainView addSubview:_sharedBtn];
//
//        if (tickeModel.share.length>0) {
//            if ([tickeModel.share isEqualToString:@"1"]) {
//                [_sharedBtn setSelected:YES];
//            } else {
//                [_sharedBtn setSelected:NO];
//            }
//        } else {
//            self.tickeModel.share = @"";
//        }
        
        _selectBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(360))];
        _selectBarView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
        [mainView addSubview:_selectBarView];
        
        NSArray *arr = @[@"    起飞时间",@"    机型",@"    舱位",@"    航空公司",@"    机场"];
        for (int i = 0; i < 5; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 100+i;
            int j = i;
            if (i==2) {
                continue;
            } else if (i>2) {
                j = i-1;
            }
            btn.frame = CGRectMake(0, PXChange(2)*(j+1)+PXChange(88)*j, PXChange(260), PXChange(88));
            btn.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:PXChange(30)];
            [btn addTarget:self.VC action:@selector(selectBarClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_selectBarView addSubview:btn];
            if (i == 0) {
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
                [self selectBarClick:btn];
            }
        }
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(PXChange(260), PXChange(2), ScreenWidth-PXChange(260), PXChange(358)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[SelectFlightConditionCell class]  forCellReuseIdentifier:@"SelectFlightConditionCell"];
        [_selectBarView addSubview:_tableView];
        if (!(self.dataArr.count>0)) {
            NSArray *tempArr = kDepartureTime;
            self.dataArr = [tempArr mutableCopy];
        }
        
        
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake( 0, _selectBarView.bottom, ScreenWidth,  mainView.height-_selectBarView.bottom)];
        bottomView.backgroundColor = [UIColor colorWithHexString:@"#6DCB99"];
        [mainView addSubview:bottomView];
        
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.frame = CGRectMake(0, 0, PXChange(177), bottomView.height);
        [_resetBtn setTitle:[NSString stringWithFormat:@"重置"] forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(30)];
        [_resetBtn addTarget:self.VC action:@selector(resetClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:_resetBtn];
        
        UIView *resetLine = [[UIView alloc] initWithFrame:CGRectMake(_resetBtn.right, PXChange(22), PXChange(1), PXChange(40))];
        resetLine.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [bottomView addSubview:resetLine];
        
        _determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _determineBtn.frame = CGRectMake(ScreenWidth-PXChange(177), 0, PXChange(177), bottomView.height);
        [_determineBtn setTitle:[NSString stringWithFormat:@"确定"] forState:UIControlStateNormal];
        [_determineBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _determineBtn.titleLabel.font = [UIFont systemFontOfSize:PXChange(30)];
        [_determineBtn addTarget:self.VC action:@selector(determineClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:_determineBtn];
        
        UIView *determineLine = [[UIView alloc] initWithFrame:CGRectMake(_determineBtn.left-PXChange(1), PXChange(22), PXChange(1), PXChange(40))];
        determineLine.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [bottomView addSubview:determineLine];
        
        _totalRowLabel = [[UILabel alloc] initWithFrame:CGRectMake(resetLine.right, 0, determineLine.left-resetLine.right,bottomView.height)];
        
        if (self.selectFlightConditionModel.count>0) {
            _totalRowLabel.text = [NSString stringWithFormat:@"共%ld条",self.selectFlightConditionModel.count];
            _count = self.selectFlightConditionModel.count;
        } else {
            _totalRowLabel.text = @"共0条";
            _count = 0;
        }
        _count = 0;
        _totalRowLabel.textColor = [UIColor colorWithHexString:@"#E2E2E2"];
        _totalRowLabel.textAlignment = NSTextAlignmentCenter;
        _totalRowLabel.font = [UIFont systemFontOfSize:PXChange(26)];
        [bottomView addSubview:_totalRowLabel];
    }
    return self;
}

- (void)setDataArr:(NSMutableArray *)dataArr {
    if (![_dataArr isEqualToArray:dataArr]) {
        _dataArr = [dataArr mutableCopy];
    }
}

//// 是否直达
//- (void)directClick:(UIButton *)sender {
//    if (sender.selected) {
//        self.tickeModel.direct = @"";
//        [sender setSelected:NO];
//    } else {
//        [sender setSelected:YES];
//        self.tickeModel.direct = @"0";
//    }
//    [self requestTicketListCount];
//}
//
//// 共享
//- (void)sharedClick:(UIButton *)sender {
//    if (sender.selected) {
//        [sender setSelected:NO];
//        self.tickeModel.share = @"";
//    } else {
//        [sender setSelected:YES];
//        self.tickeModel.share = @"1";
//    }
//    [self requestTicketListCount];
//}

- (void)selectBarClick:(UIButton *)sender {
    
    NSArray *arr = [_selectBarView subviews];
    NSInteger selectIndex = 0;
    for (UIButton *btn in arr) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag == sender.tag)
            {
                sender.backgroundColor = [UIColor whiteColor];
                [sender setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
                _selectBtnIndex = sender.tag-100;
                switch (sender.tag-100)
                {
                    case 0: {
                        [self.dataArr removeAllObjects];
                        if (self.departureTimeArr.count>0) {
                            self.dataArr = [NSMutableArray arrayWithArray:self.departureTimeArr];
                        } else {
                            self.dataArr = [kDepartureTime mutableCopy];
                        }
                        [_tableView reloadData];
                    }
                        break;
                    case 1: {
                        [self.dataArr removeAllObjects];
                        if (self.planeSizeArr.count>0) {
                            self.dataArr = [self.planeSizeArr mutableCopy];
                        } else {
                            self.dataArr = [kPlaneSizeArr mutableCopy];
                        }
                        [_tableView reloadData];
                    }
                        break;
                    case 2: {
                        [self.dataArr removeAllObjects];
                        NSArray *tempArr = @[@"不限",@"经济舱",@"头等舱/公务舱"];
                        self.dataArr = [tempArr mutableCopy];
                        if (self.tickeModel.positionType.length>0) {
                            selectIndex = [self.tickeModel.positionType integerValue]+1;
                        }
                        [self selectCellIndex:selectIndex];
                        [_tableView reloadData];
                    }
                        break;
                    case 3: {
                        // 航空公司
                        [self.dataArr removeAllObjects];
                        __block NSMutableArray *data = [NSMutableArray arrayWithObjects:@{@"companycon":@"不限",@"select":@"1",@"airlineCode":@""}, nil];
                        self.dataArr = [data copy];
                        [TLTicketModel asyncPostTicketQueryCompanyconTicketModel:self.tickeModel SuccessBlock:^(NSArray *dataArray) {
                            if (dataArray.count>0) {
                                NSArray *tempArr = [data arrayByAddingObjectsFromArray:dataArray];
                                self.dataArr = [tempArr mutableCopy];
                                [_tableView reloadData];
                            }
                        } errorBlock:^(NSError *errorResult) {
                        }];
                    }
                        break;
                    case 4: {
                        // 机场
                        _endSelIndex = [NSIndexPath indexPathForRow:0 inSection:1];
                        _selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                        [TLTicketModel asyncPostTicketQueryAirportconTicketModel:self.tickeModel SuccessBlock:^(NSArray *dataArray) {
                            if (dataArray.count>0) {
                                [self.dataArr removeAllObjects];
                                self.dataArr = [dataArray mutableCopy];
                                [_tableView reloadData];
                            }
                            
                        } errorBlock:^(NSError *errorResult) {
                        }];
                    }
                        break;
                    default:
                        break;
                }
            } else {
                [btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            }
        }
        
    }
    
}

// 重置
- (void)resetClick:(UIButton *)sender {
//    [_directBtn setSelected:NO];
    self.tickeModel.direct = @"";
//    [_sharedBtn setSelected:NO];
    self.tickeModel.share = @"";
    self.tickeModel.timeType = @"";
    self.tickeModel.positionType = _oldPositionType;
    self.tickeModel.planeSize = @"";
    self.tickeModel.airCompany = @"";
    self.tickeModel.beginAirPortName = @"";
    self.tickeModel.endAirPort = @"";
    self.departureTimeArr = nil;
    self.planeSizeArr = nil;
    _count = 0;
    NSArray *arr = [_selectBarView subviews];
    for (UIButton *btn in arr) {
        if (btn.tag == 100) {
            [self selectBarClick:btn];
        }
    }
    
//    _totalRowLabel.text = @"共0条";
    [self reloadInputViews];
    [self requestTicketListCount];
}
- (void)setselectFlightConditionModel:(SelectFlightConditionModel *)selectFlightConditionModel {
    if (!_selectFlightConditionModel) {
        _selectFlightConditionModel = [SelectFlightConditionModel new];
    }
    if (![_selectFlightConditionModel isEqual:selectFlightConditionModel] || _selectFlightConditionModel != selectFlightConditionModel) {
        _selectFlightConditionModel = selectFlightConditionModel;
    }
}

// 确定
- (void)determineClick:(UIButton *)sender {
    if (_count==0) {
        return;
    }
    self.selectFlightConditionModel = [SelectFlightConditionModel new];
    self.selectFlightConditionModel.departureTimeArr = [self.departureTimeArr copy];
    self.selectFlightConditionModel.planeSizeArr = [self.planeSizeArr copy];
    self.selectFlightConditionModel.count = _count;
    if (self.selectFlightConditionBlock) {
        self.selectFlightConditionBlock(self.tickeModel,self.selectFlightConditionModel);
    }
    [self removeFromSuperview];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
}

+ (void)recyclingView {
    [SelectFlightConditionView new].tickeModel.beginAirPortName = @"";
    [SelectFlightConditionView new].tickeModel.endAirPort = @"";
    [[SelectFlightConditionView new] removeFromSuperview];
}

- (void)settickeModel:(TLTicketModel *)tickeModel {
    if (!_tickeModel) {
        _tickeModel = [TLTicketModel new];
    }
    if (![_tickeModel isEqual:tickeModel] || _tickeModel != tickeModel) {
        _tickeModel = tickeModel;
    }
}

#pragma mark - TableViewDelegate & TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_selectBtnIndex == 4) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_selectBtnIndex == 4) {
        NSArray *arr = self.dataArr[section];
        return arr.count;
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PXChange(88);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_selectBtnIndex == 4) {
        return PXChange(66);
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 0.01)];
    if (_selectBtnIndex == 4) {
        headerView.frame = CGRectMake(0, 0, self.tableView.width, PXChange(66));
        headerView.backgroundColor = self.tableView.backgroundColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PXChange(30), 0, headerView.width-PXChange(60), headerView.height)];
        label.textColor = [UIColor colorWithHexString:@"#919191"];
        label.font = [UIFont systemFontOfSize:PXChange(26)];
        [headerView addSubview:label];
        if (section==0) {
            if (!self.tickeModel.isGo) {
                label.text = [NSString stringWithFormat:@"起:%@",self.tickeModel.endCity.name];
            } else {
                label.text = [NSString stringWithFormat:@"起:%@",self.tickeModel.beginCity.name];
            }
        } else {
            if (!self.tickeModel.isGo) {
                label.text = [NSString stringWithFormat:@"落:%@",self.tickeModel.beginCity.name];
            } else {
                label.text = [NSString stringWithFormat:@"落:%@",self.tickeModel.endCity.name];
            }
            
        }
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectFlightConditionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SelectFlightConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectFlightConditionCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_selectBtnIndex == 4) {
        cell.topTextLabel.text = self.dataArr[indexPath.section][indexPath.row];
    } else if (_selectBtnIndex == 3 || _selectBtnIndex == 0 || _selectBtnIndex == 1) {
        cell.topTextLabel.text = self.dataArr[indexPath.row][@"companycon"];
        if (_selectBtnIndex == 3 && indexPath.row != 0) {
            [cell hiddenIconImageWith:self.dataArr[indexPath.row][@"airlineCode"] hidden:NO];
        } else if (_selectBtnIndex == 3 && indexPath.row == 0) {
            [cell hiddenIconImageWith:self.dataArr[indexPath.row][@"airlineCode"] hidden:YES];
        }
    } else {
        cell.topTextLabel.text = self.dataArr[indexPath.row];
    }
    
    if (_selectBtnIndex == 4) {
        if (_selIndex == indexPath || _endSelIndex == indexPath) {
            cell.tailImage.image = [UIImage imageNamed:@"selectflight_check"];
        }else {
            cell.tailImage.image = [UIImage imageNamed:@"selectflight_uncheck"];
        }
    } else if (_selectBtnIndex == 3 || _selectBtnIndex == 0 || _selectBtnIndex == 1) {
        NSDictionary *dic = self.dataArr[indexPath.row];
        if ([[dic objectForKey:@"select"] isEqualToString:@"1"]) {
            cell.tailImage.image = [UIImage imageNamed:@"selectflight_check"];
        } else if ([[dic objectForKey:@"select"] isEqualToString:@"0"]) {
            cell.tailImage.image = [UIImage imageNamed:@"selectflight_uncheck"];
        }
    }  else if (_selectBtnIndex == 2) {
        NSInteger rowIndex = 0;
        if (self.tickeModel.positionType.length>0) {
            rowIndex = [self.tickeModel.positionType integerValue]+1;
            if (indexPath.row == rowIndex) {
                cell.tailImage.image = [UIImage imageNamed:@"selectflight_check"];
            }else {
                cell.tailImage.image = [UIImage imageNamed:@"selectflight_uncheck"];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //记录当前选中的位置索引
    if (_selectBtnIndex==4) {
        if (indexPath.section == 0) {
            SelectFlightConditionCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
            celled.tailImage.image = [UIImage imageNamed:@"selectflight_uncheck"];
            _selIndex = indexPath;
        } else {
            SelectFlightConditionCell *celled = [tableView cellForRowAtIndexPath:_endSelIndex];
            celled.tailImage.image = [UIImage imageNamed:@"selectflight_uncheck"];
            _endSelIndex = indexPath;
        }
        //当前选择的打勾
        SelectFlightConditionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.tailImage.image = [UIImage imageNamed:@"selectflight_check"];
    } else if (_selectBtnIndex == 3 || _selectBtnIndex == 0 || _selectBtnIndex == 1) {
        
        SelectFlightConditionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            NSMutableDictionary *currentDic = [NSMutableDictionary new];
            currentDic = [self.dataArr[indexPath.row] mutableCopy];
            if ([[currentDic objectForKey:@"select"] isEqualToString:@"0"]) {
                [currentDic setObject:@"1" forKey:@"select"];
                [self.dataArr replaceObjectAtIndex:0 withObject:currentDic];
                cell.tailImage.image = [UIImage imageNamed:@"selectflight_check"];
                
                for (int i = 1; i<self.dataArr.count; i++) {
                    NSMutableDictionary *old = [NSMutableDictionary new];
                    old = [self.dataArr[i] mutableCopy];
                    [old setValue:@"0" forKey:@"select"];
                    [self.dataArr replaceObjectAtIndex:i withObject:old];
                    NSIndexPath *indexPathd = [NSIndexPath indexPathForRow:i inSection:0];
                    SelectFlightConditionCell *celld = [tableView cellForRowAtIndexPath:indexPathd];
                    celld.tailImage.image = [UIImage imageNamed:@"selectflight_uncheck"];
                }
            } else {
                
            }
        } else {
            NSMutableDictionary *currentDic = [self.dataArr[indexPath.row] mutableCopy];
            SelectFlightConditionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if ([[currentDic objectForKey:@"select"] isEqualToString:@"1"]) {
                [currentDic setValue:@"0" forKey:@"select"];
                [self.dataArr replaceObjectAtIndex:indexPath.row withObject:currentDic];
                cell.tailImage.image = [UIImage imageNamed:@"selectflight_uncheck"];
            } else {
                [currentDic setValue:@"1" forKey:@"select"];
                [self.dataArr replaceObjectAtIndex:indexPath.row withObject:currentDic];
                cell.tailImage.image = [UIImage imageNamed:@"selectflight_check"];
            }
            
            NSMutableDictionary *firstDic = [self.dataArr[0] mutableCopy];
            if ([firstDic[@"select"] isEqualToString:@"1"]) {
                [firstDic setObject:@"0" forKey:@"select"];
                [self.dataArr replaceObjectAtIndex:0 withObject:firstDic];
                NSIndexPath *indexPathd = [NSIndexPath indexPathForItem:0 inSection:0];
                SelectFlightConditionCell *celld = [tableView cellForRowAtIndexPath:indexPathd];
                celld.tailImage.image = [UIImage imageNamed:@"selectflight_uncheck"];
            }
        }
        
    } else {
        SelectFlightConditionCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
        celled.tailImage.image = [UIImage imageNamed:@"selectflight_uncheck"];
        _selIndex = indexPath;
        //当前选择的打勾
        SelectFlightConditionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.tailImage.image = [UIImage imageNamed:@"selectflight_check"];
    }
    
//    if ( _selectBtnIndex == 3 || _selectBtnIndex == 0 || _selectBtnIndex == 1) {
        switch (_selectBtnIndex) {
            case 0: {
                self.departureTimeArr = [self.dataArr copy];
                if ( ![self.dataArr[0][@"select"] isEqualToString:@"1"]) {
                    NSMutableArray *oldArr = [NSMutableArray new];
                    for (NSDictionary *dict in self.dataArr) {
                        if ([dict[@"select"] isEqualToString:@"1"]) {
                            [oldArr addObject:dict[@"real"]];
                        }
                    }
                    self.tickeModel.timeType = [oldArr componentsJoinedByString:@","];
                } else {
                    self.tickeModel.timeType = @"";
                }
            }
                break;
            case 1: {
                self.planeSizeArr = [self.dataArr copy];
                if ( ![self.dataArr[0][@"select"] isEqualToString:@"1"]) {
                    NSMutableArray *oldArr = [NSMutableArray new];
                    for (NSDictionary *dict in self.dataArr) {
                        if ([dict[@"select"] isEqualToString:@"1"]) {
                            [oldArr addObject:dict[@"real"]];
                        }
                    }
                    self.tickeModel.planeSize = [oldArr componentsJoinedByString:@","];
                } else {
                    self.tickeModel.planeSize = @"";
                }
                
            }
                break;
            case 2: {
                if (_selIndex.row>0) {
                    self.tickeModel.positionType = [NSString stringWithFormat:@"%ld",_selIndex.row-1];
                } else {
                    self.tickeModel.positionType = @"";
                }
                
            }
                break;
            case 3: {
                if ( ![self.dataArr[0][@"select"] isEqualToString:@"1"]) {
                    NSMutableArray *oldArr = [NSMutableArray new];
                    for (NSDictionary *dict in self.dataArr) {
                        if ([dict[@"select"] isEqualToString:@"1"]) {
                            [oldArr addObject:dict[@"companycon"]];
                        }
                    }
                    self.tickeModel.airCompany = [oldArr componentsJoinedByString:@","];
                } else {
                    self.tickeModel.airCompany = @"";
                }
            }
                break;
            case 4: {
                if (indexPath.section==0) {
                    
                    if (_selIndex.row>0) {
                        self.tickeModel.beginAirPortName = [NSString stringWithFormat:@"%@",self.dataArr[_selIndex.section][_selIndex.row]];
                    } else {
                        self.tickeModel.beginAirPortName = @"";
                    }
                    
                } else {
                    
                    
                    if (_endSelIndex.row>0) {
                        self.tickeModel.endAirPort = [NSString stringWithFormat:@"%@",self.dataArr[_endSelIndex.section][_endSelIndex.row]];
                    } else {
                        self.tickeModel.endAirPort = @"";
                    }
                }
            }
                break;
                
            default:
                break;
        }
//    }
    [self requestTicketListCount];
}

- (void)selectCellIndex:(NSInteger)index {
    NSIndexPath * selIndex = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    NSIndexPath * path = [NSIndexPath indexPathForItem:index inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:path];
}

#pragma mark - 获取条数
- (void)requestTicketListCount {
    [SearchFlightsModel asyncPostTicketListCountTicketModel:self.tickeModel SuccessBlock:^(NSInteger count) {
        _count = count;
        _totalRowLabel.text = [NSString stringWithFormat:@"共%ld条",count];
        [self reloadInputViews];
    } errorBlock:^(NSError *errorResult) {
    }];
}


@end
