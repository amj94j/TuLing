//
//  TicketAddAddressViewController.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseTicketViewController.h"

@class TicketAddressModel;

@interface TicketAddAddressViewController : BaseTicketViewController

@property (nonatomic, copy) void (^addComplete)(TicketAddressModel *addModel);

@end
