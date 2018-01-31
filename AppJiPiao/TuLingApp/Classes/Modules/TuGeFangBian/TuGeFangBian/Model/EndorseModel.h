//
//  EndorseModel.h
//  TuLingApp
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"

@interface EndorseModel : TicketBaseModel
@property (nonatomic, copy) NSDictionary *oldEndorseDic;
@property (nonatomic, copy) NSString *backState; // 0 是前往 1是返回 2是往返
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSArray *personId;
@property (nonatomic, copy) NSArray *detailList; // 根据联系人id筛选之后的列表
@property (nonatomic, copy) NSString *returnBeginTime;
@property (nonatomic, copy) NSString *goBeginTime;
+ (EndorseModel *)getEndorseModel:(NSDictionary*)netDic;

// 获取改签申请理由能否改签
+ (void)asyncPostTicketCheckChangeTicketWithOrderDic:(NSDictionary *)orderDic SuccessBlock:(void(^)(NSDictionary *data))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;
@end
