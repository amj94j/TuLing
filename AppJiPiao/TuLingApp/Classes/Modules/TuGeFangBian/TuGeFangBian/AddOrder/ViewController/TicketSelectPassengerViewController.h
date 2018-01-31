//
//  TicketSelectPassengerViewController.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseVC.h"

@interface TicketSelectPassengerViewController : TicketBaseVC

@property (nonatomic, strong) NSMutableArray *passengerModels;
@property (nonatomic, strong) NSMutableArray *selectedModels;
@property (nonatomic, copy) void (^selectComplete)(NSMutableArray *selectedModels);

@end
