//
//  ShopOrderDetailCancelView.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/20.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ShopOrderDetailCancelView.h"
#import "UIColor+ColorChange.h"
#import "NSString+StrCGSize.h"


@implementation ShopOrderDetailCancelView
{
    NSString *_reasonStr;
    UIView *_bigBgView;
    NSArray *_reasonDatas;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = kColorClear;
        
        
        UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBeginHind:)];
        [recognizerTap setNumberOfTapsRequired:1];
        recognizerTap.cancelsTouchesInView = NO;
        recognizerTap.delegate = self;
        [self addGestureRecognizer:recognizerTap];
        
    }
    return self;
}

//让界面消失
- (void) disAppear
{
    [UIView animateWithDuration:0.1f animations:^{
        [self.layer setOpacity:0.0f];
    }                completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//让界面出现
- (void) appear
{
    [UIView animateWithDuration:0.1f animations:^{
        [self.layer setOpacity:1.0f];
    }                completion:^(BOOL finished) {
        
    }];
}

- (void) storyBoardPopViewWithReasonDataSource:(NSArray *)reasonDatas
{
    _reasonDatas = reasonDatas;
    
    _bigBgView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-250, WIDTH, 250)];
    _bigBgView.backgroundColor = kColorLine;
    _bigBgView.layer.masksToBounds = YES;
    _bigBgView.layer.cornerRadius = 2.5;
    [self addSubview:_bigBgView];
    
    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc]init];
    recognizerTap.delegate = self;
    [_bigBgView addGestureRecognizer:recognizerTap];
    
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(WIDTH-60, 0, 60, 30);
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [finishBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(onCancelFinishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bigBgView addSubview:finishBtn];
    
    
    UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, WIDTH, 220)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.backgroundColor = [UIColor whiteColor];
    [_bigBgView addSubview:picker];
    CancelOrderReasonModel *model = reasonDatas[0];
    _reasonStr = model.dicName;
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self appear];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_reasonDatas.count < 5) {
        return _reasonDatas.count;
    } else
        return 5;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CancelOrderReasonModel *model = _reasonDatas[row];
    return model.dicName;
}
// 哪一行被选中
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CancelOrderReasonModel *model = _reasonDatas[row];
    _reasonStr = model.dicName;
}


/**
 确认
 */
- (void) onCancelFinishBtnClick:(UIButton *)sender
{
    if (self.cancelFinish) {
        self.cancelFinish(_reasonStr);
    }
    [self disAppear];
}


#pragma mark--UIGestureRecognizerDelegate的代理方法,将子视图的tap手势屏蔽
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_bigBgView]) {
        return NO;
    }
    return YES;
}

- (void)tapBeginHind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self disAppear];
    }
}

@end
