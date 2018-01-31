//
//  MyOrderDetailPayTypeCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MyOrderDetailPayTypeCell.h"

@implementation MyOrderDetailPayTypeCell
{
    UILabel *_orderIdLab;
    UILabel *_typeLab;
    UILabel *_numLab;
    UILabel *_creatTime;
    UILabel *_payTime;
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
    _orderIdLab = [LXTControl createLabelWithFrame:CGRectMake(15, 15, WIDTH-30, 15) Font:TLFontSize(13, 1) Text:nil];
    _orderIdLab.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_orderIdLab];
    
    _typeLab = [LXTControl createLabelWithFrame:CGRectMake(15, 40, WIDTH-30, 15) Font:TLFontSize(13, 1) Text:nil];
    _typeLab.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_typeLab];
    
    _numLab = [LXTControl createLabelWithFrame:CGRectMake(15, 65, WIDTH-30, 15) Font:TLFontSize(13, 1) Text:nil];
    _numLab.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_numLab];
    
    _creatTime = [LXTControl createLabelWithFrame:CGRectMake(15, 90, WIDTH-30, 15) Font:TLFontSize(13, 1) Text:nil];
    _creatTime.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_creatTime];
    
    _payTime = [LXTControl createLabelWithFrame:CGRectMake(15, 115, WIDTH-30, 15) Font:TLFontSize(13, 1) Text:nil];
    _payTime.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_payTime];
    _copyBtn =[LXTControl createButtonWithFrame:CGRectMake(WIDTH-15-50, _orderIdLab.frame.origin.y-3, 50, 20) ImageName:nil Target:self Action:@selector(myCopy:) Title:@"复制"];
    [_copyBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    _copyBtn.titleLabel.font = [UIFont systemFontOfSize:TLFontSize(13, 1)];
    _copyBtn.layer.masksToBounds=YES;
    _copyBtn.layer.cornerRadius = 2.5;
    _copyBtn.layer.borderWidth=0.5;
    _copyBtn.layer.borderColor=[UIColor colorWithHexString:@"#919191"].CGColor;
    [self.contentView addSubview:_copyBtn];
    
    
    _copyBtn1 =[LXTControl createButtonWithFrame:CGRectMake(WIDTH-15-50, _numLab.frame.origin.y-3, 50, 20) ImageName:nil Target:self Action:@selector(myCopy1:) Title:@"复制"];
    [_copyBtn1 setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    _copyBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
    _copyBtn1.layer.masksToBounds=YES;
    _copyBtn1.hidden = YES;
    _copyBtn1.layer.cornerRadius = 2.5;
    _copyBtn1.layer.borderWidth=0.5;
    _copyBtn1.layer.borderColor=[UIColor colorWithHexString:@"#919191"].CGColor;
    [self.contentView addSubview:_copyBtn1];
    
}

- (void)setModel:(MyOrderDetailModel *)model
{
    _model = model;
    if ([model.status isEqualToString:@"待付款"]) {
        
        _orderIdLab.hidden=NO;
        _typeLab.hidden=YES;
        _numLab.hidden =YES;
        _creatTime.hidden=NO;
        _payTime.hidden =YES;
        _copyBtn1.hidden=YES;
      _orderIdLab.text = [NSString stringWithFormat:@"订单编号：%@", _model.orderNumber];
     _creatTime.text = [NSString stringWithFormat:@"创建时间：%@", _model.createDate];
         _creatTime.frame=CGRectMake(15, 40, WIDTH-30, 15);
        _lastHeight = _creatTime.bottom+15;
    }else
    {
    if (model.tripleOrderNumber.length == 0) {
        model.tripleOrderNumber = @"";
    }
        _orderIdLab.hidden=NO;
        _typeLab.hidden=NO;
        _numLab.hidden =NO;
        _creatTime.hidden=NO;
        _payTime.hidden =NO;
    CGFloat nullNumber = 0;
    UILabel *templastLable = _orderIdLab;
    _orderIdLab.text = [NSString stringWithFormat:@"订单编号：%@", _model.orderNumber];
        if(_model.payType.length<1)
        {
            nullNumber++;
        }else
        {
            _typeLab.text = [NSString stringWithFormat:@"支付方式：%@", _model.payType];
            _typeLab.frame =CGRectMake(15, 40, WIDTH-30, 15);
            templastLable = _typeLab;
        }
        if(_model.tripleOrderNumber.length<1)
        {
            nullNumber++;
        }else
        {
            _numLab.text = [NSString stringWithFormat:@"交易流水号：%@", _model.tripleOrderNumber];
            _numLab.frame = CGRectMake(15, templastLable.bottom+10, WIDTH-30, 15);
            _copyBtn1.frame =CGRectMake(WIDTH-15-50, _numLab.frame.origin.y-3, 50, 20);
            _copyBtn1.hidden = NO;
            templastLable = _numLab;
        }
        if(_model.createDate.length<1)
        {
            nullNumber++;
        }else
        {
            _creatTime.text = [NSString stringWithFormat:@"创建时间：%@", _model.createDate];
            _creatTime.frame = CGRectMake(15, templastLable.bottom+10, WIDTH-30, 15);
            templastLable = _creatTime;
        }
        if(_model.payDate.length<1)
        {
            nullNumber++;
        }else
        {
            _payTime.text = [NSString stringWithFormat:@"支付时间：%@", _model.payDate];
            _payTime.frame = CGRectMake(15, templastLable.bottom+10, WIDTH-30, 15);
            templastLable = _payTime;
        }
        _lastHeight = templastLable.bottom+15;
    }
    
}


-(void)myCopy:(UIButton *)sender
{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * str = [NSString stringWithFormat:@"%@", _model.orderNumber];
    if ([NSString isBlankString:str]){
        pasteboard.string = str;
        [MBProgressHUD showSuccess:@"复制成功"];
    }
}


-(void)myCopy1:(UIButton *)sender
{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * str = [NSString stringWithFormat:@"%@", _model.tripleOrderNumber];
    if ([NSString isBlankString:str]){
        pasteboard.string = str;
        [MBProgressHUD showSuccess:@"复制成功"];
    }
}


@end
