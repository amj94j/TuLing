//
//  TicketOrderContentView.h
//  TuLingApp
//
//  Created by abner on 2017/12/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TicketOrderModel, TicketOrderCommitViewController;

@interface TicketOrderContentView : UIView

@property (nonatomic, strong) TicketOrderModel *orderModel;
@property (nonatomic, copy) void (^updateLayoutBlock)(CGFloat height);
@property (nonatomic, copy) void (^updateAllCostAndPassenger)(double cost, NSUInteger passengerCount); // 更新所有费用明细和乘机人数量
@property (nonatomic, weak) TicketOrderCommitViewController *currentVC;
@property (nonatomic, copy) NSString *postageStr;
+ (instancetype)xib;

@end
