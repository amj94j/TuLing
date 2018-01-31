//
//  WKWebViewController.m
//  TuLingApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "WKWebViewController.h"
#import "OneWayCalendarChooseVC.h"
#import "BackForthCalendarChooseVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SearchFlightsVC.h"
#import "EndorseViewController.h"
#import "PayViewController.h"
#import "newServiceVC.h"

@interface WKWebViewController () <UIWebViewDelegate>
{
    NSString *_url;
}
@property WebViewJavascriptBridge *bridge;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation WKWebViewController

- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        _url = url;
        self.homeUrl = [NSURL URLWithString:url];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    }];
}

- (void)reloadWebView {
    [self.webView reload];
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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.bounces = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.webView = webView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebView) name:@"reloadWebView" object:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    if (self.dic) {
//    [_bridge callHandler:@"functionInJs" data:self.dic responseCallback:^(id responseData) {
//    }];
//}
    NSString *str = [[request URL] absoluteString];
    if(!([str rangeOfString:@"personal"].length>0) && str.length>0 && [str rangeOfString:@"http"].length>0)
    {
        NSLog(@"yes");
        if (self.webPersonalCenterBlock) {
            self.webPersonalCenterBlock(str);
        }
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self addCustomTitleWithTitle: [_webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    _url = [NSString stringWithFormat:@"%@",webView.request.URL];

}

// 返回按钮点击事件重写
- (void)onBackBarBtnClick {
    if (self.webView.canGoBack) {
        [self.webView goBack];
        if (self.navigationItem.leftBarButtonItems.count == 1) {
        }
    } else {
        if (self.webType == 2) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                // 找到相应的控制器
                if ([controller isKindOfClass:[newServiceVC class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}




/**清除缓存和cookie*/

- (void)cleanCacheAndCookie{
    
    //清除cookies
    
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [storage cookies]){
        
        [storage deleteCookie:cookie];
        
    }
    
    //清除UIWebView的缓存
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSURLCache * cache = [NSURLCache sharedURLCache];
    
    [cache removeAllCachedResponses];
    
    [cache setDiskCapacity:0];
    
    [cache setMemoryCapacity:0];
    
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


