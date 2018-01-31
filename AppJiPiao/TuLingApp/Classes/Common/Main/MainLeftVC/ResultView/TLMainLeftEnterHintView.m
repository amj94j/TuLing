//
//  TLMainLeftEnterHintView.m
//  TuLingApp
//
//  Created by 最印象 on 2017/10/11.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLMainLeftEnterHintView.h"
#import <Masonry.h>

@implementation TLMainLeftEnterHintView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title{
    self = [super initWithFrame:frame];
    if(self){
        [self viewUISet:title];
    }
    return self;
}

-(void)viewUISet:(NSString*)title{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 56, 10, 10)];
    imageView.image = [UIImage imageNamed:@"TLMainLeft_hintStarIcon"];
    [self addSubview:imageView];
    
    UILabel * hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 51, 100, 22)];
    hintLabel.text = @"温馨提示";
    hintLabel.font = TLFont_Regular_Size(16, 0);
    hintLabel.textColor = [UIColor colorWithHexString:@"#6a6a6a"];
    hintLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:hintLabel];
    
    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@22);
        make.top.equalTo(self).offset(62);
        make.width.equalTo(@100);
    }];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
        make.centerY.equalTo(hintLabel.mas_centerY);
        make.right.equalTo(hintLabel.mas_left).offset(-3);
    }];
    
    UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(hintLabel.frame) + 20, 100, 30)];
    contentLabel.font = TLFont_Semibold_Size(16, 0);
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:contentLabel];
    contentLabel.text = title;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.greaterThanOrEqualTo(@0);
        make.top.equalTo(hintLabel.mas_bottom).offset(10);
    }];
    
    NSString * url = @"http://app.touring.com.cn/shop/login";
    if ([title hasSuffix:url]){
        NSString * string = nil;
        string = [NSString stringWithFormat:@"%@",title];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:string];
        NSRange range = [string rangeOfString:url];
        [attStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6DCB99"] range:range];
        contentLabel.attributedText = attStr;
    }
    
  
   
    
}

@end
