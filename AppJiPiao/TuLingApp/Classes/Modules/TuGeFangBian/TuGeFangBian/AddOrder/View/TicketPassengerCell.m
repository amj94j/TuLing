//
//  TicketPassengerCell.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketPassengerCell.h"
#import "TicketPassengerModel.h"

@interface TicketPassengerCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@end

@implementation TicketPassengerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TicketPassengerModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.personName;
    self.idTypeLabel.text = model.personIdentityName;
    self.phoneLabel.text = model.linkPhone;
    self.idLabel.text = model.personIdentityCode;
}

- (IBAction)deleteAction:(UIButton *)sender
{
    if (self.deleteAction) {
        self.deleteAction();
    }
}
@end
