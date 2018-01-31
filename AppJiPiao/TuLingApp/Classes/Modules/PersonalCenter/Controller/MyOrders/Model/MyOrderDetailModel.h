//
//  MyOrderDetailModel.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseModel.h"

@interface MyOrderDetailModel : BaseModel

@property (nonatomic, strong) NSDictionary *address;
@property (nonatomic, strong) NSArray *brandProductPojo;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, assign) double cost;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, assign) BOOL isReturn;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *payDate;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) double productsTotle;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *returnStatus;
@property (nonatomic, assign) NSInteger returnType;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) double totle;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *tripleOrderNumber;
@property (nonatomic) NSInteger expect;
@property (nonatomic,copy) NSString * sendDate;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger startTime;
@end


@interface AddressModel : BaseModel

@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) NSInteger deleteStatus;
@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, assign) NSInteger mobileUserId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, strong) NSString *receiver;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *stress;
@property (nonatomic, strong) NSString *updatedAt;

@end
