//
//  ZJSearchHistoryBtn.h
//  TuLingApp
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSearchHistoryBtn : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beginCityWidth;
@property (weak, nonatomic) IBOutlet UILabel *beginCityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickSearchBtn;

@end
