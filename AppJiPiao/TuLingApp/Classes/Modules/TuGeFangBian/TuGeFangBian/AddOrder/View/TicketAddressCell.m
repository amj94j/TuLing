//
//  TicketAddressCell.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketAddressCell.h"
#import "TicketAddressModel.h"

@interface TicketAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipCodeLabel;

@end

@implementation TicketAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TicketAddressModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.userName;
    self.phoneLabel.text = model.linkPhone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", model.province, model.city, model.county, model.detailedAddress];
    self.zipCodeLabel.text = model.zipCode;
}

@end
