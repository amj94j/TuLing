//
//  ZJPersonalCenterWebVC.m
//  TuLingApp
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 shensiwei. All rights reserved.
//

#import "ZJPersonalCenterWebVC.h"
#import "OneWayCalendarChooseVC.h"
#import "BackForthCalendarChooseVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SearchFlightsVC.h"
#import "EndorseViewController.h"
#import "PayViewController.h"
#import "newServiceVC.h"

@interface ZJPersonalCenterWebVC ()<UIWebViewDelegate>
{
    NSString *_url;
}
@property WebViewJavascriptBridge *bridge;
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation ZJPersonalCenterWebVC

- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        _url = url;
        self.homeUrl = [NSURL URLWithString:url];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.bounces = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self addCustomBackBarButtonItemWithTarget:self action:@selector(backUP)];
    
    if (_bridge) { return; }
    
    //开启调试信息
    [WebViewJavascriptBridge enableLogging];
    //响应JS通过send发送给OC的消息
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    WS(ws)
    [_bridge registerHandler:@"submitFromWeb" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"----------submitFromWeb-------------%@",data);
        if ([data isKindOfClass:[NSDictionary class]]) {
            EndorseModel *model = [EndorseModel getEndorseModel:data];
            if ([model.orderType isEqualToString:@"2"] && [model.backState isEqualToString:@"2"]) {
                [ws backForthAction:model];
            } else {
                [ws oneWayAction:model];
            }
        }
    }];
    
    // 再来一单
    [_bridge registerHandler:@"ticketAngular" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController pushViewController:[SearchFlightsVC new] animated:YES];
    }];
    
    // 改签
    [_bridge registerHandler:@"applyAngular" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"----------applyAngular-------------%@",data);
        EndorseViewController *endorseVC = [EndorseViewController new];
        endorseVC.endorseDic = data[@"param"];
        [self.navigationController pushViewController:endorseVC animated:YES];
    }];
    
    // 去支付
    [_bridge registerHandler:@"toPay" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"----------toPay-------------%@",data);
        NSDictionary *paramDic = data[@"param"];
        PayViewController *payVC = [PayViewController new];
        if ([[NSString stringWithFormat:@"%@",paramDic[@"flag"]] isEqualToString:@"0"]) {
            payVC.payType = 2;
            
        } else {
            payVC.payType = 1;
        }
        payVC.dataDic = paramDic;
        [self.navigationController pushViewController:payVC animated:YES];
        if ([[NSString stringWithFormat:@"%@",paramDic[@"flag"]] isEqualToString:@"0"]) {
            [self.webView goBack];
        }
        
    }];
}

// 单程
- (void)oneWayAction:(EndorseModel *)model {
    OneWayCalendarChooseVC *oneVC = [OneWayCalendarChooseVC new];
    oneVC.oneWayType = OneWayTypeEndorse;
    oneVC.endorseModel = model;
    if ([model.backState isEqualToString:@"1"]) {
        oneVC.selectDate = model.returnBeginTime;
    } else {
        oneVC.selectDate = model.goBeginTime;
    }
    [self.navigationController pushViewController:oneVC animated:YES];
}

// 往返
- (void)backForthAction:(EndorseModel *)model {
    BackForthCalendarChooseVC *backVC = [BackForthCalendarChooseVC new];
    backVC.backForthType = BackForthTypeEndorse;
    backVC.endorseModel = model;
    backVC.isforth = YES;
    backVC.fortdate = [Untils dateFormString:model.goBeginTime];
    backVC.baceDate = [Untils dateFormString:model.returnBeginTime];
    [self.navigationController pushViewController:backVC animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self addCustomTitleWithTitle: [_webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onBackBarBtnClick {
    if (self.webView.canGoBack) {
        [self.webView goBack];
        if (self.navigationItem.leftBarButtonItems.count == 1) {
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadWebView" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
