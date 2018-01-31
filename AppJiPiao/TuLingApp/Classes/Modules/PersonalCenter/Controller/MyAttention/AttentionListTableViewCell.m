//
//  AttentionListTableViewCell.m
//  TuLingApp
//
//  Created by hua on 17/4/17.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "AttentionListTableViewCell.h"

@implementation AttentionListTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"statusxxww";
    // 1.缓存中取
    AttentionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[AttentionListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell被点击选择时的背景色为无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _MyImg = [LXTControl createImageViewWithFrame:CGRectMake(15, 10, 71, 71) ImageName:@""];
        _MyImg.layer.masksToBounds =YES;
        _MyImg.layer.cornerRadius =71/2;
        [self addSubview:_MyImg];
        
        _nameLabel =[LXTControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(_MyImg.frame)+15, 18, 200, 20) Font:16 Text:@""];
        
        _nameLabel.textColor = [UIColor colorWithHexString:@"#434343"];
        [self addSubview:_nameLabel];
        
        
        _AuthenticationImg = [[UIImageView alloc]init];
        _AuthenticationImg.image =[UIImage imageNamed:@"ge.png"];
        [self addSubview:_AuthenticationImg];
        
        _sexImg = [[UIImageView alloc]init];
        //_sexImg.image =[UIImage imageNamed:@"ge.png"];
        [self addSubview:_sexImg];
        
        _decLabel =[LXTControl createLabelWithFrame:CGRectMake(_nameLabel.frame.origin.x, 65, 200, 20) Font:13 Text:@""];
        _decLabel.textColor = [UIColor colorWithHexString:@"#B1B1B1"];
        [self addSubview:_decLabel];
        
        
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-15-8, 25, 8, 15)];
        _iconImg.image = [UIImage imageNamed:@"zhan.png"];
        [self  addSubview:_iconImg];

        
        
        
    }
    return self;
}

-(void)addValue:(NSMutableDictionary *)dic
{
    if ([NSString isBlankString:dic[@"icon"]]) {
        [_MyImg sd_setImageWithURL:dic[@"icon"]];
    }else
    {
        [_MyImg setImage:[UIImage imageNamed:@"person0"]];
    }

    if ([NSString isBlankString:dic[@"name"]]) {
        _nameLabel.text =dic[@"name"];
    }
    
    
    if ([NSString isBlankString:dic[@"career"]]) {
        _decLabel.text =dic[@"career"];
        
    }else
    {
        _decLabel.text  = @"还没有其他资料";
        
    
    }
    
    
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",dic[@"userType"]]]) {
        NSString *str1 =[NSString stringWithFormat:@"%@",dic[@"userType"]];
        if ([str1 isEqualToString:@"1"]) {
            //个人
             _AuthenticationImg.image =[UIImage imageNamed:@"ge.png"];
             _AuthenticationImg.hidden=NO;
            _AuthenticationImg.frame = CGRectMake(15, CGRectGetMaxY(_nameLabel.frame), 18, 18);
            
        }else if ([str1 isEqualToString:@"3"])
        {
            //商家
             _AuthenticationImg.image =[UIImage imageNamed:@"商家.png"];
             _AuthenticationImg.hidden=NO;
             _AuthenticationImg.frame = CGRectMake(15, CGRectGetMaxY(_nameLabel.frame), 18, 18);
            
            
        
        }else
        {
             _AuthenticationImg.hidden=YES;
        
        
        }
        
        
        if ([NSString isBlankString:[NSString stringWithFormat:@"%@",dic[@"sex"]]]) {
            NSString *str2  =[NSString stringWithFormat:@"%@",dic[@"sex"]];
            
            NSString *str1 =[NSString stringWithFormat:@"%@",dic[@"userType"]];
            if ([str2 isEqualToString:@"1"]) {
                
                _sexImg.image = [UIImage imageNamed:@"nan.png"];
                
            }else if ([str2 isEqualToString:@"2"])
            {
                _sexImg.image = [UIImage imageNamed:@"nv.png"];
            
            }else
            {
                _sexImg.hidden=YES;
            
            }
            
            
            if ([str1 isEqualToString:@"1"]) {
                //个人
                _sexImg.frame =CGRectMake(CGRectGetMaxX(_AuthenticationImg.frame)+5, _AuthenticationImg.frame.origin.y, 18, 18);
                
            }else if ([str1 isEqualToString:@"3"])
            {
                
                _sexImg.frame =CGRectMake(CGRectGetMaxX(_AuthenticationImg.frame)+5, _AuthenticationImg.frame.origin.y, 18, 18);

            }else
            {
                _sexImg.frame =CGRectMake(15, CGRectGetMaxY(_nameLabel.frame), 18, 18);
                
            
            }
            
            
        }
        
        
                         
                         
    }
    
    

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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
