//
//  shareAllVC.m
//  TuLingApp
//
//  Created by hua on 17/4/27.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "shareAllVC.h"
#import "shareRuleVC.h"
@interface shareAllVC ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation shareAllVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享统计";
    
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 40, 40) ImageName:@"" Target:self Action:@selector(rightClick) Title:@"规则"];
    [button setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    self.view.backgroundColor =[UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self createView];
}

-(void)rightClick
{
    shareRuleVC *vc = [[shareRuleVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];


}
-(void)createView
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    TLAccount *account = [TLAccountSave account];
    NSString *str = [ _urlString stringByAppendingString:[NSString stringWithFormat:@"?uuid=%@&client=ios",account.uuid]];
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSString *requestString = [[request URL] absoluteString];
    
    return YES;
    
    
}
@end
