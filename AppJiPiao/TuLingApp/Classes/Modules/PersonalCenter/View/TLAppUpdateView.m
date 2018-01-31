//
//  TLAppUpdateView.m
//  TuLingApp
//
//  Created by 李立达 on 2017/7/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLAppUpdateView.h"

@interface TLAppUpdateView ()
@property(strong,nonatomic)UIView      *backView;
@property(strong,nonatomic)UIImageView *updateImageView;
@property(strong,nonatomic)UIImageView *backImageView;
@property(strong,nonatomic)UIImageView *buttonImageView;
@property(strong,nonatomic)UIButton    *updateButton;
@property(strong,nonatomic)UIButton    *closeButton;
@property(strong,nonatomic)UILabel    *ignoreLabel;
@end

#define PhoneHEIGHT [UIScreen mainScreen].bounds.size.height/667
#define PhoneWIDTH  [UIScreen mainScreen].bounds.size.width/375

@implementation TLAppUpdateView


-(instancetype)init
{
    return [self initwithType:UpdateStatusAuto];
}



-(instancetype)initwithType:(UpdateStatus)type
{
    if(self == [super init])
    {
        _type = type;
        self.frame = CGRectMake(0, 0, mainScreenWidth, mainScreenHeight);
        [self setupView];
    }
    return self;
}


-(void)setupView
{
    //背景蒙层
    self.backView = [[UIView alloc]init];
    self.backView.bounds = CGRectMake(0, 0, mainScreenWidth, mainScreenHeight);
    self.backView.center = CGPointMake(mainScreenWidth/2, mainScreenHeight/2);
    if(self.type == 0){
        [self.backView addTapGestureWithTarget:self action:@selector(hiddenView)];
    }
    [self addSubview:self.backView];
    
    //背景花纹图
    self.backImageView = [[UIImageView alloc]init];
    self.backImageView.center = CGPointMake(mainScreenWidth/2, mainScreenHeight/2);
    UIImage *backImage = [UIImage imageNamed:@"updateflow"];
    self.backImageView.image = backImage;
    self.backImageView.bounds = CGRectMake(0, 0, backImage.size.width*PhoneWIDTH, backImage.size.height*PhoneHEIGHT);
    [self addSubview:self.backImageView];
    //背景图
    self.updateImageView =[[UIImageView alloc]init];
    UIImage *updateImage = [UIImage imageNamed:@"updateBackImage"];
    self.updateImageView.image = updateImage;
    self.updateImageView.userInteractionEnabled = YES;
    self.updateImageView.bounds = CGRectMake(0, 0, updateImage.size.width*PhoneWIDTH, updateImage.size.height*PhoneHEIGHT);
    self.updateImageView.center = CGPointMake(mainScreenWidth/2, mainScreenHeight/2);
    [self addSubview:self.updateImageView];
    //关闭按钮
    self.closeButton= [[UIButton alloc]init];
    self.closeButton.bounds = CGRectMake(0, 0, self.buttonImageView.width/2, 46);
    self.closeButton.adjustsImageWhenHighlighted = NO;
    [self.closeButton addTarget:self action:@selector(closebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setTitleColor:[UIColor colorWithHexString:@"#BD965c"] forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:17];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"updateClose"] forState:UIControlStateNormal];
    [self.closeButton sizeToFit];
    self.closeButton.center = CGPointMake(self.backView.width/2,self.updateImageView.bottom+18+self.closeButton.height/2);
    [self addSubview:self.closeButton];
    //立即更新按钮
    self.updateButton= [[UIButton alloc]init];
    self.updateButton.adjustsImageWhenHighlighted = NO;
    self.updateButton.bounds = CGRectMake(0, 0, 122*PhoneWIDTH, 31*PhoneHEIGHT);
    [self.updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
    [self.updateButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.updateButton addTarget:self action:@selector(updatebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.updateButton.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:14];
    [self.updateButton setBackgroundColor:[UIColor colorWithHexString:@"A98D63"]];
    self.updateButton.center = CGPointMake(self.backView.width/2, mainScreenHeight/2+35+self.updateButton.height/2);
    [self addSubview:self.updateButton];
    
    
//    self.ignoreLabel = [[UILabel alloc] init];
//    self.ignoreLabel.textColor = [UIColor colorWithHexString:@"#434343"];
//    [self.ignoreLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13]];
//    [self.ignoreLabel addTapGestureWithTarget:self action:@selector(hiddenView)];
//    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"关闭更新"]];
//    NSRange contentRange = {0,[content length]};
//    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
//    self.ignoreLabel.attributedText = content;
//    [self.ignoreLabel sizeToFit];
//    self.ignoreLabel.center = CGPointMake(self.backView.width/2, self.updateButton.bottom+17+self.ignoreLabel.height/2);
//    [self addSubview:self.ignoreLabel];
    
    if(self.type == 1)
    {
        self.closeButton.hidden = YES;
    }else
    {
        self.closeButton.hidden = NO;
    }
    
}

-(void)updatebuttonClick:(UIButton *)sender
{
    if(self.updateButtonBlock)
    {
        self.updateButtonBlock();
    }
}

-(void)closebuttonClick:(UIButton *)sender
{
    if(self.closeButtonBlock)
    {
        self.closeButtonBlock();
    }
    [self hiddenView];
}

-(void)showView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
}


-(void)hiddenView
{
    [UIView animateWithDuration:0.1f animations:^{
        [self.layer setOpacity:0.0f];
    }                completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end


