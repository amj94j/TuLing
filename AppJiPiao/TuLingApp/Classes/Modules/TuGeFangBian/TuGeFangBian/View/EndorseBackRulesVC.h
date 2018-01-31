//
//  EndorseBackRulesVC.h
//  TuLingApp
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  单程退改签规则弹窗

#import <UIKit/UIKit.h>
#import "EndorseBackRulesModel.h"

@interface EndorseBackRulesVC : UIViewController
- (void)reloadData:(EndorseBackRulesModel *)model;
@end
