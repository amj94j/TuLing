//
//  PayViewController.h
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  支付页

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PayType) {
    PayTypeDefault = 0,
    PayTypeOrderPay, // 订单支付 H5跳转过来
    PayTypeChangeTicketPay // 改签支付 H5跳转过来
};

@class TicketOrderModel;

@interface PayViewController : BaseVC

@property (nonatomic, strong) NSArray *orderDataArray;
@property (nonatomic, strong) TicketOrderModel *orderModel;
@property (nonatomic, assign) PayType payType;
@property (nonatomic, strong) NSDictionary *dataDic;
@end
