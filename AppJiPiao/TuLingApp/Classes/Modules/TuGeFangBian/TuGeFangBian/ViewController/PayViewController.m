//
//  PayViewController.m
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "PayViewController.h"
#import "OrderTableViewCell.h"
#import "OrderScoreTableViewCell.h"
#import "PayTableViewCell.h"
#import "TicketOrderModel.h"
#import "OrderPayModel.h"
#import "ChangeTicketPayCell.h"
#import "SearchFlightsVC.h"
#import "WKWebViewController.h"
#import "NetAccess.h"

#define kNavHeight 64

#define kBottomBtnHeight 44

@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSTimer *_countDownTimer;
    NSInteger _remainTimer_S;
    NSInteger _payWay; // 0 是微信 1是支付宝
    BOOL _is_integral; // 是否使用积分
    BOOL _is_balance; // 是否使用余额
}

@property (nonatomic, weak)UITableView * tableView;

@property (nonatomic, weak)UIButton * bottomBtn;

/**
 显示的总价
 */
@property (nonatomic, assign)double totalPrice;


/**
 要支付的费用
 */
@property (nonatomic, assign)double priceToPay;

/**
 可用积分
 */
@property (nonatomic, assign)NSInteger usableScore;

/**
 可用抵扣钱
 */
@property (nonatomic, assign)CGFloat usableSettleBalance;

/**
 账户余额
 */
@property (nonatomic, assign)CGFloat settleBalance;


// 倒计时时间
@property (nonatomic, copy) NSString *countdownTimer;

// 按钮是否显示
@property (nonatomic) BOOL isHidden;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    self.title = @"订单支付";
    self.countdownTimer = @"10";
    _payWay = 0;
    _remainTimer_S = 600;
    // 开始倒计时
    [self countdownAction];
    
    [self addTableView];
    
    [self addBottomBtn];
    
    if (self.payType == 1) {
        // 订单支付 H5跳转过来
        [OrderPayModel asyncPostToOrderPayDataDic:self.dataDic SuccessBlock:^(TicketOrderModel *ticketOrderModel, NSString *timeStr) {
            self.orderModel = ticketOrderModel;
            self.totalPrice = [self.orderModel.orderPayModel.totalAmount floatValue];
            self.priceToPay = [self.orderModel.orderPayModel.totalAmount floatValue];
            
            self.usableScore = self.orderModel.orderPayModel.freezeScore;
            
            self.isHidden = !self.orderModel.orderPayModel.isCallFree;
            // 余额
             self.usableSettleBalance = [[NSString stringWithFormat:@"%.0f",self.orderModel.orderPayModel.integralBalance] floatValue];
            
            self.settleBalance = self.orderModel.orderPayModel.settleBalance;
            
            _remainTimer_S = 600 - [Untils getCountDownRemainingTimeWithCreateTime:[Untils timeWithTimeIntervalString:timeStr] currentTime:[Untils getFormatDateByDate:[NSDate date]]];
            if (_remainTimer_S<=0) {
                _remainTimer_S = 0;
                self.countdownTimer = @"0";
                [_countDownTimer invalidate];
            }
            if (self.isHidden) {
                [self.bottomBtn setTitle:@"继续付款" forState:UIControlStateNormal];
            }
            [self.tableView reloadData];
        } errorBlock:^(NSError *errorResult) {
            
        }];
    } else if (self.payType == 2) {
        // 改签支付 H5跳转过来
        [OrderPayModel asyncPostToChangeTicketPayDataDic:self.dataDic SuccessBlock:^(TicketOrderModel *ticketOrderModel, NSString *timeStr) {
            self.orderModel = ticketOrderModel;
            self.totalPrice = [self.orderModel.orderPayModel.totalAmount floatValue];
            self.priceToPay = [self.orderModel.orderPayModel.totalAmount floatValue];
            
            self.usableScore = self.orderModel.orderPayModel.freezeScore;
            
            self.isHidden = !self.orderModel.orderPayModel.isCallFree;
            // 余额
            self.usableSettleBalance = [[NSString stringWithFormat:@"%.0f",self.orderModel.orderPayModel.integralBalance] floatValue];
            
            self.settleBalance = self.orderModel.orderPayModel.settleBalance;
            
            _remainTimer_S = 600 - [Untils getCountDownRemainingTimeWithCreateTime:[Untils timeWithTimeIntervalString:timeStr] currentTime:[Untils getFormatDateByDate:[NSDate date]]];
            if (_remainTimer_S<=0) {
                _remainTimer_S = 0;
                self.countdownTimer = @"0";
                [_countDownTimer invalidate];
            }
            
            [self.tableView reloadData];
        } errorBlock:^(NSError *errorResult) {
            
        }];
        
        
        
    } else {
        
        // 获取积分余额的接口
        [self getSoreAndMoney];
        
        self.totalPrice = self.orderModel.allCost;
        
        self.priceToPay = self.orderModel.allCost;
    }
    
}

- (void)addTableView
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TLScreenWidth, TLScreenHeight - kNavHeight - kBottomBtnHeight) style:UITableViewStylePlain];
    
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangeTicketPayCell" bundle:nil] forCellReuseIdentifier:@"ChangeTicketPayCell"];
}

- (void)addBottomBtn
{
    CGFloat btnY = CGRectGetMaxY(self.tableView.frame);
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, btnY, TLScreenWidth, PXChange(88))];
    
    self.bottomBtn = btn;
    
    btn.backgroundColor = TLColor(16, 124, 61, 1);
    
    [btn setTitle:@"确认支付" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(goToPay) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.payType == 2) {
            return 46;
        } else {
            return 221;
        }
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 2) {
        return 1;
    }else{
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.payType == 2) {
            ChangeTicketPayCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeTicketPayCell" forIndexPath:indexPath];
            // 改签总价
            cell.upgradeCostLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.orderPayModel.totalAmount];
            return cell;
        } else {
            OrderTableViewCell * cell = [OrderTableViewCell cellWithTableView:tableView];
            
            cell.model = self.orderModel;
            
            if (self.payType == 1) {
                cell.totalPriceLabel.text = [NSString stringWithFormat:@"%@",self.orderModel.orderPayModel.totalAmount];
            } else {
                cell.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.orderModel.allCost];
            }
            return cell;
        }
    }else if (indexPath.section == 1){
        
        PayTableViewCell * cell = [PayTableViewCell cellWithTableView:tableView];
        
        cell.iconView.hidden = YES;
        
        cell.zhiFuIconView.hidden =YES;
        
        cell.zhiFuLabel.hidden = YES;
        
        cell.middleLabel.hidden = NO;
        
        NSString * str = [NSString stringWithFormat:@"请在%@分钟内完成支付,以免耽误您的行程",self.countdownTimer];
        
        NSString * subStr = [NSString stringWithFormat:@"%@分钟",self.countdownTimer];
        
        NSRange range = [str rangeOfString:subStr];
        
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:str];
        
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        
        cell.middleLabel.text = [NSString stringWithFormat:@"请在%@分钟内完成支付,以免耽误您的行程",self.countdownTimer];
        
        cell.middleLabel.font = [UIFont systemFontOfSize:12];
        
        cell.middleLabel.attributedText = attStr;
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        OrderScoreTableViewCell * cell = [OrderScoreTableViewCell cellWithTableView:tableView];
        if (self.payType == PayTypeOrderPay) {
            cell.switchBtn.hidden = self.isHidden;
        } else if (self.payType == PayTypeChangeTicketPay) {
            cell.switchBtn.hidden = YES;
        }
        if (indexPath.row == 0) {
            
            cell.titleLabel.text = @"途铃积分";
            
            cell.contentLabel.text = [NSString stringWithFormat:@"可用%ld途铃积分抵¥%.2f",(long)self.usableScore,self.usableSettleBalance];
            
//            if (self.usableSettleBalance == 0) {
//                cell.switchBtn.enabled = NO;
//            } else {
//                cell.switchBtn.enabled = YES;
//            }
            
            cell.openOrCloseBlock = ^(BOOL isOn) {
                _is_integral = isOn;
                if (isOn) {
                    
                    self.priceToPay = self.priceToPay -self.usableSettleBalance;
                    
                }else{
                    self.priceToPay = self.priceToPay + self.usableSettleBalance;
                }
            };
            
        } else {
            
            cell.titleLabel.text = @"账户余额";
            
            cell.contentLabel.text = [NSString stringWithFormat:@"¥%.2f",self.settleBalance];
//            if (self.settleBalance == 0) {
//                cell.switchBtn.enabled = NO;
//            } else {
//                cell.switchBtn.enabled = YES;
//            }
            
            cell.openOrCloseBlock = ^(BOOL isOn) {
                _is_balance = isOn;
                if (isOn) {
                    self.priceToPay = self.priceToPay - self.settleBalance;
                }else{
                    self.priceToPay = self.priceToPay + self.settleBalance;
                }
                
            };
            
        }
        
        return cell;
        
    } else if (indexPath.section == 3) {
        
        PayTableViewCell * cell = [PayTableViewCell cellWithTableView:tableView];
        
        if (indexPath.row == 0) {
            cell.iconView.image = [UIImage imageNamed:@"形状8"];
            cell.zhiFuLabel.text = @"微信支付";
            cell.isSelect = YES;
            cell.zhiFuIconView.image = [UIImage imageNamed:@"形状5"];
        }else{
            cell.iconView.image = [UIImage imageNamed:@"形状7"];
            cell.zhiFuLabel.text = @"支付宝支付";
            cell.isSelect = NO;
            cell.zhiFuIconView.image = [UIImage imageNamed:@"形状6"];
        }
        
        
//        if (cell.isSelect) {
//            cell.zhiFuIconView.image = [UIImage imageNamed:@"形状5"];
//        } else {
//            cell.zhiFuIconView.image = [UIImage imageNamed:@"形状6"];
//        }
        
        return cell;
    }
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        PayTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        _payWay = indexPath.row;
        cell.isSelect = YES;// 修改这个被选中的一行
        cell.zhiFuIconView.image = [UIImage imageNamed:@"形状5"];
        if (indexPath.row == 0) {
            NSIndexPath *temp = [NSIndexPath indexPathForRow:1 inSection:3];
            PayTableViewCell *sCell = [tableView cellForRowAtIndexPath:temp];
            sCell.isSelect = NO;// 修改这个被选中的一行
            sCell.zhiFuIconView.image = [UIImage imageNamed:@"形状6"];
        } else {
            NSIndexPath *temp = [NSIndexPath indexPathForRow:0 inSection:3];
            PayTableViewCell *sCell = [tableView cellForRowAtIndexPath:temp];
            sCell.isSelect = NO;
            sCell.zhiFuIconView.image = [UIImage imageNamed:@"形状6"];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TLScreenWidth, 10)];
    
    view.backgroundColor = TLColor(234, 234, 234, 1);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

//请求数据,获取积分和余额
- (void)getSoreAndMoney
{
    NSString * urlStr = [kDomainName stringByAppendingString:@"basics/queryMobileUserScore"];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"token"] = kToken;
    
    [NetAccess postJSONWithUrl:urlStr parameters:param WithLoadingView:YES andLoadingViewStr:@"加载中..." success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            
            NSDictionary * dict = [responseObject[@"content"] firstObject];
            
            self.usableScore = [dict[@"usableScore"] integerValue];
            
            self.usableSettleBalance = [dict[@"usableSettleBalance"] floatValue];
            
            self.settleBalance = [dict[@"settleBalance"] floatValue];
            
            [self.tableView reloadData];
        }
        
    } fail:^{
       
        NSLog(@"出错了");
    }];
}

#pragma mark - 确认支付
- (void)goToPay
{
    if (_remainTimer_S == 0) {
        [self showProgress:@"当前订单已失效!"];
        return;
    }
    
    NSLog(@"去支付,需要支付%f,%ld",self.priceToPay,_payWay);
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    /* token     用户token
    orderId     途铃订单ID
    payChannelCode     支付渠道 100为支付宝，101为微信
    url     同步通知地址
    sign     签名
     */
    [dic setObject:kToken forKey:@"token"];
    if (_payWay == 0) {
        [dic setObject:@"101" forKey:@"payChannelCode"];
    } else {
        [dic setObject:@"100" forKey:@"payChannelCode"];
    }
    // 余额
    if (self.settleBalance == 0) {
        [dic setObject:@"1" forKey:@"shifouAccountBalance"];
    } else {
        [dic setObject:_is_balance?@"0":@"1" forKey:@"shifouAccountBalance"];
    }
    // 积分
    if (self.usableSettleBalance == 0) {
        [dic setObject:@"1" forKey:@"shifouIntegralBalance"];
    } else {
        [dic setObject:_is_integral?@"0":@"1" forKey:@"shifouIntegralBalance"];
    }

    [dic setObject:@"www.google.com" forKey:@"url"];
    
    switch (self.payType) {
        case PayTypeDefault:
            [dic setObject:[self.orderDataArray firstObject][@"id"] forKey:@"orderId"];
            break;
        case PayTypeOrderPay:
            [dic setObject:self.dataDic[@"orderID"] forKey:@"orderId"];
            break;
        case PayTypeChangeTicketPay:
            [dic setObject:self.dataDic[@"id"] forKey:@"orderId"];
            break;
            
        default:
            break;
    }
    
    NSArray *keys = [dic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *str = @"";
    for (NSString *categoryId in sortedArray) {
        if (str.length>0) {
            str = [NSString stringWithFormat:@"%@&%@=%@",str,categoryId,[dic objectForKey:categoryId]];
        } else {
            str = [NSString stringWithFormat:@"%@=%@",categoryId,[dic objectForKey:categoryId]];
        }
    }
    [dic setObject:[NetAccess md532BitLower:str] forKey:@"sign"];
    if (self.payType == PayTypeChangeTicketPay) {
        NSString *url = [kDomainName stringByAppendingString:kPayOrderChangeTouringPay];
        NSLog(@"%@---%@",url,dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            NSLog(@"---------kPayOrderTouringPay------------\n%@",responseObject);
        } fail:^{
            
        }];
    } else {
        NSString *url = [kDomainName stringByAppendingString:kPayOrderTouringPay];
        NSLog(@"%@---%@",url,dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            NSLog(@"---------kPayOrderTouringPay------------\n%@",responseObject);
        } fail:^{
            
        }];
    }
    
    
}

// 返回限制
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    } else {
        [self back];
        return YES;
    }
}

- (void)onBackBarBtnClick {
    [self back];
}

- (void)back {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"超过支付时效后的订单将被取消，请尽快完成支付。" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"继续支付" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认离开" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             if (self.payType == 0) {
                                                                 //个人中心
                                                                 WKWebViewController *webVC = [[WKWebViewController alloc] initWithURL:kPersonalCenterURL];
                                                                 webVC.webType = 2;
                                                                 [self.navigationController pushViewController:webVC animated:NO];
                                                             } else {
                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                             }
                                                         }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 定时器
- (void)countdownAction {
    // 1.创建NSTimer
    _countDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    //倒计时-1
    _remainTimer_S --;
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_remainTimer_S%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",_remainTimer_S%60];
    self.countdownTimer = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if (_remainTimer_S==0){
        [_countDownTimer invalidate];
    }
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
