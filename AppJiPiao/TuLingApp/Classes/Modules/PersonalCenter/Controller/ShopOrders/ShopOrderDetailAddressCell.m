//
//  ShopOrderDetailAddressCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/20.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ShopOrderDetailAddressCell.h"

@implementation ShopOrderDetailAddressCell
{
    UILabel *_nameLab;
    UILabel *_phoneLab;
    UILabel *_addressLab;
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
    _nameLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 20*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:15 Text:@"" LabTextColor:kColorFontBlack1];
    [self.contentView addSubview:_nameLab];
    
    
    _phoneLab = [createControl labelWithFrame:CGRectZero Font:15 Text:@"" LabTextColor:kColorFontBlack1];
    [self.contentView addSubview:_phoneLab];
    
    _addressLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 45*kHeightScale, WIDTH-30*kWidthScale, 100) Font:15 Text:@"" LabTextColor:kColorFontBlack1];
    _addressLab.numberOfLines = 0;
    [self.contentView addSubview:_addressLab];
}

- (void)setModel:(ShopOrderDetailModel *)model
{
    _model = model;
    
    _nameLab.text = model.consignee;
    _phoneLab.text = model.phone;
    _addressLab.text = model.address;

    CGSize nameSize = [_nameLab.text sizeWithFont:15 andMaxSize:CGSizeMake(WIDTH-30*kWidthScale, 20)];
    if (nameSize.width > WIDTH-170*kWidthScale) {
        nameSize.width = WIDTH-170*kWidthScale;
    }
    _nameLab.frame = CGRectMake(15*kWidthScale, 20*kHeightScale, nameSize.width, nameSize.height);
    _phoneLab.frame = CGRectMake(45*kWidthScale+nameSize.width, 20*kHeightScale, WIDTH-60*kWidthScale-nameSize.width, nameSize.height);
    
    CGSize addSize = [_addressLab.text sizeWithFont:15 andMaxSize:CGSizeMake(WIDTH-30*kWidthScale, 200)];
    _addressLab.frame = CGRectMake(15*kWidthScale, 35*kHeightScale+nameSize.height, WIDTH-30*kWidthScale, addSize.height);
}

@end
