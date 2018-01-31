//
//  shareRuleVC.m
//  TuLingApp
//
//  Created by hua on 17/4/27.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "shareRuleVC.h"

@interface shareRuleVC ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation shareRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"分享赚规则";
    [self createView];
    // Do any additional setup after loading the view.
}

-(void)createView
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    TLAccount *account = [TLAccountSave account];
    NSString *str = [ktestWEBV2 stringByAppendingString:[NSString stringWithFormat:@"share-statics/rule.html?uuid=%@&client=ios",account.uuid]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    
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
