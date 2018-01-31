//
//  OrderPayModel.h
//  TuLingApp
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"

@class TicketOrderModel;

@interface OrderPayModel : TicketBaseModel

@property (nonatomic) NSInteger isInsurance;
@property (nonatomic, copy) NSString *mobilePhone;
@property (nonatomic, copy) NSString *mtime;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic) NSInteger orderState;
@property (nonatomic) NSInteger orderType;
@property (nonatomic, copy) NSString *totalAmount; // 总价
@property (nonatomic, copy) NSString *businessCode;
@property (nonatomic, copy) NSString *backBusinessCode;
@property (nonatomic) BOOL isCallFree; //是否要开启 0关闭 1开启
@property (nonatomic) double settleBalance; // 账户余额
@property (nonatomic) NSInteger freezeScore;  //积分
@property (nonatomic) double integralBalance;

+ (OrderPayModel *)getOrderPayModel:(NSDictionary*)netDic;

// 订单支付页面获取数据
+ (void)asyncPostToOrderPayDataDic:(NSDictionary *)dataDic SuccessBlock:(void(^)(TicketOrderModel *ticketOrderModel,NSString *timeStr))successBlock errorBlock:(void(^)(NSError *errorResult))errorBlock ;

// 改签支付页面获取数据
+ (void)asyncPostToChangeTicketPayDataDic:(NSDictionary *)dataDic SuccessBlock:(void(^)(TicketOrderModel *ticketOrderModel,NSString *timeStr))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;
@end
