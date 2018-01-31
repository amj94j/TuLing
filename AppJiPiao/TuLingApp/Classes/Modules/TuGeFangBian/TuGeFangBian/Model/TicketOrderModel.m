//
//  TicketOrderModel.m
//  TuLingApp
//
//  Created by apple on 2017/12/11.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketOrderModel.h"

@implementation TicketOrderModel

- (NSMutableArray *)passengerModels
{
    if (!_passengerModels) {
        _passengerModels = [NSMutableArray array];
    }
    return _passengerModels;
}

- (NSMutableArray *)insuranceTradeModels
{
    if (!_insuranceTradeModels) {
        _insuranceTradeModels = [NSMutableArray array];
    }
    return _insuranceTradeModels;
}

// 获取Demo数据
+ (instancetype)getDemoInstance
{
    TicketOrderModel *orderModel = [[TicketOrderModel alloc] init];
    orderModel.ticketModel = [TLTicketModel getDemoInstance:NO];
    orderModel.goFlightModel = [SearchFlightsModel getDemoInstance:YES];
    orderModel.backFlightModel = [SearchFlightsModel getDemoInstance:NO];
    return orderModel;
}

+ (void)asyncPostTicketQueryFlightDeatilTicketModel:(TLTicketModel *)ticketModel flightno:(NSString *)flightno SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        CityModel *begincity = ticketModel.beginCity;
        CityModel *endCity = ticketModel.endCity;
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic = [NSMutableDictionary dictionaryWithDictionary:[Untils getObjectData:ticketModel]];
        NSString *begStr = [NSString stringWithFormat:@"%@",begincity.cityCode];
        NSString *endStr = [NSString stringWithFormat:@"%@",endCity.cityCode];
        [dic setObject:begStr forKey:@"beginCity"];
        [dic setObject:endStr forKey:@"endCity"];
        [dic setObject:flightno forKey:@"flightno"];
        [dic setObject:kToken forKey:@"token"];
        [dic setObject:[Untils accountUUID] forKey:@"userCode"];
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketQueryFlightDeatil];
        NSLog(@"---------kPlaneTicketQueryFlightDeatil---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
            NSLog(@"-----kPlaneTicketQueryFlightDeatil------%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                
//                NSDictionary *jiaDic = [TicketOrderModel aaa];
//                NSArray *datalist = [jiaDic objectForKey:@"content"];
                NSMutableArray *allDataArr = [NSMutableArray array];
                if ([datalist isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in datalist) {
                        NSMutableDictionary *oldDic = [NSMutableDictionary new
                                                       ];
                        oldDic = [dic mutableCopy];
                        [oldDic removeObjectForKey:@"policyinfos"];
                        
                        if ([[dic objectOrNilForKey:@"policyinfos"] isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *dict in [dic objectOrNilForKey:@"policyinfos"]) {
                                [oldDic addEntriesFromDictionary:dict];
                                [allDataArr addObject:oldDic];
                            }
                        }
                    }
                }
                
                if (successBlock) successBlock([allDataArr copy]);
            }
        } fail:^{
        }];
    }
    
}


// 假数据
+ (NSDictionary *)aaa {
    NSDictionary *dic =      @{
        @"content": @[
                    @{
                        @"seatcode": @"H",
                        @"ticketprice": @1270,
                        @"babyticketprice": @0,
                        @"fee": @50,
                        @"classtype": @"经济舱",
                        @"discount": @75,
                        @"tax": @0,
                        @"policyinfos": @[
                                        @{
                                            @"settleprice": @1313,
                                            @"bindings": @[],
                                            @"childticketsettleprice": @0,
                                            @"saleprice": @1263,
                                            @"babysettleprice": @0,
                                            @"isstandardkg": @1,
                                            @"childsettleprice": @0,
                                            @"brandname": @0,
                                            @"babyticketsettleprice": @0,
                                            @"producttype": @2,
                                            @"issuperpolicy": @0,
                                            @"itremark": @"",
                                            @"itprintprice": @1270,
                                            @"policyid": @"1_0_190909000",
                                            @"rate": @0.5,
                                            @"childrate": @0,
                                            @"brandtype": @"",
                                            @"customertype": @"1",
                                            @"airrule": @"",
                                            @"policytype": @"B2B",
                                            @"policysource": @3,
                                            @"ticketsettleprice": @1313,
                                            @"comment": @"",
                                            @"speprice": @7,
                                            @"babyrate": @2
                                        },
                                        @{
                                            @"settleprice": @1318,
                                            @"bindings": @[],
                                            @"childticketsettleprice": @0,
                                            @"saleprice": @1268,
                                            @"babysettleprice": @0,
                                            @"isstandardkg": @1,
                                            @"childsettleprice": @0,
                                            @"brandname": @0,
                                            @"babyticketsettleprice": @0,
                                            @"producttype": @2,
                                            @"issuperpolicy": @0,
                                            @"itremark": @"",
                                            @"itprintprice": @1270,
                                            @"policyid": @"1_0_190349417",
                                            @"rate": @0.1,
                                            @"childrate": @0,
                                            @"brandtype": @"",
                                            @"customertype": @"1",
                                            @"airrule": @"",
                                            @"policytype": @"BSP",
                                            @"policysource": @3,
                                            @"ticketsettleprice": @1318,
                                            @"comment": @"",
                                            @"speprice": @2,
                                            @"babyrate": @2
                                        }
                                        ],
                        @"planetype": @0,
                        @"itemid": @"0",
                        @"seatnum": @9,
                        @"babytax": @0,
                        @"flightno": @"KN5218",
                        @"chdtax": @0,
                        @"babyfee": @0,
                        @"planecode": @"",
                        @"pricetype": @"公布运价",
                        @"chdticketprice": @0,
                        @"chdfee": @0
                    },
                    @{
                        @"seatcode": @"H",
                        @"ticketprice": @1270,
                        @"babyticketprice": @0,
                        @"fee": @50,
                        @"classtype": @"经济舱",
                        @"discount": @75,
                        @"tax": @0,
                        @"policyinfos": @[
                                @{
                                    @"settleprice": @1313,
                                    @"bindings": @[],
                                    @"childticketsettleprice": @0,
                                    @"saleprice": @1263,
                                    @"babysettleprice": @0,
                                    @"isstandardkg": @1,
                                    @"childsettleprice": @0,
                                    @"brandname": @0,
                                    @"babyticketsettleprice": @0,
                                    @"producttype": @2,
                                    @"issuperpolicy": @0,
                                    @"itremark": @"",
                                    @"itprintprice": @1270,
                                    @"policyid": @"1_0_190909000",
                                    @"rate": @0.5,
                                    @"childrate": @0,
                                    @"brandtype": @"",
                                    @"customertype": @"1",
                                    @"airrule": @"",
                                    @"policytype": @"B2B",
                                    @"policysource": @3,
                                    @"ticketsettleprice": @1313,
                                    @"comment": @"",
                                    @"speprice": @7,
                                    @"babyrate": @2
                                    },
                                @{
                                    @"settleprice": @1318,
                                    @"bindings": @[],
                                    @"childticketsettleprice": @0,
                                    @"saleprice": @1268,
                                    @"babysettleprice": @0,
                                    @"isstandardkg": @1,
                                    @"childsettleprice": @0,
                                    @"brandname": @0,
                                    @"babyticketsettleprice": @0,
                                    @"producttype": @2,
                                    @"issuperpolicy": @0,
                                    @"itremark": @"",
                                    @"itprintprice": @1270,
                                    @"policyid": @"1_0_190349417",
                                    @"rate": @0.1,
                                    @"childrate": @0,
                                    @"brandtype": @"",
                                    @"customertype": @"1",
                                    @"airrule": @"",
                                    @"policytype": @"BSP",
                                    @"policysource": @3,
                                    @"ticketsettleprice": @1318,
                                    @"comment": @"",
                                    @"speprice": @2,
                                    @"babyrate": @2
                                    }
                                ],
                        @"planetype": @0,
                        @"itemid": @"0",
                        @"seatnum": @9,
                        @"babytax": @0,
                        @"flightno": @"KN5218",
                        @"chdtax": @0,
                        @"babyfee": @0,
                        @"planecode": @"",
                        @"pricetype": @"公布运价",
                        @"chdticketprice": @0,
                        @"chdfee": @0
                        },@{
                        @"seatcode": @"H",
                        @"ticketprice": @1270,
                        @"babyticketprice": @0,
                        @"fee": @50,
                        @"classtype": @"经济舱",
                        @"discount": @75,
                        @"tax": @0,
                        @"policyinfos": @[
                                @{
                                    @"settleprice": @1313,
                                    @"bindings": @[],
                                    @"childticketsettleprice": @0,
                                    @"saleprice": @1263,
                                    @"babysettleprice": @0,
                                    @"isstandardkg": @1,
                                    @"childsettleprice": @0,
                                    @"brandname": @0,
                                    @"babyticketsettleprice": @0,
                                    @"producttype": @2,
                                    @"issuperpolicy": @0,
                                    @"itremark": @"",
                                    @"itprintprice": @1270,
                                    @"policyid": @"1_0_190909000",
                                    @"rate": @0.5,
                                    @"childrate": @0,
                                    @"brandtype": @"",
                                    @"customertype": @"1",
                                    @"airrule": @"",
                                    @"policytype": @"B2B",
                                    @"policysource": @3,
                                    @"ticketsettleprice": @1313,
                                    @"comment": @"",
                                    @"speprice": @7,
                                    @"babyrate": @2
                                    },
                                @{
                                    @"settleprice": @1318,
                                    @"bindings": @[],
                                    @"childticketsettleprice": @0,
                                    @"saleprice": @1268,
                                    @"babysettleprice": @0,
                                    @"isstandardkg": @1,
                                    @"childsettleprice": @0,
                                    @"brandname": @0,
                                    @"babyticketsettleprice": @0,
                                    @"producttype": @2,
                                    @"issuperpolicy": @0,
                                    @"itremark": @"",
                                    @"itprintprice": @1270,
                                    @"policyid": @"1_0_190349417",
                                    @"rate": @0.1,
                                    @"childrate": @0,
                                    @"brandtype": @"",
                                    @"customertype": @"1",
                                    @"airrule": @"",
                                    @"policytype": @"BSP",
                                    @"policysource": @3,
                                    @"ticketsettleprice": @1318,
                                    @"comment": @"",
                                    @"speprice": @2,
                                    @"babyrate": @2
                                    }
                                ],
                        @"planetype": @0,
                        @"itemid": @"0",
                        @"seatnum": @9,
                        @"babytax": @0,
                        @"flightno": @"KN5218",
                        @"chdtax": @0,
                        @"babyfee": @0,
                        @"planecode": @"",
                        @"pricetype": @"公布运价",
                        @"chdticketprice": @0,
                        @"chdfee": @0
                        },@{
                        @"seatcode": @"H",
                        @"ticketprice": @1270,
                        @"babyticketprice": @0,
                        @"fee": @50,
                        @"classtype": @"经济舱",
                        @"discount": @75,
                        @"tax": @0,
                        @"policyinfos": @[
                                @{
                                    @"settleprice": @1313,
                                    @"bindings": @[],
                                    @"childticketsettleprice": @0,
                                    @"saleprice": @1263,
                                    @"babysettleprice": @0,
                                    @"isstandardkg": @1,
                                    @"childsettleprice": @0,
                                    @"brandname": @0,
                                    @"babyticketsettleprice": @0,
                                    @"producttype": @2,
                                    @"issuperpolicy": @0,
                                    @"itremark": @"",
                                    @"itprintprice": @1270,
                                    @"policyid": @"1_0_190909000",
                                    @"rate": @0.5,
                                    @"childrate": @0,
                                    @"brandtype": @"",
                                    @"customertype": @"1",
                                    @"airrule": @"",
                                    @"policytype": @"B2B",
                                    @"policysource": @3,
                                    @"ticketsettleprice": @1313,
                                    @"comment": @"",
                                    @"speprice": @7,
                                    @"babyrate": @2
                                    },
                                @{
                                    @"settleprice": @1318,
                                    @"bindings": @[],
                                    @"childticketsettleprice": @0,
                                    @"saleprice": @1268,
                                    @"babysettleprice": @0,
                                    @"isstandardkg": @1,
                                    @"childsettleprice": @0,
                                    @"brandname": @0,
                                    @"babyticketsettleprice": @0,
                                    @"producttype": @2,
                                    @"issuperpolicy": @0,
                                    @"itremark": @"",
                                    @"itprintprice": @1270,
                                    @"policyid": @"1_0_190349417",
                                    @"rate": @0.1,
                                    @"childrate": @0,
                                    @"brandtype": @"",
                                    @"customertype": @"1",
                                    @"airrule": @"",
                                    @"policytype": @"BSP",
                                    @"policysource": @3,
                                    @"ticketsettleprice": @1318,
                                    @"comment": @"",
                                    @"speprice": @2,
                                    @"babyrate": @2
                                    }
                                ],
                        @"planetype": @0,
                        @"itemid": @"0",
                        @"seatnum": @9,
                        @"babytax": @0,
                        @"flightno": @"KN5218",
                        @"chdtax": @0,
                        @"babyfee": @0,
                        @"planecode": @"",
                        @"pricetype": @"公布运价",
                        @"chdticketprice": @0,
                        @"chdfee": @0
                        },@{
                        @"seatcode": @"H",
                        @"ticketprice": @1270,
                        @"babyticketprice": @0,
                        @"fee": @50,
                        @"classtype": @"经济舱",
                        @"discount": @75,
                        @"tax": @0,
                        @"policyinfos": @[
                                @{
                                    @"settleprice": @1313,
                                    @"bindings": @[],
                                    @"childticketsettleprice": @0,
                                    @"saleprice": @1263,
                                    @"babysettleprice": @0,
                                    @"isstandardkg": @1,
                                    @"childsettleprice": @0,
                                    @"brandname": @0,
                                    @"babyticketsettleprice": @0,
                                    @"producttype": @2,
                                    @"issuperpolicy": @0,
                                    @"itremark": @"",
                                    @"itprintprice": @1270,
                                    @"policyid": @"1_0_190909000",
                                    @"rate": @0.5,
                                    @"childrate": @0,
                                    @"brandtype": @"",
                                    @"customertype": @"1",
                                    @"airrule": @"",
                                    @"policytype": @"B2B",
                                    @"policysource": @3,
                                    @"ticketsettleprice": @1313,
                                    @"comment": @"",
                                    @"speprice": @7,
                                    @"babyrate": @2
                                    },
                                @{
                                    @"settleprice": @1318,
                                    @"bindings": @[],
                                    @"childticketsettleprice": @0,
                                    @"saleprice": @1268,
                                    @"babysettleprice": @0,
                                    @"isstandardkg": @1,
                                    @"childsettleprice": @0,
                                    @"brandname": @0,
                                    @"babyticketsettleprice": @0,
                                    @"producttype": @2,
                                    @"issuperpolicy": @0,
                                    @"itremark": @"",
                                    @"itprintprice": @1270,
                                    @"policyid": @"1_0_190349417",
                                    @"rate": @0.1,
                                    @"childrate": @0,
                                    @"brandtype": @"",
                                    @"customertype": @"1",
                                    @"airrule": @"",
                                    @"policytype": @"BSP",
                                    @"policysource": @3,
                                    @"ticketsettleprice": @1318,
                                    @"comment": @"",
                                    @"speprice": @2,
                                    @"babyrate": @2
                                    }
                                ],
                        @"planetype": @0,
                        @"itemid": @"0",
                        @"seatnum": @9,
                        @"babytax": @0,
                        @"flightno": @"KN5218",
                        @"chdtax": @0,
                        @"babyfee": @0,
                        @"planecode": @"",
                        @"pricetype": @"公布运价",
                        @"chdticketprice": @0,
                        @"chdfee": @0
                        },
                    ],
        @"status": @"0"
        };
    
    
    return dic;
}
@end
