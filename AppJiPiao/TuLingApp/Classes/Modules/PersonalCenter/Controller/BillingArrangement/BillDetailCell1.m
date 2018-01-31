//
//  BillDetailCell1.m
//  TuLingApp
//
//  Created by hua on 17/4/19.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BillDetailCell1.h"

@implementation BillDetailCell1

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"statusdfgdfwwdsf";
    // 1.缓存中取
    BillDetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[BillDetailCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell被点击选择时的背景色为无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _Number = [[UILabel alloc]init];
        _Number.font =[UIFont systemFontOfSize:15];
        _Number.textColor = [UIColor colorWithHexString:@"#919191"];
        _Number.frame = CGRectMake(15, 17, WIDTH-30, 20);
        [self addSubview:_Number];
        
        _myImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_Number.frame)+10, _Number.frame.origin.y, 18, 18)];
        _myImage.image = [UIImage imageNamed:@"phone11.png"];
        [self addSubview:_myImage];
        
        
    }
    
    
    return self;
}

-(void)addValue:(NSString *)phone
{
    _Number.text=[NSString stringWithFormat:@"商户服务热线：%@",phone];
    _Number.frame = CGRectMake(15, 17, [NSString singeWidthForString:_Number.text fontSize:15 Height:20], 20);
    _myImage.frame =CGRectMake(CGRectGetMaxX(_Number.frame)+10, _Number.frame.origin.y, 18, 18);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
