//
//  SelectFlightConditionView.h
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectFlightViewController.h"
#import "SelectFlightConditionModel.h"
@interface SelectFlightConditionView : UIView
@property (nonatomic, weak) SelectFlightViewController *VC;
@property (nonatomic, copy) void(^selectFlightConditionBlock)(TLTicketModel *model,SelectFlightConditionModel *selectFlightConditionModel);
@property (nonatomic, strong) SelectFlightConditionModel *selectFlightConditionModel;
- (instancetype)initWithFrame:(CGRect)frame tickeModel:(TLTicketModel *)tickeModel selectFlightConditionModel:(SelectFlightConditionModel *)selectFlightConditionModel;
+ (void)recyclingView;
@end
