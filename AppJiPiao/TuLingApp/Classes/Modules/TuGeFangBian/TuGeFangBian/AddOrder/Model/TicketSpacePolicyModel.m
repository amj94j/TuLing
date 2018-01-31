//
//  TicketSpacePolicyModel.m
//  TuLingApp
//
//  Created by abner on 2017/12/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketSpacePolicyModel.h"
#import "TicketSpaceModel.h"

@implementation TicketSpacePolicyModel

+ (TicketSpacePolicyModel *)getUserModel:(NSDictionary*)netDic
{
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    TicketSpacePolicyModel *model = [[TicketSpacePolicyModel alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    
    model.policyid = [dataDic objectOrNilForKey:@"policyid"];
    model.policytype = [dataDic objectOrNilForKey:@"policytype"];
    model.policysource = [dataDic int64ValueForKey:@"policysource"];
    model.producttype = [dataDic int64ValueForKey:@"producttype"];
    model.brandtype = [dataDic objectOrNilForKey:@"brandtype"];
    model.brandname = [dataDic objectOrNilForKey:@"brandname"];
    model.policyplattype = [dataDic int64ValueForKey:@"policyplattype"];
    model.policysign = [dataDic int64ValueForKey:@"policysign"];
    
    model.saleprice = [dataDic doubleValueForKey:@"saleprice"];
    model.rate = [dataDic doubleValueForKey:@"rate"];
    model.childrate = [dataDic doubleValueForKey:@"childrate"];
    model.babyrate = [dataDic doubleValueForKey:@"babyrate"];
    model.speprice = [dataDic doubleValueForKey:@"speprice"];
    
    model.ticketsettleprice = [dataDic doubleValueForKey:@"ticketsettleprice"];
    model.childticketsettleprice = [dataDic doubleValueForKey:@"childticketsettleprice"];
    model.babyticketsettleprice = [dataDic doubleValueForKey:@"babyticketsettleprice"];
    
    //    model.bindings = [dataDic objectOrNilForKey:@"bindings"];
    model.settleprice = [dataDic doubleValueForKey:@"settleprice"];
    model.childsettleprice = [dataDic doubleValueForKey:@"childsettleprice"];
    model.babysettleprice = [dataDic doubleValueForKey:@"babysettleprice"];
    
    model.itprintprice = [dataDic doubleValueForKey:@"itprintprice"];
    model.itremark = [dataDic objectOrNilForKey:@"itremark"];
    model.comment = [dataDic objectOrNilForKey:@"comment"];
    model.customertype = [dataDic objectOrNilForKey:@"customertype"];
    model.issuperpolicy = [dataDic boolValueForKey:@"issuperpolicy"];
    model.isstandardkg = [dataDic boolValueForKey:@"isstandardkg"];
    model.airrule = [dataDic objectOrNilForKey:@"airrule"];
    
    return model;
}

// 获取Demo数据
+ (instancetype)getDemoInstance
{
    TicketSpaceModel *spaceModel = [TicketSpaceModel getDemoInstance];
    return spaceModel.policyModels.firstObject;
}

@end
