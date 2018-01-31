//
//  newServiceVC.m
//  TuLingApp
//
//  Created by hua on 2017/6/19.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "newServiceVC.h"
#import "SearchFlightsVC.h"
#import "WKWebViewController.h"
#import "ZJPersonalCenterViewController.h"
@interface newServiceVC ()

@end

@implementation newServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame =  CGRectMake(100, 200, 100, 30);
    [button setTitle:@"机票" forState:UIControlStateNormal];
    [ self.view addSubview:button];
    [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *endorseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    endorseBtn.frame =  CGRectMake(220, 200, 100, 30);
    [endorseBtn setTitle:@"个人中心" forState:UIControlStateNormal];
    [ self.view addSubview:endorseBtn];
    [endorseBtn addTarget:self action:@selector(endorseEvent:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *endorseBtns = [UIButton buttonWithType:UIButtonTypeSystem];
//    endorseBtns.frame =  CGRectMake(100, 320, 100, 30);
//    [endorseBtns setTitle:@"改签" forState:UIControlStateNormal];
//    [ self.view addSubview:endorseBtns];
//    [endorseBtns addTarget:self action:@selector(endorseBtnsEvent:) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *btns = [UIButton buttonWithType:UIButtonTypeSystem];
//    btns.frame =  CGRectMake(230, 320, 100, 30);
//    [btns setTitle:@"改签2" forState:UIControlStateNormal];
//    [ self.view addSubview:btns];
//    [btns addTarget:self action:@selector(btns) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonEvent:(UIButton*)button {
    [self.navigationController pushViewController:[SearchFlightsVC new] animated:YES];
}

- (void)endorseEvent:(UIButton*)button{
    ZJPersonalCenterViewController *webVC = [[ZJPersonalCenterViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)endorseBtnsEvent:(UIButton*)button{
    ZJPersonalCenterViewController *webVC = [[ZJPersonalCenterViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)btns {
    
}

@end

