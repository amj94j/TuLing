//
//  TLOrderDetailViewCell.m
//  ticket
//
//  Created by LQMacBookPro on 2017/12/12.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "TLOrderDetailViewCell.h"

#import "SearchFlightsModel.h"

#import "TicketSpacePolicyModel.h"

#import "TicketSpaceModel.h"

static NSString * orderCellID = @"orderCellID";

@interface TLOrderDetailViewCell()


@end

@implementation TLOrderDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

+ (TLOrderDetailViewCell *)orderDetailCellWithTableView:(UITableView *)tableView
{
    TLOrderDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:orderCellID];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    }
    return cell;
}

- (void)setSearchFlightModel:(SearchFlightsModel *)searchFlightModel
{
    _searchFlightModel = searchFlightModel;
    
    self.ticketTypeLabel.text = self.personType;
    
    if ([self.personType isEqualToString:@"成人票"]) {
        self.priceLabel.text = [NSString stringWithFormat:@"%ld",searchFlightModel.spacePolicyModel.belongSpcaceModel.ticketprice];
        
        self.personCountLabel.text = [NSString stringWithFormat:@"×%ld",self.adultCount];
        
        self.jiJianPricelabel.text = [NSString stringWithFormat:@"%.1f+%.1f",searchFlightModel.spacePolicyModel.belongSpcaceModel.fee,searchFlightModel.spacePolicyModel.belongSpcaceModel.tax];
        
        self.jiJianPersonCountLabel.text = [NSString stringWithFormat:@"×%ld",self.adultCount];
        
    }else if ([self.personType isEqualToString:@"儿童票"]){
        
        self.priceLabel.text = [NSString stringWithFormat:@"%ld",searchFlightModel.spacePolicyModel.belongSpcaceModel.chdticketprice];
        
        self.personCountLabel.text = [NSString stringWithFormat:@"×%ld",self.childCount];
        
        self.jiJianPricelabel.text = [NSString stringWithFormat:@"%.1f+%.1f",searchFlightModel.spacePolicyModel.belongSpcaceModel.chdfee,searchFlightModel.spacePolicyModel.belongSpcaceModel.chdtax];
        self.jiJianPersonCountLabel.text = [NSString stringWithFormat:@"%ld",self.childCount];
        
    }else if ([self.personType isEqualToString:@"婴儿票"]){
        self.priceLabel.text = [NSString stringWithFormat:@"%f",searchFlightModel.spacePolicyModel.belongSpcaceModel.babyticketprice];
        
        self.personCountLabel.text = [NSString stringWithFormat:@"×%ld",self.babyCount];
        
        self.jiJianPricelabel.text = [NSString stringWithFormat:@"%.1f+%.1f",searchFlightModel.spacePolicyModel.belongSpcaceModel.babyfee,searchFlightModel.spacePolicyModel.belongSpcaceModel.babytax];
        
        self.jiJianPersonCountLabel.text = [NSString stringWithFormat:@"%ld",self.babyCount];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
