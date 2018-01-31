//
//  ReturnDetailFootCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/7.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ReturnDetailFootCell.h"

@implementation ReturnDetailFootCell
{
    UILabel *_priceLab;
    UILabel *_reasonLab;
//    UILabel *_contentLab;
    UILabel *_numberLab;
    UILabel *_dateLab;
    UIButton *_copyBtn;
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
    _priceLab = [LXTControl createLabelWithFrame:CGRectMake(15, 20, WIDTH-30, 20) Font:17 Text:@""];
    _priceLab.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_priceLab];
    
    _reasonLab = [LXTControl createLabelWithFrame:CGRectMake(15, 45, WIDTH-30, 20) Font:17 Text:@""];
    _reasonLab.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_reasonLab];
    
//    _contentLab = [LXTControl createLabelWithFrame:CGRectMake(15, 70, WIDTH-30, 20) Font:17 Text:@""];
//    _contentLab.textColor = [UIColor colorWithHexString:@"#919191"];
//    [self.contentView addSubview:_contentLab];
    
    
    _numberLab = [LXTControl createLabelWithFrame:CGRectMake(15, 70, WIDTH-30, 20) Font:17 Text:@""];
    _numberLab.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_numberLab];
    
    
    _dateLab = [LXTControl createLabelWithFrame:CGRectMake(15, 95, WIDTH-30, 20) Font:17 Text:@""];
    _dateLab.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_dateLab];
    
    _copyBtn =[LXTControl createButtonWithFrame:CGRectMake(WIDTH-15-50, _numberLab.frame.origin.y-3, 50, 20) ImageName:nil Target:self Action:@selector(myCopy:) Title:@"复制"];
    [_copyBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    _copyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _copyBtn.layer.masksToBounds=YES;
    _copyBtn.layer.cornerRadius = 2.5;
    _copyBtn.layer.borderWidth=0.5;
    _copyBtn.layer.borderColor=[UIColor colorWithHexString:@"#919191"].CGColor;
    [self.contentView addSubview:_copyBtn];
    
}

- (void)setModel:(ReturnDetailModel *)model
{
    _model = model;
    
    _priceLab.text = [NSString stringWithFormat:@"退款金额：¥%0.2f", model.returnTotle];
    _reasonLab.text = [NSString stringWithFormat:@"退款原因：%@", model.returnMessage];
//    _contentLab.text = [NSString stringWithFormat:@"退款说明：%@", model.returnContent];
    _numberLab.text = [NSString stringWithFormat:@"退款编号：%@", model.returnNumber];
    _dateLab.text = [NSString stringWithFormat:@"申请时间：%@", model.createDate];
}

-(void)myCopy:(UIButton *)sender
{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@", _model.returnNumber];
    [MBProgressHUD showSuccess:@"复制成功"];
    
}
@end
