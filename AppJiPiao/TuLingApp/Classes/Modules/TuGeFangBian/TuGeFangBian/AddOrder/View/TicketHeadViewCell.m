//
//  TicketHeadViewCell.m
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketHeadViewCell.h"

#import "TicketHeadModel.h"

static NSString * cellID = @"ticketHeadViewCell";

@interface TicketHeadViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;


@end

@implementation TicketHeadViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (TicketHeadViewCell *)cellWithTableView:(UITableView *)tableView
{
    TicketHeadViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    }
    
    return cell;
}

- (void)setModel:(TicketHeadModel *)model
{
    _model = model;
    
    self.selectIconView.image = [UIImage imageNamed:model.isSelected ? @"打钩" : @"未选中"];
    
    self.titleLabel.text = _model.invoiceHead;
    
    self.numberLabel.text= _model.voucherCode;
    
    if ([_model.isPersonal isEqualToString:@"0"]) {
        self.companyLabel.text = @"个人";
    } else if ([_model.isPersonal isEqualToString:@"1"]) {
        self.companyLabel.text = @"企业";
    }
    
}

- (IBAction)deletBtnClick:(UIButton *)sender {
    
    if ([_headCellDelegate respondsToSelector:@selector(delegteItemAtIndex:)]) {
        
        [_headCellDelegate delegteItemAtIndex:self.index];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
