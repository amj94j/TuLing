//
//  ShopOrderDetailModel.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/20.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseModel.h"

@interface ShopOrderDetailModel : BaseModel

@property (nonatomic, assign) NSInteger orderId; // 订单id
@property (nonatomic, assign) NSInteger returnId; // 退款id
@property (nonatomic, assign) NSInteger statusId; // 状态id
@property (nonatomic, assign) double cost; // 运费
@property (nonatomic, assign) BOOL isReturn; // 是否有退款
@property (nonatomic, assign) double totle; // 合计

@property (nonatomic, strong) NSString *createTime; // 下单时间
@property (nonatomic, strong) NSString *endTime; // 交易完成时间
@property (nonatomic, strong) NSString *logisticsName; //快递公司
@property (nonatomic, strong) NSString *logisticsNumber; // 物流编号
@property (nonatomic, strong) NSString *logisticsStatus; // 物流状态
@property (nonatomic, strong) NSString *orderNumber; // 订单编号
@property (nonatomic, strong) NSString *payNumber; // 交易流水号
@property (nonatomic, strong) NSString *payTime; // 付款时间
@property (nonatomic, strong) NSString *payType; // 支付类型
@property (nonatomic, strong) NSString *remarks; // 买家留言
@property (nonatomic, strong) NSString *returnStatus; // 退款状态
@property (nonatomic, strong) NSString *status; // 状态
@property (nonatomic, strong) NSString *userName; // 买家名称
@property (nonatomic, strong) NSString *consignee; // 收货人
@property (nonatomic, strong) NSString *phone; // 收货电话
@property (nonatomic, strong) NSString *address; // 收货地址

@property (nonatomic, strong) NSDictionary *buttons;

@property (nonatomic, strong) NSMutableArray *priducts;

@end
