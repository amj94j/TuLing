//
//  baseCell.m
//  TuLingApp
//
//  Created by hua on 17/4/18.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "baseCell.h"

@implementation baseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 绘制Cell分割线
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, cellLineColor.CGColor);
    //    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, cellLineColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(15, rect.size.height, rect.size.width-30, cellLineH));
    
}

@end
