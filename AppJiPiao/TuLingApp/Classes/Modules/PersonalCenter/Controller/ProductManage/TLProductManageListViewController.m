//
//  TLProductManageListViewController.m
//  TuLingApp
//
//  Created by 最印象 on 2017/10/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLProductManageListViewController.h"

@interface TLProductManageListViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation TLProductManageListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.webView reload];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self createView];
}

-(void)onBackBarBtnClick{
    [self exit];
    if (self.isShowLeftView){
        AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app.tab showLeftView];
    }
}


-(void)createView
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    NSString * idString = @"";
    if ([NSString isBlankString:self.shopID]){
        idString = self.shopID;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@goods-menage/goods-list.html?shopId=%@&client=ios",kH5Host1,idString];
//    TLAccount *account = [TLAccountSave account];
//    if ([NSString isBlankString:account.uuid]){
    NSString *str = urlString;
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
//    }
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    if (([requestString rangeOfString:@"/back"]).location!=NSNotFound) {
        

        [self onBackBarBtnClick];
       
        return NO;
    }
    
    return YES;
}

@end
