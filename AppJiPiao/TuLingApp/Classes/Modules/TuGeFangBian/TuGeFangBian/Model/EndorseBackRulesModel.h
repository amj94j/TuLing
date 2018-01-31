//
//  EndorseBackRulesModel.h
//  TuLingApp
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"

@interface EndorseBackRulesModel : TicketBaseModel
// 是否可改签，0:可以，1:不可以,2:航空公司规定为准
@property (nonatomic) NSInteger IsAllowedToSign;
@property (nonatomic, copy) NSString *IsAllowedToSignInfo;
@property (nonatomic) NSInteger OrderID; // 订单id
@property (nonatomic, copy) NSString *RefundTicketRuleInfo; // 退票客规描述
@property (nonatomic, copy) NSString *ChangeTicketRuleInfo; // 改签客规描述
@property (nonatomic, copy) NSString *Remark; // 其他描述

+(EndorseBackRulesModel *)getRuleModel:(NSDictionary*)netDic;
//获取退改签规则
+ (void)asyncPostPlaneTicketRuleProDic:(NSDictionary *)Dic SuccessBlock:(void(^)(EndorseBackRulesModel *model))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;
@end
