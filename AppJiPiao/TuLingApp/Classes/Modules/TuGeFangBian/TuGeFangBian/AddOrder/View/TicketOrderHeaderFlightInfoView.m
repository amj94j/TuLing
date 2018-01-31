//
//  TicketOrderHeaderFlightInfoView.m
//  TuLingApp
//
//  Created by abner on 2017/12/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketOrderHeaderFlightInfoView.h"
#import "TicketOrderModel.h"
#import "ShowFlightInforView.h"
#import "EndorseBackRulesModel.h"
#import "EndorseBackRulesVC.h"
@interface TicketOrderHeaderFlightInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *isBackFlightLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *airCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *isShareLabel;
@property (weak, nonatomic) IBOutlet UILabel *cabinTypeLabel; // 机舱型号
@property (weak, nonatomic) IBOutlet UILabel *adultPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *adultFeeAndTaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *childPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *childFeeAndTaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *babyPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *babyFeeAndTaxLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beginTimeLabelLCons;

@end

@implementation TicketOrderHeaderFlightInfoView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.isBackFlightLabel.layer.masksToBounds = YES;
    self.isBackFlightLabel.layer.cornerRadius = 2;
}

- (void)setFlightModel:(SearchFlightsModel *)flightModel
{
    _flightModel = flightModel;
    
    // 返、去
    if (flightModel.flightType == OrderFlightTypeWangFanGo || flightModel.flightType == OrderFlightTypeWangFanBack) {
        self.isBackFlightLabel.text = flightModel.flightType == OrderFlightTypeWangFanGo ? @"去" : @"返";
        self.isBackFlightLabel.hidden = NO;
        self.beginTimeLabelLCons.constant = 3;
    } else { // 单程、未知
        self.isBackFlightLabel.text = @"";
        self.isBackFlightLabel.hidden = YES;
        self.beginTimeLabelLCons.constant = 0.0f;
    }
    
    // 起飞时间
    self.beginTimeLabel.text = [flightModel.beginWeekTime substringWithRange:NSMakeRange(0, flightModel.beginWeekTime.length - 3)];

    // 航空公司、航班号码
    self.airCompanyLabel.text = [NSString stringWithFormat:@"%@ %@", flightModel.airlineCompany, flightModel.flightNumber];

    // 共享
    if (flightModel.isSharing) {
        self.isShareLabel.hidden = NO;
        self.isShareLabel.text = @"(共享)";
    } else {
        self.isShareLabel.hidden = YES;
        self.isShareLabel.text = @"";
    }

    // 机舱型号
    self.cabinTypeLabel.text = flightModel.spacePolicyModel.belongSpcaceModel.classtype;
    
    // 机票价格
    TicketSpacePolicyModel *spacePolicyModel = flightModel.spacePolicyModel;
    TicketSpaceModel *spcaceModel = spacePolicyModel.belongSpcaceModel;
    self.adultPriceLabel.text = [NSString stringWithFormat:@"￥%ld", spacePolicyModel.belongSpcaceModel.ticketprice];
    self.childPriceLabel.text = [NSString stringWithFormat:@"￥%ld", (long)spcaceModel.chdticketprice];
    self.babyPriceLabel.text = [NSString stringWithFormat:@"￥%.f", spcaceModel.babyticketprice];
    self.adultFeeAndTaxLabel.text = [NSString stringWithFormat:@"基建 ￥%.f + 燃油 ￥%.f", spcaceModel.fee, spcaceModel.tax];
    self.childFeeAndTaxLabel.text = [NSString stringWithFormat:@"基建 ￥%.f + 燃油 ￥%.f", spcaceModel.chdfee, spcaceModel.chdtax];
    self.babyFeeAndTaxLabel.text = [NSString stringWithFormat:@"基建 ￥%.f + 燃油 ￥%.f", spcaceModel.babyfee, spcaceModel.babytax];
}

- (IBAction)showDetailInfo:(UIButton *)sender
{
    ShowDetailInfoType type = sender.tag;
    if (self.showDetailInfoBlock) {
        self.showDetailInfoBlock(type);
    }
    
    ShowFlightInforView * flightInfoView = [[ShowFlightInforView alloc]initFlightInfoWithModel:_flightModel];
    
    [AppDelegateWindow addSubview:flightInfoView];
}

// 退改签规则
- (IBAction)endorseBackRulesAction:(id)sender {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    WS(ws)
    [dic setObject:ws.flightModel.airlineCode forKey:@"carrier"];
    [dic setObject:ws.flightModel.flightNumber forKey:@"flightNo"];
    [dic setObject:ws.flightModel.spacePolicyModel.belongSpcaceModel.seatcode forKey:@"seatClass"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)ws.flightModel.spacePolicyModel.belongSpcaceModel.ticketprice] forKey:@"ticketParsPrice"];
    [dic setObject:ws.flightModel.beginCity forKey:@"formCity"];
    [dic setObject:ws.flightModel.endCity forKey:@"toCity"];
    [dic setObject:ws.flightModel.bTime forKey:@"takeOffDate"];
    [dic setObject:kToken forKey:@"token"];
    if (ws.flightModel.flightType == 1 || ws.flightModel.flightType == 2) {
        [dic setObject:@"0" forKey:@"isOrderType"];
    } else if (ws.flightModel.flightType == 3) {
        [dic setObject:@"1" forKey:@"isOrderType"];
    }
    [EndorseBackRulesModel asyncPostPlaneTicketRuleProDic:dic SuccessBlock:^(EndorseBackRulesModel *model) {
        EndorseBackRulesVC  *tankTypeVC = [EndorseBackRulesVC new];
        [tankTypeVC reloadData:model];
        tankTypeVC.modalPresentationStyle = 4;
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window.rootViewController presentViewController:tankTypeVC animated:YES completion:nil];
    } errorBlock:^(NSError *errorResult) {
        
    }];
}
@end
