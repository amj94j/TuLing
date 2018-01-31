//
//  paymentSuccessViewController.m
//  TuLingApp
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "paymentSuccessViewController.h"
#import "MyOrderDescriptionViewController.h"
#import "TripViewController.h"

@interface paymentSuccessViewController ()<UIWebViewDelegate>

@end

@implementation paymentSuccessViewController
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backTripView" object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{  [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewWillDisappear:(BOOL)animated
{ [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(buttonClick) Title:@""];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    self.title = @"支付成功";
   // [self createView];
}
-(void)createView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    TLAccount *account = [TLAccountSave account];
    NSString *allstr = [[CURRENTURL stringByAppendingString:@"#!/orders/paysuccess/"] stringByAppendingString:[StaticTools GetOrderId:@"orderid"]];
    NSString *str = [allstr stringByAppendingString:[NSString stringWithFormat:@"?uuid=%@&client=ios",account.uuid]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
//webViewdelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    
    if ([requestString containsString:@"/orders/"]) {
        if (![requestString containsString:@"orders/paysuccess"]&&![requestString isEqualToString:@"about:blank"]) {
            MyOrderDescriptionViewController *description = [[MyOrderDescriptionViewController alloc]init];
            description.DescriptionString = requestString;
            [self.navigationController pushViewController:description animated:YES];
            return NO;
        }
    } else if ([requestString containsString:@"ketao"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backTripView" object:nil];
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
        
        return NO;
    }
    return YES;
}
-(void)buttonClick
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
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
