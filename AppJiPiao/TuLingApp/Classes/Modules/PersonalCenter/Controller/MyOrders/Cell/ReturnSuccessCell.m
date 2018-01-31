//
//  ReturnSuccessCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/7.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ReturnSuccessCell.h"

@implementation ReturnSuccessCell
{
    
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
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-27, 40, 55, 40)];
    imgView.image = [UIImage imageNamed:@"img_returnSuccess"];
    [self.contentView addSubview:imgView];
    
    
    UILabel *successLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, WIDTH-200, 20)];
    successLab.text = @"退款成功";
    successLab.textAlignment = NSTextAlignmentCenter;
    successLab.textColor = [UIColor colorWithHexString:@"#6DCB99"];
    [self.contentView addSubview:successLab];
    
    UILabel *detailLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 185, WIDTH-30, 20)];
    detailLab.text = @"亲，再去挑挑其他更感兴趣的商品吧";
    detailLab.textColor = [UIColor colorWithHexString:@"#434343"];
    [self.contentView addSubview:detailLab];

    UILabel *fanhuiLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 225, 35, 20)];
    fanhuiLab.text = @"返回";
    fanhuiLab.textColor = [UIColor colorWithHexString:@"#434343"];
    [self.contentView addSubview:fanhuiLab];
    
    UIButton *tiao = [LXTControl createButtonWithFrame:CGRectMake(50, 220, 120, 30) ImageName:nil Target:self Action:@selector(onBackBtnClick:) Title:@"途有可淘首页"];
    [tiao setTitleColor:[UIColor colorWithHexString:@"#6DCB99"] forState:UIControlStateNormal];
    [self.contentView addSubview:tiao];
}

- (void) onBackBtnClick:(UIButton *) sender
{
    if (self.backBtnClick) {
        self.backBtnClick();
    }
}

@end
