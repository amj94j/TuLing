//
//  ShopOrderDetailBaseInfoCell.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/20.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopOrderDetailModel.h"

typedef void(^ReturnBtnBlock)();

@interface ShopOrderDetailBaseInfoCell : UITableViewCell

@property (nonatomic, strong) ShopOrderDetailModel *model;
@property (nonatomic, copy) ReturnBtnBlock returnBtnClick;

@end
