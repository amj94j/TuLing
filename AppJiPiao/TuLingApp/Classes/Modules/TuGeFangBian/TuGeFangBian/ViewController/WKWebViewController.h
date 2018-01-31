//
//  WKWebViewController.h
//  TuLingApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  Web页面

#import "TicketBaseVC.h"

@interface WKWebViewController : TicketBaseVC
@property (strong, nonatomic) NSURL *homeUrl;
@property (nonatomic ,copy) NSDictionary *dic;
@property (nonatomic) NSInteger webType;
- (instancetype)initWithURL:(NSString *)url;
@property (nonatomic, copy) void(^webPersonalCenterBlock)(NSString *URL);
@end
