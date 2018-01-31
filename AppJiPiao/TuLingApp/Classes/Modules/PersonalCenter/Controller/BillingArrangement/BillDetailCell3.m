//
//  BillDetailCell3.m
//  TuLingApp
//
//  Created by hua on 17/4/19.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BillDetailCell3.h"

@implementation BillDetailCell3

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"swqewdxfwdsf";
    // 1.缓存中取
    BillDetailCell3 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[BillDetailCell3 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _leftLabel.font =[UIFont systemFontOfSize:17];
        _leftLabel.textColor = [UIColor colorWithHexString:@"#434343"];
        _leftLabel.text = @"结算金额：";
        _leftLabel.frame = CGRectMake(15, 17, [NSString singeWidthForString:_leftLabel.text fontSize:17 Height:20], 20);
        [self addSubview:_leftLabel];
        
        
        _twoLabel = [[UILabel alloc]init];
        _twoLabel.font =[UIFont systemFontOfSize:20];
        _twoLabel.textColor = [UIColor colorWithHexString:@"#434343"];
        _twoLabel.frame = CGRectMake(15, 10, WIDTH-30, 20);
        [self addSubview:_twoLabel];

        
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
    if ([NSString isBlankString: [NSString stringWithFormat:@"%@",dic[@"orderSettleCost"]]]) {
        _twoLabel.text =[NSString stringWithFormat:@"￥%@",dic[@"orderSettleCost"]];
        
       _twoLabel.frame =CGRectMake(CGRectGetMaxX(_leftLabel.frame), 14, [NSString singeWidthForString:_twoLabel.text fontSize:20 Height:20], 20);
        
    }
    if ([NSString isBlankString: [NSString stringWithFormat:@"%@",dic[@"billEnumDetail"]]]) {
        

        if ([[NSString stringWithFormat:@"%@",dic[@"billEnumDetail"]] isEqualToString:@"0"]) {
            _rightLabel.text = @"{收入}";
            
        }else
        {
        _rightLabel.text = @"{支出}";
        
        }
        
        _rightLabel.frame =CGRectMake(CGRectGetMaxX(_twoLabel.frame)-2, 17, 60, 20);
        
    }
    

}

@end
