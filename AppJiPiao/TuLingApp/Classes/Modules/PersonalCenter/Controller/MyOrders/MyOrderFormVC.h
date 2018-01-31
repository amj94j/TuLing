//
//  MyOrderFormVC.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/22.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseVC.h"

@interface MyOrderFormVC : BaseVC

@property (nonatomic, assign) BOOL isFromLeft;

//判断是否从付款失败页面进来 0代表是
@property (nonatomic, assign) NSString* ispayLogin;


@end
