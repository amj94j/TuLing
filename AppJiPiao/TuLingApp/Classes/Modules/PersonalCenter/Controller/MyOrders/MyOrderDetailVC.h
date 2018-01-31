//
//  MyOrderDetailVC.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseVC.h"

@interface MyOrderDetailVC : BaseVC

@property (nonatomic, assign) NSInteger orderId;

//判断是否从付款失败页面进来 0代表是
@property (nonatomic, assign) NSString * ispayLogin;

@end
