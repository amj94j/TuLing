//
//  MyOrderDescriptionViewController.m
//  TuLingApp
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "MyOrderDescriptionViewController.h"
#import "ProductOfArticlesViewController.h"
#import "PaymentViewController.h"
//#import "LogisticsViewController.h"

@interface MyOrderDescriptionViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *OrderDescriptionWebView;

@end

@implementation MyOrderDescriptionViewController
- (void)viewWillAppear:(BOOL)animated
{[super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(buttonClick) Title:@""];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    self.title = @"订单详情";
    [self createView];
}
- (void)createView
{
    self.OrderDescriptionWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    self.OrderDescriptionWebView.delegate = self;
    self.OrderDescriptionWebView.scrollView.bounces = NO;
    NSURL *url = [NSURL URLWithString:self.DescriptionString];
    
 
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.OrderDescriptionWebView loadRequest:request];
    [self.view addSubview:self.OrderDescriptionWebView];
}
- (void)buttonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark webView
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
  
    if ([requestString containsString:@"ketao/product"]) {
        ProductOfArticlesViewController *product = [[ProductOfArticlesViewController alloc]init];
        product.ProductOfArticlesString = requestString;
        [self.navigationController pushViewController:product animated:YES];
        return NO;
    } else if ([requestString containsString:@"/orders/confirm"]) {
        PaymentViewController *payment = [[PaymentViewController alloc]init];
        payment.paymenString = requestString;
        [self.navigationController pushViewController:payment animated:YES];
        return NO;
    } else if ([requestString containsString:@"myorders"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    } else if ([requestString containsString:@"logistics"]) {
//        LogisticsViewController *logistics = [[LogisticsViewController alloc]init];
//        logistics.LogisticsString = requestString;
//        [self.navigationController pushViewController:logistics animated:YES];
        return NO;
    }
    return YES;
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
