//
//  SelectFlightConditionModel.m
//  TuLingApp
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 shensiwei. All rights reserved.
//

#import "SelectFlightConditionModel.h"

@implementation SelectFlightConditionModel
- (NSArray *)planeSizeArr {
    if (!_planeSizeArr) {
        _planeSizeArr = [NSArray new];
    }
    return _planeSizeArr;
}

- (NSArray *)departureTimeArr {
    if (!_departureTimeArr) {
        _departureTimeArr = [NSArray new];
    }
    return _departureTimeArr;
}

@end
