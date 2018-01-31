//
//  MyOrderFormListModel.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/22.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface MyOrderFormListModel : BaseModel

@property (nonatomic, assign) double cost;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isReturn;
// 订单id
@property (nonatomic, assign) NSInteger orderId;
// 订单号
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSString *retrunStatus;
// 交易状态
@property (nonatomic, strong) NSString *status;
// 价格
@property (nonatomic, assign) double totle;
@property (nonatomic, strong) NSString *shopName;

@property (nonatomic, strong) NSString *createDate;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *consignee;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, copy) NSString *remarks;


@property (nonatomic, copy) NSString *logisticsName;
@property (nonatomic, copy) NSString *logisticsContent;
@property (nonatomic, copy) NSString *logisticsDate;

@end

// 同一组订单列表
@interface OrderFormProductsModel : BaseModel

@property (nonatomic, assign) NSInteger buyCount;
@property (nonatomic, strong) NSString *headImage;
@property (nonatomic, assign) double price;
@property (nonatomic, strong) NSString *specName;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic) BOOL expect;
@property (nonatomic,copy) NSString * shareCost;
@end

// 下部按钮
@interface OrderFormButtonsModel : BaseModel

@property (nonatomic, assign) NSInteger buttonId;
@property (nonatomic, strong) NSString *buttonName;

@end

@interface CancelOrderReasonModel : BaseModel

@property (nonatomic, assign) NSInteger reasonId;
@property (nonatomic, strong) NSString *dicName;
@property (nonatomic, assign) NSInteger dicType;
@property (nonatomic, assign) NSInteger sort;

@end
