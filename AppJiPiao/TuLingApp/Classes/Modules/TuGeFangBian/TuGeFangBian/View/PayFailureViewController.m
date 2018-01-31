//
//  PayFailureViewController.m
//  TuLingApp
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "PayFailureViewController.h"

@interface PayFailureViewController ()
@property (weak, nonatomic) IBOutlet UILabel *payForLabel;
@property (weak, nonatomic) IBOutlet UIButton *payForBtn;
@property (weak, nonatomic) IBOutlet UIImageView *payForImageView;

@end

@implementation PayFailureViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    请尝试重新支付～
    if (self.payFailureType == 1) {
        self.payForLabel.text = @"请尝试重新提交～";
        [self.payForBtn setTitle:@"重新提交" forState:(UIControlStateNormal)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.payFailureType == 1) {
        [self addCustomTitleWithTitle:@"创建失败"];
    } else {
        [self addCustomTitleWithTitle:@"支付失败"];
    }
    
}

#pragma mark - 重新支付
- (IBAction)payAgainAction:(id)sender {
    if (self.payFailureType == 1) {
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        // 重新支付跳转订单页面
        [self.navigationController popViewControllerAnimated:NO];
    }
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
