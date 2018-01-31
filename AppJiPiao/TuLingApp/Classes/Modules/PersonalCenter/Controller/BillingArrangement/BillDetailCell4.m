//
//  BillDetailCell4.m
//  TuLingApp
//
//  Created by hua on 17/4/19.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BillDetailCell4.h"

@interface BillDetailCell4 ()

@end

@implementation BillDetailCell4
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"swqewffdxfwdsf";
    // 1.缓存中取
    BillDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[BillDetailCell4 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        //_leftLabel.text = @"结算金额：";
        _leftLabel.frame = CGRectMake(15, 12, WIDTH-30, 20);
        [self addSubview:_leftLabel];
        
        
     
        
        
//        _rightLabel = [[UILabel alloc]init];
//        _rightLabel.font =[UIFont systemFontOfSize:13];
//        _rightLabel.textAlignment =NSTextAlignmentRight;
//        _rightLabel.textColor = [UIColor colorWithHexString:@"#919191"];
//        _rightLabel.frame = CGRectMake(15, 10, WIDTH-30, 20);
//        [self addSubview:_rightLabel];
        
        
        
    }
    
    
    return self;
}

-(void)addValue:(NSMutableDictionary *)dic
{
    if ([NSString isBlankString: [NSString stringWithFormat:@"%@",dic[@"createDate"]]]) {
        _leftLabel.text =[NSString stringWithFormat:@"%@   (订单生成日期)",dic[@"createDate"]];
        
    }
}


@end
