//
//  EndorseViewController.h
//  TuLingApp
//
//  Created by apple on 2017/12/23.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  改签详情页

#import "TicketBaseVC.h"
#import "TicketEndorseInfo.h"

@interface EndorseViewController : TicketBaseVC
// 状态 是否已改签
@property (nonatomic) BOOL isEndorse; // NO未开前
@property (nonatomic, strong) TicketEndorseInfo *endorseInfo;
@property (nonatomic, copy) NSDictionary *selEndorseTicketDic; // 选择的航班信息
@property (nonatomic, strong) SearchFlightsModel *goSearchFlightsInfo;
@property (nonatomic, strong) SearchFlightsModel *backSearchFlightsInfo;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *businessCode;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *backBusinessCode;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSDictionary *endorseDic;
@end
