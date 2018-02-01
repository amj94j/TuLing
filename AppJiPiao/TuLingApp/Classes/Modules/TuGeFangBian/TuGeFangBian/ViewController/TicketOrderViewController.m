//
//  TicketOrderViewController.m
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketOrderViewController.h"
#import "TicketOrderDetailsCell.h"
#import "TicketOrderCell.h"
#import "SelectFlightViewController.h"
#import "SelectReturnCell.h"
#import "TicketOrderModel.h"
#import "EndorseBackRulesVC.h"
#import "TicketInsuranceModel.h"
#import "TicketOrderCommitViewController.h"
#import "EndorseBackRulesModel.h"
#import "EndorseViewController.h"
#import "TicketEndorseFlightInfo.h"
#import "ShowFlightInforView.h"
@interface TicketOrderViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TicketOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.ticketOrderType == TicketOrderTicketEndorse) {
        if (self.endorseInfo.backState == 0) {
            [self addCustomTitleWithTitle:@"可改签去程舱位"];
        } else if (self.endorseInfo.backState == 1) {
            [self addCustomTitleWithTitle:@"可改签返程舱位"];
        } else if (self.tickeModel.orderType == 1)  {
            [self layoutNavigationItemViewGo:self.tickeModel.beginCity.name back:self.tickeModel.endCity.name];
        } else {
            if (self.endorseInfo.backState == 2 && self.tickeModel.isGo) {
                [self addCustomTitleWithTitle:@"可改签去程舱位"];
            } else if (self.endorseInfo.backState == 2 && !self.tickeModel.isGo) {
                [self addCustomTitleWithTitle:@"可改签返程舱位"];
            } else {
                [self addCustomTitleWithTitle:@"可改签舱位"];
            }
        }
    } else {
        if (self.tickeModel.orderType == 2) {
            if (self.tickeModel.isGo) {
                [self addCustomTitleWithTitle:@"选去程舱位"];
            } else {
                [self addCustomTitleWithTitle:@"选返程舱位"];
            }
        } else if (self.tickeModel.orderType == 1)  {
            [self layoutNavigationItemViewGo:self.tickeModel.beginCity.name back:self.tickeModel.endCity.name];
        }
    }
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"TicketOrderDetailsCell" bundle:nil] forCellReuseIdentifier:@"TicketOrderDetailsCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TicketOrderCell" bundle:nil] forCellReuseIdentifier:@"TicketOrderCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SelectReturnCell" bundle:nil] forCellReuseIdentifier:@"SelectReturnCell"];
    }
    return _tableView;
}

- (void)setDataArr:(NSArray *)dataArr {
    if (![_dataArr isEqualToArray:dataArr] || _dataArr != dataArr) {
        _dataArr = [dataArr copy];
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

- (void)setSearchFlightsInfo:(SearchFlightsModel *)searchFlightsInfo {
    if (!_searchFlightsInfo) {
        _searchFlightsInfo = [SearchFlightsModel new];
    }
    if (![_searchFlightsInfo isEqual:searchFlightsInfo] || _searchFlightsInfo != searchFlightsInfo) {
        _searchFlightsInfo = searchFlightsInfo;
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
    return self.dataArr.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tickeModel.orderType == 2 && !self.tickeModel.isGo && section ==0){
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return PXChange(15);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(15))];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.tickeModel.orderType == 2 && !self.tickeModel.isGo && indexPath.row ==0){
            return 45;
        } else {
            if (self.searchFlightsInfo.realCompany.length>0) {
                return PXChange(442);
            } else {
                return PXChange(442-63);
            }
        }
    }
    return PXChange(144);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = nil;
        if (self.tickeModel.orderType == 2 && !self.tickeModel.isGo && indexPath.row == 0) {
            cell = (SelectReturnCell *)[tableView dequeueReusableCellWithIdentifier:@"SelectReturnCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [(SelectReturnCell *)cell refreshData:self.goSearchFlightsInfo];

        } else {
            cell = (TicketOrderDetailsCell *)[tableView dequeueReusableCellWithIdentifier:@"TicketOrderDetailsCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [(TicketOrderDetailsCell *)cell cabinTypeLabel].hidden = YES;
            if (self.tickeModel.orderType == 2) {
                if (self.tickeModel.isGo) {
                    [(TicketOrderDetailsCell *)cell refreshData:self.searchFlightsInfo type:@"去"];
                } else {
                    [(TicketOrderDetailsCell *)cell refreshData:self.searchFlightsInfo type:@"返"];
                }
            } else {
                [(TicketOrderDetailsCell *)cell refreshData:self.searchFlightsInfo type:@""];
            }
        }
        return cell;
    } else {
        TicketOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketOrderCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        TicketSpacePolicyModel *ticketSpacePolicyModel = [TicketSpacePolicyModel new];
        NSDictionary *ticketOrderEndorseDic = [NSDictionary new];
        if (self.ticketOrderType == TicketOrderTicketEndorse) {
            ticketOrderEndorseDic = self.dataArr[indexPath.section-1];
            [cell reloadDataDic:ticketOrderEndorseDic];
        } else {
            ticketSpacePolicyModel = self.dataArr[indexPath.section-1];
            [cell reloadData:ticketSpacePolicyModel];
        }
        WS(ws)
        cell.bookingActionBlock = ^{
            // 点击订票
            NSInteger seatNum;
            if (self.ticketOrderType == TicketOrderTicketEndorse) {
                seatNum = [[NSString stringWithFormat:@"%@", ticketOrderEndorseDic[@"surplusCabinNumber"]] integerValue];
            } else {
                seatNum = ticketSpacePolicyModel.belongSpcaceModel.seatnum;
            }
            if (seatNum == 0) {
                [self showProgress:@"当前舱位余票不足"];
                return;
            }
            NSLog(@"点击订票----%ld", indexPath.section - 1);
            if (ws.ticketOrderType == TicketOrderEndorse) {
                [self EndorseJumpVUEAtIndexPath:indexPath];
            } else if (ws.ticketOrderType == TicketOrderTicketEndorse) {
                [self EndorseJumpIndexPath:indexPath];
            } else {
                [self goOrderPageAtIndexPath:indexPath];
            }
            
        };
        
        
        cell.backToRuleActionBlock = ^{
            NSLog(@"点----=====%ld",indexPath.section);
            NSMutableDictionary *dic = [NSMutableDictionary new];
            WS(ws)
            [dic setObject:ws.searchFlightsInfo.airlineCode forKey:@"carrier"];
            [dic setObject:ws.searchFlightsInfo.flightNumber forKey:@"flightNo"];
            if (self.ticketOrderType == TicketOrderTicketEndorse) {
                [dic setObject:ticketOrderEndorseDic[@"cabinCode"] forKey:@"seatClass"];
                [dic setObject:ticketOrderEndorseDic[@"freight"][@"highPrice"] forKey:@"ticketParsPrice"];
            } else {
                [dic setObject:ticketSpacePolicyModel.belongSpcaceModel.seatcode forKey:@"seatClass"];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)ticketSpacePolicyModel.belongSpcaceModel.ticketprice] forKey:@"ticketParsPrice"];
            }
            
            [dic setObject:ws.searchFlightsInfo.beginCity forKey:@"formCity"];
            [dic setObject:ws.searchFlightsInfo.endCity forKey:@"toCity"];
            [dic setObject:ws.searchFlightsInfo.bTime forKey:@"takeOffDate"];
            [dic setObject:kToken forKey:@"token"];
            if (ws.searchFlightsInfo.flightType == 1 || ws.searchFlightsInfo.flightType == 2) {
                [dic setObject:@"0" forKey:@"isOrderType"];
            } else if (ws.searchFlightsInfo.flightType == 3) {
                [dic setObject:@"1" forKey:@"isOrderType"];
            }
            [EndorseBackRulesModel asyncPostPlaneTicketRuleProDic:dic SuccessBlock:^(EndorseBackRulesModel *model) {
                EndorseBackRulesVC  *tankTypeVC = [EndorseBackRulesVC new];
                [tankTypeVC reloadData:model];
                tankTypeVC.modalPresentationStyle = 4;
                [ws presentViewController:tankTypeVC animated:NO completion:^{
                }];
            } errorBlock:^(NSError *errorResult) {
                
            }];
            
        };
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tickeModel.orderType == 2 && !self.tickeModel.isGo && indexPath.row == 0 && indexPath.section == 0) {
        ShowFlightInforView * flightInfoView = [[ShowFlightInforView alloc]initFlightInfoWithModel:self.goSearchFlightsInfo];
        
        [AppDelegateWindow addSubview:flightInfoView];
    }
}

// 去订单详情页面
- (void)goOrderPageAtIndexPath:(NSIndexPath *)indexPath {
    WS(ws)
    // 当前机票选择的舱位模型
    ws.searchFlightsInfo.spacePolicyModel = ws.dataArr[indexPath.section - 1];
    
    // 往返
    if (ws.tickeModel.orderType == 2) {
        
        __block SelectFlightViewController *selectFlightVC = [SelectFlightViewController new];
        if (ws.tickeModel.isGo) {
            ws.searchFlightsInfo.flightType = OrderFlightTypeWangFanGo;
            selectFlightVC.goSearchFlightsInfo = ws.searchFlightsInfo;
            ws.tickeModel.isGo = NO;
            ws.tickeModel.beginAirPortName = @"";
            ws.tickeModel.direct = @"";
            ws.tickeModel.endAirPort = @"";
            ws.tickeModel.planeSize = @"";
            ws.tickeModel.positionType = @"";
            ws.tickeModel.timeType = @"";
            ws.tickeModel.airCompany = @"";
            // 选返程机票
            [SearchFlightsModel asyncPostQueryFlightDeatilTicketModel:ws.tickeModel SuccessBlock:^(NSArray *dataArray) {
                selectFlightVC.tickeModel = ws.tickeModel;
                selectFlightVC.dataArray = dataArray;
                [ws.navigationController pushViewController:selectFlightVC animated:YES];
            } errorBlock:^(NSError *errorResult) {
                ws.tickeModel.isGo = YES;
            }];
            
        } else {
            ws.searchFlightsInfo.flightType = OrderFlightTypeWangFanBack;
            selectFlightVC.goSearchFlightsInfo = ws.goSearchFlightsInfo;
            
            // 去订单界面
            TicketOrderModel *orderModel = [[TicketOrderModel alloc] init];
            orderModel.goFlightModel = ws.goSearchFlightsInfo;
            orderModel.backFlightModel = ws.searchFlightsInfo;
            orderModel.ticketModel = ws.tickeModel;
            [ws goOrderCommitVCWithOrderModel:orderModel];
        }
    } else {
        ws.searchFlightsInfo.flightType = OrderFlightTypeDanCheng;
        // 单程
        TicketOrderModel *orderModel = [[TicketOrderModel alloc] init];
        orderModel.goFlightModel = ws.searchFlightsInfo;
        orderModel.ticketModel = ws.tickeModel;
        [ws goOrderCommitVCWithOrderModel:orderModel];
    }
}

// 改签去VUE
// 改签跳转到VUE页面
- (void)EndorseJumpVUEAtIndexPath:(NSIndexPath *)indexPath {
    WS(ws)
    ws.searchFlightsInfo.spacePolicyModel = ws.dataArr[indexPath.section - 1];
      NSMutableDictionary *allDic = [NSMutableDictionary new];
    // 往返
    if (ws.tickeModel.orderType == 2 && [ws.endorseModel.backState isEqualToString:@"2"]) {
        
        __block SelectFlightViewController *selectFlightVC = [SelectFlightViewController new];
        if (ws.tickeModel.isGo) {
            ws.searchFlightsInfo.flightType = OrderFlightTypeWangFanGo;
            selectFlightVC.goSearchFlightsInfo = ws.searchFlightsInfo;
            ws.tickeModel.isGo = NO;
            // 选返程机票
            [SearchFlightsModel asyncPostEndorseModel:ws.tickeModel backState:ws.endorseModel.backState SuccessBlock:^(NSArray *dataArray) {
                selectFlightVC.tickeModel = ws.tickeModel;
                selectFlightVC.dataArray = dataArray;
                selectFlightVC.endorseModel = self.endorseModel;
                selectFlightVC.selecFlightType = SelectFlightEndorse;
                [ws.navigationController pushViewController:selectFlightVC animated:YES];
            } errorBlock:^(NSError *errorResult) {
                ws.tickeModel.isGo = YES;
            }];
            
        } else {
            ws.searchFlightsInfo.flightType = OrderFlightTypeWangFanBack;
            selectFlightVC.goSearchFlightsInfo = ws.goSearchFlightsInfo;
            
            // 去订单界面
            TicketOrderModel *orderModel = [[TicketOrderModel alloc] init];
            orderModel.goFlightModel = ws.goSearchFlightsInfo;
            orderModel.backFlightModel = ws.searchFlightsInfo;
            orderModel.ticketModel = ws.tickeModel;
            
            NSMutableDictionary *goFlightsInfo = [[ws.goSearchFlightsInfo properties_aps] mutableCopy];
            [goFlightsInfo removeObjectForKey:@"spacePolicyModel"];
            [allDic setObject:goFlightsInfo forKey:@"goFlightsInfo"];
            
            NSMutableDictionary *goDic =  [[ws.goSearchFlightsInfo.spacePolicyModel.belongSpcaceModel properties_aps] mutableCopy];
            [goDic removeObjectForKey:@"policyModels"];
            [allDic setObject:goDic forKey:@"goSpacePolicyInfo"];
            
            NSMutableDictionary *backDic =  [[ws.searchFlightsInfo.spacePolicyModel.belongSpcaceModel properties_aps] mutableCopy];
            [backDic removeObjectForKey:@"policyModels"];
            [allDic setObject:backDic forKey:@"backSpacePolicyInfo"];
            
            NSMutableDictionary *backFlightsInfo = [[ws.searchFlightsInfo properties_aps] mutableCopy];
            [backFlightsInfo removeObjectForKey:@"spacePolicyModel"];
            [allDic setObject:backFlightsInfo forKey:@"backFlightsInfo"];
            
            [allDic setObject:self.endorseModel.oldEndorseDic forKey:@"oldEndorseDic"];
            [self goVUEWithOrderDic:allDic];
            
        }
        
        
    } else {
        ws.searchFlightsInfo.flightType = OrderFlightTypeDanCheng;
        
        // 单程
        NSMutableDictionary *goSpacePolicyInfo =  [[ws.searchFlightsInfo.spacePolicyModel.belongSpcaceModel properties_aps] mutableCopy];
        [goSpacePolicyInfo removeObjectForKey:@"policyModels"];
        [allDic setObject:goSpacePolicyInfo forKey:@"goSpacePolicyInfo"];
        
        NSMutableDictionary *goFlightsInfo = [[ws.searchFlightsInfo properties_aps] mutableCopy];
        [goFlightsInfo removeObjectForKey:@"spacePolicyModel"];
        [allDic setObject:goFlightsInfo forKey:@"goFlightsInfo"];
        
        [allDic setObject:self.endorseModel.oldEndorseDic forKey:@"oldEndorseDic"];
        
        [self goVUEWithOrderDic:allDic];
    }
    
}

// 跳转VUE页面
- (void)goVUEWithOrderDic:(NSDictionary *)dic {
    NSString *URL = @"";
    if ([self.endorseModel.orderType isEqualToString:@"1"]) {
        URL = [NSString stringWithFormat:@"%@?orderCode=%@",kUserInfoEndorseURL,dic[@"oldEndorseDic"][@"param"][@"orderCode"]];
    } else if ([self.endorseModel.orderType isEqualToString:@"2"]) {
        URL = [NSString stringWithFormat:@"%@?orderCode=%@",kUserInfoEndorseGBURL,dic[@"oldEndorseDic"][@"param"][@"orderCode"]];
    }
    WKWebViewController *webVC = [[WKWebViewController alloc] initWithURL:URL];
    webVC.dic = [dic copy];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

// 改签 跳转本地
- (void)EndorseJumpIndexPath:(NSIndexPath *)indexPath {
    WS(ws)
//    ws.searchFlightsInfo.spacePolicyModel = ws.dataArr[indexPath.section - 1];
    NSMutableDictionary *allDic = [NSMutableDictionary new];
    // 往返
    if (ws.tickeModel.orderType == 2 && ws.endorseInfo.backState == 2) {

        __block SelectFlightViewController *selectFlightVC = [SelectFlightViewController new];
        if (ws.tickeModel.isGo) {
            ws.searchFlightsInfo.flightType = OrderFlightTypeWangFanGo;
            selectFlightVC.goSearchFlightsInfo = ws.searchFlightsInfo;
            ws.tickeModel.isGo = NO;
            NSDictionary *goDic = ws.dataArr[indexPath.section-1];
            ws.goDic = goDic;
            // 选返程机票
            NSString *isOrderType = @"1";
            [TicketEndorseFlightInfo asyncPostNewEndorseModel:ws.tickeModel dataDic:self.endorseInfo backState:[NSString stringWithFormat:@"%ld",self.endorseInfo.backState] isOrderType:isOrderType SuccessBlock:^(NSArray *dataArray) {
                selectFlightVC.tickeModel = ws.tickeModel;
                selectFlightVC.dataArray = dataArray;
                selectFlightVC.endorseInfo = self.endorseInfo;
                selectFlightVC.selecFlightType = SelectFlightTicketEndorse;
                [ws.navigationController pushViewController:selectFlightVC animated:YES];
            } errorBlock:^(NSError *errorResult) {
                ws.tickeModel.isGo = YES;
            }];
        } else {
            ws.searchFlightsInfo.flightType = OrderFlightTypeWangFanBack;
            selectFlightVC.goSearchFlightsInfo = ws.goSearchFlightsInfo;
            
            // 去订单界面
            TicketOrderModel *orderModel = [[TicketOrderModel alloc] init];
            orderModel.goFlightModel = ws.goSearchFlightsInfo;
            orderModel.backFlightModel = ws.searchFlightsInfo;
            orderModel.ticketModel = ws.tickeModel;
            
            NSMutableDictionary *goFlightsInfo = [[ws.goSearchFlightsInfo properties_aps] mutableCopy];
            [goFlightsInfo removeObjectForKey:@"spacePolicyModel"];
            [allDic setObject:goFlightsInfo forKey:@"goFlightsInfo"];
            
//            NSMutableDictionary *goDic =  [[ws.goSearchFlightsInfo.spacePolicyModel.belongSpcaceModel properties_aps] mutableCopy];
//            [goDic removeObjectForKey:@"policyModels"];
            NSDictionary *goDic = self.goDic;
            // 往返的还需要将去的舱位信息传过去 最后加起来
            [allDic setObject:goDic forKey:@"goSpacePolicyInfo"];
            
//            NSMutableDictionary *backDic =  [[ws.searchFlightsInfo.spacePolicyModel.belongSpcaceModel properties_aps] mutableCopy];
//            [backDic removeObjectForKey:@"policyModels"];
            NSDictionary *backDic = ws.dataArr[indexPath.section-1];
            [allDic setObject:backDic forKey:@"backSpacePolicyInfo"];
            
            NSMutableDictionary *backFlightsInfo = [[ws.searchFlightsInfo properties_aps] mutableCopy];
            [backFlightsInfo removeObjectForKey:@"spacePolicyModel"];
            [allDic setObject:backFlightsInfo forKey:@"backFlightsInfo"];
            
            [self goTicketEndorseDic:allDic];
        }
        
    } else {
        ws.searchFlightsInfo.flightType = OrderFlightTypeDanCheng;
        // 单程
//        NSMutableDictionary *goSpacePolicyInfo =  [[ws.searchFlightsInfo.spacePolicyModel.belongSpcaceModel properties_aps] mutableCopy];
//        [goSpacePolicyInfo removeObjectForKey:@"policyModels"];
//        [allDic setObject:goSpacePolicyInfo forKey:@"goSpacePolicyInfo"];
        NSDictionary *goDic = ws.dataArr[indexPath.section-1];
        [allDic setObject:goDic forKey:@"goSpacePolicyInfo"];
        
        NSMutableDictionary *goFlightsInfo = [[ws.searchFlightsInfo properties_aps] mutableCopy];
        [goFlightsInfo removeObjectForKey:@"spacePolicyModel"];
        [allDic setObject:goFlightsInfo forKey:@"goFlightsInfo"];
        
        [self goTicketEndorseDic:allDic];
    }
}
- (void)goTicketEndorseDic:(NSDictionary *)dic {
    EndorseViewController *endorseVC = [EndorseViewController new];
    endorseVC.isEndorse = YES;
    endorseVC.selEndorseTicketDic = dic;
    if (self.endorseInfo.backState == 2) {
        endorseVC.goSearchFlightsInfo = self.goSearchFlightsInfo;
        endorseVC.backSearchFlightsInfo = self.searchFlightsInfo;
    } else {
        endorseVC.goSearchFlightsInfo = self.searchFlightsInfo;
    }
    endorseVC.endorseInfo = self.endorseInfo;
    [self.navigationController pushViewController:endorseVC animated:YES];
}
#pragma mark 去订单提交界面
- (void)goOrderCommitVCWithOrderModel:(TicketOrderModel *)orderModel {
    WS(ws)
    // 加载保险数据
    [HzTools showLoadingViewWithString:@""];
    [TicketInsuranceTradeModel asyncGetInsuranceWithIsDanCheng:self.tickeModel.orderType == 1 successBlock:^(NSArray *dataArray) {
        [HzTools hiddenLoadingView];
        
        // 去订单界面
        [orderModel.insuranceTradeModels addObjectsFromArray:dataArray];
        TicketOrderCommitViewController *vc = [[TicketOrderCommitViewController alloc] init];
        vc.orderModel = orderModel;
        vc.hidesBottomBarWhenPushed = YES;
        [ws.navigationController pushViewController:vc animated:YES];
    } errorBlock:^(NSError *errorResult) {
        [HzTools hiddenLoadingView];
    }];
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
