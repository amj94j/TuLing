//
//  TicketSpaceModel.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  机票舱位模型

#import "TicketBaseModel.h"

@interface TicketSpaceModel : TicketBaseModel

// 舱位信息
@property (nonatomic, copy) NSString *flightno; // 航班号
@property (nonatomic, copy) NSString *seatcode; // 舱位码
@property (nonatomic, assign) NSInteger seatnum; // 剩余舱位个数
@property (nonatomic, assign) NSInteger seatclass; // 舱位分类 0经济舱，1公务舱，2头等舱
@property (nonatomic, copy) NSString *classtype; // 舱位类型 特价/公务舱折扣舱/头等舱折扣舱 等
@property (nonatomic, assign) double discount; // 折扣
@property (nonatomic, copy) NSString *pricetype; // 价格类型 公布运价
@property (nonatomic, assign) NSInteger planetype; // 机型大小 0小飞机1大飞机
@property (nonatomic, copy) NSString *planecode; // 机型 330

// 票价和基建、燃油
@property (nonatomic, assign) NSInteger ticketprice; // 成人票面价
@property (nonatomic, assign) NSInteger chdticketprice; // 儿童票面价
@property (nonatomic, assign) double babyticketprice; // 婴儿票面价
@property (nonatomic, assign) double fee; // 成人基建
@property (nonatomic, assign) double tax; // 成人燃油
@property (nonatomic, assign) double chdfee; // 儿童基建
@property (nonatomic, assign) double chdtax; // 儿童燃油
@property (nonatomic, assign) double babyfee; // 婴儿基建
@property (nonatomic, assign) double babytax; // 婴儿燃油

@property (nonatomic, strong) NSMutableArray *policyModels; // 机票舱位政策信息模型

// 获取Demo数据
+ (instancetype)getDemoInstance;

#pragma mark 获取航班舱位信息接口
+ (void)asyncQueryFlightSpaceInfoWithTicketModel:(TLTicketModel *)ticketModel
                                        flightno:(NSString *)flightno
                                       beginTime:(NSString *)beginTime
                                    SuccessBlock:(void(^)(NSArray *dataArray))successBlock
                                      errorBlock:(void(^)(NSError *errorResult))errorBlock;

#pragma mark 获取改签航班舱位信息接口
+ (void)asyncPostQueryChangeFlightDeatilWithTicketModel:(TLTicketModel *)ticketModel
                                           FlightsModel:(SearchFlightsModel *)flightsModel
                                            oldSeatcode:(NSString *)oldSeatcode
                                            oldDiscount:(NSString *)oldDiscount
                                           SuccessBlock:(void(^)(NSArray *dataArray))successBlock
                                             errorBlock:(void(^)(NSError *errorResult))errorBlock;

@end

