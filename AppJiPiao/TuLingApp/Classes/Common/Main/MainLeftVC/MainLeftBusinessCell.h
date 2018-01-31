//
//  MainLeftBusinessCell.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Item1Btns)(UIButton *);
typedef void(^Item2Btns)(UIButton *);

@interface MainLeftBusinessCell : UITableViewCell

@property (nonatomic, copy) Item1Btns item1;
@property (nonatomic, copy) Item2Btns item2;

@property (nonatomic, copy)NSString *isNews;

@end
