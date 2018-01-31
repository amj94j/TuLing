//
//  BillDetailCell2.m
//  TuLingApp
//
//  Created by hua on 17/4/19.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BillDetailCell2.h"

@implementation BillDetailCell2

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"swqewwdsf";
    // 1.缓存中取
    BillDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[BillDetailCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell被点击选择时的背景色为无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.font =[UIFont systemFontOfSize:13];
        _leftLabel.textColor = [UIColor colorWithHexString:@"#919191"];
        _leftLabel.frame = CGRectMake(15, 10, WIDTH-30, 20);
        [self addSubview:_leftLabel];
        
        
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.font =[UIFont systemFontOfSize:13];
        _rightLabel.textAlignment =NSTextAlignmentRight;
        _rightLabel.textColor = [UIColor colorWithHexString:@"#919191"];
        _rightLabel.frame = CGRectMake(15, 10, WIDTH-30, 20);
        [self addSubview:_rightLabel];
        
        
        
    }
    
    
    return self;
}

-(void)addValue:(NSMutableDictionary *)dic
{
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",dic[@"orderNumber"]]]) {
        _leftLabel.text =[NSString stringWithFormat:@"订单编号：%@",dic[@"orderNumber"]];
        _leftLabel.frame = CGRectMake(15, 10, [NSString singeWidthForString:_leftLabel.text fontSize:13 Height:20], 20);
        
    }
    
    
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",dic[@"orderCost"]]]) {
        _rightLabel.text =[NSString stringWithFormat:@"订单金额：%@",dic[@"orderCost"]];
        _rightLabel.frame = CGRectMake(_leftLabel.frame.origin.x, 10,WIDTH-15-_leftLabel.frame.origin.x, 20);
        
    }
    
    
    
    
    





}
@end
