//
//  TicketAddressModel.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketAddressModel.h"

@implementation TicketAddressModel

+ (TicketAddressModel *)getUserModel:(NSDictionary*)netDic
{
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    TicketAddressModel *model = [[TicketAddressModel alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    
    model.isNew = [dataDic int64ValueForKey:@"new"];
    model.zipCode = [dataDic objectOrNilForKey:@"zipCode"];
    model.createUserId = [dataDic int64ValueForKey:@"createUserId"];
    model.linkPhone = [dataDic objectOrNilForKey:@"linkPhone"];
    model.updateUserId = [dataDic objectOrNilForKey:@"updateUserId"];
    model.versionNum = [dataDic int64ValueForKey:@"versionNum"];
    model.updateTime = [dataDic objectOrNilForKey:@"updateTime"];
    model.userName = [dataDic objectOrNilForKey:@"userName"];
    model.userId = [dataDic int64ValueForKey:@"userId"];
    model.province = [dataDic objectOrNilForKey:@"province"];
    model.city = [dataDic objectOrNilForKey:@"city"];
    model.county = [dataDic objectOrNilForKey:@"county"];
    model.detailedAddress = [dataDic objectOrNilForKey:@"detailedAddress"];
    model.createTime = [dataDic int64ValueForKey:@"createTime"];
    model.addressId = [dataDic int64ValueForKey:@"id"];
    model.isDel = [dataDic boolValueForKey:@"isDel"];
    model.isSelected = NO;
    
    return model;
}

#pragma mark 地址操作
+ (void)asyncAddressActionWithActionType:(AddressAction)actionType
                            addressModel:(TicketAddressModel *)addressModel
                            successBlock:(void(^)(NSArray *dataArray))successBlock
                              errorBlock:(void(^)(NSError *errorResult))errorBlock
{
    @synchronized(self){
        NSMutableDictionary *dic = [NSMutableDictionary new];
        
        [dic setObject:[NSString stringWithFormat:@"%lu", (unsigned long)actionType] forKey:@"flag"];
        if (actionType != AddressActionQuery) {
            [dic setObject:addressModel.zipCode forKey:@"zipCode"];
            [dic setObject:addressModel.province forKey:@"province"];
            [dic setObject:addressModel.city forKey:@"city"];
            [dic setObject:addressModel.county forKey:@"county"];
            [dic setObject:addressModel.detailedAddress forKey:@"detailedAddress"];
            [dic setObject:addressModel.linkPhone forKey:@"linkPhone"];
            [dic setObject:addressModel.userName forKey:@"userName"];
            [dic setObject:[NSString stringWithFormat:@"%ld", (long)addressModel.addressId] forKey:@"addressId"];
            [dic setObject:[NSString stringWithFormat:@"%ld", (long)addressModel.versionNum] forKey:@"versionNum"];
        }
        
        [dic setObject:kToken forKey:@"token"];
        NSString *url = [kDomainName stringByAppendingString:kPlaneTicketQueryDetailedAddressList];
        NSLog(@"---------kPlaneTicketQueryDetailedAddressList---dic---------\n%@",dic);
        [NetAccess postJSONWithUrl:url parameters:dic WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
//            NSLog(@"-----kPlaneTicketQueryDetailedAddressList------%@",responseObject);
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSMutableArray *allDataArray = [NSMutableArray array];
                if ([datalist isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in datalist) {
                        TicketAddressModel *model = [TicketAddressModel getUserModel:dict];
                        [allDataArray addObject:model];
                    }
                }
                if (successBlock) successBlock([allDataArray copy]);
            }
        } fail:^{
        }];
    }
}

@end
