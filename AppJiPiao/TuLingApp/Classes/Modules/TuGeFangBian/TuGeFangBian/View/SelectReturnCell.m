//
//  SelectReturnCell.m
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "SelectReturnCell.h"
#import "TicketSpacePolicyModel.h"
#import "TicketSpaceModel.h"

@implementation SelectReturnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.returnLabel.layer.masksToBounds = YES;
    self.returnLabel.layer.cornerRadius = 2;
    
}

- (void)refreshData:(id)data {
    SearchFlightsModel *model = data;
    if (!model) {
        return;
    }
    
    self.timerLabel.text = model.beginWeekTime;
    if (model.isSharing) {
        self.sharedLabel.hidden = NO;
        self.sharedLabel.text = @"(共享)";
    } else {
        self.sharedLabel.hidden = YES;
        self.sharedLabel.text = @"";
    }
    self.cabinTypeLabel.text = model.spacePolicyModel.belongSpcaceModel.classtype; // 机舱型号
    
    // 航班号码
    self.flightNumLabel.text = [model.airlineCompany stringByAppendingString:model.flightNumber];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
