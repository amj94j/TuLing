//
//  MainUserInfoModel.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseModel.h"

@interface MainUserInfoModel : BaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *icon;
// 积分、订单数
@property (nonatomic, assign) NSInteger score;
// 余额、销售额
@property (nonatomic, assign) double balance;
@property (nonatomic, assign) NSInteger messageNumber;

@end
