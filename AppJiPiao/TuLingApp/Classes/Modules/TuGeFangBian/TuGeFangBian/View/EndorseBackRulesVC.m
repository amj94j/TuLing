//
//  EndorseBackRulesVC.m
//  TuLingApp
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "EndorseBackRulesVC.h"
#import "Untils.h"

@interface EndorseBackRulesVC ()
@property (weak, nonatomic) IBOutlet UILabel *signTransferPolicyLabel; // 签转规定
@property (weak, nonatomic) IBOutlet UIView *signTransferPolicyLineView;

@property (weak, nonatomic) IBOutlet UILabel *reschedulingRulesLabel; // 改期规定
@property (weak, nonatomic) IBOutlet UIView *reschedulingRulesLineView;

@property (weak, nonatomic) IBOutlet UILabel *refundRulesLabel; // 退票规定
@property (weak, nonatomic) IBOutlet UIView *refundRulesLineView;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@property (nonatomic, strong) EndorseBackRulesModel *eModel;
@end

@implementation EndorseBackRulesVC

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.bgview.backgroundColor = [UIColor clearColor];
    [self.bgview addSubview:effectView];
    
    [Untils drawDashLine:self.signTransferPolicyLineView lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#E7E7E7"]];
    [Untils drawDashLine:self.reschedulingRulesLineView lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#E7E7E7"]];
    [Untils drawDashLine:self.refundRulesLineView lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#E7E7E7"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.signTransferPolicyLabel.text = self.eModel.IsAllowedToSignInfo;
    self.refundRulesLabel.text = self.eModel.RefundTicketRuleInfo;
    self.reschedulingRulesLabel.text = self.eModel.ChangeTicketRuleInfo;
    [self.view reloadInputViews];
}

- (void)reloadData:(EndorseBackRulesModel *)model {
    self.eModel = model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shutDownClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
