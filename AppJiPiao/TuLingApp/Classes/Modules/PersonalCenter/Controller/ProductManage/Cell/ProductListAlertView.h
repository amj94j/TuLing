//
//  ProductListAlertView.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ContinueBtnClick)();

@interface ProductListAlertView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, copy)ContinueBtnClick continueBtn;

- (void) storyBoardPopViewWithContent:(NSString *)content;

@end
