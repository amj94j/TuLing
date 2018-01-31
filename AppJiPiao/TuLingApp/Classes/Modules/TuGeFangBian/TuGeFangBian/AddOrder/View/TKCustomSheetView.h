//
//  TKCustomSheetView.h
//  泰行销
//
//  Created by LQMacBookPro on 2017/8/17.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKCustomSheetViewDelegate <NSObject>

@optional
- (void)customerSheetSelect:(NSString *)str;

@end

@interface TKCustomSheetView : UIView

@property (nonatomic, strong)NSArray * dataArray;

@property (nonatomic, weak)id<TKCustomSheetViewDelegate>delegate;

+ (TKCustomSheetView *)customerViewWithDataArray:(NSArray *)array;

- (void)showCustSheetInView:(UIView *)view WithDataArray:(NSArray *)array delegate:(id)delegate;

@end
