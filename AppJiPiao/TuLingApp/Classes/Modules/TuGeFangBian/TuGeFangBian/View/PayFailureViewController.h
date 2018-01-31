//
//  PayFailureViewController.h
//  TuLingApp
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseVC.h"

typedef NS_ENUM(NSInteger, PayFailureType){
    PayFailureTypeDefault = 0, // 支付失败
    PayFailureTypeCreate // 创建订单失败
};

@interface PayFailureViewController : TicketBaseVC
@property (nonatomic) PayFailureType payFailureType;
@end
