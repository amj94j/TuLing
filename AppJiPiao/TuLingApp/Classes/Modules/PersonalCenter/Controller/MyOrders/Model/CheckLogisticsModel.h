//
//  CheckLogistics.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/27.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseModel.h"

@interface CheckLogisticsModel : BaseModel

@property (nonatomic, strong) NSMutableArray *brandProductPojo;
@property (nonatomic, strong) NSString *LogisticCode;
@property (nonatomic, strong) NSString *ShipperCode;
@property (nonatomic, strong) NSString *ShipperName;
@property (nonatomic, strong) NSMutableArray *Traces;

@end

// 物流跟踪
@interface TracesModel : BaseModel

@property (nonatomic, strong) NSString *acceptStation;
@property (nonatomic, strong) NSString *acceptTime;

@end


// 猜你喜欢
@interface BrandProductPojoModel : BaseModel

@property (nonatomic, assign) NSInteger pojoId;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger orgPrice;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) NSInteger saleCount;

@end
