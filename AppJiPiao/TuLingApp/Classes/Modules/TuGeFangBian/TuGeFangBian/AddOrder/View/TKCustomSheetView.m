//
//  TKCustomSheetView.m
//  泰行销
//
//  Created by LQMacBookPro on 2017/8/17.
//  Copyright © 2017年 taikanglife. All rights reserved.
//

#import "TKCustomSheetView.h"

#define kSelectProjectBtnHeight 55

@interface TKCustomSheetView()

@property (nonatomic, weak)UIButton * dimBtn;

@end

@implementation TKCustomSheetView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        TLScreenWidth
        
//        TLScreenHeight
    }
    return self;
}


+ (TKCustomSheetView *)customerViewWithDataArray:(NSArray *)array
{
    TKCustomSheetView * sheetView = [[TKCustomSheetView alloc]init];
    
    sheetView.backgroundColor = [UIColor redColor];
    
    CGFloat sheetY = TLScreenHeight;
    
    sheetView.frame = CGRectMake(0, sheetY, TLScreenWidth, kSelectProjectBtnHeight * array.count);
    
    for (int i = 0; i < array.count; i ++) {
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i * kSelectProjectBtnHeight, TLScreenWidth, kSelectProjectBtnHeight)];
        
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:array[i] forState:UIControlStateNormal];
        
        [sheetView addSubview:btn];
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        sheetView.y = TLScreenHeight - array.count * kSelectProjectBtnHeight;
        
    }];
    
    return sheetView;
}

- (void)showCustSheetInView:(UIView *)view WithDataArray:(NSArray *)array delegate:(id)delegate
{
    TKCustomSheetView * sheetView = [[TKCustomSheetView alloc]init];
    
    CGFloat sheetY = TLScreenHeight;
    
    sheetView.delegate = delegate;
    
    sheetView.frame = CGRectMake(0, sheetY, TLScreenWidth, kSelectProjectBtnHeight * array.count);
    
    sheetView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < array.count; i ++) {
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i * kSelectProjectBtnHeight, TLScreenWidth, kSelectProjectBtnHeight)];
        
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        
        [btn setTitle:array[i] forState:UIControlStateNormal];
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, kSelectProjectBtnHeight -1, TLScreenWidth, 1)];
        
        line1.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        
        [btn addSubview:line1];
        
        [sheetView addSubview:btn];
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        sheetView.y = view.height - array.count * kSelectProjectBtnHeight;
        
    }];
    
    UIButton * dimBtn = [[UIButton alloc]initWithFrame:view.bounds];
    
    dimBtn.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.5];
    
    [dimBtn addSubview:sheetView];
    
    [view addSubview:dimBtn];
    
    _dimBtn = dimBtn;
    
    [dimBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismiss
{
    [_dimBtn removeFromSuperview];
}

- (void)selectBtn:(UIButton *)btn
{
    
    if ([_delegate respondsToSelector:@selector(customerSheetSelect:)]) {
        [_delegate customerSheetSelect:btn.currentTitle];
    }
    
    [_dimBtn removeFromSuperview];
}

@end
