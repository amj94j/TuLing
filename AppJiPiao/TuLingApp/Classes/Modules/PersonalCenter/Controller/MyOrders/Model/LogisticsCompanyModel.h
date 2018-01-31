//
//  LogisticsCompanyModel.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseModel.h"

@interface LogisticsCompanyModel : BaseModel

@property (nonatomic, strong) NSString *att1;
@property (nonatomic, assign) NSInteger companyType;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, strong) NSString *logisticsCode;
@property (nonatomic, strong) NSString *logisticsName;

@end
