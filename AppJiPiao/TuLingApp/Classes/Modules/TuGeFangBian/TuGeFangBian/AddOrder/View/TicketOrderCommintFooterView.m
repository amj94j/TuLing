//
//  TicketOrderCommintFooterView.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketOrderCommintFooterView.h"

@interface TicketOrderCommintFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *detaileBtn;

@end

@implementation TicketOrderCommintFooterView

+ (instancetype)xib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

- (void)updateAllCost:(double)cost passengerCount:(NSInteger)passengerCount
{
    self.allPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", cost];
    self.personNumLabel.text = [NSString stringWithFormat:@"订单总额(%ld人)", (long)passengerCount];
}

- (IBAction)showDetaileAndGoPayAction:(id)sender
{
    if (self.showDetaileAndGoPayBlock) {
        self.showDetaileAndGoPayBlock(((UIButton *)sender).tag);
    }
}

@end
