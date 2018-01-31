//
//  TicketModel.m
//  TuLingApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLTicketModel.h"

@implementation TLTicketModel

// 获取Demo数据:是否单程
+ (instancetype)getDemoInstance:(BOOL)isDanCheng
{
    TLTicketModel *model = [[TLTicketModel alloc] init];
    
    model.beginCity = [CityModel getDemoInstance:YES];
    model.endCity = [CityModel getDemoInstance:NO];
    model.beginTime = @"2017-12-14";
    model.endTime = isDanCheng ? @"" : @"2017-12-14";
    model.orderType = isDanCheng ? 1 : 2; // 单程1 往返2
    model.positionType = @""; // 经济舱0 头等舱1
    model.ticketSort = @"0"; // 0价格升 1价格降 2时间升 3时间降
    model.timeType = @"1"; // 0是0-6，1是6-12,2是12-18,3是18-24 时间段
    model.direct = @"0"; // 0是，1不是 是否直达
    model.share = @"0"; // 0是共享，1不是 是否共享
    model.isGo = isDanCheng; // 是否是去程 默认是去
    
    return model;
}

+(TLTicketModel *)getUserModel:(NSDictionary*)netDic {
    
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    TLTicketModel *model = [[TLTicketModel alloc] init];
    model.beginTime = [dataDic objectOrNilForKey:@"beginTime"];
    model.backBeginTime = [dataDic objectOrNilForKey:@"backBeginTime"];
    model.orderType = [dataDic int32ValueForKey:@"orderType"];
//    model.positionType = [dataDic objectOrNilForKey:@"positionType"];
    model.ticketSort = [dataDic objectOrNilForKey:@"ticketSort"];
    model.timeType = [dataDic objectOrNilForKey:@"timeType"];
    model.direct = [dataDic objectOrNilForKey:@"direct"];
    model.share = [dataDic objectOrNilForKey:@"share"];
    model.isGo = [dataDic boolValueForKey:@"isGo"];
    CityModel *beginCity = [CityModel getHotUserModel:dataDic[@"beginCity"]];
    CityModel *endModel = [CityModel getHotUserModel:dataDic[@"endCity"]];
    model.beginCity = beginCity;
    model.endCity = endModel;
    return model;
}

+ (TLTicketModel *)getEndorseRequestModel:(NSDictionary*)netDic {
    
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    TLTicketModel *model = [[TLTicketModel alloc] init];
    model.beginTime = [dataDic objectOrNilForKey:@"btime"];
    model.positionType = [dataDic objectOrNilForKey:@"positionsType"];
    CityModel *beginCity = [CityModel new];
    model.isGo = YES;
    beginCity.name = [dataDic objectOrNilForKey:@"beginCity"];
    beginCity.cityCode = [dataDic objectOrNilForKey:@"beginAirPort"];
    
    CityModel *endModel = [CityModel new];
    endModel.name = [dataDic objectOrNilForKey:@"endCity"];
    endModel.cityCode = [dataDic objectOrNilForKey:@"endAirPort"];
    model.beginCity = beginCity;
    model.endCity = endModel;
    return model;
}

// 机场
+ (void)asyncPostTicketQueryAirportconTicketModel:(TLTicketModel *)ticketModel SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        NSString *URL = [kDomainName stringByAppendingString:kPlaneTicketQueryAirportcon];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:kToken forKey:@"token"];
        [dic setObject:[Untils accountUUID] forKey:@"userCode"];
        if (ticketModel.isGo) {
            [dic setObject:@"1" forKey:@"orderType"];
        } else {
            [dic setObject:@"2" forKey:@"orderType"];
        }
        
//        NSLog(@"---------机场---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:URL parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
             NSLog(@"---------机场------------\n%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [NSArray new];
                if ([[responseObject objectForKey:@"content"] isKindOfClass:[NSArray class]]) {
                    NSArray *arr = [responseObject objectForKey:@"content"];
                    if ([[arr firstObject][@"beginPort"] isKindOfClass:[NSArray class]] && [[arr firstObject][@"endPort"] isKindOfClass:[NSArray class]]) {
                        NSArray *bArr = [arr firstObject][@"beginPort"];
                        NSArray *eArr = [arr firstObject][@"endPort"];
                        NSMutableArray *beginPortMArr = [NSMutableArray arrayWithObject:@"不限"];
                        NSArray *newArr = [beginPortMArr arrayByAddingObjectsFromArray:bArr];
                        NSMutableArray *endPortMArr = [NSMutableArray arrayWithObject:@"不限"];
                        NSArray *new2Arr = [endPortMArr arrayByAddingObjectsFromArray:eArr];
                        NSMutableArray *allArr = [NSMutableArray new];
                        [allArr addObject:newArr];
                        [allArr addObject:new2Arr];
                        datalist = [allArr copy];
                    }
                }
                if (successBlock) successBlock(datalist);
            }
        } fail:^{
            
        }];
    }
}

// 航空公司
+ (void)asyncPostTicketQueryCompanyconTicketModel:(TLTicketModel *)ticketModel SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        NSString *URL = [kDomainName stringByAppendingString:kPlaneTicketQueryCompanycon];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:kToken forKey:@"token"];
        [dic setObject:[Untils accountUUID] forKey:@"userCode"];
        [dic setObject:[NSString stringWithFormat:@"%ld",ticketModel.orderType] forKey:@"orderType"];
        NSLog(@"---------航空公司---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:URL parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
             NSLog(@"---------航空公司------------\n%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSMutableArray *allList = [NSMutableArray new];
                if ([[responseObject objectForKey:@"content"] isKindOfClass:[NSArray class]]) {
                    NSArray *datalist = [responseObject objectForKey:@"content"];
                    
                    for (NSString *str in datalist) {
                        NSMutableDictionary *dic = [NSMutableDictionary new];
                        NSArray *arr = [str componentsSeparatedByString:@"#"];
                        [dic setObject:arr[0] forKey:@"companycon"];
                        [dic setObject:@"0" forKey:@"select"];
                        [dic setObject:arr[1] forKey:@"airlineCode"];
                        [allList addObject:dic];
                    }
                }
                if (successBlock) successBlock([allList copy]);
            }
        } fail:^{
        }];
    }
}
@end
