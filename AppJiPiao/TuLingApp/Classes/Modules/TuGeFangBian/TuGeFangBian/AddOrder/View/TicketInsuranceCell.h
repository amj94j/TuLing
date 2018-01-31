//
//  TicketInsuranceCell.h
//  TuLingApp
//
//  Created by abner on 2017/12/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketOrderCommitViewController.h"
@class TicketInsuranceTradeModel;

@interface TicketInsuranceCell : UITableViewCell

@property (nonatomic, strong) TicketInsuranceTradeModel *tradeModel;
@property (nonatomic, copy) void (^selectInsuranceBlock)(); // 选择保险
@property (nonatomic, copy) void (^selectInsurancePassengerModelsBlock)(NSMutableArray *selectInsurancePassengerModels); // 选择购买保险的乘机人

@property (nonatomic, weak) TicketOrderCommitViewController *currentVC;
@end
