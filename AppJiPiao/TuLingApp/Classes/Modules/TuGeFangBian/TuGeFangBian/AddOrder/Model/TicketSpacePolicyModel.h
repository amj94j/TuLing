//
//  TicketSpacePolicyModel.h
//  TuLingApp
//
//  Created by abner on 2017/12/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  机票舱位政策信息模型

#import "TicketBaseModel.h"

@class TicketSpaceModel;

@interface TicketSpacePolicyModel  : TicketBaseModel

@property (nonatomic, strong) TicketSpaceModel *belongSpcaceModel; // 政策信息模型所属的舱位模型
@property (nonatomic, copy) NSString *policyid; // 政策ID
@property (nonatomic, copy) NSString *policytype; // 政策类型 /B2B/BSP/B2C
@property (nonatomic, assign) NSInteger policysource; // 政策来源 0:直减 1:官网 2:官网标准 3:平台标准 4:紧急通道5:多运价
@property (nonatomic, assign) NSInteger producttype; // 产品类型 0:旗舰店 1:标准 2:极速 3:紧急通道 4:直减 5:不允许换编码 6:多运价 7:全价 8:头等
@property (nonatomic, copy) NSString *brandtype; // 品牌类型 10、优选20、标准21、普通22、急速30、紧急通道40、特惠优选
@property (nonatomic, copy) NSString *brandname; // 品牌名称
@property (nonatomic, assign) NSInteger policyplattype; // 政策平台类型 0 国内，1 官网
@property (nonatomic, assign) NSInteger policysign; // 政策标识0国内 标准(极速)1国内 紧急2国内 多运价 3官网 旗舰店 4官网 标准 5官网 直减 6官网 官网 7官网 大客户


@property (nonatomic, assign) double saleprice; // 销售价
@property (nonatomic, assign) double rate; // 返点
@property (nonatomic, assign) double childrate; // 儿童返点
@property (nonatomic, assign) double babyrate; // 婴儿返点
@property (nonatomic, assign) double speprice; // 机票成人优惠金额

@property (nonatomic, assign) double ticketsettleprice; // 机票总结算价格(机票+机建+燃油)
@property (nonatomic, assign) double childticketsettleprice; // 儿童机票总结算价格
@property (nonatomic, assign) double babyticketsettleprice; // 婴儿机票总结算价格

@property (nonatomic, strong) NSMutableArray *bindings; // 绑定产品信息 TicketBindInfoModel
@property (nonatomic, assign) double settleprice; // 单个乘机人总结算价格(含机票+强制绑定产品信息)
@property (nonatomic, assign) double childsettleprice; // 单个乘机人总结算价格(儿童)
@property (nonatomic, assign) double babysettleprice; // 单个乘机人总结算价格(婴儿)

@property (nonatomic, assign) double itprintprice; // 行程单打印价格
@property (nonatomic, copy) NSString *itremark; // 行程单备注信息
@property (nonatomic, copy) NSString *comment; // 政策备注
@property (nonatomic, copy) NSString *customertype; // 乘客类型 成人、成人+儿童、成人+婴儿
@property (nonatomic, assign) BOOL issuperpolicy; // 是否上级政策 0．不是，1. 是
@property (nonatomic, assign) BOOL isstandardkg; // 是否标准客规 0. 不是；1. 是
@property (nonatomic, copy) NSString *airrule; // 客规

/**
 ticketparprice:票面价
 rate": 返点
 speprice: 机票成人优惠金额       （机票成人优惠金额=票面价*返点）
 saleprice  销售价    (销售价=票面价-机票成人优惠金额)
 ticketsettleprice   机票总结算价   (机票总结算价格=(机票"销售价"+机建+燃油)
 */

// 获取Demo数据
+ (instancetype)getDemoInstance;
+ (TicketSpacePolicyModel *)getUserModel:(NSDictionary*)netDic;
@end
