//
//  TLAppUpdateView.h
//  TuLingApp
//
//  Created by 李立达 on 2017/7/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UpdateStatus) {
    UpdateStatusNeed = 1,
    UpdateStatusAuto = 0
};

@interface TLAppUpdateView : UIView
@property(assign,nonatomic)UpdateStatus type;
@property(copy,nonatomic)void(^updateButtonBlock)();
@property(copy,nonatomic)void(^closeButtonBlock)();
-(instancetype)initwithType:(UpdateStatus)type;
-(void)showView;
-(void)hiddenView;
@end
