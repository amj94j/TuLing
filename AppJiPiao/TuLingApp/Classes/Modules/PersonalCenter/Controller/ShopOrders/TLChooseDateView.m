//
//  TLChooseDateView.m
//  TuLingApp
//
//  Created by gyc on 2017/5/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <Masonry.h>
#import "TLChooseDateView.h"

#define kAlpha 0.5

@interface TLChooseDateView ()
@property (nonatomic,copy) ChooseDateFinishBlock finishBlock;
@property (nonatomic,strong)NSDate * startDate;
@property (nonatomic,strong)NSDate * endDate;
@property (nonatomic,strong) UIView * viewBack;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic,strong) NSDate * selectDate;
@end

@implementation TLChooseDateView

-(instancetype)initWithRootView:(UIView *)rootView start:(NSDate *)startDate end:(NSDate *)endDate{
    self = [super initWithFrame:CGRectMake(0, 0,CGRectGetWidth(rootView.frame), CGRectGetHeight(rootView.frame))];
    if (self){
        
        [self viewUISet:rootView];
    }
    
    return  self;
}

-(void)viewUISet:(UIView*)rootView{
    
    [rootView addSubview:self];
    
    _viewBack = [[UIView alloc] initWithFrame:self.bounds];
    
    _viewBack.backgroundColor = [UIColor blackColor];
    _viewBack.alpha = 0;
    [self addSubview:_viewBack];
    [_viewBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseViewHide)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_viewBack addGestureRecognizer:tap];
    
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.frame.size.height + 40, self.frame.size.width, 180)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    [_datePicker addTarget:self action:@selector(onDateChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_datePicker];
    
    if (_startDate){
        [_datePicker setMinimumDate:_startDate];
    }
    
    if (_endDate){
        [_datePicker setMaximumDate:_endDate];
    }
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, self.bounds.size.width, 1/ [UIScreen mainScreen].scale)];
    line.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [backView addSubview:line];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(5, 5, 100, 30);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(chooseViewHide) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(self.bounds.size.width - 5 - 100, 5, 100, 30);
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"919191"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"919191"] forState:UIControlStateNormal];
    
    [backView addSubview:cancelButton];
    [backView addSubview:confirmButton];
    
    [self addSubview:backView];
    
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(180);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_datePicker.mas_left);
        make.right.equalTo(_datePicker.mas_right);
        make.height.equalTo(@(40));
        make.bottom.equalTo(_datePicker.mas_top).offset(0);
    }];
}

- (void) onDateChange:(UIDatePicker *)sender
{
    NSDate *date = sender.date;
    
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"yyyy年 MM月 dd号"];
    //    NSString *dateStr = [formatter stringFromDate:date];
    //    DLog(@"%@", dateStr);
    
    self.selectDate = date;
}


-(void)finishChooseDate:(ChooseDateFinishBlock)block{
    self.finishBlock = block;
}

-(void)confirmButtonClick:(UIButton*)sender{
    
    if (self.finishBlock){
        if (_selectDate){
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy年 MM月 dd号"];
            NSString *dateStr = [formatter stringFromDate:_selectDate];
            self.finishBlock(self.selectDate,dateStr);
        }else{
            self.finishBlock(nil, nil);
        }
    }
    [self chooseViewHide];
}

-(void)showView{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        weakSelf.viewBack.alpha = kAlpha;
        [weakSelf.datePicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
        }];
        [weakSelf updateConstraints];
        [weakSelf.superview layoutIfNeeded];
    } completion:nil];
    
}

-(void)chooseViewHide{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        weakSelf.viewBack.alpha = 0;
        [weakSelf.datePicker mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(240);
        }];
        [weakSelf updateConstraints];
        [weakSelf.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}


@end
