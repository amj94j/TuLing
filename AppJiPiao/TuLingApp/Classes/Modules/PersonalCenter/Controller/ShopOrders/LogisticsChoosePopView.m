//
//  LogisticsChoosePopView.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "LogisticsChoosePopView.h"


@implementation LogisticsChoosePopView
{
    LogisticsCompanyModel *_logModel;
    UIView *_bigBgView;
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

- (void) storyBoardPopViewWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    _bigBgView = [[UIView alloc]initWithFrame:frame];
    _bigBgView.backgroundColor = kColorLine;
    _bigBgView.layer.masksToBounds = YES;
    _bigBgView.layer.cornerRadius = 2.5;
    [self addSubview:_bigBgView];
    
    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc]init];
    recognizerTap.delegate = self;
    [_bigBgView addGestureRecognizer:recognizerTap];
    

    UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.backgroundColor = [UIColor whiteColor];
    [_bigBgView addSubview:picker];
    _logModel = dataSource[0];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self appear];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    if (_dataSource.count < 5) {
        return _dataSource.count;
//    } else
//        return 5;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LogisticsCompanyModel *model = _dataSource[row];
    return model.logisticsName;
}
// 哪一行被选中
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _logModel = _dataSource[row];
    
    if (self.logisClick) {
        self.logisClick(_logModel);
    }
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
