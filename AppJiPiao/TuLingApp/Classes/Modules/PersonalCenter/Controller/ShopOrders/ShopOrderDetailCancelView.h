//
//  ShopOrderDetailCancelView.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/20.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderFormListModel.h"

typedef void(^CancelFinishBlock)(NSString *reason);

@interface ShopOrderDetailCancelView : UIView <UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

- (void) storyBoardPopViewWithReasonDataSource:(NSArray *)reasonDatas;
@property (nonatomic, copy) CancelFinishBlock cancelFinish;

@end
