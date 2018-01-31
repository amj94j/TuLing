//
//  TicketHeadModel.h
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef enum{
    TicketHeadFlogTypeAdd,
    TicketHeadFlogTypeAll,
    TicketHeadFlogTypeDele = 3
}TicketHeadFlogType;

@interface TicketHeadModel : NSObject

/** 创建时间 **/
@property (nonatomic,copy)NSString * createTime;

/** userId **/
@property (nonatomic,copy)NSString * createUserId;

/** id **/
@property (nonatomic,copy)NSString * ID;

/** 发票抬头名称 **/
@property (nonatomic,copy)NSString * invoiceHead;

/** 纳税人(公司)识别号(要显示的) **/
@property (nonatomic,copy)NSString * voucherCode;

/**企业、个人 **/
@property (nonatomic,copy)NSString * isPersonal;

/** 发票抬头id **/
@property (nonatomic,copy)NSString * lookedUpId;

/** 版本号 **/
@property (nonatomic,copy)NSString * versionNum;

/** 是否已选 **/
@property (nonatomic,assign) BOOL isSelected;

- (TicketHeadModel *)initTicketHeadModelWithDic:(NSDictionary *)dict;

+ (void)ticketHeadWithParam:(NSMutableDictionary *)param WithFlog:(TicketHeadFlogType)flogType success:(void(^)(id respond))success faild:(void(^)(id error))faild;


@end
