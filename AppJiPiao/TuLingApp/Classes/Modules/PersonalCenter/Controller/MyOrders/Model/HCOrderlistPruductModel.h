//
//  HCOrderlistPruductModel.h
//  TuLingApp
//
//  Created by 李立达 on 2017/8/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "JSONModel.h"
#import "HCOrderlistPruductDetailModel.h"

@interface HCOrderlistPruductModel : JSONModel
@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *payActualAmount;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, assign) NSInteger buyCount;

@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, assign) NSInteger businessType;

@property (nonatomic, copy)   NSString *payAmount;
@property (nonatomic, strong) HCOrderlistPruductDetailModel *myProduct;
@property (nonatomic, assign) NSInteger  orderStatus;
@property (nonatomic,  copy)  NSString  *shopOrderId;
@property (nonatomic,  assign)NSInteger keyId;
@property (nonatomic, assign) NSInteger voucherType;

@end
