//
//  ProductListCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ProductListCell.h"

@implementation ProductListCell
{
    UIImageView *_imgView;
    UILabel *_titleLab;
    UILabel *_priceLab;
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
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15*kWidthScale, 20*kHeightScale, 150*kWidthScale, 85*kHeightScale)];
    [self.contentView addSubview:_imgView];
    
    CGFloat imgMaxX = CGRectGetMaxX(_imgView.frame);
    _titleLab = [createControl labelWithFrame:CGRectMake(imgMaxX+10*kWidthScale, 25*kHeightScale, WIDTH-imgMaxX-25*kWidthScale, 20*kHeightScale) Font:16 Text:@"" LabTextColor:kColorFontBlack1];
    _titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.contentView addSubview:_titleLab];
    
    CGFloat imgMaxY = CGRectGetMaxY(_imgView.frame);
    _priceLab = [createControl labelWithFrame:CGRectMake(imgMaxX+10*kWidthScale, imgMaxY-30*kHeightScale, WIDTH-25*kWidthScale-imgMaxX, 20*kHeightScale) Font:17 Text:@"" LabTextColor:kColorAppRed];
    [self.contentView addSubview:_priceLab];
    
    UILabel *line = [createControl createLineWithFrame:CGRectMake(0, 119.5*kHeightScale, WIDTH, 0.5*kHeightScale) labelLineColor:kColorLine];
    [self.contentView addSubview:line];
}

- (void)setModel:(ProductListModel *)model
{
    _model = model;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.headImage] placeholderImage:nil];
    
    _titleLab.text = model.name;
    if (model.price){
        _priceLab.text = [NSString stringWithFormat:@"¥%@", model.price];
    }else{
        _priceLab.text = @"¥0";
    }
    
}


@end
