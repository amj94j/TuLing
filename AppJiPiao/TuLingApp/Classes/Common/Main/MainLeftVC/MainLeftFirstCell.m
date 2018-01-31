//
//  MainLeftFirstCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MainLeftFirstCell.h"

@implementation MainLeftFirstCell
{
    UILabel *_moneyLab;
    UILabel *_fenLab;
    UIButton *_yueBtn;
    UIButton *_jiFenBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createContentSubview];
    }
    return self;
}

- (void) createContentSubview
{
    _moneyLab = [LXTControl createLabelWithFrame:CGRectMake(0, 20*kHeightScale, kLeftVCWidth/2, 20*kHeightScale) Font:20 Text:@""];
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    _moneyLab.font = [UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:_moneyLab];
    
    
    _yueBtn = [LXTControl createBtnWithFrame:CGRectMake(0, 40*kHeightScale, kLeftVCWidth/2, 40*kHeightScale) titleName:nil imgName:nil selImgName:nil target:self action:@selector(onYuEBtnClick)];
    _yueBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_yueBtn];
    
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(kLeftVCWidth/2, 28*kHeightScale, 1*kWidthScale, 25*kHeightScale)];
    line.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.contentView addSubview:line];
    
    
    
    _fenLab = [LXTControl createLabelWithFrame:CGRectMake(kLeftVCWidth/2, 20*kHeightScale, kLeftVCWidth/2, 20*kHeightScale) Font:20 Text:@""];
    _fenLab.textAlignment = NSTextAlignmentCenter;
    _fenLab.font = [UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:_fenLab];
    
    
    _jiFenBtn = [LXTControl createBtnWithFrame:CGRectMake(kLeftVCWidth/2, 40*kHeightScale, kLeftVCWidth/2, 40*kHeightScale) titleName:nil imgName:nil selImgName:nil target:self action:@selector(onJiFenBtnClick)];
    _jiFenBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_jiFenBtn];
}

- (void)setIsBusiness:(BOOL)isBusiness
{
    _isBusiness = isBusiness;
    
//    if (!_isBusiness) { // 用户
//        _moneyLab.text = @"¥0.00";
//        _fenLab.text = @"0分";
//        
//        _yueBtn.userInteractionEnabled = YES;
//        _jiFenBtn.userInteractionEnabled = YES;
//        
//        
//        [_yueBtn setTitle:nil forState:UIControlStateNormal];
//        [_jiFenBtn setTitle:nil forState:UIControlStateNormal];
//        
//        
//        NSString *yueStr = @"余额(账户明细)";
//        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:yueStr];
//        NSRange yueRange1 = [yueStr rangeOfString:[NSString stringWithFormat:@"%@",@"余额"]];
//        NSRange yueRange2 = [yueStr rangeOfString:[NSString stringWithFormat:@"%@",@"(账户明细)"]];
//        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6A6A6A"] range:yueRange1];
//        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6DCB99"] range:yueRange2];
//        [_yueBtn setAttributedTitle:attStr forState:UIControlStateNormal];
//        
//        
//        
//        NSString *jiFenStr = @"积分(积分明细)";
//        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc]initWithString:jiFenStr];
//        NSRange jiFenRange1 = [jiFenStr rangeOfString:[NSString stringWithFormat:@"%@",@"积分"]];
//        NSRange jiFenRange2 = [jiFenStr rangeOfString:[NSString stringWithFormat:@"%@",@"(积分明细)"]];
//        [attStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6A6A6A"] range:jiFenRange1];
//        [attStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6DCB99"] range:jiFenRange2];
//        [_jiFenBtn setAttributedTitle:attStr1 forState:UIControlStateNormal];
//        
//    } else { // 商户
//        _moneyLab.text = @"¥0.00";
//        _fenLab.text = @"0";
//        
//        _yueBtn.userInteractionEnabled = NO;
//        _jiFenBtn.userInteractionEnabled = NO;
//        
//        [_yueBtn setAttributedTitle:nil forState:UIControlStateNormal];
//        [_jiFenBtn setAttributedTitle:nil forState:UIControlStateNormal];
//        
//        [_yueBtn setTitle:@"累计销售额" forState:UIControlStateNormal];
//        [_jiFenBtn setTitle:@"累计订单数" forState:UIControlStateNormal];
//    }
}

- (void)setModel:(MainUserInfoModel *)model
{
    _model = model;
    
    if (!model.score) {
        _model.score = 0.00f;
    }
    if (!model.balance) {
        _model.balance = 0;
    }
    
    _moneyLab.text = [NSString stringWithFormat:@"¥%0.2f", _model.balance];
    
    if (!_isBusiness) { // 用户
        
        NSString *scoreStr = [NSString stringWithFormat:@"%zd分", _model.score];
        NSMutableAttributedString *scoreAttStr = [[NSMutableAttributedString alloc]initWithString:scoreStr];
        NSRange range = [scoreStr rangeOfString:@"分"];
        [scoreAttStr addAttribute:NSForegroundColorAttributeName value:kColorFontBlack3 range:range];
        [scoreAttStr addAttribute:NSFontAttributeName value:kFontNol12 range:range];
        _fenLab.attributedText = scoreAttStr;
        
        
        _yueBtn.userInteractionEnabled = YES;
        _jiFenBtn.userInteractionEnabled = YES;
        
        
        [_yueBtn setTitle:nil forState:UIControlStateNormal];
        [_jiFenBtn setTitle:nil forState:UIControlStateNormal];
        
        
        NSString *yueStr = @"余额(账户明细)";
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:yueStr];
        NSRange yueRange1 = [yueStr rangeOfString:@"余额"];
        NSRange yueRange2 = [yueStr rangeOfString:@"(账户明细)"];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6A6A6A"] range:yueRange1];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6DCB99"] range:yueRange2];
        [_yueBtn setAttributedTitle:attStr forState:UIControlStateNormal];
        
        
        
        NSString *jiFenStr = @"积分(积分明细)";
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc]initWithString:jiFenStr];
        NSRange jiFenRange1 = [jiFenStr rangeOfString:[NSString stringWithFormat:@"%@",@"积分"]];
        NSRange jiFenRange2 = [jiFenStr rangeOfString:[NSString stringWithFormat:@"%@",@"(积分明细)"]];
        [attStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6A6A6A"] range:jiFenRange1];
        [attStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6DCB99"] range:jiFenRange2];
        [_jiFenBtn setAttributedTitle:attStr1 forState:UIControlStateNormal];
        
    } else { // 商户
        _fenLab.text = [NSString stringWithFormat:@"%zd", _model.messageNumber];
        
        _yueBtn.userInteractionEnabled = NO;
        _jiFenBtn.userInteractionEnabled = NO;
        
        [_yueBtn setAttributedTitle:nil forState:UIControlStateNormal];
        [_jiFenBtn setAttributedTitle:nil forState:UIControlStateNormal];
        
        [_yueBtn setTitle:@"累计销售额" forState:UIControlStateNormal];
        [_jiFenBtn setTitle:@"累计订单数" forState:UIControlStateNormal];
    }
}


// 余额
- (void) onYuEBtnClick
{
    if (self.yueClick) {
        self.yueClick();
    }
}

// 积分
- (void) onJiFenBtnClick
{
    if (self.jiFenClick) {
        self.jiFenClick();
    }
}

@end
