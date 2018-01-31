//
//  TicketOrderCommitViewController.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketOrderCommitViewController.h"
#import "TicketOrderModel.h"
#import "TicketOrderContentView.h"
#import "TicketOrderCommintFooterView.h"
#import "OrderDetailPopView.h"
#import "PayViewController.h"
#import "TicketOrderInfoModel.h"
#import "PayFailureViewController.h"

@interface TicketOrderCommitViewController ()

@property (nonatomic, strong) TicketOrderContentView *contentView;
@property (nonatomic, strong) TicketOrderCommintFooterView *footerView;
@property (nonatomic, weak) OrderDetailPopView * popView;
@property (nonatomic, copy) NSString *postageStr;
@end

@implementation TicketOrderCommitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.orderModel.ticketModel.orderType == 1) {
        [self layoutNavigationItemViewGo:self.orderModel.ticketModel.beginCity.name back:self.orderModel.ticketModel.endCity.name];
    } else {
        [self layoutNavigationItemViewGo:self.orderModel.ticketModel.beginCity.name back:self.orderModel.ticketModel.endCity.name image:@"selectflight_arrow_wf"];
    }
    // 请求邮费
    [self requestQueryDict];
    // 添加内容视图
    [self addContentView];
}

#pragma mark - planeTicket/queryDict
- (void)requestQueryDict {
    NSString *URL = [kDomainName stringByAppendingString:@"planeTicket/queryDict"];
    [NetAccess postJSONWithUrl:URL parameters:@{@"token":kToken} WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *datalist = [responseObject objectForKey:@"content"];
            self.postageStr = [datalist firstObject][@"courierFees"];
            _contentView.postageStr = self.postageStr;
        }
    } fail:^{
    }];
}

#pragma mark 添加内容视图
- (void)addContentView
{
    CGFloat footerViewH = 50.0f;
    [self updateBaseScrollViewEdgeMargin:UIEdgeInsetsMake(0, 0, -footerViewH, 0.0f)];
    
    WS(ws)
    __weak typeof(_contentView) weak_contentView = _contentView;
    _contentView = [TicketOrderContentView xib];
    _contentView.currentVC = self;
    _contentView.updateLayoutBlock = ^(CGFloat changeHeight) {
        [weak_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(changeHeight);
            
        }];
    };
    // 更新所有费用明细和乘机人数量
    _contentView.updateAllCostAndPassenger = ^(double cost, NSUInteger passengerCount) {
        [ws.footerView updateAllCost:cost passengerCount:passengerCount];
    };
    [self.baseScrollView addSubview:_contentView];

    CGFloat height = _contentView.height;
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.baseScrollView);
        make.left.equalTo(ws.baseScrollView);
        make.width.equalTo(ws.baseScrollView);
        make.height.mas_equalTo(height);
    }];
    self.baseScrollView.contentSize = CGSizeMake(self.baseScrollView.width, height);
    
    _contentView.orderModel = self.orderModel;
    
    // 底部视图
    _footerView = [TicketOrderCommintFooterView xib];
    
    _footerView.showDetaileAndGoPayBlock = ^(BOOL isGoPay) {
        if (isGoPay) { // 去支付
            if (ws.popView) {
                [ws.popView disMaskViewDismiss];
            }
            [ws createOrder];
        } else { // 明细
            if (!ws.popView) {
                OrderDetailPopView * popView = [[OrderDetailPopView alloc]initPopWithModel:ws.orderModel postageStr:ws.postageStr];
                [[[[UIApplication sharedApplication] delegate] window]addSubview:popView];
                ws.popView = popView;
            }else{
                [ws.popView disMaskViewDismiss];
                ws.popView = nil;
            }
        }
    };
    [self.view addSubview:_footerView];
    
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view);
        make.left.equalTo(ws.view);
        make.width.equalTo(ws.view);
        make.height.mas_equalTo(footerViewH);
    }];
}

#pragma mark 创建订单
- (void)createOrder
{
    
    // 验证
    if (self.orderModel.passengerModels.count == 0) {
        [self showProgress:@"请添加乘机人"];
        return;
    } else if (!self.orderModel.phoneNum || [self.orderModel.phoneNum isEqualToString:@""]) {
        [self showProgress:@"请输入联系手机"];
        return;
    } else if (self.orderModel.isNeedBaoXiaoPingZheng) {
        if (!self.orderModel.headModel) {
            [self showProgress:@"请选择发票抬头"];
            return;
        } else if (!self.orderModel.addrssModel) {
            [self showProgress:@"请选择邮寄地址"];
            return;
        }
    } else if (![HzTools isMobileNumber:self.orderModel.phoneNum]) {
        [self showProgress:@"请输入正确的手机号"];
        return;
    }
    
    WS(ws)
    [TicketOrderInfoModel asyncCreateOrderWithTicketOrderModel:self.orderModel SuccessBlock:^(NSArray *dataArray) {
        if (dataArray && dataArray.count) {
            PayViewController * payVc = [[PayViewController alloc]init];
            payVc.orderModel = ws.orderModel;
            payVc.orderDataArray = [dataArray copy];
            [ws.navigationController pushViewController:payVc animated:YES];
        }
    } errorBlock:^(NSError *errorResult) {
        [ws showProgressError:errorResult.localizedDescription];
        PayFailureViewController *payFailureVC = [PayFailureViewController new];
        payFailureVC.payFailureType = 1;
        [self.navigationController pushViewController:payFailureVC animated:NO];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
