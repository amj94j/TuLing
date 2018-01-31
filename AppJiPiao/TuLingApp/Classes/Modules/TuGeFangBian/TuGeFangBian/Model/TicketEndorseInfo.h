//
//  TicketEndorseInfo.h
//  TuLingApp
//
//  Created by apple on 2017/12/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"
#import "EndorseBackRulesModel.h"

@interface TicketEndorseInfo : TicketBaseModel
@property (nonatomic) NSInteger backState; // 0 是前往 1是返回 2是往返
@property (nonatomic) NSInteger orderType;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *backBeginTime;
@property (nonatomic, copy) NSArray *selectPersons;
@property (nonatomic, copy) NSDictionary *selectedReasonResult;
@property (nonatomic, copy) NSDictionary *order;
@property (nonatomic, copy) NSArray *reasonResult;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *businessCode;
@property (nonatomic, copy) NSString *backBusinessCode;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *superiorId;
@property (nonatomic, strong) EndorseBackRulesModel *ruleResult;

+ (TicketEndorseInfo *)getTicketEndorseInfo:(NSDictionary*)netDic;
+ (void)asyncPostPlaneQueryAPPChangeTicketDetailDic:(NSDictionary *)Dic SuccessBlock:(void(^)(NSDictionary *dataDic))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;
@end
