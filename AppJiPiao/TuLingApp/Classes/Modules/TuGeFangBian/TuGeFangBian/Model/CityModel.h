//
//  CityModel.h
//  TuLingApp
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"

@interface CityModel : TicketBaseModel
@property (nonatomic, copy)NSString *cityCode;// 三字码 搜索的时候要用到
@property (nonatomic, copy)NSString *name; // 城市名
@property (nonatomic, copy)NSString *initial; // 城市首字母
// 获取Demo数据:是否起点城市
+ (instancetype)getDemoInstance:(BOOL)isBeginCity;
+(CityModel *)getHotUserModel:(NSDictionary*)netDic;
// 获取城市列表
+ (void)asyncPostCityListSuccessBlock:(void(^)(NSDictionary *cityListDic))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;

// 获取热门城市
+ (void)asyncPostHotCitySuccessBlock:(void(^)(NSArray *hotCityArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;

// 根据城市名称获取三字码
+ (void)asyncPostQueryCityCodeByCityName:(NSString *)cityName SuccessBlock:(void(^)(CityModel *cityModel))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock ;
@end
