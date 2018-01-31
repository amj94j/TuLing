//
//  TLMyOrderRemainEvaluateCell.h
//  TuLingApp
//
//  Created by gyc on 2017/7/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderFormListModel.h"

typedef void(^TLMyOrderRemainEvaluateCellEventBlock)(void);



@interface TLMyOrderRemainEvaluateCell : UITableViewCell
@property (nonatomic, strong) OrderFormProductsModel *model;
@property (nonatomic,copy) TLMyOrderRemainEvaluateCellEventBlock eventBlock;
-(void)cellSharePriceEvent:(TLMyOrderRemainEvaluateCellEventBlock)block;

@end
