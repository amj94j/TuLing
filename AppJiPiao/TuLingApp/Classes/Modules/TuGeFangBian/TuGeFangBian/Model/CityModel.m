//
//  CityModel.m
//  TuLingApp
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

+(CityModel *)getUserModel:(NSDictionary*)netDic {
    
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    CityModel *model = [[CityModel alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    model.cityCode = [dataDic objectOrNilForKey:@"citySectionCode"];
    model.name = [dataDic objectOrNilForKey:@"name"];
    model.initial = [dataDic objectOrNilForKey:@"initial"];
    
    return model;
}

+(CityModel *)getHotUserModel:(NSDictionary*)netDic {
    
    if (![netDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSDictionary *dataDic = [self getDataDictionary:netDic];
    CityModel *model = [[CityModel alloc] init];
    for (id key in [model getAllProperties]) {
        if(dataDic[key]) [model setValue:dataDic[key] forKey:key];
    }
    model.cityCode = [dataDic objectOrNilForKey:@"cityCode"];
    model.name = [dataDic objectOrNilForKey:@"name"];
    model.initial = [dataDic objectOrNilForKey:@"initial"];
    
    return model;
}

//获取城市列表
+ (void)asyncPostCityListSuccessBlock:(void(^)(NSDictionary *cityListDic))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        NSString *cityListURL = [kDomainName stringByAppendingString:kPlaneTicketCityList];
        [NetAccess postJSONWithUrl:cityListURL parameters:nil WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSMutableDictionary *cityListDic = [NSMutableDictionary new];
                NSMutableArray *listarr = [NSMutableArray new];
                NSMutableArray *zimuMArr = [NSMutableArray new];
                NSMutableArray *allCityList = [NSMutableArray new];
                for (NSDictionary *dic in datalist) {
                    [zimuMArr addObject:dic[@"initial"]];
                }
                // 将首字母进行排序 因为后面的排序的是根据首字母又进行排序的
                NSArray *result = [zimuMArr sortedArrayUsingSelector:@selector(localizedCompare:)];
                // 字母去重
                NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:result];
                NSArray *lettersArr = set.array;
                for (NSString *str in lettersArr) {
                    CityModel *model = nil;
                    NSMutableArray *tempArr = [NSMutableArray new];
                    for (NSDictionary *dic in datalist) {
                        model = [self getUserModel:dic];
                        if ([str isEqualToString:model.initial]) {
                            [tempArr addObject:model];
                        }
                    }
                    [listarr addObject:tempArr];
                }
                for (NSDictionary *dic in datalist) {
                    CityModel *model = [CityModel new];
                    model = [self getUserModel:dic];
                    [allCityList addObject:model];
                }
                
                [cityListDic setObject:lettersArr forKey:@"letters"];
                [cityListDic setObject:listarr forKey:@"citylist"];
                [cityListDic setObject:allCityList forKey:@"allcity"];
                if (successBlock) successBlock(cityListDic);
            }
        } fail:^{
        }];
    }
}

+ (void)asyncPostHotCitySuccessBlock:(void(^)(NSArray *hotCityArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        NSString *cityListURL = [kDomainName stringByAppendingString:kPlaneTicketHotCity];
        [NetAccess postJSONWithUrl:cityListURL parameters:nil WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                NSMutableArray *cityListArray = [NSMutableArray array];
                CityModel *model = nil;
                for (NSDictionary *dic in datalist) {
                    model = [self getHotUserModel:dic];
                    [cityListArray addObject:model];
                }
                if (successBlock) successBlock([cityListArray copy]);
            }
        } fail:^{
        }];
    }
}

// 根据城市名称获取三字码
+ (void)asyncPostQueryCityCodeByCityName:(NSString *)cityName SuccessBlock:(void(^)(CityModel *cityModel))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock {
    @synchronized(self){
        NSString *cityListURL = [kDomainName stringByAppendingString:kPlaneTicketCityList];
        [NetAccess postJSONWithUrl:cityListURL parameters:@{@"cityName":cityName} WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSArray *datalist = [responseObject objectForKey:@"content"];
                CityModel *model = [self getUserModel:[datalist firstObject]];
                if (successBlock) successBlock(model);
            }
        } fail:^{
        }];
    }
}
// 获取Demo数据:是否起点城市
+ (instancetype)getDemoInstance:(BOOL)isBeginCity
{
    NSDictionary *beginCityDataDict = @{
                                        @"cityCode" : @"BJS",
                                        @"cityNumber" : @1,
                                        @"cityType" : @0,
                                        @"createTime" : @"",
                                        @"createUserId" : @"",
                                        @"createdAt" : @1464337395000,
                                        @"id" : @213,
                                        @"initial" : @"热门城市",
                                        @"isDel" : @0,
                                        @"name" : @"北京",
                                        @"new" : @0,
                                        @"pinyin" : @"Beijing",
                                        @"updateTime" : @"",
                                        @"updateUserId" : @"",
                                        @"updatedAt" : @1464337395000,
                                        @"versionNum" : @0,
                                        };
    NSDictionary *endCityDataDict = @{
                                      @"cityCode" : @"SZX",
                                      @"cityNumber" : @30,
                                      @"cityType" : @0,
                                      @"createTime" : @"",
                                      @"createUserId" : @"",
                                      @"createdAt" : @1464337397000,
                                      @"id" : @418,
                                      @"initial" : @"热门城市",
                                      @"isDel" : @0,
                                      @"name" : @"深圳",
                                      @"new" : @0,
                                      @"pinyin" : @"Shenzhen",
                                      @"updateTime" : @"",
                                      @"updateUserId" : @"",
                                      @"updatedAt" : @1464337397000,
                                      @"versionNum" : @0,
                                      };
    return [self getHotUserModel:isBeginCity ? beginCityDataDict : endCityDataDict];
}
@end
