//
//  TicketSelectAddressViewController.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseVC.h"

@class TicketAddressModel;

@interface TicketSelectAddressViewController : TicketBaseVC

@property (nonatomic, strong) NSMutableArray *addressModels;
@property (nonatomic, strong) TicketAddressModel *selectedModel;
@property (nonatomic, copy) void (^selectComplete)(TicketAddressModel *selectedModel);

@end
