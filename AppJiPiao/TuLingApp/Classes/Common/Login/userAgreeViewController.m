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
    //self.currentWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
    [self createView];

}
//About
- (void)createView {
    self.currentWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.currentWebView.delegate = self;
    self.currentWebView.scrollView.bounces = NO;
    //TLAccount *account = [TLAccountSave account];
    //?uuid=377af837-b57b-372f-9ad3-cc3295adf1c0
    NSString *str = [NSString stringWithFormat:@"%@",About1];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.currentWebView loadRequest:request];
    [self.view addSubview:self.currentWebView];
}

#pragma webView
- (void)webViewDidFinishLoad:(UIWebView *)webView{
   // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    _webViewHeigh = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
//    CGRect newFrame = webView.frame;
//    newFrame.size.height=_webViewHeigh+10;
//    webView.frame =newFrame;
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
