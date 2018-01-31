//
//  EndorseBackForthVC.m
//  TuLingApp
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "EndorseBackForthVC.h"

@interface EndorseBackForthVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
// 虚线
@property (weak, nonatomic) IBOutlet UIView *lineView_1;
@property (weak, nonatomic) IBOutlet UIView *lineView_2;
@property (weak, nonatomic) IBOutlet UIView *lineView_3;
@property (weak, nonatomic) IBOutlet UIView *lineView_4;
@property (weak, nonatomic) IBOutlet UIView *lineView_5;
@property (weak, nonatomic) IBOutlet UIView *lineView_6;

// 去
// 退票
@property (weak, nonatomic) IBOutlet UILabel *go_refundLabel;
// 改期
@property (weak, nonatomic) IBOutlet UILabel *go_rainCheckLabel;
// 签转
@property (weak, nonatomic) IBOutlet UILabel *go_endorsementLabel;

// 返
// 退票
@property (weak, nonatomic) IBOutlet UILabel *back_refundLabel;
// 改期
@property (weak, nonatomic) IBOutlet UILabel *back_rainCheckLabel;
// 签转
@property (weak, nonatomic) IBOutlet UILabel *back_endorsementLabel;

@end

@implementation EndorseBackForthVC

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:effectView];
    
    [Untils drawDashLine:self.lineView_1 lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#E7E7E7"]];
    [Untils drawDashLine:self.lineView_2 lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#E7E7E7"]];
    [Untils drawDashLine:self.lineView_3 lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#E7E7E7"]];
    [Untils drawDashLine:self.lineView_4 lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#E7E7E7"]];
    [Untils drawDashLine:self.lineView_5 lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#E7E7E7"]];
    [Untils drawDashLine:self.lineView_6 lineLength:5 lineSpacing:3 lineColor:[UIColor colorWithHexString:@"#E7E7E7"]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.back_endorsementLabel.text = self.back_Model.IsAllowedToSignInfo;
    self.back_refundLabel.text = self.back_Model.RefundTicketRuleInfo;
    self.back_rainCheckLabel.text = self.back_Model.ChangeTicketRuleInfo;
    self.go_endorsementLabel.text = self.go_Model.IsAllowedToSignInfo;
    self.go_refundLabel.text = self.go_Model.RefundTicketRuleInfo;
    self.go_rainCheckLabel.text = self.go_Model.ChangeTicketRuleInfo;
    [self.view reloadInputViews];
}
// 关闭当前
- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
