//
//  ShowFlightInforView.h
//  ticket
//
//  Created by LQMacBookPro on 2017/12/13.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchFlightsModel;

@interface ShowFlightInforView : UIView

+ (ShowFlightInforView *)showFlightInforWithModel:(SearchFlightsModel *)model;

- (ShowFlightInforView *)initFlightInfoWithModel:(SearchFlightsModel *)model;

@end
