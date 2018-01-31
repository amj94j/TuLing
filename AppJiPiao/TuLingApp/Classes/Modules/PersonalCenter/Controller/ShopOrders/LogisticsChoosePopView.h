//
//  LogisticsChoosePopView.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogisticsCompanyModel.h"


typedef void(^ChooseLogisticsClick)(LogisticsCompanyModel *logModel);

@interface LogisticsChoosePopView : UIView <UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>


@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) ChooseLogisticsClick logisClick;


- (void) storyBoardPopViewWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;

@end
