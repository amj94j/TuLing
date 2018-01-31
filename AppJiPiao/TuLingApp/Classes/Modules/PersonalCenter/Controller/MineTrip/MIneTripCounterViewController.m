//
//  MIneTripCounterViewController.m
//  TuLingApp
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "MIneTripCounterViewController.h"

@interface MIneTripCounterViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *CounterWebView;

@end

@implementation MIneTripCounterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网上值机";
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(ButtonClick) Title:@""];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [self createView];
}
- (void)createView
{
    self.CounterWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    self.CounterWebView.delegate = self;
    self.CounterWebView.scrollView.bounces = NO;
    NSURL *url = [NSURL URLWithString:self.CounterString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.CounterWebView loadRequest:request];
    [self.view addSubview:self.CounterWebView];
}
//webViewdelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)ButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
