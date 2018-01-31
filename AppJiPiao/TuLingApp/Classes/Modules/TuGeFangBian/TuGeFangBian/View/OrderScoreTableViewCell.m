//
//  OrderScoreTableViewCell.m
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "OrderScoreTableViewCell.h"

static NSString * cellID = @"OrderScoreCell";

@implementation OrderScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
- (IBAction)switchClick {
    
    if (self.cacluePriceBlock) {
        self.cacluePriceBlock();
    }
    
}

+ (OrderScoreTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    OrderScoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    }
    return cell;
}
- (IBAction)switchBtnclick:(UISwitch *)sender {
    
    if (self.openOrCloseBlock) {
        self.openOrCloseBlock(sender.isOn);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
