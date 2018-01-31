//
//  userAgreeViewController.m
//  TuLingApp
//
//  Created by hua on 17/1/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "userAgreeViewController.h"

@interface userAgreeViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *currentWebView;
@property(nonatomic,assign)NSInteger webViewHeigh;
@end

@implementation userAgreeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"用户协议";
     self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(ButtonClick) Title:@""];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [self createView];

}

- (void)createView {
    self.currentWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.currentWebView.delegate = self;
    self.currentWebView.scrollView.bounces = NO;
}

#pragma webView
- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

- (void)ButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
