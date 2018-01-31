//
//  MainLeftThridCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MainLeftThridCell.h"
#import "LXTControl.h"

@implementation MainLeftThridCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createContentSubview];
    }
    return self;
}

- (void) createContentSubview
{
    self.backgroundColor = [UIColor whiteColor];
    UIView * topView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLeftVCWidth, 10)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self addSubview:topView];
   
    UIImageView * imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(22,  10 + (55*kWidthScale - 25) / 2.0, 25, 25)];
    imageView.image = [UIImage imageNamed:@"TLMainLeft_enterBusinessIcon"];
    [self addSubview:imageView];
    
    UILabel * label = [LXTControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 15, 10 + (55 * kWidthScale - 22) / 2.0, 100, 22) Font:15 Text:@"商家入驻"];
    label.font = TLFont_Regular_Size(15, 0);
    label.textColor = [UIColor colorWithHexString:@"#434343"];
    label.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label];
    
    UIButton *businessBtn = [LXTControl createBtnWithFrame:CGRectMake(kLeftVCWidth - 15 - 50, 10 + (55 * kWidthScale - 22) / 2.0, 50, 22) titleName:@"入驻" imgName:nil selImgName:nil target:self action:@selector(onBusinessBtnClick)];
    businessBtn.titleLabel.font = TLFont_Regular_Size(15, 0);
    [businessBtn setTitleColor:[UIColor colorWithHexString:@"#6dcb99"] forState:UIControlStateNormal];
    businessBtn.layer.cornerRadius = 2.5;
    businessBtn.layer.borderColor  = [UIColor colorWithHexString:@"6dcb99"].CGColor;
    businessBtn.layer.borderWidth = .5;
    [self.contentView addSubview:businessBtn];
}

- (void) onBusinessBtnClick
{
    if (self.businessClick) {
        self.businessClick();
    }
}

@end
