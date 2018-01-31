//
//  TicketOrderInfoModel.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/22.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketOrderInfoModel.h"
#import "TicketOrderModel.h"
#import "SearchFlightsModel.h"
#import "TLTicketModel.h"
#import "TicketSpaceModel.h"
#import "TicketHeadModel.h"
#import "TicketAddressModel.h"
#import "TicketPassengerModel.h"
#import "TicketInsuranceModel.h"

@implementation TicketOrderInfoModel

#pragma mark 创建订单
+ (void)asyncCreateOrderWithTicketOrderModel:(TicketOrderModel *)orderModel
                                SuccessBlock:(void(^)(NSArray *dataArray))successBlock
                                  errorBlock:(void(^)(NSError *errorResult))errorBlock
{
    @synchronized(self){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%ld", (long)orderModel.ticketModel.orderType] forKey:@"orderType"];
        
        NSMutableArray *flightsArray = [NSMutableArray array];
        if (orderModel.goFlightModel) [flightsArray addObject:orderModel.goFlightModel];
        if (orderModel.backFlightModel) [flightsArray addObject:orderModel.backFlightModel];
        [flightsArray enumerateObjectsUsingBlock:^(SearchFlightsModel *flightModel, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *flightDict = [[NSMutableDictionary alloc] init];
            [flightDict setObject:flightModel.beginTimeOrigin forKey:@"beginTime"];
            [flightDict setObject:flightModel.fromterminal forKey:@"fromTerminal"];
            [flightDict setObject:flightModel.arrterminal forKey:@"arrTerminal"];
            [flightDict setObject:flightModel.beginAirPort forKey:@"beginAirPort"];
            [flightDict setObject:flightModel.endAirPort forKey:@"endAirPort"];
            [flightDict setObject:flightModel.beginAirPortName forKey:@"depairPortch"];
            [flightDict setObject:flightModel.endAirPortName forKey:@"arrairPortch"];
            [flightDict setObject:flightModel.endTimeOrigin forKey:@"endTime"];
            [flightDict setObject:flightModel.beginCity forKey:@"beginCity"];
            [flightDict setObject:flightModel.endCity forKey:@"endCity"];
            [flightDict setObject:flightModel.beginCityName forKey:@"beginCityName"];
            [flightDict setObject:flightModel.endCityName forKey:@"endCityName"];
            [flightDict setObject:flightModel.beginAirPort forKey:@"beginAirPort"];
            [flightDict setObject:flightModel.endAirPort forKey:@"endAirPort"];
            [flightDict setObject:flightModel.airlineCode forKey:@"aircode"];
            [flightDict setObject:flightModel.airlineCompany forKey:@"airCompany"];
            [flightDict setObject:flightModel.flightNumber forKey:@"flightNumber"];
//            [flightDict setObject:[NSString stringWithFormat:@"%d", flightModel.isSharing] forKey:@"isShare"];
            [flightDict setObject:@"1" forKey:@"isShare"];
            [flightDict setObject:![flightModel.realFlightNum isEqualToString:@""] ? flightModel.realFlightNum : flightModel.flightNumber forKey:@"realFlightNumber"];///
            [flightDict setObject:flightModel.realCompany forKey:@"realAirCompany"];
            [flightDict setObject:[NSString stringWithFormat:@"%d", !flightModel.twoDay] forKey:@"isDirect"];
            [flightDict setObject:flightModel.stopCityName forKey:@"stopCity"];
            [flightDict setObject:[NSString stringWithFormat:@"%.1f", flightModel.spacePolicyModel.belongSpcaceModel.fee] forKey:@"buildFee"]; //
            [flightDict setObject:[NSString stringWithFormat:@"%.1f", flightModel.spacePolicyModel.belongSpcaceModel.tax] forKey:@"fuelFee"]; //
            [flightDict setObject:flightModel.planeType forKey:@"planeCode"];
            [flightDict setObject:flightModel.planeSize forKey:@"planeSize"];
            [flightDict setObject:[NSString stringWithFormat:@"%ld", (long)flightModel.spacePolicyModel.belongSpcaceModel.ticketprice] forKey:@"sale"]; //
            [flightDict setObject:[NSString stringWithFormat:@"%ld", (long)flightModel.spacePolicyModel.belongSpcaceModel.ticketprice] forKey:@"price"]; //
            [flightDict setObject:[NSString stringWithFormat:@"%.1f", flightModel.spacePolicyModel.rate] forKey:@"rebate"];
            [flightDict setObject:[NSString stringWithFormat:@"%ld", (long)flightModel.spacePolicyModel.belongSpcaceModel.ticketprice] forKey:@"costCrice"]; //
//            [flightDict setObject:[NSString stringWithFormat:@"%ld", (long)flightModel.spacePolicyModel.belongSpcaceModel.seatclass] forKey:@"seatType"];
            
            [flightDict setObject:flightModel.spacePolicyModel.belongSpcaceModel.classtype forKey:@"positionsType"];
            [flightDict setObject:flightModel.spacePolicyModel.belongSpcaceModel.seatcode forKey:@"seatType"];
            [flightDict setObject:[NSString stringWithFormat:@"%.0f", flightModel.spacePolicyModel.belongSpcaceModel.discount] forKey:@"discount"];
            [flightDict setObject:@"0" forKey:@"voyageno"]; //
            [dict setObject:flightDict forKey:idx == 0 ? @"toFilghtInfo" : @"backFilghtInfo"];
            [flightDict setObject:flightModel.airlineCode forKey:@"carrier"];
            [flightDict setObject:flightModel.spacePolicyModel.belongSpcaceModel.seatcode forKey:@"seatCode"];
            
        }];
        [dict setObject:kToken forKey:@"token"];
        
//        NSMutableString *persionIds = [[NSMutableString alloc] init];

        NSMutableArray *persionIds = [NSMutableArray new];
        [orderModel.passengerModels enumerateObjectsUsingBlock:^(TicketPassengerModel *passengerModel, NSUInteger idx, BOOL * _Nonnull stop) {
//            [persionIds appendFormat:@"%ld", (long)passengerModel.personId];
            [persionIds addObject:[NSString stringWithFormat:@"%ld",passengerModel.personId]];
        }];
        NSArray *arr = [persionIds copy];
        NSString *str = [arr componentsJoinedByString:@","];
        [dict setObject:str forKey:@"persionIds"];
//        [dict setObject:persionIds forKey:@"persionIds"];
        
        // 保险
        NSMutableArray *insuranceArray = [NSMutableArray array];
        [orderModel.insuranceTradeModels enumerateObjectsUsingBlock:^(TicketInsuranceTradeModel *tradeModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (tradeModel.isSelected) {
                [tradeModel.buyPassengerModels enumerateObjectsUsingBlock:^(TicketPassengerModel *passengerModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary *insuranceDict = [[NSMutableDictionary alloc] init];
                    [insuranceDict setObject:tradeModel.insuranceModel.insuranceId forKey:@"insuranceProductId"];
                    [insuranceDict setObject:[NSString stringWithFormat:@"%ld", (long)passengerModel.personId] forKey:@"personId"];
                    [insuranceArray addObject:insuranceDict];
                }];
                
            }
        }];
        [dict setObject:[NSString stringWithFormat:@"%d", insuranceArray.count != 0] forKey:@"isInsurance"];
        [dict setObject:insuranceArray forKey:@"insurance"];
        
        // 报销
        [dict setObject:[NSString stringWithFormat:@"%d", orderModel.isNeedBaoXiaoPingZheng] forKey:@"isReimburse"];
        if (orderModel.isNeedBaoXiaoPingZheng) {
            NSMutableDictionary *baoxiaoDict = [[NSMutableDictionary alloc] init];
            NSString *allAddress = [NSString stringWithFormat:@"%@%@%@%@", orderModel.addrssModel.province, orderModel.addrssModel.city, orderModel.addrssModel.county, orderModel.addrssModel.detailedAddress];
            [baoxiaoDict setObject:allAddress forKey:@"goodsAddress"];
            [baoxiaoDict setObject:orderModel.addrssModel.linkPhone forKey:@"goodsPhone"];
            [baoxiaoDict setObject:orderModel.addrssModel.userName forKey:@"consignee"];
            [baoxiaoDict setObject:orderModel.headModel.voucherCode forKey:@"voucherCode"];
            [baoxiaoDict setObject:orderModel.headModel.invoiceHead forKey:@"invoiceHead"];
            [baoxiaoDict setObject:orderModel.headModel.isPersonal forKey:@"isPersonal"];
            [dict setObject:baoxiaoDict forKey:@"voucher"];            
        }
        // 手机号
        [dict setObject:orderModel.phoneNum forKey:@"phone"];
        [dict setObject:orderModel.goFlightModel.spacePolicyModel.policyid forKey:@"policyId"];
        [dict setObject:@"0" forKey:@"outTicketType"];
        
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketCreateOrder];
        NSString *paramsJson = [Untils convertToJsonData:dict];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObject:paramsJson forKey:@"paramsJson"];
        NSLog(@"---------kPlaneTicketCreateOrder---paramsDic---------\n%@",paramsDic);
        [NetAccess postJSONWithUrl:url parameters:paramsDic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"-----kPlaneTicketCreateOrder------%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                if ([[NSString stringWithFormat:@"%@",responseObject[@"status"]] isEqualToString:@"0"] || responseObject[@"status"] == 0) {
                    if (successBlock) successBlock([datalist copy]);
                }
                else {
                    NSError *err;
                   if (errorBlock) errorBlock(err);
                }
            } else {
                NSError *err;
                if (errorBlock) errorBlock(err);
            }
        } fail:^{
            NSError *err;
             if (errorBlock) errorBlock(err);
        }];
    }
}

@end
