//
//  TicketOrderCommintFooterView.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketOrderCommintFooterView : UIView

@property (nonatomic, copy) void (^showDetaileAndGoPayBlock)(BOOL isGoPay);

+ (instancetype)xib;

// 更新所有费用和更新乘客数量
- (void)updateAllCost:(double)cost passengerCount:(NSInteger)passengerCount;

@end
