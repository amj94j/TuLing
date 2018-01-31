//
//  DetailXiuXianYuLeViewController.m
//  TuLingApp
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "DetailXiuXianYuLeViewController.h"

@interface DetailXiuXianYuLeViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *detailWebView;

@end

@implementation DetailXiuXianYuLeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(ButtonClick) Title:@""];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    [self createWebView];
}
- (void)createWebView
{
    _detailWebView  =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    _detailWebView.scrollView.bounces = NO;
    _detailWebView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_detailWebView loadRequest:request];
    [self.view addSubview:_detailWebView];
}
//返回上页
- (void)ButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
//加载完成
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    //获取当前页面的title
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
