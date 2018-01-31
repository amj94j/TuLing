//
//  HeadInfoView.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/17.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "HeadInfoView.h"
#import "TicketHeadModel.h"

@interface HeadInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation HeadInfoView

- (void)setModel:(TicketHeadModel *)model
{
    _model = model;
    
    self.titleLabel.text = _model.invoiceHead;
    self.titleLabel.adjustsFontSizeToFitWidth = NO;
    self.numberLabel.text= _model.voucherCode;
    
    self.companyLabel.text = _model.isPersonal.boolValue ? @"公司" : @"个人";
}
@end
