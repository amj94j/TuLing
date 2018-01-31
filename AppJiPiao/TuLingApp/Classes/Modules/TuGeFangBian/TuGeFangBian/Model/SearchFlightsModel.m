//
//  SearchFlightsModel.m
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "SearchFlightsModel.h"

@implementation SearchFlightsModel
+(SearchFlightsModel *)getUserModel:(NSDictionary*)netDic {
    
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    SearchFlightsModel *model = [[SearchFlightsModel alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    model.airlineCode = [dataDic objectOrNilForKey:@"airlineCode"];
    model.airlineCompany = [dataDic objectOrNilForKey:@"airlineCompany"];
    model.arrterminal = [dataDic objectOrNilForKey:@"arrterminal"];
    model.beginAirPort = [dataDic objectOrNilForKey:@"beginAirPort"];
    model.beginAirPortName = [dataDic objectOrNilForKey:@"beginAirPortName"];
    model.beginCity = [dataDic objectOrNilForKey:@"beginCity"];
    model.beginCityName = [dataDic objectOrNilForKey:@"beginCityName"];
    model.beginTimeOrigin = [dataDic objectOrNilForKey:@"beginTime"];
    model.beginTime = [model.beginTimeOrigin substringWithRange:NSMakeRange(11,5)];
    model.bTime = [dataDic objectOrNilForKey:@"beginTime"];
    model.beginWeekTime = [Untils getMMDDWeekFormatDate:[Untils dateFormString:[dataDic objectOrNilForKey:@"beginTime"]]];
    model.beginWeek = [Untils weekdayStringFromDate:[Untils dateFormString:[dataDic objectOrNilForKey:@"beginTime"]]];
    model.flightTime = [Untils getCountDownStringWithBeginTime:[dataDic objectOrNilForKey:@"beginTime"] EndTime:[dataDic objectOrNilForKey:@"endTime"]];
    model.classtype = [dataDic objectOrNilForKey:@"classtype"];
    model.endAirPort = [dataDic objectOrNilForKey:@"endAirPort"];
    model.endAirPortName = [dataDic objectOrNilForKey:@"endAirPortName"];
    model.endCity = [dataDic objectOrNilForKey:@"endCity"];
    model.endCityName = [dataDic objectOrNilForKey:@"endCityName"];
    model.endTimeOrigin = [dataDic objectOrNilForKey:@"endTime"];
    model.endTime = [model.endTimeOrigin substringWithRange:NSMakeRange(11,5)];
    model.eTime = [dataDic objectOrNilForKey:@"endTime"];
    model.faceprice = [dataDic objectOrNilForKey:@"faceprice"];
    model.flightNumber = [dataDic objectOrNilForKey:@"flightNumber"];
    model.fromterminal = [dataDic objectOrNilForKey:@"fromterminal"];
    CGFloat low = [dataDic floatValueForKey:@"lowprice"];
    model.lowprice = [NSString stringWithFormat:@"%.0f",low];
    model.newLowPrice = [model.lowprice integerValue];
    model.planeSize = [dataDic objectOrNilForKey:@"planeSize"];
    model.planeType = [dataDic objectOrNilForKey:@"planeType"];
    model.rate = [dataDic objectOrNilForKey:@"rate"];
    model.realCompany = [dataDic objectOrNilForKey:@"realCompany"];
    model.realFlightNum = [dataDic objectOrNilForKey:@"realFlightNum"];
    model.remark = [dataDic objectOrNilForKey:@"remark"];
    model.seatList = [dataDic objectOrNilForKey:@"seatList"];
    model.seats = [dataDic objectOrNilForKey:@"seats"];
    model.settlementprice = [dataDic objectOrNilForKey:@"settlementprice"];
    model.buildFee = [dataDic objectOrNilForKey:@"buildFee"];
    model.fuelFee = [dataDic objectOrNilForKey:@"fuelFee"];
    model.stopCity = [dataDic objectOrNilForKey:@"stopCity"];
    model.stopCityName = [dataDic objectOrNilForKey:@"stopCityName"];
    model.tgqremark = [dataDic objectOrNilForKey:@"tgqremark"];
    model.isSharing = ![dataDic boolValueForKey:@"isSharing"];
    model.isDirect = ![dataDic boolValueForKey:@"isDirect"];
    model.twoDay = [dataDic boolValueForKey:@"twoDay"];
    
    return model;
}

- (NSArray *)cabinListArr {
    if (!_cabinListArr) {
        _cabinListArr = [NSArray new];
    }
    return _cabinListArr;
}

+(SearchFlightsModel *)getNewEndorseModel:(NSDictionary*)netDic {
    
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    SearchFlightsModel *model = [[SearchFlightsModel alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    // 成人基建费
    model.buildFee = [dataDic objectOrNilForKey:@"airportBuildFee"];
    // 到达机场
    model.endAirPort = [dataDic objectOrNilForKey:@"arrAirport"];
    // 到达机场中文名称
    model.endAirPortName = [dataDic objectOrNilForKey:@"arrAirportCH"];
    // 机型
    if ([dataDic int32ValueForKey:@"airplaneSize"]==1) {
        model.planeSize = @"大";
    } else if ([dataDic int32ValueForKey:@"airplaneSize"]==0) {
        model.planeSize = @"小";
    }
    // 到达城市
    model.endCity = [dataDic objectOrNilForKey:@"arrCity"];
    // 到达城市中文名
    model.endCityName = [dataDic objectOrNilForKey:@"arrCityCH"];
    // 到达航站楼
    model.arrterminal = [dataDic objectOrNilForKey:@"arriveTerminal"];
    // 到达时间
    NSString *arriveTime = [Untils timeWithTimeIntervalString:[dataDic objectOrNilForKey:@"arriveTime"]];
    model.endTimeOrigin = arriveTime;
    model.endTime = [arriveTime substringWithRange:NSMakeRange(11,5)];
    model.eTime = arriveTime;
    // 承运人 carrier = HO;
    model.airlineCode = [dataDic objectOrNilForKey:@"carrier"];
    // 航司中文名
    model.airlineCompany = [dataDic objectOrNilForKey:@"carrierCH"];
    // 航班号
    model.flightNumber = [dataDic objectOrNilForKey:@"flightNo"];
    // 出发机场
    model.beginAirPort = [dataDic objectOrNilForKey:@"fromAirport"];
    // 出发机场中文名称
    model.beginAirPortName = [dataDic objectOrNilForKey:@"fromAirportCH"];
    // 出发城市
    model.beginCity = [dataDic objectOrNilForKey:@"fromCity"];
    // 出发城市中文名称
    model.beginCityName = [dataDic objectOrNilForKey:@"fromCityCH"];
    // 成人燃油费
    model.fuelFee = [dataDic objectOrNilForKey:@"fuelFee"];
    // 共享航班
    model.isSharing = [dataDic boolValueForKey:@"isShare"];
    // 机型
    model.planeType = [dataDic objectOrNilForKey:@"planeStyle"];
//    // 经停机场三字码
//    model.stopAirport = [dataDic objectOrNilForKey:@"stopAirport"];
//    // 经停机场名称
//    model.stopAirportCH = [dataDic objectOrNilForKey:@"stopAirportCH"];
    //
    model.stopCity = [dataDic objectOrNilForKey:@"stopCity"];
    // 经停城市名称
    model.stopCityName = [dataDic objectOrNilForKey:@"stopCityCH"];
    // 起飞航班楼
    model.fromterminal = [dataDic objectOrNilForKey:@"takeOffTerminal"];
    // 起飞时间
    NSString *takeOffTime = [Untils timeWithTimeIntervalString:[dataDic objectOrNilForKey:@"takeOffTime"]];
    model.beginTimeOrigin = takeOffTime;
    model.beginTime = [takeOffTime substringWithRange:NSMakeRange(11,5)];
    model.bTime = takeOffTime;
    model.beginWeekTime = [Untils getMMDDWeekFormatDate:[Untils dateFormString:takeOffTime]];
    model.beginWeek = [Untils weekdayStringFromDate:[Untils dateFormString:takeOffTime]];
    model.flightTime = [Untils getCountDownStringWithBeginTime:takeOffTime EndTime:arriveTime];
    // model.isDirect 1是非直达 直达
    if (model.stopCityName.length>0) {
        model.isDirect = YES;
    } else {
        model.isDirect = NO;
    }
    
    NSArray *cabinList = [dataDic objectOrNilForKey:@"cabinList"];
    model.cabinListArr = [cabinList copy];
    model.rate = [[cabinList firstObject] objectOrNilForKey:@"discount"];
    model.classtype = [[cabinList firstObject] objectOrNilForKey:@"newCabinMsg"];

    CGFloat low = [[cabinList firstObject][@"freight"] floatValueForKey:@"highPrice"];
    model.lowprice = [NSString stringWithFormat:@"%.0f",low];
    model.newLowPrice = [model.lowprice integerValue];
//    cabinList =             (
//                             {
//                                 // 舱位分类
//                                 cabinClass = 0;
//                                 // 航位码
//                                 cabinCode = C;
//                                 // 舱位状态
//                                 cabinStatus = 5;
//                                 // 舱位折扣
//                                 discount = 300;
//                                 // 运价列表
//                                 freight =                     {
//                                     /* FreightSource    运价来源    string
//                                      FullB2BMoney    B2B全价    decimal
//                                      FullBSPMoney    BSP全价    decimal
//                                      HighPrice    高价    decimal
//                                      IsTrustSupplier    是否是受信任供应商    int
//                                      LowPrice    低价    decimal
//                                      PolicyID    政策ID    int
//                                      PriceSource    价格来源    string
//                                      PriceType    价格来源类型    int    B2B：0，BSP：1，DEFAULT:2
//                                      SourceType    数据源     int    PT:0,Supplier:1 */
//                                     highPrice = 1860;
//                                 };
//                                 // 特价
//                                 isSpecial = 0;
//                                 // 新舱位属性
//                                 newCabinMsg = "\U516c\U52a1\U8231";
//                                 // 原始舱位属性
//                                 originalCabinMsg = "\U516c\U52a1\U8231";
//                                 // 特价类型
//                                 specialType = "-1";
//                                 // 剩余座位数
//                                 surplusCabinNumber = 5;
//                             },
//                             );
    
    return model;
}

+ (void)asyncPostTicketInfoListTicketModel:(TLTicketModel *)ticketModel SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self) {
        //    NSString *url = @"http://10.69.32.167:9092/planeTicket/queryTicketInfoList"; 本地测试用
        CityModel *begincity = ticketModel.beginCity;
        CityModel *endCity = ticketModel.endCity;
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic = [NSMutableDictionary dictionaryWithDictionary:[Untils getObjectData:ticketModel]];
        NSString *begStr = [NSString stringWithFormat:@"%@",begincity.cityCode];
        NSString *endStr = [NSString stringWithFormat:@"%@",endCity.cityCode];
        [dic setObject:kToken forKey:@"token"];
        [dic setObject:[Untils accountUUID] forKey:@"userCode"];
        [dic setObject:begStr forKey:@"beginCity"];
        [dic setObject:endStr forKey:@"endCity"];
        if (ticketModel.orderType == 2) {
            [dic setObject:ticketModel.backBeginTime forKey:@"backBeginTime"];
        }
        [dic setObject:ticketModel.beginTime forKey:@"beginTime"];
        [dic setObject:@"" forKey:@"positionType"];
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketInfoList];
        NSLog(@"---------kPlaneTicketInfoList---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"---------kPlaneTicketInfoList------------\n%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSMutableArray *cityListArray = [NSMutableArray array];
                SearchFlightsModel *model = nil;
                for (NSDictionary *dic in datalist) {
                    model = [self getUserModel:dic];
                    [cityListArray addObject:model];
                }
                if (successBlock) successBlock([cityListArray copy]);
            }
        } fail:^{
        }];
        
    }
}

+ (void)asyncPostQueryFlightDeatilTicketModel:(TLTicketModel *)ticketModel SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        CityModel *begincity = ticketModel.beginCity;
        CityModel *endCity = ticketModel.endCity;
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic = [NSMutableDictionary dictionaryWithDictionary:[Untils getObjectData:ticketModel]];
        NSString *begStr = [NSString stringWithFormat:@"%@",begincity.name];
        NSString *endStr = [NSString stringWithFormat:@"%@",endCity.name];
        [dic setObject:kToken forKey:@"token"];
        [dic setObject:[Untils accountUUID] forKey:@"userCode"];
        [dic setObject:begStr forKey:@"beginCity"];
        [dic setObject:endStr forKey:@"endCity"];
        if (ticketModel.orderType == 2) {
            [dic setObject:ticketModel.backBeginTime forKey:@"backBeginTime"];
            [dic setObject:ticketModel.beginTime forKey:@"beginTime"];
            if (!ticketModel.isGo) {
                [dic setObject:endStr forKey:@"beginCity"];
                [dic setObject:begStr forKey:@"endCity"];
                [dic setObject:ticketModel.beginTime forKey:@"backBeginTime"];
                [dic setObject:ticketModel.backBeginTime forKey:@"beginTime"];
            }
        }
        
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketTicketList];
        NSLog(@"---------kPlaneTicketTicketList---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"---------kPlaneTicketTicketList------------\n%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSMutableArray *cityListArray = [NSMutableArray array];
                SearchFlightsModel *model = nil;
                for (NSDictionary *dic in datalist) {
                    model = [self getUserModel:dic];
                    [cityListArray addObject:model];
                }
                if (successBlock) successBlock([cityListArray copy]);
            }
        } fail:^{
            if (!ticketModel.isGo) {
                ticketModel.isGo = YES;
            }
        }];
        
    }
}

// 查询条数
+ (void)asyncPostTicketListCountTicketModel:(TLTicketModel *)ticketModel SuccessBlock:(void(^)(NSInteger count))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        CityModel *begincity = ticketModel.beginCity;
        CityModel *endCity = ticketModel.endCity;
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic = [NSMutableDictionary dictionaryWithDictionary:[Untils getObjectData:ticketModel]];
        NSString *begStr = [NSString stringWithFormat:@"%@",begincity.name];
        NSString *endStr = [NSString stringWithFormat:@"%@",endCity.name];
        [dic setObject:kToken forKey:@"token"];
        [dic setObject:[Untils accountUUID] forKey:@"userCode"];
        [dic setObject:begStr forKey:@"beginCity"];
        [dic setObject:endStr forKey:@"endCity"];
        if (ticketModel.orderType == 2) {
            [dic setObject:ticketModel.backBeginTime forKey:@"backBeginTime"];
            [dic setObject:ticketModel.beginTime forKey:@"beginTime"];
            if (!ticketModel.isGo) {
                [dic setObject:endStr forKey:@"beginCity"];
                [dic setObject:begStr forKey:@"endCity"];
                [dic setObject:ticketModel.beginTime forKey:@"backBeginTime"];
                [dic setObject:ticketModel.backBeginTime forKey:@"beginTime"];
            }
        }
        
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketTicketListCount];
        NSLog(@"---------kPlaneTicketTicketListCount---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            NSLog(@"---------kPlaneTicketTicketListCount------------\n%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSInteger count = 0;
                if ([datalist isKindOfClass:[NSArray class]]) {
                    NSDictionary *dic = [datalist firstObject];
                    count = [dic int64ValueForKey:@"count"];
                }
                if (successBlock) successBlock(count);
            }
        } fail:^{
        }];
        
    }
}


+ (void)asyncPostEndorseModel:(TLTicketModel *)ticketModel backState:(NSString *)backState SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        CityModel *begincity = ticketModel.beginCity;
        CityModel *endCity = ticketModel.endCity;
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic = [NSMutableDictionary dictionaryWithDictionary:[Untils getObjectData:ticketModel]];
        NSString *begStr = [NSString stringWithFormat:@"%@",begincity.name];
        NSString *endStr = [NSString stringWithFormat:@"%@",endCity.name];
        [dic setObject:kToken forKey:@"token"];
        [dic setObject:[Untils accountUUID] forKey:@"userCode"];
        [dic setObject:begStr forKey:@"beginCity"];
        [dic setObject:endStr forKey:@"endCity"];
        if (ticketModel.orderType == 2 ) {
            [dic setObject:ticketModel.backBeginTime forKey:@"backBeginTime"];
            [dic setObject:ticketModel.beginTime forKey:@"beginTime"];
            
            if (([backState isEqualToString:@"2"] && !ticketModel.isGo)) {
                [dic setObject:endStr forKey:@"beginCity"];
                [dic setObject:begStr forKey:@"endCity"];
                [dic setObject:ticketModel.beginTime forKey:@"backBeginTime"];
                [dic setObject:ticketModel.backBeginTime forKey:@"beginTime"];
            }
        } else {
           [dic setObject:ticketModel.beginTime forKey:@"beginTime"];
        }
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketInfoList];
        NSLog(@"---------EndorseModel---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"---------EndorseModel------------\n%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSMutableArray *cityListArray = [NSMutableArray array];
                SearchFlightsModel *model = nil;
                for (NSDictionary *dic in datalist) {
                    model = [self getUserModel:dic];
                    [cityListArray addObject:model];
                }
                if (successBlock) successBlock([cityListArray copy]);
            }
        } fail:^{
        }];
        
    }
}
@end
