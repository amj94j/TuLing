//
//  TicketAddressModel.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"
typedef enum : NSUInteger {
    AddressActionAdd = 0,
    AddressActionQuery,
    AddressActionEdit,
    AddressActionDelete,
} AddressAction;  // 操作方式

@interface TicketAddressModel : TicketBaseModel

@property (nonatomic, assign) NSInteger isNew;      //
@property (nonatomic, copy) NSString *zipCode;      // 邮编：100022
@property (nonatomic, assign) NSInteger createUserId;      // 123123
@property (nonatomic, copy) NSString *linkPhone;      // 电话号码
@property (nonatomic, copy) NSString *updateUserId; //
@property (nonatomic, assign) NSInteger versionNum;      //
@property (nonatomic, copy) NSString *updateTime; //
@property (nonatomic, copy) NSString *userName; // 李四
@property (nonatomic, assign) NSInteger userId;      // 1231
@property (nonatomic, copy) NSString *province; // 省：河北
@property (nonatomic, copy) NSString *city; // 市：张家口
@property (nonatomic, copy) NSString *county; // 县
@property (nonatomic, copy) NSString *detailedAddress;      // 详细地址：小街项5号
@property (nonatomic, assign) NSInteger createTime;    // 创建时间
@property (nonatomic, assign) NSInteger addressId;      //
@property (nonatomic, assign) BOOL isDel;      //
@property (nonatomic,assign)BOOL isSelected; /** 是否已选 **/

#pragma mark 地址操作
+ (void)asyncAddressActionWithActionType:(AddressAction)actionType
                            addressModel:(TicketAddressModel *)addressModel
                            successBlock:(void(^)(NSArray *dataArray))successBlock
                              errorBlock:(void(^)(NSError *errorResult))errorBlock;

@end
