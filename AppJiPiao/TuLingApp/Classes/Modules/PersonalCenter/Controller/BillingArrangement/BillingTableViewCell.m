//
//  BillingTableViewCell.m
//  TuLingApp
//
//  Created by hua on 17/4/17.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BillingTableViewCell.h"
#import <Masonry.h>

@implementation BillingTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"statusww";
    // 1.缓存中取
    BillingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[BillingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell被点击选择时的背景色为无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftLabel = [LXTControl createLabelWithFrame:CGRectMake(15, 12,150, 20) Font:13 Text:@"结算日：2017-03-07"];
        _leftLabel.textColor =RGBCOLOR(145, 145, 145);
        _leftLabel.textAlignment= NSTextAlignmentLeft;
        [self addSubview:_leftLabel];
        
        _leftDownLabel = [createControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(_leftLabel.frame)+7, 70, 20) Font:13 Text:@"结算余额：" LabTextColor:RGBCOLOR(67, 67, 67)];
        _leftDownLabel.textAlignment= NSTextAlignmentLeft;
        [self addSubview:_leftDownLabel];
        
        
        _leftDownValueLabel = [LXTControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(_leftDownLabel.frame), _leftDownLabel.frame.origin.y,70, 20) Font:16 Text:@"1000.00"];
        _leftDownValueLabel.textColor =RGBCOLOR(67, 67,67);
        _leftDownValueLabel.textAlignment= NSTextAlignmentLeft;
        [self addSubview:_leftDownValueLabel];
        
        _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-15-8, 25, 8, 15)];
        _iconImg.image = [UIImage imageNamed:@"zhan.png"];
        [self  addSubview:_iconImg];
        
        
        _rightLabel = [LXTControl createLabelWithFrame:CGRectMake(_iconImg.frame.origin.x-65-15, 22.5, 65, 20) Font:16 Text:@"已确认"];
        _rightLabel.textColor =RGBCOLOR(67, 67, 67);
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rightLabel];
        
        
        
        
        
        _rightTimeLabel = [LXTControl createLabelWithFrame:CGRectMake(_iconImg.frame.origin.x-65-15, 22.5, 65, 20) Font:16 Text:@""];
        _rightTimeLabel.textColor =RGBCOLOR(67, 67, 67);
        _rightTimeLabel.textAlignment = NSTextAlignmentRight;
        _rightTimeLabel.hidden=YES;
        [self addSubview:_rightTimeLabel];
      
        
        
        _rightTime1Label = [LXTControl createLabelWithFrame:CGRectMake(_iconImg.frame.origin.x-65-15, 22.5, 65, 20) Font:13 Text:@""];
        _rightTime1Label.textColor =RGBCOLOR(145, 145, 145);
        _rightTime1Label.textAlignment = NSTextAlignmentRight;
        _rightTime1Label.hidden=YES;
        _rightTime1Label.text = @"结算时间";
        [self addSubview:_rightTime1Label];
        
    }
    return self;
}

-(void)addValue:(NSMutableDictionary *)dic  type:(NSString *)str
{
    
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",dic[@"billEndTime"]]]) {

        _leftLabel.text =[NSString stringWithFormat:@"结算日：%@",dic[@"billEndTime"]];
        _leftLabel.frame =CGRectMake(15, 12,200, 20);

        NSString * dateString = dic[@"billEndTime"];
        _leftLabel.text = [NSString stringWithFormat:@"结算日：%@",dateString];
        _leftLabel.frame = CGRectMake(15, 12,[NSString singeWidthForString:_leftLabel.text fontSize:13 Height:20] + 10, 20);
    }
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",dic[@"settleCost"]]]) {
        _leftDownValueLabel.text = [NSString stringWithFormat:@"%@",dic[@"settleCost"]];
    }
    
    
    
    if ([str isEqualToString:@"1"]) {
        _rightLabel.hidden=NO;
        _iconImg.hidden=NO;
        _rightTimeLabel.hidden=YES;
        _rightTime1Label.hidden=YES;
        
        if ([NSString isBlankString:dic[@"status"]]) {
            _rightLabel.text =dic[@"status"];
            if ([dic[@"status"] isEqualToString:@"待确认"]) {
                _rightLabel.textColor = [UIColor colorWithHexString:@"#6DCB99"];
            }else
            {
                _rightLabel.textColor =RGBCOLOR(67, 67, 67);
            }
            
        }

    }else
    {
        _rightLabel.hidden=YES;
        _iconImg.hidden=YES;
        _rightTimeLabel.hidden=NO;
        _rightTime1Label.hidden=NO;
     if ([NSString isBlankString:dic[@"settleTime"]]) {
         _rightTimeLabel.text =dic[@"settleTime"];
         
         
_rightTimeLabel.frame = CGRectMake(CGRectGetMaxX(_leftDownValueLabel.frame), _leftDownValueLabel.frame.origin.y, WIDTH-15-CGRectGetMaxX(_leftDownValueLabel.frame), 20);
         
         _rightTime1Label.frame =CGRectMake(WIDTH-15-[NSString singeWidthForString:_rightTimeLabel.text fontSize:15 Height:20]-15, _leftLabel.frame.origin.y, WIDTH-15-CGRectGetMaxX(_leftDownValueLabel.frame) , 20);
         [_rightTime1Label mas_makeConstraints:^(MASConstraintMaker *make) {
            
             make.right.equalTo(_rightTimeLabel);
             make.centerY.equalTo(_leftLabel);
         }];
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
