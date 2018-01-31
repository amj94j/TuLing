//
//  CityListViewController.h
//  TuLingApp
//
//  Created by apple on 2017/12/6.
//  Copyright © 2017年 shensiwei. All rights reserved.
//  城市列表

#import <UIKit/UIKit.h>

typedef void (^CityListViewControllerBlock)(CityModel *model);

@interface CityListViewController : UIViewController
@property (nonatomic, copy) CityListViewControllerBlock block;

@property (nonatomic, strong) CityModel *positioningCity;
@end
