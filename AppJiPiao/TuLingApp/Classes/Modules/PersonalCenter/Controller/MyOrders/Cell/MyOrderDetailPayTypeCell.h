//
//  MyOrderDetailPayTypeCell.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderDetailModel.h"

@interface MyOrderDetailPayTypeCell : UITableViewCell

@property (nonatomic, strong) MyOrderDetailModel *model;
@property (nonatomic, assign)   CGFloat  lastHeight;
@end
