//
//  OnReturnHeaderCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/7.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "OnReturnHeaderCell.h"

@implementation OnReturnHeaderCell
{
    UILabel *_contentLab;
    UILabel *_firstLab;
    UILabel *_secondLab;
    
    UIButton *_repealBtn;
    UIButton *_checkLogisBtn;
    UIButton *_phoneNumBtn;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildSubviews];
    }
    return self;
}

- (void) buildSubviews
{
    _contentLab = [LXTControl createLabelWithFrame:CGRectMake(15, 20, WIDTH-30, 150) Font:17 Text:@""];
    _contentLab.numberOfLines = 0;
    _contentLab.textColor = [UIColor colorWithHexString:@"#434343"];
    [self.contentView addSubview:_contentLab];

    _firstLab = [LXTControl createLabelWithFrame:CGRectZero Font:17 Text:@""];
    _firstLab.textColor = [UIColor colorWithHexString:@"#434343"];
    [self.contentView addSubview:_firstLab];
    
    _secondLab = [[UILabel alloc]initWithFrame:CGRectZero];
    _secondLab.textColor = [UIColor colorWithHexString:@"#434343"];
    _secondLab.numberOfLines = 0;
    [self.contentView addSubview:_secondLab];
    
    
    _repealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _repealBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _repealBtn.layer.masksToBounds = YES;
    _repealBtn.layer.cornerRadius = 3;
    _repealBtn.backgroundColor = [UIColor colorWithHexString:@"#F9516A"];
    [_repealBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_repealBtn addTarget:self action:@selector(onRepealBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_repealBtn];
    
    
    _checkLogisBtn = [LXTControl createButtonWithFrame:CGRectZero ImageName:nil Target:self Action:@selector(onCheckLogisBtnClick:) Title:@""];
    [_checkLogisBtn setTitleColor:[UIColor colorWithHexString:@"#6DCB99"] forState:UIControlStateNormal];
    [self.contentView addSubview:_checkLogisBtn];
    
    
    _phoneNumBtn = [LXTControl createButtonWithFrame:CGRectZero ImageName:nil Target:self Action:@selector(onPhoneNumBtnCLick:) Title:@""];
    [_phoneNumBtn setTitleColor:[UIColor colorWithHexString:@"#6DCB99"] forState:UIControlStateNormal];
    _phoneNumBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:_phoneNumBtn];
}

- (void)setModel:(ReturnDetailModel *)model
{
    _model = model;
//    if (model == nil) {
//        model = [[ReturnDetailModel alloc]init];
//        model.orderReturnType = 6;
//    }
    
    if (model.orderReturnType == 1 || model.orderReturnType == 3 || model.orderReturnType == 2) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.returnDateEnd/1000];
        NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:model.nowDate/1000];
        NSTimeInterval time = [date timeIntervalSinceDate:nowDate];
        //NSInteger time= model.returnDateEnd-model.returnDateStart;
        
        int value = abs((int)time);
        int minute = value / 60 % 60;// 分
        int house = value / 3600 % 24; // 时
        int day = value / (24 * 3600); // 天
        
        if (model.orderReturnType == 1) { // 待商家处理退款申请

            if (model.isReceipt != 2) {
                _contentLab.text = [onReturnStr2 stringByAppendingFormat:@"\n如果商家未处理：商家还剩下%02d天%02d时%02d分处理退款申请,如果逾期未处理,系统将自动返回给买家", day, house, minute];
            } else {
                _contentLab.text = [onReturnStr1 stringByAppendingFormat:@"\n如果商家未处理：超过%02d天%02d时%02d分钟系统发送商家的默认退货地址给买家", day, house, minute];
            }

//            if ([model.title isEqualToString:@"退款"]) {
//                _contentLab.text = [onReturnStr3 stringByAppendingFormat:@"\n如果商家未处理：超过%02d天%02d时%02d分钟系统发送商家的默认退货地址给买家", day, house, minute];
//            } else {
//                _contentLab.text = [onReturnStr1 stringByAppendingFormat:@"\n如果商家未处理：超过%02d天%02d时%02d分钟系统发送商家的默认退货地址给买家", day, house, minute];
//            }
            

            _firstLab.text = [NSString stringWithFormat:@"您还可以"];
            [_repealBtn setTitle:model.button[@"buttonName"] forState:UIControlStateNormal];
        } else if (model.orderReturnType == 2) {
            _contentLab.text = [NSString stringWithFormat:@"请在%02d天%02d时内寄回退款，并填入运单号码\n如未按时操作，将退款关闭",day, house];
            _secondLab.text = [NSString stringWithFormat:@"退款地址：%@",model.returnAddress];
        } else if (model.orderReturnType == 3) { // 待商家验货并同意退款
            _contentLab.text = [onReturnStr3 stringByAppendingFormat:@"\n如果商家未处理：超过%02d天%02d时%02d分钟系统默认进入等待平台退款", day, house, minute];
            _firstLab.text = [NSString stringWithFormat:@"物流公司：%@", model.shipperName];
            _secondLab.text = [NSString stringWithFormat:@"物流单号：%@", model.shipperCode];
            [_checkLogisBtn setTitle:model.button[@"buttonName"] forState:UIControlStateNormal];
        }
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_contentLab.text];
        NSRange range1 = [_contentLab.text rangeOfString:[NSString stringWithFormat:@"%02d",day]];
        NSRange range2 = [_contentLab.text rangeOfString:[NSString stringWithFormat:@"%02d",house]];
        NSRange range3 = [_contentLab.text rangeOfString:[NSString stringWithFormat:@"%02d",minute]];
        
        
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F9516A"] range:range1];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F9516A"] range:range2];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F9516A"] range:range3];
        
        // 调整行间距
        //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //    [paragraphStyle setLineSpacing:6];
        //    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_contentLab.text length])];
        
        _contentLab.attributedText = attStr;
        //    [_contentLab sizeToFit];
        
    } else {
        
        if (model.orderReturnType == 4) {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.returnDateEnd/1000];
//            NSString *dateStr = [formatter stringFromDate:date];
//            _contentLab.text = [NSString stringWithFormat:@"平台会在%@前将退款返到您的支付宝中，请您耐心等待", model.showDate];
            _contentLab.text = @"平台会在3日内（遇节假日会有延迟）将退款返还至原支付渠道，请耐心等待";
            
            _secondLab.text = @"如有任何问题请联系";
            [_phoneNumBtn setTitle:model.sysPhone forState:UIControlStateNormal];
        } else if (model.orderReturnType == 6) {
            _contentLab.text = @"如果不同意商家观点请联系平台进行维权";
            [_phoneNumBtn setTitle:model.sysPhone forState:UIControlStateNormal];
        }
    }
    
    CGSize size = [_contentLab.text sizeWithFont:17 andMaxSize:CGSizeMake(WIDTH-30, 500)];
    CGSize secondLabSize = [_secondLab.text sizeWithFont:17 andMaxSize:CGSizeMake(WIDTH-30, 500)];

    
    _contentLab.frame = CGRectMake(15, 20, WIDTH-30, size.height);
    CGFloat contentMaxY = CGRectGetMaxY(_contentLab.frame);
    
    if (model.orderReturnType == 1) {
        _firstLab.hidden = NO;
        _repealBtn.hidden = NO;
        _secondLab.hidden = YES;
        _checkLogisBtn.hidden = YES;
        _phoneNumBtn.hidden = YES;
        
        _firstLab.frame = CGRectMake(15, contentMaxY+30, 80, 30);
        _repealBtn.frame = CGRectMake(110, contentMaxY+30, 100, 30);
        
        
    } else if (model.orderReturnType == 2) {
        _firstLab.hidden = YES;
        _repealBtn.hidden = YES;
        _checkLogisBtn.hidden = YES;
        _phoneNumBtn.hidden = YES;
        _secondLab.hidden = NO;
        
        _secondLab.frame = CGRectMake(15, contentMaxY+45, secondLabSize.width, secondLabSize.height);
        
    } else if (model.orderReturnType == 3) {
        _firstLab.hidden = NO;
        _secondLab.hidden = NO;
        _checkLogisBtn.hidden = NO;
        _repealBtn.hidden = YES;
        _phoneNumBtn.hidden = YES;
        
        _firstLab.frame = CGRectMake(15, contentMaxY+30, WIDTH-30, 20);
        _secondLab.frame = CGRectMake(15, contentMaxY+60, secondLabSize.width, 20);
        _checkLogisBtn.frame = CGRectMake(15+secondLabSize.width, contentMaxY+60, 80, 20);
    } else if (model.orderReturnType == 4) {
        
        _firstLab.hidden = YES;
        _repealBtn.hidden = YES;
        _checkLogisBtn.hidden = YES;
        _secondLab.hidden = NO;
        _phoneNumBtn.hidden = NO;
        
        _secondLab.frame = CGRectMake(15, contentMaxY+20, WIDTH-30, 20);
        _phoneNumBtn.frame = CGRectMake(15+secondLabSize.width, contentMaxY+20, 150, 20);
    } else if (model.orderReturnType == 6) {
        _firstLab.hidden = YES;
        _repealBtn.hidden = YES;
        _checkLogisBtn.hidden = YES;
        _secondLab.hidden = YES;
        _phoneNumBtn.hidden = NO;
        
        _phoneNumBtn.frame = CGRectMake(15, contentMaxY+10, 150, 30);
    }
    
}

- (void) onRepealBtnClick:(UIButton *) sender
{
    if (self.repealBtnCLick) {
        self.repealBtnCLick();
    }
}

- (void) onCheckLogisBtnClick:(UIButton *) sender
{
    if (self.checkLogisBtnClick) {
        self.checkLogisBtnClick();
    }
}

- (void) onPhoneNumBtnCLick:(UIButton *) sender
{
    if (self.phoneNumBtnClick) {
        self.phoneNumBtnClick();
    }
}

@end
