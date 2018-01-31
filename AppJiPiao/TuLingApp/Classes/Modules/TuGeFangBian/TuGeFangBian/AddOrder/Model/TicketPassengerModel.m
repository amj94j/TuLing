//
//  TicketPassengerModel.m
//  TuLingApp
//
//  Created by abner on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketPassengerModel.h"

@implementation TicketPassengerModel

+ (TicketPassengerModel *)getUserModel:(NSDictionary*)netDic
{
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    TicketPassengerModel *model = [[TicketPassengerModel alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    
    model.createTime = [dataDic int64ValueForKey:@"createTime"];
    model.personId = [dataDic int64ValueForKey:@"id"];
    model.isDel = [dataDic boolValueForKey:@"isDel"];
    model.linkPhone = [dataDic objectOrNilForKey:@"linkPhone"];
    model.isNew = [dataDic boolValueForKey:@"new"];
    model.personIdentityCode = [dataDic objectOrNilForKey:@"personIdentityCode"];
    model.personIdentityType = [dataDic int64ValueForKey:@"personIdentityType"];
    model.personIdentityName = (model.personIdentityType == 1) ? @"身份证" : (model.personIdentityType == 3) ? @"护照" : @"其他";
    model.personName = [dataDic objectOrNilForKey:@"personName"];
    model.versionNum = [dataDic int64ValueForKey:@"versionNum"];
    model.isSelected = NO;
    
    return model;
}

#pragma mark 获取乘机人列表
+ (void)asyncQuerySelctedFlightPersonWithPersonId:(NSInteger)personId
                                     successBlock:(void(^)(NSArray *dataArray))successBlock
                                       errorBlock:(void(^)(NSError *errorResult))errorBlock
{
    @synchronized(self){
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:[NSString stringWithFormat:@"%ld", (long)personId] forKey:@"personIds"];
        [dic setObject:kToken forKey:@"token"];
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketQuerySelctedFlightPerson];
//        NSLog(@"---------kPlaneTicketQuerySelctedFlightPerson---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"-----kPlaneTicketQuerySelctedFlightPerson------%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSMutableArray *allDataArray = [NSMutableArray array];
                if ([datalist isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in datalist) {
                        TicketPassengerModel *passengerModel = [TicketPassengerModel getUserModel:dict];
                        [allDataArray addObject:passengerModel];
                    }
                }
                if (successBlock) successBlock([allDataArray copy]);
            }
        } fail:^{
        }];
    }
}

#pragma mark 乘机人操作
+ (void)asyncPassengerActionWithActionType:(PassengerAction)actionType
                            passengerModel:(TicketPassengerModel *)passengerModel
                              successBlock:(void(^)(NSArray *dataArray))successBlock
                                errorBlock:(void(^)(NSError *errorResult))errorBlock
{
    @synchronized(self){
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:[NSString stringWithFormat:@"%lu", (unsigned long)actionType] forKey:@"flag"];
        
//        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        [dic setObject:[NSString stringWithFormat:@"%ld", (long)passengerModel.versionNum] forKey:@"versionNum"];
        
        [dic setObject:[NSString stringWithFormat:@"%ld", (long)passengerModel.personId] forKey:@"persionId"];
//        [dic setObject:[NSString stringWithFormat:@"%ld", (long)passengerModel.personIdentityType] forKey:@"personIdentityType"];
        [dic setObject:@"1" forKey:@"personIdentityType"];
        [dic setObject:passengerModel.personIdentityCode forKey:@"personIdentityCode"];
        [dic setObject:passengerModel.personName forKey:@"personName"];
        [dic setObject:passengerModel.linkPhone forKey:@"linkPhone"];
        [dic setObject:kToken forKey:@"token"];
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketFlightPersonAction];
        NSLog(@"---------kPlaneTicketFlightPersonAction---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"-----kPlaneTicketFlightPersonAction------%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSMutableArray *allDataArray = [NSMutableArray array];
                if ([datalist isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in datalist) {
                        TicketPassengerModel *passengerModel = [TicketPassengerModel getUserModel:dict];
                        [allDataArray addObject:passengerModel];
                    }
                }
                if (successBlock) successBlock([allDataArray copy]);
            }
        } fail:^{
        }];
    }
}

#pragma mark 判断添加的乘客是否是成年人
+ (void)asyncCheckPersonIsAdultWithPersonIdentityCode:(NSString *)personIdentityCode
                                         successBlock:(void(^)(NSInteger passengerType))successBlock
                                           errorBlock:(void(^)(NSError *errorResult))errorBlock
{
    @synchronized(self){
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:personIdentityCode forKey:@"idCard"];
        [dic setObject:kToken forKey:@"token"];
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketCheckPersonType];
//        NSLog(@"---------kPlaneTicketCheckPersonType---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"-----kPlaneTicketCheckPersonType------%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                if (datalist.count) {
                    NSInteger passengerType = [datalist.firstObject integerValue];
                    if (passengerType == 0) {
                        [HzTools showHudWithOnlySting:@"不支持婴儿,只支持成年人" withTime:1];
                    } else if (passengerType == 1) {
                        [HzTools showHudWithOnlySting:@"不支持儿童,只支持成年人" withTime:1];
                    } else {
                        if (successBlock) successBlock(passengerType);
                    }
                }
            }
        } fail:^{
        }];
    }
}

@end
