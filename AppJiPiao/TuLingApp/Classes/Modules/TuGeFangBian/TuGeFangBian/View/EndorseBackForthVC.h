//
//  EndorseBackForthVC.h
//  TuLingApp
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  往返退改签规则弹窗

#import <UIKit/UIKit.h>
#import "EndorseBackRulesModel.h"

@interface EndorseBackForthVC : UIViewController
@property (nonatomic, strong) EndorseBackRulesModel *go_Model;
@property (nonatomic, strong) EndorseBackRulesModel *back_Model;
@end
