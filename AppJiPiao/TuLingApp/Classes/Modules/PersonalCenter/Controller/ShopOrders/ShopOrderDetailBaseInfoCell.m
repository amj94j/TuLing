//
//  ShopOrderDetailBaseInfoCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/20.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ShopOrderDetailBaseInfoCell.h"

@implementation ShopOrderDetailBaseInfoCell
{
    UILabel *_orderNumLab;
    UILabel *_userNameLab;
    UILabel *_creatTimeLab;
    UILabel *_payTimeLab;
    UILabel *_payNumLab;
    
    UIButton *_retureBtn;
    
    UILabel *_endTimeLab;
    UIButton *_copyBtn;
    UIButton *_copyBtn1;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void) createSubviews
{
    // 订单编号
    _orderNumLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 20*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:15 Text:@"" LabTextColor:kColorFontBlack3];
    [self.contentView addSubview:_orderNumLab];
    
    // 买家名称
    _userNameLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 45*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:15 Text:@"" LabTextColor:kColorFontBlack3];
    [self.contentView addSubview:_userNameLab];
    
    // 下单时间
    _creatTimeLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 70*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:15 Text:@"" LabTextColor:kColorFontBlack3];
    [self.contentView addSubview:_creatTimeLab];
    
    // 付款时间
    _payTimeLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 95*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:15 Text:@"" LabTextColor:kColorFontBlack3];
    [self.contentView addSubview:_payTimeLab];
    
    // 交易流水号
    _payNumLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 120*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:15 Text:@"" LabTextColor:kColorFontBlack3];
    [self.contentView addSubview:_payNumLab];
    
    // 交易完成时间
    _endTimeLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 120*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:15 Text:@"" LabTextColor:kColorFontBlack3];
    [self.contentView addSubview:_endTimeLab];
    
    
    // 查看退款详情
    _retureBtn = [LXTControl createBtnWithFrame:CGRectMake(WIDTH/2-60*kWidthScale, 165*kHeightScale, 120*kWidthScale, 30*kHeightScale) titleName:@"查看退款详情" imgName:nil selImgName:nil target:self action:@selector(onReturnBtnClick:)];
    _retureBtn.titleLabel.font = kFontNol15;
    _retureBtn.layer.masksToBounds = YES;
    _retureBtn.layer.cornerRadius = 2.5;
    _retureBtn.layer.borderWidth = 0.5;
    _retureBtn.layer.borderColor = kColorAppRed.CGColor;
    [_retureBtn setTitleColor:kColorAppRed forState:UIControlStateNormal];
    [self.contentView addSubview:_retureBtn];
    
    
     _copyBtn =[LXTControl createButtonWithFrame:CGRectMake(WIDTH-15-50, _orderNumLab.frame.origin.y-3, 50, 20) ImageName:nil Target:self Action:@selector(myCopy:) Title:@"复制"];
    [_copyBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    _copyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _copyBtn.layer.masksToBounds=YES;
    _copyBtn.layer.cornerRadius = 2.5;
    _copyBtn.layer.borderWidth=0.5;
    _copyBtn.layer.borderColor=[UIColor colorWithHexString:@"#919191"].CGColor;
    [self.contentView addSubview:_copyBtn];
    
    
    _copyBtn1 =[LXTControl createButtonWithFrame:CGRectMake(WIDTH-15-50, _payNumLab.frame.origin.y-3, 50, 20) ImageName:nil Target:self Action:@selector(myCopy1:) Title:@"复制"];
    [_copyBtn1 setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    _copyBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
    _copyBtn1.layer.masksToBounds=YES;
    _copyBtn1.layer.cornerRadius = 2.5;
    _copyBtn1.layer.borderWidth=0.5;
    _copyBtn1.layer.borderColor=[UIColor colorWithHexString:@"#919191"].CGColor;
    [self.contentView addSubview:_copyBtn1];

}

- (void)setModel:(ShopOrderDetailModel *)model
{
    _model = model;
    
    NSString *orderNumStr = [NSString stringWithFormat:@"订单编号：%@", model.orderNumber];
    NSString *userNameStr = [NSString stringWithFormat:@"买家名称：%@", model.userName];
    NSString *creatTimeStr = [NSString stringWithFormat:@"下单时间：%@", model.createTime];
    NSString *payTimeStr = [NSString stringWithFormat:@"付款时间：%@", model.payTime];
    
    
    _retureBtn.hidden = !_model.isReturn;
    
    if (_model.statusId == 2 || _model.statusId == 3) { // 待发货
        _payTimeLab.hidden = NO;
        _payNumLab.hidden = NO;
        _retureBtn.hidden = NO;
       
        _copyBtn1.hidden=NO;
    } else {
        _payTimeLab.hidden = YES;
        _payNumLab.hidden = YES;
        _retureBtn.hidden = YES;
        _copyBtn1.hidden=YES;
    }
    
    
    NSMutableAttributedString *orderNumAttStr = [[NSMutableAttributedString alloc]initWithString:orderNumStr];
    NSRange orderNumRange = [orderNumStr rangeOfString:[NSString stringWithFormat:@"%@", _model.orderNumber]];
    [orderNumAttStr addAttribute:NSForegroundColorAttributeName value:kColorFontBlack1 range:orderNumRange];
    _orderNumLab.attributedText = orderNumAttStr;
    
    
    NSMutableAttributedString *userNameAttStr = [[NSMutableAttributedString alloc]initWithString:userNameStr];
    NSRange userNameRange = [userNameStr rangeOfString:[NSString stringWithFormat:@"%@", _model.userName]];
    [userNameAttStr addAttribute:NSForegroundColorAttributeName value:kColorFontBlack1 range:userNameRange];
    _userNameLab.attributedText = userNameAttStr;
    
    
    
    NSMutableAttributedString *creatTimeAttStr = [[NSMutableAttributedString alloc]initWithString:creatTimeStr];
    NSRange creatTimeRange = [creatTimeStr rangeOfString:[NSString stringWithFormat:@"%@", _model.createTime]];
    [creatTimeAttStr addAttribute:NSForegroundColorAttributeName value:kColorFontBlack1 range:creatTimeRange];
    _creatTimeLab.attributedText = creatTimeAttStr;
    
    
    
    NSMutableAttributedString *payTimeAttStr = [[NSMutableAttributedString alloc]initWithString:payTimeStr];
    NSRange payTimeRange = [payTimeStr rangeOfString:[NSString stringWithFormat:@"%@", _model.payTime]];
    [payTimeAttStr addAttribute:NSForegroundColorAttributeName value:kColorFontBlack1 range:payTimeRange];
    _payTimeLab.attributedText = payTimeAttStr;
    
    
    _payNumLab.text = [NSString stringWithFormat:@"交易流水号：%@", model.payNumber];
    
    
    if (_model.statusId == 4 || _model.statusId == 6) { //完成
        
        _payTimeLab.hidden = NO;
        _payNumLab.hidden = NO;
        _endTimeLab.hidden = NO;
        
        NSString *endTimeStr = [NSString stringWithFormat:@"交易完成时间：%@", model.endTime];
        
        NSMutableAttributedString *endTimeAttStr = [[NSMutableAttributedString alloc]initWithString:endTimeStr];
        NSRange endTimeRange = [endTimeStr rangeOfString:[NSString stringWithFormat:@"%@", _model.endTime]];
        [endTimeAttStr addAttribute:NSForegroundColorAttributeName value:kColorFontBlack1 range:endTimeRange];
        _endTimeLab.attributedText = endTimeAttStr;
        
        _payNumLab.frame = CGRectMake(15*kWidthScale, 145*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale);
        
    } else {
        
        _payNumLab.frame = CGRectMake(15*kWidthScale, 120*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale);
        _endTimeLab.hidden = YES;
    }
    
}

- (void) onReturnBtnClick:(UIButton *)sender
{
    if (self.returnBtnClick) {
        self.returnBtnClick();
    }
}


-(void)myCopy:(UIButton *)sender
{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@", _model.orderNumber];
    [MBProgressHUD showSuccess:@"复制成功"];
    
}

-(void)myCopy1:(UIButton *)sender
{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@", _model.payNumber];
    [MBProgressHUD showSuccess:@"复制成功"];
    
}
@end
