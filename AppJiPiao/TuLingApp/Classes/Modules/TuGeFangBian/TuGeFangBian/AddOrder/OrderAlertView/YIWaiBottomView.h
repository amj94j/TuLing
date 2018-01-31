//
//  YIWaiBottomView.h
//  ticket
//
//  Created by LQMacBookPro on 2017/12/12.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TicketInsuranceTradeModel;

@interface YIWaiBottomView : UIView

+ (instancetype)yiwaiBottomView;

@property (nonatomic, strong)TicketInsuranceTradeModel * baoXianModel;

@end
