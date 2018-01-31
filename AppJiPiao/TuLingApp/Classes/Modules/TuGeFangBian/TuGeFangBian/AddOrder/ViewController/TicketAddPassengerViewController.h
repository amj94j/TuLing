//
//  TicketAddPassengerViewController.h
//  TuLingApp
//
//  Created by abner on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseTicketViewController.h"

@class TicketPassengerModel;

@interface TicketAddPassengerViewController : BaseTicketViewController

@property (nonatomic, strong) TicketPassengerModel *model;
@property (nonatomic, copy) void (^addComplete)(TicketPassengerModel *addModel);

@end
