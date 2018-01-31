//
//  MyOrderAddressCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MyOrderAddressCell.h"

@implementation MyOrderAddressCell
{
    UIImageView *_imgView;
    UILabel *_nameLab;
    UILabel *_addressLab;
    UILabel *_phoneLab;
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
    _imgView = [LXTControl createImageViewWithFrame:CGRectMake(15, 40, 22, 25) ImageName:@"img_locat"];
    [self.contentView addSubview:_imgView];
    
    _nameLab = [LXTControl createLabelWithFrame:CGRectMake(50, 15, 200, 20) Font:15 Text:nil];
    _nameLab.textColor = [UIColor colorWithHexString:@"#434343"];
    [self.contentView addSubview:_nameLab];
    
    
    _phoneLab = [LXTControl createLabelWithFrame:CGRectMake(50, 15, WIDTH-65, 20) Font:15 Text:nil];
    _phoneLab.textColor = [UIColor colorWithHexString:@"#434343"];
    _phoneLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_phoneLab];
    
    
    _addressLab = [LXTControl createLabelWithFrame:CGRectMake(50, 45, WIDTH-65, 40) Font:15 Text:nil];
    _addressLab.textColor = [UIColor colorWithHexString:@"#434343"];
    _addressLab.numberOfLines = 0;
    [self.contentView addSubview:_addressLab];
}

- (void)setModel:(AddressModel *)model
{
    _model = model;
    _nameLab.text = [NSString stringWithFormat:@"收件人：%@", model.receiver];
    _phoneLab.text = [NSString stringWithFormat:@"%@",model.phone];
    _addressLab.text = [NSString stringWithFormat:@"收货地址：%@ %@ %@",model.region, model.stress, model.address];
}

@end
