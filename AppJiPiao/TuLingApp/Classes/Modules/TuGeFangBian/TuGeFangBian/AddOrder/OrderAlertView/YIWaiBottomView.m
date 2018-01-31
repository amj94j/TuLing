//
//  YIWaiBottomView.m
//  ticket
//
//  Created by LQMacBookPro on 2017/12/12.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "YIWaiBottomView.h"
#import "TicketInsuranceModel.h"

@interface YIWaiBottomView()

@property (weak, nonatomic) IBOutlet UILabel *baoXianTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *baoXianPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *personCountLabel;

@end

@implementation YIWaiBottomView

+ (instancetype)yiwaiBottomView
{
    YIWaiBottomView * view = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    return view;
}

- (void)setBaoXianModel:(TicketInsuranceTradeModel *)baoXianModel
{
    _baoXianModel = baoXianModel;
    
    self.baoXianPriceLabel.text =[NSString stringWithFormat:@"%.1f",_baoXianModel.insuranceModel.insuranceFee];
    
    if ([_baoXianModel.insuranceModel.insuranceName isEqualToString:@"快递费"]) {
        self.baoXianTitleLabel.text = @"快递费";
        self.personCountLabel.text = [NSString stringWithFormat:@"×1"];
    }else{
        if (_baoXianModel.insuranceModel.insuranceType == 1) {
            self.baoXianTitleLabel.text = @"航空意外险";
        } else if (_baoXianModel.insuranceModel.insuranceType == 2) {
            self.baoXianTitleLabel.text = @"航空延误险";
        }

        if (_baoXianModel.isDanCheng) {
            self.personCountLabel.text = [NSString stringWithFormat:@"×%ld",_baoXianModel.buyPassengerModels.count];
        } else {
            NSInteger count = _baoXianModel.buyPassengerModels.count*2;
            self.personCountLabel.text = [NSString stringWithFormat:@"×%ld",count];
        }
        
    }
    
}

@end
