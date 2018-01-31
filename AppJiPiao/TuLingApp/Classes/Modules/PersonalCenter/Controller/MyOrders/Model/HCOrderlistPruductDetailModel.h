//
//  HCOrderlistPruductDetailModel.h
//  TuLingApp
//
//  Created by 李立达 on 2017/8/30.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "JSONModel.h"
@protocol  HCOrderlistPruductDetailModel

@end
@interface HCOrderlistPruductDetailModel : JSONModel
@property (nonatomic, copy) NSString *productName;

@property (nonatomic, assign) long long validEndTime;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, strong) NSArray *productImgUrl;

@property (nonatomic, assign) long long validBeginTime;
@end
