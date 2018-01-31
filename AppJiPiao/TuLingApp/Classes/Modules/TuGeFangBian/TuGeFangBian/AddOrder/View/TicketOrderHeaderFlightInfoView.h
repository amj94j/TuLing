//
//  TicketOrderHeaderFlightInfoView.h
//  TuLingApp
//
//  Created by abner on 2017/12/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ZJXibSubView.h"

typedef enum : NSUInteger {
    ShowDetailInfoTypeFlight = 0, // 机票详情
    ShowDetailInfoTypeChild,      // 儿童票、婴儿票
    ShowDetailInfoTypeSign,       // 退改签规则
} ShowDetailInfoType;

@class SearchFlightsModel;

@interface TicketOrderHeaderFlightInfoView : ZJXibSubView

@property (nonatomic, strong) SearchFlightsModel *flightModel;
@property (nonatomic, copy) void (^showDetailInfoBlock)(ShowDetailInfoType type);

@end
