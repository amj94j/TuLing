//
//  TicketSpaceModel.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketSpaceModel.h"
#import "TicketSpacePolicyModel.h"

@implementation TicketSpaceModel

+ (TicketSpaceModel *)getUserModel:(NSDictionary*)netDic
{
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    TicketSpaceModel *model = [[TicketSpaceModel alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    
    model.flightno = [dataDic objectOrNilForKey:@"flightno"];
    model.seatcode = [dataDic objectOrNilForKey:@"seatcode"];
    model.seatnum = [dataDic int64ValueForKey:@"seatnum"];
    model.seatclass = [dataDic int64ValueForKey:@"seatclass"];
    model.classtype = [dataDic objectOrNilForKey:@"classtype"];
    model.discount = [dataDic doubleValueForKey:@"discount"];
    model.pricetype = [dataDic objectOrNilForKey:@"pricetype"];
    model.planetype = [dataDic int64ValueForKey:@"planetype"];
    model.planecode = [dataDic objectOrNilForKey:@"planecode"];
    
    model.ticketprice = [dataDic int64ValueForKey:@"ticketprice"];
    model.chdticketprice = [dataDic int64ValueForKey:@"chdticketprice"];
    model.babyticketprice = [dataDic doubleValueForKey:@"babyticketprice"];
    model.fee = [dataDic doubleValueForKey:@"fee"];
    model.tax = [dataDic doubleValueForKey:@"tax"];
    model.chdfee = [dataDic doubleValueForKey:@"chdfee"];
    model.chdtax = [dataDic doubleValueForKey:@"chdtax"];
    model.babyfee = [dataDic doubleValueForKey:@"babyfee"];
    model.babytax = [dataDic doubleValueForKey:@"babytax"];
    
    // 舱位政策模型
    NSArray *policyDictArray = [dataDic objectOrNilForKey:@"policyinfos"];
    model.policyModels = [NSMutableArray arrayWithCapacity:policyDictArray.count];
    for (NSDictionary *policyDict in policyDictArray) {
        TicketSpacePolicyModel *spacePolicyModel = [TicketSpacePolicyModel getUserModel:policyDict];
        spacePolicyModel.belongSpcaceModel = model;
        [model.policyModels addObject:spacePolicyModel];
    }
    
    return model;
}

#pragma mark 获取航班舱位信息接口
+ (void)asyncQueryFlightSpaceInfoWithTicketModel:(TLTicketModel *)ticketModel
                                        flightno:(NSString *)flightno
                                       beginTime:(NSString *)beginTime
                                    SuccessBlock:(void(^)(NSArray *dataArray))successBlock
                                      errorBlock:(void(^)(NSError *errorResult))errorBlock
{
    @synchronized(self){
        CityModel *begincity = ticketModel.beginCity;
        CityModel *endCity = ticketModel.endCity;
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic = [NSMutableDictionary dictionaryWithDictionary:[Untils getObjectData:ticketModel]];
        NSString *begStr = [NSString stringWithFormat:@"%@",begincity.cityCode];
        NSString *endStr = [NSString stringWithFormat:@"%@",endCity.cityCode];
        if (ticketModel.orderType == 2 && !ticketModel.isGo) {
            [dic setObject:endStr forKey:@"beginCity"];
            [dic setObject:begStr forKey:@"endCity"];
        } else {
            [dic setObject:begStr forKey:@"beginCity"];
            [dic setObject:endStr forKey:@"endCity"];
        }
        [dic setObject:flightno forKey:@"flightno"];
        [dic setObject:beginTime forKey:@"beginTime"];
        [dic setObject:kToken forKey:@"token"];
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketQueryFlightDeatil];
        NSLog(@"---------kPlaneTicketQueryFlightDeatil---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"-----kPlaneTicketQueryFlightDeatil------%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSMutableArray *allSpacePolicyArray = [NSMutableArray array];
                if ([datalist isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *spaceDict in datalist) {
                        // 舱位模型
                        TicketSpaceModel *spaceModel = [self getUserModel:spaceDict];
                        [allSpacePolicyArray addObjectsFromArray:spaceModel.policyModels];
                    }
                }
                if (successBlock) successBlock([allSpacePolicyArray copy]);
            }
        } fail:^{
        }];
    }
}



#pragma mark 获取改签航班舱位信息接口
/* oldSeatcode     原仓位     是     string     原仓位
 oldDiscount     原折扣     是     string     原折扣*/
+ (void)asyncPostQueryChangeFlightDeatilWithTicketModel:(TLTicketModel *)ticketModel
                                           FlightsModel:(SearchFlightsModel *)flightsModel
                                            oldSeatcode:(NSString *)oldSeatcode
                                            oldDiscount:(NSString *)oldDiscount
                                           SuccessBlock:(void(^)(NSArray *dataArray))successBlock
                                             errorBlock:(void(^)(NSError *errorResult))errorBlock
{
    @synchronized(self){
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
//        dic = [NSMutableDictionary dictionaryWithDictionary:[Untils getObjectData:flightsModel]];
        if (ticketModel.orderType == 2 && !ticketModel.isGo) {
            [dic setObject:flightsModel.endCity forKey:@"beginCity"];
            [dic setObject:flightsModel.beginCity forKey:@"endCity"];
            [dic setObject:flightsModel.beginAirPort forKey:@"endAirPort"];
            [dic setObject:flightsModel.endAirPort forKey:@"beginAirPort"];
        } else {
            [dic setObject:flightsModel.endCity forKey:@"endCity"];
            [dic setObject:flightsModel.beginCity forKey:@"beginCity"];
            [dic setObject:flightsModel.beginAirPort forKey:@"beginAirPort"];
            [dic setObject:flightsModel.endAirPort forKey:@"endAirPort"];
            
        }
        [dic setObject:flightsModel.bTime forKey:@"beginTime"];
        [dic setObject:flightsModel.flightNumber forKey:@"flightno"];
        [dic setObject:oldSeatcode forKey:@"oldSeatcode"];
        [dic setObject:oldDiscount forKey:@"oldDiscount"];
        [dic setObject:kToken forKey:@"token"];
        NSString *url = [kDomainName stringByAppendingString:kPlaneQueryChangeFlightDeatil];
        NSLog(@"---------kPlaneQueryChangeFlightDeatil---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
            NSLog(@"-----kPlaneQueryChangeFlightDeatil------%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSMutableArray *allSpacePolicyArray = [NSMutableArray array];
                if ([datalist isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *spaceDict in datalist) {
                        // 舱位模型
                        TicketSpaceModel *spaceModel = [self getUserModel:spaceDict];
                        [allSpacePolicyArray addObjectsFromArray:spaceModel.policyModels];
                    }
                }
                if (successBlock) successBlock([allSpacePolicyArray copy]);
            }
        } fail:^{
        }];
    }
}

// 获取Demo数据
+ (instancetype)getDemoInstance
{
    NSArray *datalist = [[self aaa] objectForKey:@"content"];
    TicketSpaceModel *spaceModel = [self getUserModel:datalist.firstObject];
    return spaceModel;
}

// 假数据
+ (NSDictionary *)aaa {
    NSDictionary *dic = @{
                          @"content": @[
                                  @{ // 1
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
                                      }
                                  ],
                          @"status": @"0"
                          };
    return dic;
}

@end
