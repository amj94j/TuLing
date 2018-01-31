//
//  InsuranceVC.h
//  TuLingApp
//
//  Created by apple on 2017/12/29.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  保险

#import "TicketBaseVC.h"
#import "TicketInsuranceModel.h"

@interface InsuranceVC : TicketBaseVC
@property (weak, nonatomic) IBOutlet UILabel *premiumPriceLabel;
@property (nonatomic, strong) TicketInsuranceModel *insuranceModel;
@end
