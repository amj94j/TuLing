//
//  TicketOrderDetailsCell.m
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketOrderDetailsCell.h"
#import "EndorseBackRulesModel.h"
#import "EndorseBackRulesVC.h"
#import "TicketSpaceModel.h"

@implementation TicketOrderDetailsCell
{
    SearchFlightsModel *_model;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.returnLabel.layer.masksToBounds = YES;
    self.returnLabel.layer.cornerRadius = 2;
    [Untils drawDashLine:self.lineView lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#E7E7E7"]];
    
}

- (void)refreshData:(id)data type:(NSString *)type {
    
//    if (self.ticketOrderType == TicketOrderDetailsCellBG) {
//        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ticket_background"]];
//    } else {
//        self.bgView.layer.masksToBounds = YES;
//        self.bgView.layer.cornerRadius = 3;
//        self.bgView.layer.borderWidth = 1;
//        self.bgView.layer.borderColor = [UIColor colorWithHexString:@"#919191"].CGColor;
//    }
    SearchFlightsModel *model = data;
    _model = model;
    if (self.isBGImage) {
        if (model.realCompany.length>0) {
            self.bgHeight.constant = PXChange(397);
            self.height = PXChange(442);
            self.bgImageView.hidden = YES;
            self.bgView.layer.masksToBounds = YES;
            self.bgView.layer.cornerRadius = 3;
            self.articleGreyView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
            self.bgView.layer.masksToBounds = YES;
            self.bgView.layer.cornerRadius = 3;
            self.articleGreyView.hidden = NO;
        }
        else {
            self.bgHeight.constant = PXChange(334);
            self.height = PXChange(397);
            self.bgImageView.hidden = YES;
            self.bgView.layer.masksToBounds = YES;
            self.bgView.layer.cornerRadius = 3;
            self.articleGreyView.hidden = YES;
            self.bgView.layer.masksToBounds = YES;
            self.bgView.layer.cornerRadius = 3;
        }
    } else {
        if ([type isEqualToString:@"改"]) {
            self.bgImageView.image = [UIImage imageNamed:@"机票背景框_2"];
            self.bgHeight.constant = PXChange(397);
            self.height = PXChange(442);
            self.endorseBackRulesBtn.hidden = NO;
        } else {
            if (model.realCompany.length>0) {
                self.bgImageView.image = [UIImage imageNamed:@"机票背景框_2"];
                self.bgHeight.constant = PXChange(397);
                self.height = PXChange(442);
            } else {
                self.bgImageView.image = [UIImage imageNamed:@"机票背景框"];
                self.bgHeight.constant = PXChange(334);
                self.height = PXChange(397);
            }
        }
    }
    
    
    if ([type isEqualToString:@"去"]) {
        self.returnLabel.text = @"去";
        self.returnLabel.hidden = NO;
        self.banckLineLayout.constant = 3;
    } else if ([type isEqualToString:@"返"]) {
        self.returnLabel.text = @"返";
        self.returnLabel.hidden = NO;
        self.banckLineLayout.constant = 3;
    } else if ([type isEqualToString:@"改"]) {
        self.returnLabel.text = @"改";
        self.returnLabel.backgroundColor = [UIColor colorWithHexString:@"#FE5D46"];
        self.returnLabel.hidden = NO;
        self.banckLineLayout.constant = 3;
    } else {
        self.returnLabel.text = @"";
        self.returnLabel.hidden = YES;
        self.banckLineLayout.constant = 0;
    }
    if (!model) {
        return;
    }
    self.timerLabel.text = model.beginWeekTime;
    self.lengthTimeLabel.text = [NSString stringWithFormat:@"约 %@",model.flightTime];
    if (model.isSharing) {
        self.sharedLabel.hidden = NO;
        self.sharedLabel.text = @"(共享)";
    } else {
        self.sharedLabel.hidden = YES;
        self.sharedLabel.text = @"";
    }
    self.cabinTypeLabel.text = model.spacePolicyModel.belongSpcaceModel.classtype; // 机舱型号
    self.beginTimeLabel.text = model.beginTime; // 起飞时间 23:25
    self.beginAirportLabel.text = [NSString stringWithFormat:@"%@%@机场%@",model.beginCityName,model.beginAirPortName,model.fromterminal]; // 起飞机场
    
    self.flightNumLabel.text = [model.airlineCompany stringByAppendingString:model.flightNumber]; // 航班号码
    
    if (model.stopCityName.length>0) {
        self.afterStopLabel.hidden = NO;
        self.afterStopLabel.text = [@"经停" stringByAppendingString:model.stopCityName]; // 经停
    } else {
        self.afterStopLabel.hidden = YES;
    }
    self.nextDayLabel.hidden = !model.twoDay;
    
    self.endTimeLabel.text = model.endTime; // 到达时间
    self.endAirportLabel.text = [NSString stringWithFormat:@"%@%@机场%@",model.endCityName,model.endAirPortName,model.arrterminal]; // 右下角 "空客 320(中)"
    self.companyLabel.text = [NSString stringWithFormat:@"%@ (%@)",  model.planeType,model.planeSize];
    
    if (model.realCompany.length>0) {
        self.actualRideLabel.text = [NSString stringWithFormat:@"实际乘坐 %@ %@",model.realCompany,model.realFlightNum]; // 实际公司
        self.actualRideLabel.hidden = NO;
    } else {
        self.actualRideLabel.hidden = YES;
    }
    
}

- (NSDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSDictionary new];
    }
    return _dataDic;
}

// 退改签规则 改签之后的退改签规则
- (IBAction)endorseBackRulesAction:(id)sender {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:_model.airlineCode forKey:@"carrier"];
    [dic setObject:_model.flightNumber forKey:@"flightNo"];
//    [dic setObject:_model.spacePolicyModel.belongSpcaceModel.seatcode forKey:@"seatClass"];
//    [dic setObject:[NSString stringWithFormat:@"%ld",(long)_model.spacePolicyModel.belongSpcaceModel.ticketprice] forKey:@"ticketParsPrice"];

    [dic setObject:self.dataDic[@"cabinCode"] forKey:@"seatClass"];
    [dic setObject:self.dataDic[@"freight"][@"highPrice"] forKey:@"ticketParsPrice"];
    
    [dic setObject:_model.beginCity forKey:@"formCity"];
    [dic setObject:_model.endCity forKey:@"toCity"];
    [dic setObject:_model.bTime forKey:@"takeOffDate"];
    [dic setObject:kToken forKey:@"token"];
    if (_model.flightType == 1 || _model.flightType == 2) {
        [dic setObject:@"0" forKey:@"isOrderType"];
    } else if (_model.flightType == 3) {
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
