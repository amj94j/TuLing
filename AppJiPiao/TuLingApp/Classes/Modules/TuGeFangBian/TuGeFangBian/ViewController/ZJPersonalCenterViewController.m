//
//  ZJPersonalCenterViewController.m
//  TuLingApp
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 shensiwei. All rights reserved.
//

#import "ZJPersonalCenterViewController.h"
#import "WKWebViewController.h"
#import "ZJPersonalCenterWebVC.h"
@interface ZJPersonalCenterViewController ()

@end

@implementation ZJPersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    addChildViewController
    WKWebViewController *webVC = [[WKWebViewController alloc] initWithURL:[NSString stringWithFormat:@"http://apptest.touring.com.cn/h5v2/airplane/personal.html?token=%@",kToken]];
//    WKWebViewController *webVC = [[WKWebViewController alloc] initWithURL:[NSString stringWithFormat:@"http://192.168.5.247:8099/htmlAirplane2/personal.html?token=5572622e39fee6d039942ac7d54610c2"]];
    
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [webVC.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addChildViewController:webVC];
    WS(ws)
    webVC.webPersonalCenterBlock = ^(NSString *URL) {
        ZJPersonalCenterWebVC *webVC = [[ZJPersonalCenterWebVC alloc] initWithURL:URL];
        [ws.navigationController pushViewController:webVC animated:YES];
    };
    [self.view addSubview:webVC.view];
    
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
