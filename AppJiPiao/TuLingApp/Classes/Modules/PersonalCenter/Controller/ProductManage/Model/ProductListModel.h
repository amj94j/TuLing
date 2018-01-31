//
//  ProductListModel.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseModel.h"

@interface ProductListModel : BaseModel

@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, strong) NSString *headImage;
@property (nonatomic, strong) NSString *heading;
@property (nonatomic, assign) BOOL isCost;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) BOOL invoice;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL store;
@property (nonatomic, strong) NSString *shareUrl;

@property (nonatomic, strong) NSString *reviewReason;
@property (nonatomic, assign) BOOL isShowReason;

@end

@interface ProductListButtonModel : BaseModel

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *name;

@end
