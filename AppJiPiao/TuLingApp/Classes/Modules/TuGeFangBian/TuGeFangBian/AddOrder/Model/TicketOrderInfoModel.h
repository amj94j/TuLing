//
//  TicketOrderInfoModel.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/22.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"

@class TicketOrderModel;

@interface TicketOrderInfoModel : TicketBaseModel

#pragma mark 创建订单
+ (void)asyncCreateOrderWithTicketOrderModel:(TicketOrderModel *)orderModel
                                SuccessBlock:(void(^)(NSArray *dataArray))successBlock
                                  errorBlock:(void(^)(NSError *errorResult))errorBlock;

@end
