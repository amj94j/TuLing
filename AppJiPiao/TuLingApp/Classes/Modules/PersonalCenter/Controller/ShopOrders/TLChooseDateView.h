//
//  TLChooseDateView.h
//  TuLingApp
//
//  Created by gyc on 2017/5/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

/*
 *   选择日期页面
 */

typedef void(^ChooseDateFinishBlock)(NSDate * date,NSString * stringDate);

#import <UIKit/UIKit.h>

@interface TLChooseDateView : UIView

-(instancetype)initWithRootView:(UIView*)rootView start:(NSDate*)startDate end:(NSDate*)endDate;
-(void)showView;

//选择返回时间结果
-(void)finishChooseDate:(ChooseDateFinishBlock)block;
@end
