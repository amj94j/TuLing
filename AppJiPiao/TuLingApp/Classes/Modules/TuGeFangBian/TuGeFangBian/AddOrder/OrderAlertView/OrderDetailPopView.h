//
//  OrderDetailPopView.h
//  ticket
//
//  Created by LQMacBookPro on 2017/12/12.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TicketOrderModel;

@interface OrderDetailPopView : UIView

//+ (instancetype)orderDetailPopViewWithPassageArray:(NSMutableArray <TicketOrderModel *>*)passageArray;
//
//+ (OrderDetailPopView *)orderDetailPopViewWithTicketOrderModel:(TicketOrderModel *)model;

- (void)disMaskViewDismiss;

- (OrderDetailPopView *)initPopWithModel:(TicketOrderModel *)model postageStr:(NSString *)postageStr;

@end
