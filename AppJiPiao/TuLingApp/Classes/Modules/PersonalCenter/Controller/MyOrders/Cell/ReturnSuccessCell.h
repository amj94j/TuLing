//
//  ReturnSuccessCell.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/7.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackBtnClick)(void);

@interface ReturnSuccessCell : UITableViewCell

@property (nonatomic, copy) BackBtnClick backBtnClick;

@end
