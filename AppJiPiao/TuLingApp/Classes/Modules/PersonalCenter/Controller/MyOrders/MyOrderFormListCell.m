//
//  MyOrderFormListCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/22.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MyOrderFormListCell.h"

@implementation MyOrderFormListCell
{
    UIImageView *_imgView;
    UILabel *_title;
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
    _title = [LXTControl createLabelWithFrame:CGRectMake(imgMaxX+10, 25, WIDTH-imgMaxX, 20) Font:15 Text:nil];
    [self.contentView addSubview:_title];
    
    CGFloat titleMaxY = CGRectGetMaxY(_title.frame);
    _pirce = [LXTControl createLabelWithFrame:CGRectMake(imgMaxX+10, titleMaxY+35, WIDTH-imgMaxX, 20) Font:18 Text:nil];
    [self.contentView addSubview:_pirce];
    
    _number = [LXTControl createLabelWithFrame:CGRectMake(WIDTH-100, 85, 85, 20) Font:18 Text:nil];
    _number.textAlignment = NSTextAlignmentRight;
    _number.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_number];
}

- (void)setModel:(OrderFormProductsModel *)model
{
    _model = model;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.headImage] placeholderImage:[UIImage imageNamed:@""]];
    _title.text = _model.productName;
    _pirce.text = [NSString stringWithFormat:@"%zd", _model.price];
    _number.text = [NSString stringWithFormat:@"x%zd",_model.buyCount];
    
}

@end
