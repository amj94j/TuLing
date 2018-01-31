//
//  MainLeftSecondCell.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemsClick)(UIButton *);

@interface MainLeftSecondCell : UITableViewCell

@property (nonatomic, copy) ItemsClick itemsClick;

@property (nonatomic, copy)NSString *isNews;

@end
