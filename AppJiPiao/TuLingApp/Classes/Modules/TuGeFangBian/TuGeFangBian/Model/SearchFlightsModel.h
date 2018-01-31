//
//  SearchFlightsModel.h
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"
#import "TLTicketModel.h"
#import "TicketSpacePolicyModel.h"

typedef enum : NSUInteger {
    OrderFlightTypeUnknow = 0,   // 未知
    OrderFlightTypeDanCheng,     // 单程
    OrderFlightTypeWangFanGo,    // 往返去
    OrderFlightTypeWangFanBack,  // 往返回
} OrderFlightType;               // 行程类型

@interface SearchFlightsModel : TicketBaseModel
@property (nonatomic, copy)NSString *airlineCode; // 航空公司代码
@property (nonatomic, copy)NSString *airlineCompany; // 航空公司名字
@property (nonatomic, copy)NSString *arrterminal; // 降落航站楼
@property (nonatomic, copy)NSString *beginAirPort; // 起飞机场
@property (nonatomic, copy)NSString *beginAirPortName; // 起飞机场名
@property (nonatomic, copy)NSString *beginCity;// = CTU;
@property (nonatomic, copy)NSString *beginCityName;// = "\U6210\U90fd";
@property (nonatomic, copy)NSString *beginTimeOrigin;// 原始的开始时间 "2017-12-11 13:30:00";
@property (nonatomic, copy)NSString *beginTime;// 开始时间 "2017-12-11 13:30:00";
@property (nonatomic, copy)NSString *bTime;
@property (nonatomic, copy)NSString *beginWeekTime;
@property (nonatomic, copy)NSString *beginWeek;
@property (nonatomic, copy)NSString *classtype;// 舱位 "\U5934\U7b49\U8231\U6298\U6263\U8231";
@property (nonatomic, copy)NSString *endAirPort;//  PEK;
@property (nonatomic, copy)NSString *endAirPortName;//  "\U9996\U90fd";
@property (nonatomic, copy)NSString *endCity; // PEK;
@property (nonatomic, copy)NSString *endCityName;//  "\U5317\U4eac";
@property (nonatomic, copy)NSString *endTimeOrigin;// 原始的结束时间 "2017-12-11 16:10:00";
@property (nonatomic, copy)NSString *endTime;//  "2017-12-11 16:10:00";
@property (nonatomic, copy)NSString *eTime;
@property (nonatomic, copy)NSString *faceprice;// = 810;
@property (nonatomic, copy)NSString *flightNumber; // 班机号码  3U8887;
@property (nonatomic, copy)NSString *fromterminal; // 起飞航站楼 T1;
@property (nonatomic, assign)BOOL isSharing; // 是否共享
@property (nonatomic, assign)BOOL isDirect; // 是否直达
@property (nonatomic, copy)NSString *lowprice; // 最低价 "2200.00";
@property (nonatomic, assign)NSInteger newLowPrice; // 最低价 "2200.00";
@property (nonatomic, copy)NSString *planeSize; // 飞机大小 "\U5927";
@property (nonatomic, copy)NSString *planeType; //= 33B;
@property (nonatomic, copy)NSString *rate; //折扣 "0.0";
@property (nonatomic, copy)NSString *realCompany; //真实公司"<null>";
@property (nonatomic, copy)NSString *realFlightNum; // 真实飞机号 "<null>";
@property (nonatomic, copy)NSString *remark; // 备注  "<null>";
@property (nonatomic, copy)NSString *seatList; //座位名单 "<null>";
@property (nonatomic, copy)NSString *seats; //座位 9;
@property (nonatomic, copy)NSString *settlementprice; //结算价格 850;
@property (nonatomic, copy)NSString *buildFee; //= "基建费用";
@property (nonatomic, copy)NSString *fuelFee; //= "燃油费用";
@property (nonatomic, copy)NSString *stopCity; //= "<null>";
@property (nonatomic, copy)NSString *stopCityName; // 停止城市名 "";
@property (nonatomic, copy)NSString *tgqremark; // "<null>";
@property (nonatomic, assign)BOOL twoDay; // 是否次日
@property (nonatomic, copy)NSString *flightTime; // 飞行时长 1h10m
@property (nonatomic, copy) NSArray *cabinListArr;
@property (nonatomic, strong) TicketSpacePolicyModel *spacePolicyModel; // 当前选择的舱位政策模型，里面包含选择的舱位模型
@property (nonatomic, assign) OrderFlightType flightType; // 行程类型



// 获取Demo数据
+ (instancetype)getDemoInstance:(BOOL)isGo;
+ (NSMutableArray *)getDemoInstances;

+(SearchFlightsModel *)getUserModel:(NSDictionary*)netDic;
+(SearchFlightsModel *)getNewEndorseModel:(NSDictionary*)netDic;

// 搜索页 点击搜索
+ (void)asyncPostTicketInfoListTicketModel:(TLTicketModel *)ticketModel SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;

// 条件搜索
+ (void)asyncPostQueryFlightDeatilTicketModel:(TLTicketModel *)ticketModel SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;
// 查询条数
+ (void)asyncPostTicketListCountTicketModel:(TLTicketModel *)ticketModel SuccessBlock:(void(^)(NSInteger count))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;
// 改签
+ (void)asyncPostEndorseModel:(TLTicketModel *)ticketModel backState:(NSString *)backState SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;
@end
