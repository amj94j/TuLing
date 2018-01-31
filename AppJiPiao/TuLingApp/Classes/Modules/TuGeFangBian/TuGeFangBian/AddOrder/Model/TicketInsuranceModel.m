//
//  TicketInsuranceModel.m
//  TuLingApp
//
//  Created by abner on 2017/12/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketInsuranceModel.h"

@implementation TicketInsuranceModel

+ (TicketInsuranceModel *)getUserModel:(NSDictionary*)netDic
{
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    TicketInsuranceModel *model = [[TicketInsuranceModel alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    
    model.insuranceCompanyCode = [dataDic objectOrNilForKey:@"insuranceCompanyCode"];
    model.insuranceCompanyName = [dataDic objectOrNilForKey:@"insuranceCompanyName"];
    model.insuranceName = [dataDic objectOrNilForKey:@"insuranceName"];
    model.insuranceProductId = [dataDic objectOrNilForKey:@"insuranceProductId"];
    model.insuranceId = [dataDic objectOrNilForKey:@"id"];
    model.insuranceType = [dataDic int64ValueForKey:@"insuranceType"];
    model.insuranceTypeName = model.insuranceType == 1 ? @"意外险" : @"延误险";
    model.insuranceProductCode = [dataDic objectOrNilForKey:@"insuranceProductCode"];
    model.insuranceFee = [dataDic doubleValueForKey:@"insuranceFee"];
    model.costFee = [dataDic doubleValueForKey:@"costFee"];
    
    model.insuranceMemo = [dataDic objectOrNilForKey:@"insuranceMemo"];
    model.insuranceDetail = [dataDic objectOrNilForKey:@"insuranceDetail"];
    model.createTime = [dataDic doubleValueForKey:@"createTime"];
    model.createUserId = [dataDic objectOrNilForKey:@"createUserId"];
    model.updateTime = [dataDic doubleValueForKey:@"updateTime"];
    model.updateUserId = [dataDic objectOrNilForKey:@"updateUserId"];
    model.versionNum = [dataDic objectOrNilForKey:@"versionNum"];
    model.isDel = [dataDic boolValueForKey:@"isDel"];
    
    return model;
}

+ (NSMutableArray *)getDemoInstances
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < 2; i++) {
        TicketInsuranceModel *model = [[TicketInsuranceModel alloc] init];
        
        model.insuranceTypeName = i == 0 ? @"意外险" : @"延误险";
        model.insuranceFee = i == 0 ? 30 : 20;
        
        [array addObject:model];
    }
    
    return array;
}

@end

@implementation TicketInsuranceTradeModel

#pragma mark 获取保险信息
+ (void)asyncGetInsuranceWithIsDanCheng:(BOOL)isDanCheng
                           successBlock:(void(^)(NSArray *dataArray))successBlock
                             errorBlock:(void(^)(NSError *errorResult))errorBlock
{
    @synchronized(self){
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:kToken forKey:@"token"];
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketQueryInsuranceProduct];
//        NSLog(@"---------kPlaneTicketQueryInsuranceProduct---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"-----kPlaneTicketQueryInsuranceProduct------%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSMutableArray *allDataArray = [NSMutableArray array];
                if ([datalist isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in datalist) {
                        // 舱位模型
                        TicketInsuranceModel *insuranceModel = [TicketInsuranceModel getUserModel:dict];
                        TicketInsuranceTradeModel *tradeModel = [[TicketInsuranceTradeModel alloc] init];
                        tradeModel.insuranceModel = insuranceModel;
                        tradeModel.passengerModels = [NSMutableArray array];
                        tradeModel.buyPassengerModels = [NSMutableArray array];
                        tradeModel.isDanCheng = isDanCheng;
                        tradeModel.isSelected = NO;
                        [allDataArray addObject:tradeModel];
                    }
                }
                if (successBlock) successBlock([allDataArray copy]);
            }
        } fail:^{
        }];
    }
}

@end
