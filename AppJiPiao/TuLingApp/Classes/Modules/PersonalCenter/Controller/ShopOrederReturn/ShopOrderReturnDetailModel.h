//
//  ShopOrderReturnDetailModel.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseModel.h"

@interface ShopOrderReturnDetailModel : BaseModel

@property (nonatomic, assign) BOOL logistics;
@property (nonatomic, assign) double cost;

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) NSInteger orderReturnType;
@property (nonatomic, assign) NSInteger returnDateEnd;
@property (nonatomic, assign) NSInteger returnDateStart;
@property (nonatomic, assign) NSInteger returnId;


@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *returnCreateTime;
@property (nonatomic, strong) NSString *returnNumber;
@property (nonatomic, strong) NSString *returnReason;
@property (nonatomic, strong) NSString *returnStatus;
//@property (nonatomic, strong) NSString *


@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) NSMutableArray *consults;

@end



@interface ShopOrderREturnDetailConsultsModel : BaseModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, assign) NSInteger shopOrderRetrunId;
@property (nonatomic, assign) BOOL isShop;
@property (nonatomic, strong) NSMutableArray *shopOrderRetrunImgs;

@end




