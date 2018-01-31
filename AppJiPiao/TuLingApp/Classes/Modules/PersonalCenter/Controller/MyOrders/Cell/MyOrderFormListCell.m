//
//  MyOrderFormListCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/22.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MyOrderFormListCell.h"
#import <Masonry.h>
@implementation MyOrderFormListCell
{
    UIImageView *_imgView;
    UILabel *_title;
    UILabel *_specName;
    UILabel *_pirce;
    UILabel *_number;
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
    _title.numberOfLines = 2;
    [self.contentView addSubview:_title];
    
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).offset(imgMaxX+10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(17);
        make.height.greaterThanOrEqualTo(@(0));
    }];
    
    CGFloat titleMaxY = CGRectGetMaxY(_title.frame);
    _specName = [LXTControl createLabelWithFrame:CGRectMake(imgMaxX+10, titleMaxY+7, WIDTH-imgMaxX, 15) Font:13 Text:nil];
    _specName.textColor = [UIColor colorWithHexString:@"#939393"];
    [self.contentView addSubview:_specName];
    [_specName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(imgMaxX+10);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(_title.mas_bottom).offset(4);
    }];
    
    
    _pirce = [LXTControl createLabelWithFrame:CGRectMake(imgMaxX+10, titleMaxY+32, WIDTH-imgMaxX, 20) Font:18 Text:nil];
    _pirce.textColor = [UIColor colorWithHexString:@"#939393"];
    [self.contentView addSubview:_pirce];
    
    
    _number = [LXTControl createLabelWithFrame:CGRectMake(WIDTH-100, 80, 85, 20) Font:18 Text:nil];
    _number.textAlignment = NSTextAlignmentRight;
    _number.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_number];
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
    
    _specName.text = [NSString stringWithFormat:@"规格：%@", _model.specName];
    _pirce.text = [NSString stringWithFormat:@"¥%0.2f", _model.price];
    _number.text = [NSString stringWithFormat:@"x%zd",_model.buyCount];
    
}

@end
