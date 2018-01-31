//
//  PassengerInfoCell.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TicketPassengerModel;

@interface PassengerInfoCell : UITableViewCell

@property (nonatomic, strong) TicketPassengerModel *model;
@property (nonatomic, copy) void (^userAction)(NSUInteger tag);

@end
