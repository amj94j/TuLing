//
//  TicketOrderViewController.h
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  舱位选择页

#import "TicketBaseVC.h"
#import "WKWebViewController.h"
#import "TicketEndorseInfo.h"
typedef NS_ENUM(NSInteger, TicketOrderType) {
    TicketOrderDefault,
    TicketOrderEndorse, // 改签
    TicketOrderTicketEndorse
};

@interface TicketOrderViewController : TicketBaseVC
@property (nonatomic, strong) SearchFlightsModel *searchFlightsInfo;
@property (nonatomic, strong) TLTicketModel *tickeModel;
@property (nonatomic, strong) SearchFlightsModel *goSearchFlightsInfo;
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, copy) NSDictionary *goDataDic;
@property (nonatomic, assign) TicketOrderType ticketOrderType;
@property (nonatomic, strong) EndorseModel *endorseModel;
@property (nonatomic, strong) TicketEndorseInfo *endorseInfo;
@property (nonatomic, copy) NSDictionary *goDic;
@end
