//
//  MyOrderProductTableViewCell.m
//  TuLingApp
//
//  Created by 李立达 on 2017/7/26.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MyOrderProductTableViewCell.h"
#import <Masonry.h>

@interface MyOrderProductTableViewCell ()
@property (strong,nonatomic)UIImageView *protuctImage;
@property (strong,nonatomic)UILabel     *protuctTitle;
@property (strong,nonatomic)UILabel     *proctucCount;
@property (strong,nonatomic)UILabel     *pricetLabel;
@property (strong,nonatomic)UIView      *backView;
@property (strong,nonatomic)UILabel     *tempLable;
@property (strong,nonatomic)UILabel     *moneyLable;
@property (strong,nonatomic)UIView      *line;
@end

@implementation MyOrderProductTableViewCell

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
    self.protuctImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.protuctImage];
    
    self.proctucCount = [[UILabel alloc]init];
    self.proctucCount.font = [UIFont fontWithName:FONT_REGULAR size:13];
    self.proctucCount.textColor =[UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:self.proctucCount];
    self.protuctTitle = [[UILabel alloc]init];
    self.protuctTitle.textColor = [UIColor colorWithHexString:@"#434343"];
    self.protuctTitle.font = TLFont_Semibold_Size(16, 1);
    [self.contentView addSubview:self.protuctTitle];
    
    self.pricetLabel = [[UILabel alloc]init];
    self.pricetLabel.textColor = [UIColor colorWithHexString:@"#919191"];
    self.pricetLabel.font = TLFont_Regular_Size(14, 1);
    [self.contentView addSubview:self.pricetLabel];
    
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor colorWithHexString:@"919191"];
    [self.contentView addSubview:self.line];
    
    
    self.backView = [[UIView alloc]init];
    self.backView.layer.borderWidth = SINGLE_LINE_WIDTH;
    self.backView.layer.borderColor = [UIColor colorWithHexString:@"#919191"].CGColor;
    self.backView.layer.cornerRadius = 3;
    [self.backView addTapGestureWithTarget:self action:@selector(buttonClicked)];
    [self.contentView addSubview:self.backView];
    CGFloat tempFont = isIPHONE5 ?14:16;
    self.moneyLable = [[UILabel alloc]init];
    self.moneyLable.font = [UIFont fontWithName:FONT_REGULAR size:tempFont];
    self.moneyLable.textColor = [UIColor colorWithHexString:@"#FC5D3F"];
    [self.backView addSubview:self.moneyLable];
    
    
    self.tempLable = [[UILabel alloc]init];
    
    self.tempLable.font = [UIFont fontWithName:FONT_REGULAR size:tempFont];
    self.tempLable.textColor = [UIColor colorWithHexString:@"#434343"];
    self.tempLable.text = @"(最低) | 分享赚";
    NSString *allstring = self.tempLable.text;
    NSString *tempString = @"(最低) |";
    NSRange range = [allstring rangeOfString:tempString];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:allstring];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#919191"] range:range];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_REGULAR size:tempFont-4] range:range];
    self.tempLable.attributedText = str;
    [self.tempLable sizeToFit];
    [self.backView addSubview:self.tempLable];
    
    [self.protuctImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView.mas_centerX).offset(-15);
        make.height.mas_equalTo(85);
    }];
    
    [self.proctucCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(16);
    }];
    
    [self.protuctTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.proctucCount.mas_left).offset(-5);
        make.top.equalTo(self.contentView).offset(14);
        make.left.equalTo(self.protuctImage.mas_right).offset(15);
    }];
    
    [self.pricetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.protuctImage.mas_right).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.protuctTitle.mas_bottom).offset(10);
    }];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@0);
        make.left.equalTo(self.protuctImage.mas_right).offset(15);
        make.bottom.equalTo(self.protuctImage.mas_bottom);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(5);
        make.centerY.equalTo(self.backView.mas_centerY);
        make.top.equalTo(self.backView).offset(2);
        make.bottom.equalTo(self.backView).offset(-2);
    }];
    [_tempLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLable.mas_right).offset(1);
        make.centerY.equalTo(self.moneyLable.mas_centerY).offset(-1);
        make.right.equalTo(self.backView.mas_right).offset(-3);
    }];
    
    
}

- (void)setModel:(OrderFormProductsModel *)model
{
    _model = model;
    _model = model;
    [self.protuctImage sd_setImageWithURL:[NSURL URLWithString:model.headImage]];
    self.protuctTitle.text = model.productName;
    self.pricetLabel.text = [NSString stringWithFormat:@"¥%.2f / 规格：%@",model.price,model.specName];
    self.proctucCount.text = [NSString stringWithFormat:@"x%ld",(long)model.buyCount];
    self.moneyLable.text = [NSString stringWithFormat:@"¥%@",model.shareCost];
}

-(void)buttonClicked
{
    if(self.buttonClick)
    {
        self.buttonClick();
    }
}

@end
