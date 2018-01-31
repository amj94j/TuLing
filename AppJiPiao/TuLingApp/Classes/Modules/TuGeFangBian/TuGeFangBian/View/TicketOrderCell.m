//
//  TicketOrderCell.m
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketOrderCell.h"
#import "TicketSpaceModel.h"
@implementation TicketOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)bookingClick:(UIButton *)sender {
    if (self.bookingActionBlock) {
        self.bookingActionBlock();
    }
}

- (IBAction)backToRuleClick:(UIButton *)sender {
    if (self.backToRuleActionBlock) {
        self.backToRuleActionBlock();
    }
}

- (void)reloadData:(TicketSpacePolicyModel *)model {
//    TicketSpacePolicyModel *model = data;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%ld", model.belongSpcaceModel.ticketprice]; // 价钱
    self.cabinTypeLabel.text = [NSString stringWithFormat:@"%@", model.belongSpcaceModel.classtype]; // 机舱类型
//    self.discountLabel.text = model.belongSpcaceModel.discount < 100 ? [NSString stringWithFormat:@"%.1f折", model.belongSpcaceModel.discount*0.1] : @"全价"; // 折扣
    if (model.belongSpcaceModel.discount == 100 || model.belongSpcaceModel.discount == 300) {
        self.discountLabel.text = @"全价";
    } else if (model.belongSpcaceModel.discount == 0) {
        self.discountLabel.text = @"";
    } else {
        if (model.belongSpcaceModel.discount<100 && 0<model.belongSpcaceModel.discount) {
            self.discountLabel.text = [[NSString stringWithFormat:@"%.1f",model.belongSpcaceModel.discount/10] stringByAppendingString:@"折"];
        } else if (model.belongSpcaceModel.discount<300 && 100<model.belongSpcaceModel.discount) {
            self.discountLabel.text = @"折扣舱";
        }
        
    }
    // 余票
    NSInteger seatNum = model.belongSpcaceModel.seatnum;
    if (seatNum >= 1 && seatNum <= 3) {
        self.moreTicketLabel.text = [NSString stringWithFormat:@"剩%ld张", (long)seatNum];
    }
    
    
    
}
@end
