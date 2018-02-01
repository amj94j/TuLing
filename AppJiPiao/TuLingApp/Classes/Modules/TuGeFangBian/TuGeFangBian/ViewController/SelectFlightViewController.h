//
//  SelectFlightViewController.h
//  TuLingApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  航班列表页

#import "TicketBaseVC.h"
#import "TLTicketModel.h"
#import "TicketEndorseInfo.h"
#import "SelectFlightConditionModel.h"

typedef NS_ENUM(NSInteger, SelectFlightType) {
    SelectFlightDefault,
    SelectFlightEndorse, // 改签
    SelectFlightTicketEndorse // 改签 本地
};

@interface SelectFlightViewController : TicketBaseVC
@property (nonatomic, strong) TLTicketModel *tickeModel;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) SearchFlightsModel *goSearchFlightsInfo;
@property (nonatomic, copy) NSDictionary *goDataDic;
@property (nonatomic, assign) SelectFlightType selecFlightType;
@property (nonatomic, strong) EndorseModel *endorseModel;
@property (nonatomic, strong) TicketEndorseInfo *endorseInfo;
@property (nonatomic, strong) SelectFlightConditionModel *selectFlightConditionModel;
@property (nonatomic, copy) NSDictionary *goDic;
@end
