//
//  TLMyOrderLogisticsView.m
//  TuLingApp
//
//  Created by gyc on 2017/7/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLMyOrderLogisticsView.h"
#import <Masonry.h>
@implementation TLMyOrderLogisticsView
{
    UIImageView *_imgView;
    UILabel *_title;
    UILabel *_specName;
    UILabel *_pirce;
    UILabel *_number;
    
    UILabel * _logisticsLabel;
    UILabel * _logisticsTimeLabel;
}

-(instancetype)init{

    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, 15 + 32 + 7 + 16 + 15)];
    if (self){
        [self createSubviews];
    }
    return self;
}

- (void) createSubviews
{
    
    UIImageView * iconImageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TLOrder_wuliuIcon"]];
    [self addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(30));
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    _logisticsLabel = [[UILabel alloc] init];
    _logisticsLabel.font = [UIFont systemFontOfSize:13];
    _logisticsLabel.textAlignment = NSTextAlignmentLeft;
    _logisticsLabel.numberOfLines = 2;
    _logisticsLabel.textColor = [UIColor colorWithHexString:@"#6a6a6a"];
    [self addSubview:_logisticsLabel];
    
    [_logisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@32);
        make.left.equalTo(iconImageView.mas_right).offset(15);
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    
    _logisticsTimeLabel = [[UILabel alloc] init];
    _logisticsTimeLabel.font = [UIFont systemFontOfSize:13];
    _logisticsTimeLabel.textAlignment = NSTextAlignmentLeft;
    _logisticsTimeLabel.textColor = [UIColor colorWithHexString:@"#919191"];
    [self addSubview:_logisticsTimeLabel];
    
    [_logisticsTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@16);
        make.left.equalTo(iconImageView.mas_right).offset(15);
        make.top.equalTo(_logisticsLabel.mas_bottom).offset(7);
        make.right.equalTo(self).offset(-15);
    }];
}


- (void)setModel:(MyOrderFormListModel *)model
{
    _model = model;
    
    if([NSString isBlankString:model.logisticsContent]){
        _logisticsLabel.text = model.logisticsContent;
    }else{
        _logisticsLabel.text = @"暂无物流信息";
    }
    
    if([NSString isBlankString:model.logisticsDate]){
        _logisticsTimeLabel.text =  model.logisticsDate;
    }else{
        _logisticsTimeLabel.text = @"暂无物流信息时间";
    }
}

@end
