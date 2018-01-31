//
//  EndorseTicketHeaderCell.m
//  TuLingApp
//
//  Created by apple on 2017/12/23.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "EndorseTicketHeaderCell.h"

@implementation EndorseTicketHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.typeLabel.layer.masksToBounds = YES;
    self.typeLabel.layer.cornerRadius = 3;
}

- (void)refreshData:(id)data {
    SearchFlightsModel *model = data;
    if (!model) {
        return;
    }
//    if (model.flightType == OrderFlightTypeDanCheng) {
//        
//    } else {
//        self.typeLabel.layer.borderWidth = 1;
//        self.typeLabel.layer.borderColor = [UIColor colorWithHexString:@"#008C4E"].CGColor;
//        self.typeLabel.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
//        if (model.flightType == OrderFlightTypeWangFanGo) {
//            self.typeLabel.text = @" 原去程 ";
//        } else {
//            self.typeLabel.text = @" 原返程 ";
//        }
//    }
    
    self.timerLabel.text = model.beginWeekTime;
    self.cabinTypeLabel.text = model.classtype; // 机舱型号
    self.flightNumLabel.text = [model.airlineCompany stringByAppendingString:model.flightNumber];; // 航班号码
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
