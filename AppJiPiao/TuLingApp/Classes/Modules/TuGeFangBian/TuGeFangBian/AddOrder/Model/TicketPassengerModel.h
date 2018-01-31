//
//  TicketPassengerModel.h
//  TuLingApp
//
//  Created by abner on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"

typedef enum : NSUInteger {
    PassengerActionAdd = 0,
    PassengerActionQuery,
    PassengerActionEdit,
    PassengerActionDelete,
} PassengerAction;  // 操作方式

@interface TicketPassengerModel : TicketBaseModel

@property (nonatomic, assign) NSInteger createTime;    // 创建时间
@property (nonatomic, assign) NSInteger personId;      //
@property (nonatomic, assign) BOOL isDel;      //
@property (nonatomic, copy) NSString *linkPhone;      // 电话号码
@property (nonatomic, assign) NSInteger isNew;      //
@property (nonatomic, copy) NSString *personIdentityCode; // 证件号
@property (nonatomic, assign) NSInteger personIdentityType;      // 证件类型：1身份证 3护照 8其他
@property (nonatomic, copy) NSString *personIdentityName;      // 证件名
@property (nonatomic, copy) NSString *personName; // 姓名
@property (nonatomic, assign) NSInteger versionNum;      //

/** 是否成年 **/
@property (nonatomic,assign)BOOL  isAudlt;
/** 是否儿童 **/
@property (nonatomic,assign)BOOL isChild;
/** 是否婴儿 **/
@property (nonatomic,assign)BOOL isBaby;
/** 是否已选 **/
@property (nonatomic,assign)BOOL isSelected;

#pragma mark 获取乘机人列表
+ (void)asyncQuerySelctedFlightPersonWithPersonId:(NSInteger)personId
                                     successBlock:(void(^)(NSArray *dataArray))successBlock
                                       errorBlock:(void(^)(NSError *errorResult))errorBlock;

#pragma mark 乘机人操作
+ (void)asyncPassengerActionWithActionType:(PassengerAction)actionType
                            passengerModel:(TicketPassengerModel *)passengerModel
                              successBlock:(void(^)(NSArray *dataArray))successBlock
                                errorBlock:(void(^)(NSError *errorResult))errorBlock;

#pragma mark 判断添加的乘客是否是成年人
+ (void)asyncCheckPersonIsAdultWithPersonIdentityCode:(NSString *)personIdentityCode
                                         successBlock:(void(^)(NSInteger passengerType))successBlock
                                           errorBlock:(void(^)(NSError *errorResult))errorBlock;
@end
