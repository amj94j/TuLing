//
//  ReturnDetailModel.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/6.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseModel.h"

@interface ReturnDetailModel : BaseModel

// 按钮
@property (nonatomic, strong) NSDictionary *button;
// 退款状态
@property (nonatomic, strong) NSString *content;
// 创建时间
@property (nonatomic, strong) NSString *createDate;
// 订单id
@property (nonatomic, assign) NSInteger orderId;
// 退款id
@property (nonatomic, assign) NSInteger orderReturnId;
// 退款类型（1、   2、    ）
@property (nonatomic, assign) NSInteger orderReturnType;
// 电话
@property (nonatomic, strong) NSString *phone;
// 退款地址
@property (nonatomic, strong) NSString *returnAddress;
// 退款说明
@property (nonatomic, strong) NSString *returnContent;
// 退款原因
@property (nonatomic, strong) NSString *returnMessage;
// 结束时间
@property (nonatomic, assign) NSInteger returnDateEnd;
// 开始时间
@property (nonatomic, assign) NSInteger returnDateStart;
// 服务器时间
@property (nonatomic, assign) NSInteger nowDate;
// 退款编号
@property (nonatomic, strong) NSString *returnNumber;
// 退款金额
@property (nonatomic, assign) double returnTotle;
// 标题
@property (nonatomic, strong) NSString *title;
// 快递单号
@property (nonatomic, strong) NSString *shipperCode;
// 快递名字
@property (nonatomic, strong) NSString *shipperName;
//
@property (nonatomic, strong) NSString *showDate;
// 商家留言
@property (nonatomic, strong) NSString *shopMessage;
//是否收到货
@property (nonatomic, assign) NSInteger isReceipt;
//系统电话
@property (nonatomic, strong) NSString  *sysPhone;

@end
