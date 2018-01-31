//
//  OrderTableViewCell.m
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/20.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "OrderTableViewCell.h"

#import "TLTicketModel.h"
#import "TicketInsuranceModel.h"
#import "TicketOrderModel.h"
#import "SearchFlightsModel.h"
#import "TicketPassengerModel.h"
#import "CityModel.h"
#import "TicketSpacePolicyModel.h"

#import "TicketSpaceModel.h"

static NSString * cellID = @"OrderTableViewCell";

@interface OrderTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *goView;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *goFlightTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *backFlightTimeLabel;


@property (weak, nonatomic) IBOutlet UILabel *startCityLabel;

@property (weak, nonatomic) IBOutlet UILabel *toCityLabel;

@property (weak, nonatomic) IBOutlet UILabel *goFlightNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *backFlightNumLabel;
@property (weak, nonatomic) IBOutlet UIView *goOrBackBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goFlightHeightConst;
@property (weak, nonatomic) IBOutlet UILabel *goTipView;
@property (weak, nonatomic) IBOutlet UILabel *backTipView;
@property (weak, nonatomic) IBOutlet UIImageView *middleIconImageView; // 中间箭头

@end

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(TicketOrderModel *)model
{
    if (!model) {
        return;
    }
    _model = model;
    
    //起飞城市
    self.startCityLabel.text = _model.ticketModel.beginCity.name;

    //降落城市
    self.toCityLabel.text = _model.ticketModel.endCity.name;
    
    //判断是否是往返程类型
    if (_model.ticketModel.orderType == OrderFlightTypeDanCheng) {
        
        self.goFlightHeightConst.constant = 45;
        
        self.backView.hidden = YES;
        
        self.goTipView.hidden = YES;
        
        self.backTipView.hidden = YES;
        
        self.backFlightNumLabel.hidden = YES;
        self.goFlightNumLabel.text = _model.goFlightModel.flightNumber;
        self.middleIconImageView.image = [UIImage imageNamed:@"selectflight_arrow_x"];
        
    } else {
        self.backFlightNumLabel.hidden = NO;
        self.goTipView.hidden = NO;
        
        self.backTipView.hidden = NO;
        self.goFlightNumLabel.text = _model.goFlightModel.flightNumber;
        self.backFlightNumLabel.text = _model.backFlightModel.flightNumber;
        self.middleIconImageView.image = [UIImage imageNamed:@"组-7"];
        
    }
    
    //起飞时间
    NSString * flightTimeStr = _model.goFlightModel.beginTimeOrigin;
    
    NSString * dateStr = [flightTimeStr substringToIndex:11];
    
    NSString * timeStr = [flightTimeStr substringFromIndex:11];
    
    timeStr = [timeStr substringToIndex:timeStr.length -3];
    
    //周
    NSString * weekTime = _model.goFlightModel.beginWeek;
    
    self.goFlightTimeLabel.text = [NSString stringWithFormat:@"%@ %@ %@ 起飞",dateStr,weekTime,timeStr];
    
    if (_model.ticketModel.orderType != OrderFlightTypeDanCheng) {
        
        NSString * backFlightTimeStr = _model.backFlightModel.beginTimeOrigin;
        
        NSString * backDateStr = [backFlightTimeStr substringToIndex:11];
        
        NSString * backTimeStr = [backFlightTimeStr substringFromIndex:11];
        
        backTimeStr = [backTimeStr substringToIndex:backTimeStr.length -3];
        
        //周
        NSString * backWeekTime = _model.backFlightModel.beginWeek;
        
        self.backFlightTimeLabel.text = [NSString stringWithFormat:@"%@ %@ %@ 起飞",backDateStr,backWeekTime,backTimeStr];
    }
    
    [self calcueTotalPrice];
}

- (void)calcueTotalPrice
{
    //遍历乘客
    
    //成人数组
    NSMutableArray * adultArray = [NSMutableArray array];
    
    //儿童数组
    NSMutableArray * childArray = [NSMutableArray array];
    
    //婴儿数组
    NSMutableArray * babyArray = [NSMutableArray array];
    
    NSMutableArray * passagesArray = _model.passengerModels;
    
    for (TicketPassengerModel * passageModel in passagesArray) {
        
        if (passageModel.isAudlt) {
            [adultArray addObject:passageModel];
        }else if (passageModel.isChild){
            [childArray addObject:passageModel];
        }else if (passageModel.isBaby){
            [babyArray addObject:passageModel];
        }
    }
    
    //成人销售价
    //        NSString * adultPrice = [NSString stringWithFormat:@"%ld",_model.goFlightModel.spacePolicyModel.belongSpcaceModel.ticketprice];
    
    NSInteger adultPrice = _model.goFlightModel.spacePolicyModel.belongSpcaceModel.ticketprice * adultArray.count;
    
    //儿童票面价
    //        NSString * childPrice = [NSString stringWithFormat:@"%ld",_model.goFlightModel.spacePolicyModel.belongSpcaceModel.chdticketprice];
    
    NSInteger childPrice = _model.goFlightModel.spacePolicyModel.belongSpcaceModel.chdticketprice * childArray.count;
    
    
    //婴儿票面价
    //        NSString * babyPrice = [NSString stringWithFormat:@"%f",_model.goFlightModel.spacePolicyModel.belongSpcaceModel.babyticketprice];
    
    NSInteger babyPrice = _model.goFlightModel.spacePolicyModel.belongSpcaceModel.babyticketprice * babyArray.count;
    
    //返程销售价
    if (_model.backFlightModel) {
        NSInteger adultBackPrice = _model.backFlightModel.spacePolicyModel.belongSpcaceModel.ticketprice * adultArray.count;
        
        adultPrice += adultBackPrice;
        
        NSInteger childBackPrice = _model.backFlightModel.spacePolicyModel.belongSpcaceModel.chdticketprice * childArray.count;
        
        childPrice += childBackPrice;
        
        NSInteger babyBackPrice = _model.backFlightModel.spacePolicyModel.belongSpcaceModel.babyticketprice * babyArray.count;
        
        babyPrice += babyBackPrice;
        
    }
    
    //计算燃油+机建费
    //        NSString * adultJiJianPrice = [NSString stringWithFormat:@"%.1f+%.1f",_model.goFlightModel.spacePolicyModel.belongSpcaceModel.fee,_model.goFlightModel.spacePolicyModel.belongSpcaceModel.tax];
    
    double adultJiJianPrice = (_model.goFlightModel.spacePolicyModel.belongSpcaceModel.fee + _model.goFlightModel.spacePolicyModel.belongSpcaceModel.tax) * adultArray.count;
    
    //        NSString * childJiJianPrice = [NSString stringWithFormat:@"%.1f+%.1f",_model.goFlightModel.spacePolicyModel.belongSpcaceModel.chdfee,_model.goFlightModel.spacePolicyModel.belongSpcaceModel.chdtax];
    
    double childJiJianPrice = (_model.goFlightModel.spacePolicyModel.belongSpcaceModel.chdfee + _model.goFlightModel.spacePolicyModel.belongSpcaceModel.chdtax) * childArray.count;
    
    //        NSString * babyJiJianPrice = [NSString stringWithFormat:@"%.1f+%.1f",_model.goFlightModel.spacePolicyModel.belongSpcaceModel.babyfee,_model.goFlightModel.spacePolicyModel.belongSpcaceModel.babytax];
    
    double babyJiJianPrice = (_model.goFlightModel.spacePolicyModel.belongSpcaceModel.babyfee + _model.goFlightModel.spacePolicyModel.belongSpcaceModel.babytax) * babyArray.count;
    
    if (_model.backFlightModel) {
        
        double adultBackJIJianPrice = (_model.backFlightModel.spacePolicyModel.belongSpcaceModel.fee + _model.goFlightModel.spacePolicyModel.belongSpcaceModel.tax) * adultArray.count;
        
        adultJiJianPrice += adultBackJIJianPrice;
        
        double childBackJiJianPrice = (_model.backFlightModel.spacePolicyModel.belongSpcaceModel.chdfee + _model.goFlightModel.spacePolicyModel.belongSpcaceModel.chdtax) * childArray.count;
        
        childJiJianPrice += childBackJiJianPrice;
        
        double babyBackJiJianPrice = (_model.backFlightModel.spacePolicyModel.belongSpcaceModel.babyfee + _model.goFlightModel.spacePolicyModel.belongSpcaceModel.babytax) * babyArray.count;
        
        babyJiJianPrice += babyBackJiJianPrice;
    }
    
    //保险费用
    CGFloat baoXianPrice = 0.0;
    
    for (TicketInsuranceTradeModel * baoXianModel in _model.insuranceTradeModels) {
        
        if (baoXianModel.isSelected) {
            
            if (baoXianModel.isDanCheng) {
                baoXianPrice += baoXianModel.buyPassengerModels.count * baoXianModel.insuranceModel.costFee;
            }else{
                baoXianPrice += baoXianModel.buyPassengerModels.count * 2 * baoXianModel.insuranceModel.costFee;
            }
            
        }
        
        
    }
    
    CGFloat kuaiDiPrice = 0.0;
    //快递,开关打开的
    if (_model.isNeedBaoXiaoPingZheng) {
        kuaiDiPrice += 20;
    }
    
    //总费用
    CGFloat totalPrice = adultPrice + childPrice + babyPrice + adultJiJianPrice + childJiJianPrice + babyJiJianPrice + baoXianPrice + kuaiDiPrice;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.1f",totalPrice];
}

+ (OrderTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    OrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
