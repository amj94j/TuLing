//
//  TicketModel.h
//  TuLingApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"
#import "CityModel.h"

@interface TLTicketModel : TicketBaseModel
@property (nonatomic, strong) CityModel *beginCity;
@property (nonatomic, strong) CityModel *endCity;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *backBeginTime;
@property (nonatomic, assign) NSInteger orderType; // 单程1 往返2
@property (nonatomic, assign) NSInteger backState; 
@property (nonatomic, copy) NSString *positionType; // 经济舱0 头等舱1
@property (nonatomic, copy) NSString *ticketSort; // 0价格升 1价格降 2时间升 3时间降
@property (nonatomic, copy) NSString *timeType; // 0是0-6，1是6-12,2是12-18,3是18-24 时间段
@property (nonatomic, copy) NSString *direct; // 0是，1不是 是否直达
@property (nonatomic, copy) NSString *share; // 0是共享，1不是 是否共享
@property (nonatomic, copy) NSString *airCompany; // 航空公司 直接传
@property (nonatomic, copy) NSString *beginAirPortName; // 起飞机场
@property (nonatomic, copy) NSString *endAirPort; // 落地机场
@property (nonatomic, copy) NSString *planeSize; // 大中小
@property (nonatomic, assign) BOOL isGo; // 是否是去程 默认是去

// 获取Demo数据:是否单程
+ (instancetype)getDemoInstance:(BOOL)isDanCheng;
// 航空公司
+ (void)asyncPostTicketQueryCompanyconTicketModel:(TLTicketModel *)ticketModel SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;

// 机场
+ (void)asyncPostTicketQueryAirportconTicketModel:(TLTicketModel *)ticketModel SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;

+(TLTicketModel *)getUserModel:(NSDictionary*)netDic;
+(TLTicketModel *)getEndorseRequestModel:(NSDictionary*)netDic;
@end
