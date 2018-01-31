//
//  PassengerInfoCell.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "PassengerInfoCell.h"
#import "TicketPassengerModel.h"

@interface PassengerInfoCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@end

@implementation PassengerInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TicketPassengerModel *)model
{
    _model = model;
    
    self.selectBtn.selected = model.isSelected;
    self.nameLabel.text = model.personName;
    self.idTypeLabel.text = model.personIdentityName;
    self.phoneLabel.text = model.linkPhone;
    self.idLabel.text = model.personIdentityCode;
}

- (IBAction)userAction:(UIButton *)sender
{
    // tag 0选择 1编辑 2删除(暂不需要，所以隐藏了)
    NSUInteger tag = sender.tag;
    if (self.userAction) {
        self.userAction(tag);
    }
}

@end
