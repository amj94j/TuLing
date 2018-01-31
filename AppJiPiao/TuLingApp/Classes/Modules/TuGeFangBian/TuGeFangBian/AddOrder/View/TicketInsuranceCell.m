//
//  TicketInsuranceCell.m
//  TuLingApp
//
//  Created by abner on 2017/12/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketInsuranceCell.h"
#import "TicketInsuranceModel.h"
#import "PassageSelectInsurView.h"
#import "InsuranceVC.h"
#import "TicketOrderCommitViewController.h"

@interface TicketInsuranceCell () <PassageSelectInsurViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeContentLabel;

@end

@implementation TicketInsuranceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTradeModel:(TicketInsuranceTradeModel *)tradeModel
{
    _tradeModel = tradeModel;
    
    TicketInsuranceModel *insuranceModel = tradeModel.insuranceModel;
    
    self.selectBtn.selected = tradeModel.isSelected;
    
    // 保险名
    if (insuranceModel.insuranceType == 1) {
        self.nameLabel.text = @"航空意外险";
    } else if (insuranceModel.insuranceType == 2) {
        self.nameLabel.text = @"航空延误险";
    }
    // 保险购买份数内容
    NSString *priceString = [NSString stringWithFormat:@"￥%.f/人", insuranceModel.insuranceFee];
    NSString *bugCountString = [NSString stringWithFormat:@" x %lu人", self.selectBtn.selected ? (unsigned long)tradeModel.buyPassengerModels.count : 0];
    NSString *isDanChengString = tradeModel.isDanCheng ? @"" : @" x 2(往返)";
    self.tradeContentLabel.text = [NSString stringWithFormat:@"%@%@%@", priceString, bugCountString, isDanChengString];
}

- (IBAction)userAction:(UIButton *)sender
{
    if (sender.tag == 0) { // 选择
        if (self.selectInsuranceBlock) {
            self.selectInsuranceBlock();
        }
    } else if (sender.tag == 1) { // 显示选择保险人弹框
        //显示弹框
        PassageSelectInsurView *psInsureView = [[PassageSelectInsurView alloc] initPassageSelectInsureWithTicketInsuranceModel:self.tradeModel];
        
        psInsureView.delegate = self;
        [AppDelegateWindow addSubview:psInsureView];
    } else if (sender.tag == 2) {
        // 显示保险信息
        InsuranceVC *vc = [[InsuranceVC alloc] init];
        vc.insuranceModel = self.tradeModel.insuranceModel;
//        vc.modalPresentationStyle = 4;
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
        
        [self.currentVC.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pasageSelectinsureClickSureWithArray:(NSMutableArray<TicketPassengerModel *> *)passageArray
{
    if (self.selectInsurancePassengerModelsBlock) {
        self.selectInsurancePassengerModelsBlock(passageArray);
    }
}

@end
