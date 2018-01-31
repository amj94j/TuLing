//
//  MIneTripBindViewController.m
//  TuLingApp
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "MIneTripBindViewController.h"

@interface MIneTripBindViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation MIneTripBindViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(ButtonClick) Title:@""];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    UIButton *RightButton = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 30, 14) ImageName:@"" Target:self Action:@selector(RightButtonClick) Title:@"确定"];
    RightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *RightItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
    self.navigationItem.rightBarButtonItem = RightItem;
    self.title = @"选择清单";
    [self createView];
}
- (void)createView
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    NSString *str = [NSString stringWithFormat:@"%@&client=ios",self.bindString];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}
//webViewdelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
    return YES;
}
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    //获取当前页面的title
   // self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)ButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)RightButtonClick
{
    NSString *string  = [self.webView stringByEvaluatingJavaScriptFromString:@"global_function('bind')"];
    if ([string isEqualToString:@"success"]) {
        [self.navigationController popViewControllerAnimated:YES];
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
