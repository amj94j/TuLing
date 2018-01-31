//
//  TicketOrderModel.h
//  TuLingApp
//
//  Created by apple on 2017/12/11.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"
#import "SearchFlightsModel.h"
#import "TLTicketModel.h"
#import "TicketSpaceModel.h"
#import "TicketHeadModel.h"
#import "TicketAddressModel.h"
#import "OrderPayModel.h"

@interface TicketOrderModel : TicketBaseModel
@property (nonatomic, strong) TLTicketModel *ticketModel; // 订票信息模型
@property (nonatomic, strong) SearchFlightsModel *goFlightModel; // 搜索到的航班信息模型:去程
@property (nonatomic, strong) SearchFlightsModel *backFlightModel; // 搜索到的航班信息模型:返程
@property (nonatomic, strong) NSMutableArray *passengerModels; // 乘机人数据 TicketPassengerModel
@property (nonatomic, strong) NSMutableArray *insuranceTradeModels; // 保险数据 TicketInsuranceTradeModel
@property (nonatomic, copy) NSString *phoneNum; // 联系手机

@property (nonatomic, assign) BOOL isNeedBaoXiaoPingZheng; // 报销凭证开关是否打开
@property (nonatomic, strong) TicketHeadModel *headModel; // 发票抬头模型：报销凭证开关打开且选择了才有效
@property (nonatomic, strong) TicketAddressModel *addrssModel; // 地址模型：报销凭证开关打开且选择了才有效
@property (nonatomic, assign) double allCost; // 订单总额
// 订单数据
@property (nonatomic, strong) OrderPayModel *orderPayModel;
// 获取Demo数据
+ (instancetype)getDemoInstance;
+ (void)asyncPostTicketQueryFlightDeatilTicketModel:(TLTicketModel *)ticketModel flightno:(NSString *)flightno SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;
@end
