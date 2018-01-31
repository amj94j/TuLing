//
//  ProductListAlertView.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ProductListAlertView.h"
#import "UIColor+ColorChange.h"
#import "NSString+StrCGSize.h"

@implementation ProductListAlertView
{
    UIView *_bigBgView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.0);
        
        //毛玻璃效果（高斯模糊）
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.frame = self.bounds;
        [self addSubview:visualEffectView];
        
        
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

- (void) storyBoardPopViewWithContent:(NSString *)content
{
    CGFloat viewWidth = 280*kWidthScale;
    CGFloat viewHeight = 150*kHeightScale;
    CGFloat labHeight = 94*kHeightScale;
    CGFloat btnHeight = 56*kHeightScale;
    
    _bigBgView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2-viewWidth/2, HEIGHT/2-viewHeight/2, viewWidth, viewHeight)];
    _bigBgView.backgroundColor = [UIColor whiteColor];
    _bigBgView.layer.masksToBounds = YES;
    _bigBgView.layer.cornerRadius = 2.5;
    [self addSubview:_bigBgView];
    
    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc]init];
    recognizerTap.delegate = self;
    [_bigBgView addGestureRecognizer:recognizerTap];
    

    UILabel *nameLabel = [createControl labelWithFrame:CGRectMake(0, 0, viewWidth, labHeight) Font:15 Text:content LabTextColor:kColorFontBlack2];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.numberOfLines = 0;
    [_bigBgView addSubview:nameLabel];
    
    
    
    UIButton *closeBtn = [LXTControl createBtnWithFrame:CGRectMake(0, labHeight, viewWidth/2, btnHeight) titleName:@"取消" imgName:nil selImgName:nil target:self action:@selector(onCancelBtnClick)];
    [closeBtn setTitleColor:kColorFontBlack2 forState:UIControlStateNormal];
    [_bigBgView addSubview:closeBtn];
    
    
    
    UIButton *continueBtn = [LXTControl createBtnWithFrame:CGRectMake(viewWidth/2, labHeight, viewWidth/2, btnHeight) titleName:@"确认" imgName:nil selImgName:nil target:self action:@selector(onSureBtnClick)];
    [continueBtn setTitleColor:kColorAppGreen forState:UIControlStateNormal];
    [_bigBgView addSubview:continueBtn];

    
    
    UILabel *line1 = [createControl createLineWithFrame:CGRectMake(0, labHeight, viewWidth, 0.5*kHeightScale) labelLineColor:kColorLine];
    [_bigBgView addSubview:line1];
    
    UILabel *line2 = [createControl createLineWithFrame:CGRectMake(viewWidth / 2.0 - 0.25, labHeight, 0.5*kHeightScale, viewWidth) labelLineColor:kColorLine];
    [_bigBgView addSubview:line2];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self appear];
}

/**
 取消
 */
- (void) onCancelBtnClick
{
    [self disAppear];
}

/**
 确认
 */
- (void) onSureBtnClick
{
    if (self.continueBtn) {
        self.continueBtn();
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
