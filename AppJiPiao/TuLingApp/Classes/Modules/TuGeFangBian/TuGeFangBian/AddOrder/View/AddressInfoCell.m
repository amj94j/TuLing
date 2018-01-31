//
//  AddressInfoCell.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "AddressInfoCell.h"
#import "TicketAddressModel.h"

@interface AddressInfoCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation AddressInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TicketAddressModel *)model
{
    _model = model;
    
    self.selectBtn.selected = model.isSelected;
    self.nameLabel.text = model.userName;
    self.phoneLabel.text = model.linkPhone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@  %@", model.province, model.city, model.county, model.detailedAddress,model.zipCode];
}

- (IBAction)userAction:(UIButton *)sender
{
    // tag 0选择 1删除
    NSUInteger tag = sender.tag;
    if (tag == 0) {
        self.selectBtn.selected = !self.selectBtn.selected;
        _model.isSelected = self.selectBtn.selected;
    }
    if (self.userAction) {
        self.userAction(sender.tag);
    }
}

@end
