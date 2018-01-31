//
//  TLMyOrderRemainEvaluateCell.m
//  TuLingApp
//
//  Created by gyc on 2017/7/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLMyOrderRemainEvaluateCell.h"
#import <Masonry.h>


@interface TLMyOrderRemainEvaluateCell ()

@end

@implementation TLMyOrderRemainEvaluateCell
{
    UIImageView *_imgView;
    UILabel *_title;
    
    UILabel *_pirce;
    UILabel *_number;
    UILabel * _shareMoneyLabel;
    
    UIView * _shareMoneyView;

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

    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 150, 85)];
    [self.contentView addSubview:_imgView];
    
    CGFloat imgMaxX = CGRectGetMaxX(_imgView.frame);
    _title = [LXTControl createLabelWithFrame:CGRectMake(imgMaxX+10, 17, WIDTH-imgMaxX, 30) Font:15 Text:nil];
    _title.textColor = [UIColor colorWithHexString:@"#434343"];
    _title.lineBreakMode = NSLineBreakByTruncatingTail;
    _title.numberOfLines = 1;
    [self.contentView addSubview:_title];
    
    
   
    
    CGFloat titleMaxY = CGRectGetMaxY(_title.frame);
   
    
    _pirce = [LXTControl createLabelWithFrame:CGRectMake(imgMaxX+10, titleMaxY+5, WIDTH-imgMaxX, 20) Font:14 Text:nil];
    _pirce.numberOfLines = 1;
    _pirce.textColor = [UIColor colorWithHexString:@"#939393"];
    [self.contentView addSubview:_pirce];
    [_pirce mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_imgView.mas_right).offset(10);
        make.top.equalTo(_title.mas_bottom).offset(5);
        make.height.greaterThanOrEqualTo(@(20));
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    _number = [LXTControl createLabelWithFrame:CGRectMake(WIDTH-100, _title.frame.origin.y, 85, 20) Font:13 Text:nil];
    _number.textAlignment = NSTextAlignmentRight;
    _number.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_number];
    
    [_number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(18));
        make.right.equalTo(self.contentView).offset(-15);
        make.width.greaterThanOrEqualTo(@0);
        make.top.equalTo(self.contentView).offset(17);
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(imgMaxX+10);
        make.top.equalTo(self.contentView).offset(17);
        make.right.equalTo(_number.mas_left).offset(-15);
        make.height.greaterThanOrEqualTo(@(0));
    }];
    
    _shareMoneyView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgView.frame), CGRectGetMaxY(_imgView.frame ) - 29, 50, 29)];
    [self.contentView addSubview:_shareMoneyView];

    _shareMoneyView.layer.cornerRadius = 2.5;
    _shareMoneyView.layer.masksToBounds = YES;
    _shareMoneyView.layer.borderColor = [UIColor colorWithHexString:@"#c1c1c1"].CGColor;
    _shareMoneyView.layer.borderWidth = 0.5;
    _shareMoneyView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap  = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(sharePriceViewEvent:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [_shareMoneyView addGestureRecognizer:tap];
    
    
    
    
    [_shareMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@29);
        make.left.equalTo(_imgView.mas_right).offset(10);
        make.bottom.equalTo(_imgView);
        make.width.greaterThanOrEqualTo(@0);
    }];
    
    _shareMoneyLabel = [[UILabel alloc] init];
    _shareMoneyLabel.textAlignment = NSTextAlignmentLeft;
    _shareMoneyLabel.font = [UIFont systemFontOfSize:14];
    _shareMoneyLabel.textColor = [UIColor colorWithHexString:@"#ff5939"];
    [_shareMoneyView addSubview:_shareMoneyLabel];
    _shareMoneyLabel.userInteractionEnabled = YES;
    UILabel * zuidiLabel  =  [[UILabel alloc] init];
    zuidiLabel.textAlignment = NSTextAlignmentLeft;
    zuidiLabel.font = [UIFont systemFontOfSize:13];
    zuidiLabel.textColor = [UIColor colorWithHexString:@"#838383"];
    [_shareMoneyView addSubview:zuidiLabel];
    zuidiLabel.text = @"(最低)";
    zuidiLabel.userInteractionEnabled = YES;
    UILabel * fenxiangLabel = [[UILabel alloc] init];
    fenxiangLabel.textAlignment = NSTextAlignmentLeft;
    fenxiangLabel.font = [UIFont systemFontOfSize:14];
    fenxiangLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    [_shareMoneyView addSubview:fenxiangLabel];
    fenxiangLabel.text = @"分享赚";
    fenxiangLabel.userInteractionEnabled = YES;
    
    UILabel * line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#a1a1a1"];
    [_shareMoneyView addSubview:line];
    line.userInteractionEnabled = YES;
    [fenxiangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@46);
        make.height.equalTo(@20);
        make.centerY.equalTo(_shareMoneyView);
        make.right.equalTo(_shareMoneyView).offset(-5);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.5);
        make.height.equalTo(@19);
        make.centerY.equalTo(_shareMoneyView);
        make.right.equalTo(fenxiangLabel.mas_left).offset(-5);
    }];
    
    [zuidiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@18);
        make.centerY.equalTo(fenxiangLabel);
        make.right.equalTo(line.mas_left).offset(-5);
    }];

    [_shareMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@18);
        make.centerY.equalTo(_shareMoneyView);
        make.right.equalTo(zuidiLabel.mas_left).offset(-5);
        make.left.equalTo(_shareMoneyView).offset(5);
    }];
}

-(void)sharePriceViewEvent:(UIGestureRecognizer*)tap{

    if (self.eventBlock){
        self.eventBlock();
    }
}

-(void)cellSharePriceEvent:(TLMyOrderRemainEvaluateCellEventBlock)block{
    self.eventBlock = block;
}

- (void)setModel:(OrderFormProductsModel *)model
{
    _model = model;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.headImage] placeholderImage:[UIImage imageNamed:@""]];
    
    if (model.expect){
        NSString * string = nil;
        string = [NSString stringWithFormat:@"【预售】%@",_model.productName];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:string];
        NSRange range = [string rangeOfString:@"【预售】"];
        
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5c36"] range:range];
        _title.attributedText = attStr;
    }else{
        _title.text = _model.productName;
    }
   
    NSString * monStr = [NSString stringWithFormat:@"¥%0.2f", _model.price];
    NSString * spaStr = [NSString stringWithFormat:@"规格：%@",_model.specName];
    NSString * str = @"";
    if ([NSString isBlankString:monStr]){
    
        if ([NSString isBlankString:spaStr]){
            str = [NSString stringWithFormat:@"%@ /%@",monStr,spaStr];
        }else{
            str = monStr;
        }
        
    }else{
        if ([NSString isBlankString:spaStr]){
            str = spaStr;
        }
    }
    
    _pirce.text = str;
    _number.text = [NSString stringWithFormat:@"x%@",@(_model.buyCount)];
    if ([NSString isBlankString:model.shareCost]){
        _shareMoneyView.hidden = NO;
        _shareMoneyLabel.text = model.shareCost;
    }else{
        _shareMoneyView.hidden = YES;
        _shareMoneyLabel.text = @"";
    }
}
@end
