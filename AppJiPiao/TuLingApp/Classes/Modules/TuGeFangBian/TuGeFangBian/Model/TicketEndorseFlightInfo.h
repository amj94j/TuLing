//
//  TicketEndorseFlightInfo.h
//  TuLingApp
//
//  Created by apple on 2017/12/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"
#import "TicketEndorseInfo.h"

@interface TicketEndorseFlightInfo : TicketBaseModel

@property (nonatomic, copy) NSString *airlineCompany;
@property (nonatomic, copy) NSString *backBeginCity;
@property (nonatomic, copy) NSString *backBeginTime;
@property (nonatomic, copy) NSString *backBusinessCode;
@property (nonatomic) NSInteger backBusinessType;
@property (nonatomic, copy) NSString *backEndCity;
@property (nonatomic, copy) NSString *backEndTime;
@property (nonatomic, copy) NSString *beginCity;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *bigPnr;
@property (nonatomic, copy) NSString *btime;
@property (nonatomic, copy) NSString *businessCode;
@property (nonatomic) NSInteger businessType;
@property (nonatomic) NSInteger costAmount;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic) NSInteger createUserId;
@property (nonatomic, copy) NSString *createUserName;
@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *detailList;
@property (nonatomic, copy) NSString *draWer;
@property (nonatomic, copy) NSString *endCity;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *etime;
@property (nonatomic, copy) NSString *flightNumber;
@property (nonatomic, copy) NSString *isChange;
@property (nonatomic, copy) NSString *isChangeOrder;
@property (nonatomic) NSInteger isDel;
@property (nonatomic) NSInteger isInsurance;
@property (nonatomic) NSInteger isReimburse;
@property (nonatomic, copy) NSString *mobilePhone;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic) NSInteger orderSource;
@property (nonatomic) NSInteger orderState;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic) NSInteger orderType;
@property (nonatomic, copy) NSString *otime;
@property (nonatomic) NSInteger outTicketType;
@property (nonatomic, copy) NSString *parentOrderId;
@property (nonatomic, copy) NSString *payTime;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *pnrCode;
@property (nonatomic) NSInteger *realTotalAmount;
@property (nonatomic, copy) NSString *rebateAmount;
@property (nonatomic, copy) NSString *smsAcceptorPhone;
@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *updateUserId;
@property (nonatomic, copy) NSString *utime;
@property (nonatomic) NSInteger versionNum;


// 改签新接口
+ (void)asyncPostNewEndorseModel:(TLTicketModel *)ticketModel dataDic:(TicketEndorseInfo *)dataDic backState:(NSString *)backState isOrderType:(NSString *)isOrderType SuccessBlock:(void(^)(NSArray *dataArray))successBlock  errorBlock:(void(^)(NSError *errorResult))errorBlock;
@end
