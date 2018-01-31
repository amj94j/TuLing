//
//  OrderPayModel.m
//  TuLingApp
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "OrderPayModel.h"
#import "TicketOrderModel.h"

@implementation OrderPayModel

+ (OrderPayModel *)getOrderPayModel:(NSDictionary*)netDic {
    
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    OrderPayModel *model = [[OrderPayModel alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    model.isInsurance = [dataDic int64ValueForKey:@"isInsurance"];
    model.orderState = [dataDic int64ValueForKey:@"orderState"];
    model.orderType = [dataDic int64ValueForKey:@"orderType"];
    model.mobilePhone = [dataDic objectOrNilForKey:@"mobilePhone"];
    model.mtime = [dataDic objectOrNilForKey:@"mtime"];
    model.orderCode = [dataDic objectOrNilForKey:@"orderCode"];
    model.orderId = [dataDic objectOrNilForKey:@"orderId"];
    model.totalAmount = [dataDic objectOrNilForKey:@"totalAmount"];
    
    model.businessCode = [dataDic objectOrNilForKey:@"businessCode"];
    model.isCallFree = [dataDic boolValueForKey:@"isCallFree"];
    model.freezeScore = [dataDic int64ValueForKey:@"freezeScore"];
    model.settleBalance = [dataDic int64ValueForKey:@"settleBalance"];
    model.integralBalance = [dataDic int64ValueForKey:@"integralBalance"];
    if (model.orderType == 2) {
        model.backBusinessCode = [dataDic objectOrNilForKey:@"backBusinessCode"];
    }
    
    return model;
}


// 订单支付页面获取数据
+ (void)asyncPostToOrderPayDataDic:(NSDictionary *)dataDic SuccessBlock:(void(^)(TicketOrderModel *ticketOrderModel,NSString *timeStr))successBlock errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        
        NSMutableDictionary *mDic = [dataDic mutableCopy];
        [mDic setObject:mDic[@"orderID"] forKey:@"orderId"];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:[Untils convertToJsonData:mDic] forKey:@"params"];
        NSString *url = [kDomainName stringByAppendingString:kPlaneToOrderPay];
        NSLog(@"---------kPlaneToOrderPay---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            NSLog(@"---------kPlaneToOrderPay---------\n%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"content"] isKindOfClass:[NSArray class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                TicketOrderModel *ticketModel = [TicketOrderModel new];
                NSDictionary *allDic =  [datalist firstObject];
                NSString *timeStr = @"";
                if ([allDic[@"goDetailList"] isKindOfClass:[NSArray class]]) {
                    NSMutableDictionary *goDetailListDic = [[allDic[@"goDetailList"] firstObject] mutableCopy];
                    [goDetailListDic setObject:goDetailListDic[@"btime"] forKey:@"beginTime"];
                    [goDetailListDic setObject:goDetailListDic[@"etime"] forKey:@"endTime"];
                    timeStr = goDetailListDic[@"createTime"];
                    SearchFlightsModel *model = [SearchFlightsModel getUserModel:goDetailListDic];
                    ticketModel.goFlightModel = model;
                }
                if ([allDic[@"goDetailList"] isKindOfClass:[NSArray class]]) {
                    NSMutableDictionary *backDetailListDic = [[allDic[@"backDetailList"] firstObject] mutableCopy];
                    [backDetailListDic setObject:backDetailListDic[@"btime"] forKey:@"beginTime"];
                    [backDetailListDic setObject:backDetailListDic[@"etime"] forKey:@"endTime"];
                    SearchFlightsModel *model = [SearchFlightsModel getUserModel:backDetailListDic];
                    ticketModel.backFlightModel = model;
                }
                OrderPayModel *orderPay = [OrderPayModel getOrderPayModel:allDic];
                
                TLTicketModel *tModel = [TLTicketModel new];
                tModel.orderType = orderPay.orderType;
                CityModel *beginCity = [CityModel new];
                beginCity.name = [allDic[@"goDetailList"] firstObject][@"beginCity"];
                CityModel *endCity = [CityModel new];
                endCity.name = [allDic[@"goDetailList"] firstObject][@"endCity"];
                tModel.beginCity = beginCity;
                tModel.endCity = endCity;
                ticketModel.ticketModel = tModel;
                ticketModel.orderPayModel = orderPay;
                
                if (successBlock) successBlock(ticketModel,timeStr);
            }
            
        } fail:^{
            
        }];
    }
}

// 改签支付页面获取数据
+ (void)asyncPostToChangeTicketPayDataDic:(NSDictionary *)dataDic SuccessBlock:(void(^)(TicketOrderModel *ticketOrderModel,NSString *timeStr))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        NSMutableDictionary *mDic = [dataDic mutableCopy];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:[Untils convertToJsonData:mDic] forKey:@"params"];
        NSString *url = [kDomainName stringByAppendingString:kPlaneToChangeTicketPay];
        NSLog(@"---------kPlaneToChangeTicketPay---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            NSLog(@"---------kPlaneToChangeTicketPay---------\n%@",responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"content"] isKindOfClass:[NSArray class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                TicketOrderModel *ticketModel = [TicketOrderModel new];
                NSDictionary *allDic =  [datalist firstObject];
                NSString *timeStr = @"";
                if ([allDic[@"goOrderTicketDetail"] isKindOfClass:[NSArray class]]) {
                    NSMutableDictionary *goDetailListDic = [[allDic[@"goOrderTicketDetail"] firstObject] mutableCopy];
                    [goDetailListDic setObject:goDetailListDic[@"btime"] forKey:@"beginTime"];
                    [goDetailListDic setObject:goDetailListDic[@"etime"] forKey:@"endTime"];
                    SearchFlightsModel *model = [SearchFlightsModel getUserModel:goDetailListDic];
                    ticketModel.goFlightModel = model;
                    timeStr = goDetailListDic[@"createTime"];
                }
                if ([allDic[@"goDetailList"] isKindOfClass:[NSArray class]]) {
                    NSMutableDictionary *backDetailListDic = [[allDic[@"backDetailList"] firstObject] mutableCopy];
                    [backDetailListDic setObject:backDetailListDic[@"btime"] forKey:@"beginTime"];
                    [backDetailListDic setObject:backDetailListDic[@"etime"] forKey:@"endTime"];
                    SearchFlightsModel *model = [SearchFlightsModel getUserModel:backDetailListDic];
                    ticketModel.backFlightModel = model;
                    
                }
                OrderPayModel *orderPay = [OrderPayModel getOrderPayModel:allDic];
                orderPay.totalAmount = allDic[@"changeOderInfo"][@"payTotalAmount"];
                TLTicketModel *tModel = [TLTicketModel new];
                tModel.orderType = orderPay.orderType;
                CityModel *beginCity = [CityModel new];
                beginCity.name = [allDic[@"goDetailList"] firstObject][@"beginCity"];
                CityModel *endCity = [CityModel new];
                endCity.name = [allDic[@"goDetailList"] firstObject][@"endCity"];
                tModel.beginCity = beginCity;
                tModel.endCity = endCity;
                ticketModel.ticketModel = tModel;
                ticketModel.orderPayModel = orderPay;
                
                if (successBlock) successBlock(ticketModel,timeStr);
            }
            
            
            
        } fail:^{
            
        }];
    }
}

@end
