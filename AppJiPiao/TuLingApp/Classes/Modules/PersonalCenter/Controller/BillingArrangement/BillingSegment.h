//
//  BillingSegment.h
//  TuLingApp
//
//  Created by hua on 17/4/17.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BillingSegmentDelegate<NSObject>
@optional

-(void)segumentSelectionChange:(NSInteger)selection;


@end
@interface BillingSegment : UIView
@property(nonatomic,strong)id<BillingSegmentDelegate>delegate;
//滑竿名字(即滑竿Btn个数)
@property(nonatomic,strong) NSMutableArray *btnTitleSource;
//滑竿未点击字体颜色
@property(nonatomic,strong)UIColor *titleColor;
//滑竿点击后字体颜色
@property(nonatomic,strong)UIColor *selectColor;
//滑竿Btn字体和型号
@property(nonatomic,strong)UIFont *titleFont;
//滑竿下划线颜色
@property(nonatomic,strong)UIColor *buttonDownColor;

+(BillingSegment *)segmentedControlFrame:(CGRect)frame titDataSource:(NSArray *)titleDataSouce backgorundColor:(UIColor *)backgroundColror titleColor:(UIColor *)titleColor
                             titleFont:(UIFont *)titleFont selectColor:(UIColor *)selectColor buttonDownColor:(UIColor *)buttonDoewnColor Delegate:(id)delegate;
@end
