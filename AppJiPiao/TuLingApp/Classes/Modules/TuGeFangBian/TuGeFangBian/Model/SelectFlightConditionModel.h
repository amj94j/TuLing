//
//  SelectFlightConditionModel.h
//  TuLingApp
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"

@interface SelectFlightConditionModel : TicketBaseModel
@property (nonatomic, copy) NSArray *planeSizeArr;
@property (nonatomic, copy) NSArray *departureTimeArr;
@property (nonatomic) NSInteger count;
@end
