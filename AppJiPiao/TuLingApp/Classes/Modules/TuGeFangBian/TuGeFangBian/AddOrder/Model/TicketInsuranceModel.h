//
//  TicketInsuranceModel.h
//  TuLingApp
//
//  Created by abner on 2017/12/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"

@interface TicketInsuranceModel : TicketBaseModel

@property (nonatomic, copy) NSString *insuranceCompanyCode;
@property (nonatomic, copy) NSString *insuranceCompanyName;    // 保险公司名称
@property (nonatomic, copy) NSString *insuranceName;    // 保险产品名称
@property (nonatomic, copy) NSString *insuranceProductId;    // 保险公司产品id
@property (nonatomic, copy) NSString *insuranceId;    // 保险id
@property (nonatomic, assign) NSInteger insuranceType;    // 险种类型 1.航空意外险 ,2 航空延误限
@property (nonatomic, copy) NSString *insuranceTypeName;
@property (nonatomic, copy) NSString *insuranceProductCode;    // 保险编码，唯一
@property (nonatomic, assign) double insuranceFee;    // 保费
@property (nonatomic, assign) double costFee;    // 成本
@property (nonatomic, copy) NSString *insuranceMemo;
@property (nonatomic, copy) NSString *insuranceDetail;
@property (nonatomic, assign) NSInteger createTime;    // 创建时间
@property (nonatomic, copy) NSString *createUserId;    // 创建人id
@property (nonatomic, assign) NSInteger updateTime;    // 修改时间
@property (nonatomic, copy) NSString *updateUserId;    // 修改人id
@property (nonatomic, copy) NSString *versionNum;   //  版本号
@property (nonatomic, assign) BOOL isDel;    // 是否删除 0 未删除，1 已删除

+ (NSMutableArray *)getDemoInstances;

@end

// 保险交易模型
@interface TicketInsuranceTradeModel : TicketBaseModel

@property (nonatomic, strong) TicketInsuranceModel *insuranceModel;
@property (nonatomic, strong) NSMutableArray *passengerModels; // 乘车人模型集合
@property (nonatomic, strong) NSMutableArray *buyPassengerModels; // 购买保险的乘车人模型集合
@property (nonatomic, assign) BOOL isDanCheng; // 是否单程
@property (nonatomic, assign) BOOL isSelected; // 是否选择购买

#pragma mark 获取保险信息
+ (void)asyncGetInsuranceWithIsDanCheng:(BOOL)isDanCheng
                           successBlock:(void(^)(NSArray *dataArray))successBlock
                             errorBlock:(void(^)(NSError *errorResult))errorBlock;

@end
