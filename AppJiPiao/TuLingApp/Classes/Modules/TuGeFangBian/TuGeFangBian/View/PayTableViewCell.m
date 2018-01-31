//
//  PayTableViewCell.m
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "PayTableViewCell.h"

static NSString * cellID = @"payCell";

@implementation PayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

+ (PayTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    PayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
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
