//
//  InsuranceVC.m
//  TuLingApp
//
//  Created by apple on 2017/12/29.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "InsuranceVC.h"

@interface InsuranceVC ()
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@end

@implementation InsuranceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *titleStr = @"";
    if (self.insuranceModel.insuranceType == 1) {
        titleStr = @"航空意外险";
    } else if (self.insuranceModel.insuranceType == 2) {
        titleStr = @"航空延误险";
    }
    [self addCustomTitleWithTitle:titleStr];
    self.premiumPriceLabel.text = [NSString stringWithFormat:@"%.0f/份",self.insuranceModel.insuranceFee];
    self.detailsLabel.text = self.insuranceModel.insuranceDetail;
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
