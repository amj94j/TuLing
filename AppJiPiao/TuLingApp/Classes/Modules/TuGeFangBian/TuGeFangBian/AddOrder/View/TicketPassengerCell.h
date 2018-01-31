//
//  TicketPassengerCell.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TicketPassengerModel;

@interface TicketPassengerCell : UITableViewCell

@property (nonatomic, strong) TicketPassengerModel *model;
@property (nonatomic, copy) void (^deleteAction)();

@end
