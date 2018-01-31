//
//  MyOrderProductTableViewCell.h
//  TuLingApp
//
//  Created by 李立达 on 2017/7/26.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderFormListModel.h"
@interface MyOrderProductTableViewCell : UITableViewCell
@property (nonatomic, strong) OrderFormProductsModel *model;
@property (nonatomic, strong) void(^buttonClick)();
@end
