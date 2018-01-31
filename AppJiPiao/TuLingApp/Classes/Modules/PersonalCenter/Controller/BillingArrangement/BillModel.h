//
//  BillModel.h
//  TuLingApp
//
//  Created by hua on 17/4/19.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "JSONModel.h"



@interface BillModel : JSONModel
@property(nonatomic,copy)NSString *billCost;
@property(nonatomic,copy)NSString *billStartTime;
@property(nonatomic,copy)NSString *billEndTime;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *settleTime;
@property(nonatomic,copy)NSString *shopEnterTime;


@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *operFinancialManagerSettleTime;
@property(nonatomic,copy)NSString *billNumber;

@property(nonatomic,copy)NSString *billShowEnum;
@property(nonatomic,copy)NSString *billEnum;


@end
