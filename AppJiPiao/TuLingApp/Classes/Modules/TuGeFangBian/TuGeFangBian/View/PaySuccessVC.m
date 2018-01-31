//
//  PaySuccessVC.m
//  TuLingApp
//
//  Created by apple on 2017/12/27.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "PaySuccessVC.h"
#import "SearchFlightsVC.h"
#import "WKWebViewController.h"

@interface PaySuccessVC ()
@property (weak, nonatomic) IBOutlet UIButton *myScheduleBtn; // 我的行程
@property (weak, nonatomic) IBOutlet UIButton *orderDetailsBtn; // 订单详情
@property (weak, nonatomic) IBOutlet UIButton *backHomePageBtn; // 返回首页

@end

@implementation PaySuccessVC

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.myScheduleBtn.layer.masksToBounds = YES;
    self.myScheduleBtn.layer.cornerRadius = 1;
    self.myScheduleBtn.layer.borderWidth = 1;
    self.myScheduleBtn.layer.borderColor = [UIColor colorWithHexString:@"#6DDB99"].CGColor;
    
    self.orderDetailsBtn.layer.masksToBounds = YES;
    self.orderDetailsBtn.layer.cornerRadius = 1;
    self.orderDetailsBtn.layer.borderWidth = 1;
    self.orderDetailsBtn.layer.borderColor = [UIColor colorWithHexString:@"#EEEEEE"].CGColor;
    
    self.backHomePageBtn.layer.masksToBounds = YES;
    self.backHomePageBtn.layer.cornerRadius = 3;
    self.backHomePageBtn.layer.borderWidth = 1;
    self.backHomePageBtn.layer.borderColor = [UIColor colorWithHexString:@"#EEEEEE"].CGColor;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addCustomTitleWithTitle:@"支付成功"];
}

// 返回首页
- (IBAction)backHomePageAction:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[SearchFlightsVC class]]) {
            SearchFlightsVC *searchFlightsVC = (SearchFlightsVC *)controller;
            [self.navigationController popToViewController:searchFlightsVC animated:YES];
        }
    }
}

// 订单详情
- (IBAction)orderDetailsAction:(id)sender {
    //需要传 orderCode id 5位数的 token
    WKWebViewController *webVC = [[WKWebViewController alloc] initWithURL:[NSString stringWithFormat:@"http://192.168.3.104:8099/htmlAirplane2/personal.html?token=%@",kToken]];
    webVC.webType = 2;
    [self.navigationController pushViewController:webVC animated:YES];
}

// 我的行程
- (IBAction)myScheduleAction:(id)sender {
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
