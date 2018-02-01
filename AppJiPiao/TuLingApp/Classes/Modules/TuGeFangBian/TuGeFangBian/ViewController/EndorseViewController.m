//
//  EndorseViewController.m
//  TuLingApp
//
//  Created by apple on 2017/12/23.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "EndorseViewController.h"
#import "EndorseBackRulesVC.h"
#import "EndorseSelectWhyVC.h"
#import "OneWayCalendarChooseVC.h"
#import "BackForthCalendarChooseVC.h"
#import "WKWebViewController.h"
#import "ZJPersonalCenterViewController.h"

#pragma mark - cell
#import "EndorsePersonCell.h"
#import "EndorseWhyCell.h"
#import "EndorseTicketHeaderCell.h"
#import "EndorseSelectCell.h"
#import "TicketOrderDetailsCell.h"

#pragma mark - Model
#import "EndorseBackRulesModel.h"
#import "TicketEndorseInfo.h"
#import "ZJPersonalCenterWebVC.h"

@interface EndorseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) BOOL isOneWay;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitApplicationBtn; // 提交申请


// 乘机人
@property (nonatomic, strong) NSMutableArray *allPerson;
@property (nonatomic, strong) NSMutableArray *selectedPerson;
@property (nonatomic, strong) NSMutableArray *goPersonArr;
@property (nonatomic, strong) NSMutableArray *backPersonArr;

// 原因
@property (nonatomic, copy) NSArray *reasonResult;
@property (nonatomic, copy) NSDictionary *selectedReasonResult;
@property (nonatomic, copy) NSDictionary *orderDic;
// 退改签规则
@property (nonatomic, strong) EndorseBackRulesModel *ruleResult;
// 航班

@end

@implementation EndorseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.allPerson = [NSMutableArray new];
    self.goPersonArr = [NSMutableArray new];
    self.backPersonArr = [NSMutableArray new];
    
    [self addCustomTitleWithTitle:@"申请改签"];
    
    if (!self.isEndorse) {
        [self requestData];
    } else {
        [self fillData];
    }
    
    [self layoutMainView];
}

- (void)fillData {
    
    if (self.endorseInfo.orderType==1) {
        self.isOneWay = YES;
    } else {
        self.isOneWay = NO;
    }
    self.orderDic = self.endorseInfo.order;
    self.reasonResult = self.endorseInfo.reasonResult;
    self.ruleResult = self.endorseInfo.ruleResult;
    self.selectedReasonResult = self.endorseInfo.selectedReasonResult;
    for (NSDictionary *dic in self.endorseInfo.selectPersons) {
        NSMutableDictionary *dict = [dic mutableCopy];
        [dict setObject:@"0" forKey:@"isSelect"];
        [self.allPerson addObject:dict];
        
        if ([dict int64ValueForKey:@"backState"] == 0) {
            [self.goPersonArr addObject:dict];
        }
        if ([dict int64ValueForKey:@"backState"] == 1) {
            [self.backPersonArr addObject:dict];
        }
    }
    
    [self.tableView reloadData];
}

- (void)requestData {
    // 往返
//    NSDictionary *dic = @{@"orderId":@"11416",@"orderCode":@"5115142182586900310000",@"businessCode":@"171226001103184904"};
//    self.orderId = @"11416";
//    self.businessCode = @"171226001103184904";
//    self.orderCode = @"5115142182586900310000";
    if (!self.endorseDic) {
        return;
    }
    self.orderId = self.endorseDic[@"orderId"];
    
    self.businessCode = self.endorseDic[@"businessCode"];
    self.orderCode = self.endorseDic[@"orderCode"];
    self.source = self.endorseDic[@"source"];
//    if (self.endorseDic[@"backBusinessCode"]) {
//        self.backBusinessCode = self.endorseDic[@"backBusinessCode"];
//    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic = [self.endorseDic mutableCopy];
    if ([self.endorseDic int64ValueForKey:@"source"] == 2) {
        [dic setObject:self.endorseDic[@"superiorId"] forKey:@"orderId"];
    }
    [EndorseModel asyncPostTicketCheckChangeTicketWithOrderDic:dic SuccessBlock:^(NSDictionary *data) {
        for (NSDictionary *dic in data[@"detailList"]) {
            NSMutableDictionary *dict = [dic mutableCopy];
            [dict setObject:@"0" forKey:@"isSelect"];
            
            if ([dict int32ValueForKey:@"isChange"] == 0) {
                [self.allPerson addObject:dict];
                if ([dict int64ValueForKey:@"backState"] == 0) {
                    [self.goPersonArr addObject:dict];
                }
                if ([dict int64ValueForKey:@"backState"] == 1) {
                    [self.backPersonArr addObject:dict];
                }
            }
            
        }
        
        self.isOneWay = [data[@"order"][@"orderType"] isEqualToString:@"1"];
        self.orderDic = data[@"order"];
        self.reasonResult = data[@"reasonResult"];
        self.selectedReasonResult = [self.reasonResult firstObject];
        self.ruleResult = [EndorseBackRulesModel getRuleModel:data[@"ruleResult"]];
        [self.tableView reloadData];
    } errorBlock:^(NSError *errorResult) {
    } ];
}

- (void)layoutMainView {
    if (!self.isEndorse) {
        self.submitApplicationBtn.userInteractionEnabled = NO;
        self.submitApplicationBtn.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
        [self.submitApplicationBtn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    } else {
        self.submitApplicationBtn.userInteractionEnabled = YES;
        self.submitApplicationBtn.backgroundColor = kColorAppGreen;
        [self.submitApplicationBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }
    
    self.tableView.estimatedRowHeight = 44;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EndorsePersonCell" bundle:nil] forCellReuseIdentifier:@"EndorsePersonCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EndorseTicketHeaderCell" bundle:nil] forCellReuseIdentifier:@"EndorseTicketHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EndorseWhyCell" bundle:nil] forCellReuseIdentifier:@"EndorseWhyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EndorseSelectCell" bundle:nil] forCellReuseIdentifier:@"EndorseSelectCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketOrderDetailsCell" bundle:nil] forCellReuseIdentifier:@"TicketOrderDetailsCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
#pragma mark - 退改签规则
- (void)endorseBackRulesClick {
    EndorseBackRulesVC  *tankTypeVC = [EndorseBackRulesVC new];
    [tankTypeVC reloadData:self.ruleResult];
    tankTypeVC.modalPresentationStyle = 4;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:tankTypeVC animated:YES completion:nil];
    
    
    
}

#pragma mark - 提交申请
- (IBAction)submitApplicationClick:(id)sender {
    
    if (!self.selectedReasonResult) {
        [self showProgress:@"请选择改签原因"];
        return;
    }
    
    if (self.isEndorse) {
        
        
        //    private String changeFee;//改签费
//        private String shouldBackFee;//升舱费
        
        
        NSMutableDictionary *allDic = [NSMutableDictionary new];
//        NSString *oldPerson = [Untils arrayToJSONString:self.allPerson];
//        NSString *oldPerson = self.allPerson;
        NSMutableArray *oldAllPerson = [NSMutableArray new];
        for (NSDictionary *dic in self.allPerson) {
            NSMutableDictionary *oldPerDic = [NSMutableDictionary new];
            oldPerDic = [dic mutableCopy];
            [oldPerDic setObject:dic[@"cabinCode"] forKey:@"seatCode"];
            [oldPerDic setObject:dic[@"backState"] forKey:@"isBack"];
            [oldAllPerson addObject:oldPerDic];
        }
        
        // 旧数据
        [allDic setObject:oldAllPerson forKey:@"backOrderPersonDetail"];
        // 费用
        NSMutableArray *backcontRequestArr = [NSMutableArray new];
        
        NSMutableDictionary *goBackcontRequestDic = [NSMutableDictionary new];
        goBackcontRequestDic = [self.selEndorseTicketDic[@"goSpacePolicyInfo"] mutableCopy];
        [goBackcontRequestDic setObject:@"0" forKey:@"backState"];
        [backcontRequestArr addObject:goBackcontRequestDic];
        if (self.endorseInfo.backState == 2) {
            NSMutableDictionary *backBackcontRequestDic = [NSMutableDictionary new];
            backBackcontRequestDic = [self.selEndorseTicketDic[@"backSpacePolicyInfo"] mutableCopy];
            [backBackcontRequestDic setObject:@"1" forKey:@"backState"];
            
            [backcontRequestArr addObject:backBackcontRequestDic];
        }
        
        // 新数据
        NSMutableArray *orderPersonDetailArr = [NSMutableArray new];
        for (NSDictionary *dic in self.goPersonArr) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            dict = [self.selEndorseTicketDic[@"goFlightsInfo"] mutableCopy];
            [dict setObject:dict[@"beginTimeOrigin"] forKey:@"beginTime"];
            [dict setObject:dict[@"endTimeOrigin"] forKey:@"endTime"];

            
            [dict setObject:dic[@"flightPersonId"] forKey:@"flightPersonId"];

            [dict setObject:dict[@"beginAirPortName"] forKey:@"depairPortch"];
            [dict setObject:dict[@"endAirPortName"] forKey:@"arrairPortch"];
            [dict setObject:dict[@"airlineCode"] forKey:@"aircode"];
            [dict setObject:dict[@"airlineCompany"] forKey:@"airCompany"];
            [dict setObject:dict[@"isSharing"] forKey:@"isShare"];
            [dict setObject:dict[@"planeType"] forKey:@"planeCode"];
            [dict setObject:dict[@"fromterminal"] forKey:@"fromTerminal"];
            [dict setObject:dict[@"arrterminal"] forKey:@"arrTerminal"];
            
            [dict setObject:@"0" forKey:@"isBack"];
            [dict setObject:backcontRequestArr[0][@"cabinCode"] forKey:@"seatCode"];
            [dict setObject:backcontRequestArr[0][@"discount"] forKey:@"discount"];
            [orderPersonDetailArr addObject:dict];
        }
        if (self.endorseInfo.backState == 2) {
            for (NSDictionary *dic in self.backPersonArr) {
                NSMutableDictionary *dict = [NSMutableDictionary new];
                dict = [self.selEndorseTicketDic[@"backFlightsInfo"] mutableCopy];
                [dict setObject:@"1" forKey:@"isBack"];
                [dict setObject:dic[@"flightPersonId"] forKey:@"flightPersonId"];
                [dict setObject:backcontRequestArr[1][@"cabinCode"] forKey:@"seatCode"];
                [dict setObject:backcontRequestArr[1][@"discount"] forKey:@"discount"];
                
                [dict setObject:dict[@"beginAirPortName"] forKey:@"depairPortch"];
                [dict setObject:dict[@"endAirPortName"] forKey:@"arrairPortch"];
                [dict setObject:dict[@"airlineCode"] forKey:@"aircode"];
                [dict setObject:dict[@"airlineCompany"] forKey:@"airCompany"];
                [dict setObject:dict[@"isSharing"] forKey:@"isShare"];
                [dict setObject:dict[@"planeType"] forKey:@"planeCode"];
                [dict setObject:dict[@"fromterminal"] forKey:@"fromTerminal"];
                [dict setObject:dict[@"arrterminal"] forKey:@"arrTerminal"];
                
                [orderPersonDetailArr addObject:dict];
            }
        }
//        [allDic setObject:[Untils arrayToJSONString:orderPersonDetailArr] forKey:@"OrderPersonDetail"];
//        [allDic setObject:[Untils arrayToJSONString:backcontRequestArr] forKey:@"backcontRequest"];
        [allDic setObject:orderPersonDetailArr forKey:@"OrderPersonDetail"];
//        [allDic setObject:backcontRequestArr forKey:@"backcontRequest"];
        /**原订单ID*/
        if ([[NSString stringWithFormat:@"%@",self.endorseInfo.source] isEqualToString:@"2"]) {
            [allDic setObject:self.endorseInfo.superiorId forKey:@"orderId"];
        } else {
            [allDic setObject:self.endorseInfo.orderId forKey:@"orderId"];
            
        }
        /**改签原因*/
        [allDic setObject:self.selectedReasonResult[@"refundReasonText"] forKey:@"changeReason"];
        /**改签原因Id*/
        [allDic setObject:self.selectedReasonResult[@"keyID"] forKey:@"changeReasonId"];
        /**商家订单号*/
        [allDic setObject:self.endorseInfo.businessCode forKey:@"businessCode"];
        /**token*/
         [allDic setObject:kToken forKey:@"token"];
        /**单程往返标识*/
        [allDic setObject:[NSString stringWithFormat:@"%ld",self.endorseInfo.orderType] forKey:@"orderType"];
        [allDic setObject:self.endorseInfo.source forKey:@"source"];
//        if (self.endorseInfo.orderType == 2) {
//            /**返程商家订单号*/
//            [allDic setObject:self.endorseInfo.backBusinessCode forKey:@"backBusinessCode"];
//        }
        NSLog(@"------kPlaneQueryAPPChangeTicketDetail----URL------------%@",allDic);
        [TicketEndorseInfo asyncPostPlaneQueryAPPChangeTicketDetailDic:allDic SuccessBlock:^(NSDictionary *dataDic) {
            NSString *URL = [NSString stringWithFormat:@"%@?token=%@&id=%@&changeOrderCode=%@",kURL_ApplyDetails,kToken,dataDic[@"id"],dataDic[@"changeOrderCode"]];
            NSLog(@"----------URL------------  %@",URL);
            ZJPersonalCenterWebVC *webVC = [[ZJPersonalCenterWebVC alloc] initWithURL:URL];
            [self.navigationController pushViewController:webVC animated:YES];
        } errorBlock:^(NSError *errorResult) {
        }];
    }
}


#pragma mark - TableViewDelegate & TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isOneWay) {
        return 3;
    } else {
        if (self.isEndorse && (self.endorseInfo.backState == 0 || self.endorseInfo.backState == 1)) {
            return 4;
        }
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isOneWay) {
        switch (section) {
            case 0: {
                if (self.allPerson.count==0) {
                    return 1;
                } else {
                    return self.allPerson.count;
                }
            }
                break;
            case 1: {
                return 1;
            }
                break;
            case 2: {
                return 2;
            }
                break;
                
            default:
                break;
        }
    } else {
        if (self.isEndorse && self.endorseInfo.backState == 0) {
            switch (section) {
                case 0: {
                    return 0;
                }
                    break;
                case 1:{
                    if (self.goPersonArr.count==0) {
                        return 1;
                    } else {
                        return self.goPersonArr.count;
                    }
                }
                    break;
                case 2: {
                    return 1;
                }
                    break;
                case 3: {
                    return 2;
                    
                }
                    break;
                default:
                    break;
            }
        } else if(self.isEndorse && self.endorseInfo.backState == 1) {
            switch (section) {
                case 0: {
                    return 0;
                }
                    break;
                case 1:{
                    if (self.backPersonArr.count==0) {
                        return 1;
                    } else {
                        return self.backPersonArr.count;
                    }
                }
                case 2: {
                    return 1;
                }
                    break;
                case 3: {
                    return 2;
                }
                    break;
                default:
                    break;
            }
        } else {
        switch (section) {
            case 0: {
                return 0;
            }
                break;
            case 1:{
                if (self.goPersonArr.count==0) {
                    return 1;
                } else {
                    return self.goPersonArr.count;
                }
            }
            case 2: {
                if (self.backPersonArr.count==0) {
                    return 1;
                } else {
                    return self.backPersonArr.count;
                }
            }
                break;
            case 3: {
                return 1;
            }
                break;
            case 4: {
                if (!self.isEndorse) {
                    return 1;
                } else {
                    return 4;
                }
            }
                break;
            default:
                break;
        }
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return PXChange(90);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(90))];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *colorPieceView = [[UIView alloc] initWithFrame:CGRectMake(0, PXChange(30), PXChange(6), PXChange(30))];
    colorPieceView.backgroundColor = kColorAppGreen;
    [headerView addSubview:colorPieceView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth-PXChange(230), 0, PXChange(230), headerView.height-1);
    [btn setTitle:@"退改签规则 " forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#6A6A6A"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFont_PingFangSC size:PXChange(26)];
    [btn setImage:[UIImage imageNamed:@"提示"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(endorseBackRulesClick) forControlEvents:UIControlEventTouchUpInside];
    btn.hidden = YES;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.size.width, 0, btn.imageView.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
    [headerView addSubview:btn];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PXChange(30), 0, ScreenWidth-PXChange(60) - PXChange(230), headerView.height-1)];
    label.textColor = [UIColor colorWithHexString:@"#6A6A6A"];
    label.font = [UIFont fontWithName:kFont_PingFangSC size:PXChange(30)];
    
    if (self.isOneWay) {
        if (section == 0) {
            label.text = @"第一步：选择改签乘机人";
        } else if (section == 1) {
            label.text = @"第二步：选择改签原因";
        } else if (section == 2) {
            label.text = @"第三步：选择改签航班";
            btn.hidden = NO;
        }
    } else if (self.isEndorse && self.endorseInfo.backState == 0 ) {
        if (section == 0) {
            label.text = @"第一步：选择改签乘机人";
        } else if (section == 1) {
            label.text = @"去";
        } else if (section == 2) {
            label.text = @"第二步：选择改签原因";
        } else if (section == 3) {
            label.text = @"第三步：选择改签航班";
            btn.hidden = NO;
        }
    } else if (self.isEndorse && self.endorseInfo.backState == 1 ) {
        if (section == 0) {
            label.text = @"第一步：选择改签乘机人";
        } else if (section == 1) {
            label.text = @"返";
        } else if (section == 2) {
            label.text = @"第二步：选择改签原因";
        } else if (section == 3) {
            label.text = @"第三步：选择改签航班";
            btn.hidden = NO;
        }
    }
    else {
        if (section == 0) {
            label.text = @"第一步：选择改签乘机人";
        } else if (section == 1) {
            label.text = @"去";
        } else if (section == 2) {
            label.text = @"返";
        } else if (section == 3) {
            label.text = @"第二步：选择改签原因";
        } else if (section == 4) {
            label.text = @"第三步：选择改签航班";
            btn.hidden = NO;
        }
    }
    
    [headerView addSubview:label];
    
    UIView *lineView = [[UILabel alloc] initWithFrame:CGRectMake(PXChange(30), headerView.height-1, ScreenWidth-PXChange(60), 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    [headerView addSubview:lineView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ((self.isOneWay && (section==0 || section == 1)) || (!self.isOneWay && (section==2 || section == 3))) {
        return PXChange(20);
    }
        return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
    if ((self.isOneWay && (section==0 || section == 1)) || (!self.isOneWay && (section==2 || section == 3))) {
        footerView.frame = CGRectMake(0, 0, ScreenWidth, PXChange(20));
        footerView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    }
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.isOneWay && indexPath.section==0) || (!self.isOneWay && (indexPath.section==1 || indexPath.section==2))) {
        return 37;
    } else if (self.isEndorse && ((self.endorseInfo.backState==3&&indexPath.section==2&&indexPath.row==1)||((self.endorseInfo.backState==0||self.endorseInfo.backState==1)&&indexPath.section==3&&indexPath.row==1)||(self.endorseInfo.backState==2&&indexPath.section==4&&(indexPath.row==1||indexPath.row==3)) ) ) {
        return 218;
    } else if ((self.isOneWay && indexPath.section==1) || (!self.isOneWay && indexPath.section==3)) {
        return 44;
    } else if ((self.isOneWay && indexPath.section==2)||(!self.isOneWay && indexPath.section==4)) {
        return 44;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ((!self.isEndorse&&((self.isOneWay && indexPath.section==0) || (!self.isOneWay && (indexPath.section==1 || indexPath.section==2)))) || (self.isEndorse && (((self.endorseInfo.backState==0||self.endorseInfo.backState==1)&&indexPath.section==1)||((indexPath.section==1||indexPath.section==2)&&self.endorseInfo.backState==2)||(indexPath.section==0&&self.endorseInfo.backState==3)))) {
#pragma mark - 乘机人展示
        EndorsePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndorsePersonCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.allPerson.count == 0) {
            cell.nameLabel.text = @"暂无可改签人";
            cell.statusImageView.hidden = YES;
        } else {
            NSDictionary *dic = [NSDictionary new];
            if (self.isOneWay) {
                dic = self.allPerson[indexPath.row];
            } else {
                if (!self.isEndorse || (self.isEndorse&&self.endorseInfo.backState==2)) {
                    if (indexPath.section == 1) {
                        dic = self.goPersonArr[indexPath.row];
                    } else {
                        dic = self.backPersonArr[indexPath.row];
                    }
                } else {
                    if (self.endorseInfo.backState==0) {
                        dic = self.goPersonArr[indexPath.row];
                    } else {
                        dic = self.backPersonArr[indexPath.row];
                    }
                }
            }
            cell.nameLabel.text = dic[@"personName"];
            // 1是儿童 2 是成人 0 是婴儿
            NSInteger persontype = [dic int64ValueForKey:@"personType"];
            if (persontype == 0) {
                cell.ageLabel.text = @"(婴儿)";
            } else if (persontype == 1) {
                cell.ageLabel.text = @"(儿童)";
            } else if (persontype == 2) {
                cell.ageLabel.text = @"(成人)";
            }
            if (self.isEndorse) {
                cell.statusImageView.hidden = YES;
            } else {
                cell.statusImageView.hidden = NO;
                if ([dic[@"isSelect"] isEqualToString:@"0"]) {
                    cell.statusImageView.image = [UIImage imageNamed:@"selectflight_uncheck"];
                } else {
                    cell.statusImageView.image = [UIImage imageNamed:@"selectflight_check"];
                }
            }
        }
        return cell;

    } else if ((!self.isEndorse&&((self.isOneWay&&indexPath.section==1)||(!self.isOneWay && indexPath.section==3))) || (self.isEndorse &&(((self.endorseInfo.backState==0||self.endorseInfo.backState==1)&&indexPath.section==2)||(self.endorseInfo.backState==2&&indexPath.section==3)||(self.endorseInfo.backState==3&&indexPath.section==1)))) {
#pragma mark - 改签理由展示
        EndorseWhyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndorseWhyCell" forIndexPath:indexPath];
        if (self.selectedReasonResult) {
            cell.originallyLabel.text = self.selectedReasonResult[@"refundReasonText"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else  {
#pragma mark - 改签航班展示
        if (self.isOneWay) {
            if (indexPath.row == 0) {
                EndorseTicketHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndorseTicketHeaderCell" forIndexPath:indexPath];
                if (self.allPerson.count > 0) {
                    cell.timerLabel.text = [Untils getMMDDWeekFormatDate:[Untils dateFormString:[[self.allPerson firstObject] objectOrNilForKey:@"btime"]]];
                    if ([[[self.allPerson firstObject] objectOrNilForKey:@"positionsType"] isEqualToString:@"1"]) {
                        cell.cabinTypeLabel.text = @"经济舱";
                    } else {
                        cell.cabinTypeLabel.text = @"头等舱";
                    }
                    cell.typeLabel.text = @" 原 ";
                    cell.typeLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                    cell.typeLabel.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
                    
                    cell.flightNumLabel.text = [self.orderDic[@"airlineCompany"] stringByAppendingString:self.orderDic[@"flightNumber"]];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } else {
                if (!self.isEndorse) {
                    EndorseSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndorseSelectCell" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                } else {
                    TicketOrderDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketOrderDetailsCell" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell refreshData:self.goSearchFlightsInfo type:@"改"];
                    cell.dataDic = self.selEndorseTicketDic[@"goSpacePolicyInfo"];
                    return cell;
                }
            }
        } else {
            if (self.endorseInfo.backState == 0 && self.isEndorse) {
                // 去 后
                if (indexPath.row==0) {
                    EndorseTicketHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndorseTicketHeaderCell" forIndexPath:indexPath];
                    cell.timerLabel.text = [Untils getMMDDWeekFormatDate:[Untils dateFormString:[[self.allPerson firstObject] objectOrNilForKey:@"btime"]]];
                    if ([[[self.allPerson firstObject] objectOrNilForKey:@"positionsType"] isEqualToString:@"1"]) {
                        cell.cabinTypeLabel.text = @"经济舱";
                    } else {
                        cell.cabinTypeLabel.text = @"头等舱";
                    }
                    cell.typeLabel.layer.borderWidth = 1;
                    cell.typeLabel.layer.borderColor = [UIColor colorWithHexString:@"#008C4E"].CGColor;
                    cell.typeLabel.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
                    cell.typeLabel.text = @" 原去程 ";
                    cell.cabinTypeLabel.text = [[self.goPersonArr firstObject] objectOrNilForKey:@"airlineCompany"];
                    cell.flightNumLabel.text = [[self.goPersonArr firstObject] objectOrNilForKey:@"flightNumber"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                } else {
                    TicketOrderDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketOrderDetailsCell" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell refreshData:self.goSearchFlightsInfo type:@"改"];
                    cell.dataDic = self.selEndorseTicketDic[@"goSpacePolicyInfo"];
                    return cell;
                }
            } else if (self.endorseInfo.backState == 1 && self.isEndorse) {
                // 返 后
                if (indexPath.row==0) {
                    EndorseTicketHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndorseTicketHeaderCell" forIndexPath:indexPath];
                    cell.timerLabel.text = [Untils getMMDDWeekFormatDate:[Untils dateFormString:[[self.allPerson firstObject] objectOrNilForKey:@"btime"]]];
                    if ([[[self.allPerson firstObject] objectOrNilForKey:@"positionsType"] isEqualToString:@"1"]) {
                        cell.cabinTypeLabel.text = @"经济舱";
                    } else {
                        cell.cabinTypeLabel.text = @"头等舱";
                    }
                    cell.typeLabel.layer.borderWidth = 1;
                    cell.typeLabel.layer.borderColor = [UIColor colorWithHexString:@"#008C4E"].CGColor;
                    cell.typeLabel.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
                    cell.typeLabel.text = @" 原返程 ";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.cabinTypeLabel.text = [[self.backPersonArr firstObject] objectOrNilForKey:@"airlineCompany"];
                    cell.flightNumLabel.text = [[self.backPersonArr firstObject] objectOrNilForKey:@"flightNumber"];
                    return cell;
                } else {
                    TicketOrderDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketOrderDetailsCell" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell refreshData:self.goSearchFlightsInfo type:@"改"];
                    cell.dataDic = self.selEndorseTicketDic[@"goSpacePolicyInfo"];
                    return cell;
                }
            } else if (self.endorseInfo.backState == 2 && self.isEndorse) {
                // 往返 后
                if (indexPath.row==0 || indexPath.row==2) {
                    EndorseTicketHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndorseTicketHeaderCell" forIndexPath:indexPath];
                    cell.timerLabel.text = [Untils getMMDDWeekFormatDate:[Untils dateFormString:[[self.allPerson firstObject] objectOrNilForKey:@"btime"]]];
                    if ([[[self.allPerson firstObject] objectOrNilForKey:@"positionsType"] isEqualToString:@"1"]) {
                        cell.cabinTypeLabel.text = @"经济舱";
                    } else {
                        cell.cabinTypeLabel.text = @"头等舱";
                    }
                    cell.typeLabel.layer.borderWidth = 1;
                    cell.typeLabel.layer.borderColor = [UIColor colorWithHexString:@"#008C4E"].CGColor;
                    cell.typeLabel.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
                    if (indexPath.row == 0) {
                        cell.cabinTypeLabel.text = [[self.goPersonArr firstObject] objectOrNilForKey:@"airlineCompany"];
                        cell.flightNumLabel.text = [[self.goPersonArr firstObject] objectOrNilForKey:@"flightNumber"];
                        cell.typeLabel.text = @" 原去程 ";
                    } else {
                        cell.cabinTypeLabel.text = [[self.backPersonArr firstObject] objectOrNilForKey:@"airlineCompany"];
                        cell.flightNumLabel.text = [[self.backPersonArr firstObject] objectOrNilForKey:@"flightNumber"];
                        cell.typeLabel.text = @" 原返程 ";
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                } else {
                    TicketOrderDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketOrderDetailsCell" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if (indexPath.row == 1) {
                        [cell refreshData:self.goSearchFlightsInfo type:@"改"];
                        cell.dataDic = self.selEndorseTicketDic[@"goSpacePolicyInfo"];
                    } else {
                        [cell refreshData:self.backSearchFlightsInfo type:@"改"];
                        cell.dataDic = self.selEndorseTicketDic[@"backSpacePolicyInfo"];
                    }
                    return cell;
                }
            } else {
                EndorseSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndorseSelectCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isEndorse&&(!self.isEditing && self.isOneWay && indexPath.section==2 && indexPath.row==1)) {
#pragma mark - 跳转单程
        NSMutableArray *selectArr = [NSMutableArray new];
        for (NSDictionary *dic in self.allPerson) {
            if ([dic[@"isSelect"] isEqualToString:@"1"]) {
                [selectArr addObject:dic];
            }
        }
        
        if (selectArr.count>0) {
            NSMutableDictionary *endDic = [NSMutableDictionary new];
            [endDic setObject:selectArr forKey:@"selectPersons"];
            if (self.selectedReasonResult) {
                [endDic setObject:self.selectedReasonResult forKey:@"selectedReasonResult"];
            }
            [endDic setObject:self.reasonResult forKey:@"reasonResult"];
            [endDic setObject:self.ruleResult forKey:@"ruleResult"];
            [endDic setObject:self.orderDic forKey:@"order"];
            TicketEndorseInfo *endorseInfo = [TicketEndorseInfo getTicketEndorseInfo:endDic];
            endorseInfo.backState = 3;
            endorseInfo.orderType = 1;
            [self oneWayAction:endorseInfo];
            
        } else {
            [self showProgress:@"请选择乘机人"];
            return;
        }
        
    } else if (!self.isEndorse && !self.isOneWay && indexPath.section==4 && indexPath.row==0) {
#pragma mark - 跳转往返
        NSMutableArray *selectArr = [NSMutableArray new];
        for (NSDictionary *dic in self.goPersonArr) {
            if ([dic[@"isSelect"] isEqualToString:@"1" ]) {
                [selectArr addObject:dic];
            }
        }
        for (NSDictionary *dic in self.backPersonArr) {
            if ([dic[@"isSelect"] isEqualToString:@"1" ]) {
                [selectArr addObject:dic];
            }
        }
        
        if (selectArr.count>0) {
            NSMutableDictionary *endDic = [NSMutableDictionary new];
            [endDic setObject:selectArr forKey:@"selectPersons"];
            if (self.selectedReasonResult) {
                [endDic setObject:self.selectedReasonResult forKey:@"selectedReasonResult"];
            }
            [endDic setObject:self.reasonResult forKey:@"reasonResult"];
            [endDic setObject:self.ruleResult forKey:@"ruleResult"];
            [endDic setObject:self.orderDic forKey:@"order"];
            TicketEndorseInfo *endorseInfo = [TicketEndorseInfo getTicketEndorseInfo:endDic];
            endorseInfo.orderType = 2;
            for (NSDictionary *dic in self.allPerson) {
                if ([dic int64ValueForKey:@"backState"] == 1) {
                    endorseInfo.backBeginTime = dic[@"bTime"];
                }
            }
            BOOL isGo = NO;
            BOOL isBack = NO;
            for (NSDictionary *dict in selectArr) {
                if ([dict int64ValueForKey:@"backState"] == 0) {
                    isGo = YES;
                }
                if ([dict int64ValueForKey:@"backState"] == 1) {
                    isBack = YES;
                }
            }
            if (isGo && isBack) {
                endorseInfo.backState = 2;
                [self backForthAction:endorseInfo];
            } else if (isGo && !isBack) {
                endorseInfo.backState = 0;
                [self oneWayAction:endorseInfo];
            } else if (!isGo && isBack) {
                endorseInfo.backState = 1;
                [self oneWayAction:endorseInfo];
            }
            
        } else {
            [self showProgress:@"请选择乘机人"];
            return;
        }
    } else if ((self.isOneWay && indexPath.section==0) || (!self.isOneWay && (indexPath.section==1 || indexPath.section==2))) {
#pragma mark - 乘机人选择
        if (self.isEndorse) {
            return;
        }
        if (self.allPerson.count==0) {
            return;
        }
        NSDictionary *dic = [NSDictionary new];
        if (self.isOneWay) {
            dic = self.allPerson[indexPath.row];
        } else {
            if (indexPath.section == 1) {
                dic = self.goPersonArr[indexPath.row];
            } else {
                dic = self.backPersonArr[indexPath.row];
            }
        }
        
        EndorsePersonCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
        NSString *sele = @"";
        if ([dic[@"isSelect"] isEqualToString:@"0"]) {
            sele = @"1";
            cell.statusImageView.image = [UIImage imageNamed:@"selectflight_check"];
        } else {
            sele = @"0";
            cell.statusImageView.image = [UIImage imageNamed:@"selectflight_uncheck"];
        }
        NSMutableDictionary *mDic = [NSMutableDictionary new];
        mDic = [dic mutableCopy];
        [mDic setObject:sele forKey:@"isSelect"];
        if (self.isOneWay) {
            [self.allPerson replaceObjectAtIndex:indexPath.row withObject:mDic];
        } else {
            if (indexPath.section == 1) {
                [self.goPersonArr replaceObjectAtIndex:indexPath.row withObject:mDic];
            } else {
                [self.backPersonArr replaceObjectAtIndex:indexPath.row withObject:mDic];
            }
        }
    } else if ((!self.isEndorse&&((self.isOneWay&&indexPath.section==1)||(!self.isOneWay && indexPath.section==3))) || (self.isEndorse &&(((self.endorseInfo.backState==0||self.endorseInfo.backState==1)&&indexPath.section==2)||(self.endorseInfo.backState==2&&indexPath.section==3)||(self.endorseInfo.backState==3&&indexPath.section==1)))) {
#pragma mark - 改签理由选择
        dispatch_async(dispatch_get_main_queue(), ^{
            EndorseSelectWhyVC  *whyVC = [EndorseSelectWhyVC new];
            whyVC.dataArray = [self.reasonResult copy];
            if (self.selectedReasonResult) {
                whyVC.selectedReasonResult = self.selectedReasonResult;
            }
            whyVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
            whyVC.modalPresentationStyle = 4;
            WS(ws)
            whyVC.endorseSelectWhy = ^(NSDictionary *dic) {
                ws.selectedReasonResult = [dic copy];
                [self.tableView reloadData];
            };
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.window.rootViewController presentViewController:whyVC animated:YES completion:nil];
        });
    }
    
}

// 单程
- (void)oneWayAction:(TicketEndorseInfo *)endorseInfo {
    OneWayCalendarChooseVC *oneVC = [OneWayCalendarChooseVC new];
    oneVC.oneWayType = OneWayTypeTicketEndorse;
    endorseInfo.orderId = self.orderId;
    endorseInfo.businessCode = self.businessCode;
    endorseInfo.orderCode = self.orderCode;
    endorseInfo.source = self.source;
    if ([self.endorseDic int64ValueForKey:@"source"] == 2) {
        endorseInfo.superiorId = self.endorseDic[@"superiorId"];
    }
    oneVC.endorseInfo = endorseInfo;
    if (endorseInfo.backState == 1) {
        oneVC.selectDate = endorseInfo.beginTime;
    } else {
        oneVC.selectDate = endorseInfo.backBeginTime;
    }
    [self.navigationController pushViewController:oneVC animated:YES];
}

// 往返
- (void)backForthAction:(TicketEndorseInfo *)endorseInfo {
    BackForthCalendarChooseVC *backVC = [BackForthCalendarChooseVC new];
    backVC.backForthType = BackForthTypeTicketEndorse;
    endorseInfo.orderId = self.orderId;
    endorseInfo.businessCode = self.businessCode;
    endorseInfo.backBusinessCode = self.backBusinessCode;
    endorseInfo.orderCode = self.orderCode;
    endorseInfo.source = self.source;
    if ([self.endorseDic int64ValueForKey:@"source"] == 2) {
        endorseInfo.superiorId = self.endorseDic[@"superiorId"];
    }
    backVC.endorseInfo = endorseInfo;
    backVC.isforth = YES;
    backVC.fortdate = [Untils dateFormString:endorseInfo.beginTime];
    backVC.baceDate = [Untils dateFormString:endorseInfo.backBeginTime];
    [self.navigationController pushViewController:backVC animated:YES];
}

- (void)onBackBarBtnClick {
    BOOL isPop = NO;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        // 找到相应的控制器
        
        if ([controller isKindOfClass:[ZJPersonalCenterWebVC class]]) {
            isPop = YES;
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    if (!isPop) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ZJPersonalCenterViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    } else {
        BOOL isPop = NO;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            // 找到相应的控制器
            
            if ([controller isKindOfClass:[ZJPersonalCenterWebVC class]]) {
                isPop = YES;
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        if (!isPop) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ZJPersonalCenterViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }
        return YES;
    }
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
