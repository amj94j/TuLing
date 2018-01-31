//
//  MainLeftsatuesFailCell.h
//  TuLingApp
//
//  Created by hua on 2017/5/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BackBtnClick)();
@interface MainLeftsatuesFailCell : UITableViewCell

@property (nonatomic, copy) BackBtnClick backBtn;


@property (nonatomic, copy) UILabel *title;

@property (nonatomic, copy) UILabel *detail;

@property (nonatomic, copy) UILabel *detail1;
@property (nonatomic, strong) UIButton *mybackBtn;

@end
