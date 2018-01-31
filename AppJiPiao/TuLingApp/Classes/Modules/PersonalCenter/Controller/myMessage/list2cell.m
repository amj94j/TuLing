//
//  list2cell.m
//  TuLingApp
//
//  Created by hua on 17/5/5.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "list2cell.h"

@implementation list2cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"afrgdsdsfffds";
    // 1.缓存中取
    list2cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[list2cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell被点击选择时的背景色为无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = NO;
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _photoView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (59 - 33.5) / 2, 33.5, 33.5)];
        [_photoView setImage:[UIImage imageNamed:@"sys1.png"]];
        _photoView.layer.masksToBounds=YES;
        _photoView.layer.cornerRadius=_photoView.frame.size.width*0.5;
        [self addSubview:_photoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+_photoView.frame.size.width+15,15, 150, 20)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#434343"];
        _nameLabel.text = @"系统通知";
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_nameLabel];
        
        
        
        _count = [[UILabel alloc]init];
        _count.frame= CGRectMake(CGRectGetMaxX(_photoView.frame)-20, 15, 20, 20);
        _count.backgroundColor = [UIColor colorWithHexString:@"#FF5C36"];
        _count.textColor = [UIColor whiteColor];
        _count.font = [UIFont systemFontOfSize:13];
        _count.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_count];
        
        _timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(WIDTH-15-100,_photoView.frame.origin.y, 100, 20)];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#919191"];
        _timeLabel.text = @"17:00";
        _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_timeLabel];
        
        _content =[[UILabel alloc] initWithFrame:CGRectMake(80,CGRectGetMaxY(_nameLabel.frame)+5, WIDTH-95, 20)];
        _content .textColor = [UIColor colorWithHexString:@"#919191"];
        _content .text = @"17:00";
        _content .lineBreakMode = NSLineBreakByTruncatingTail;
        _content .textAlignment = NSTextAlignmentLeft;
        _content .font = [UIFont systemFontOfSize:12];
        [self addSubview:_content ];
    }
    return self;
    
}
-(void)addTheValue:(NSMutableDictionary *)dic
{
    
    if ([NSString isBlankString:dic[@"sendIcon"]]) {
        [_photoView sd_setImageWithURL:[NSURL URLWithString:dic[@"sendIcon"]]];
    }
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",dic[@"countAll"]]]) {
        _count.text = [NSString stringWithFormat:@"%@",dic[@"countAll"]];
        CGFloat a =[NSString singeWidthForString:_count.text fontSize:13 Height:14]+5;
        _count.frame =CGRectMake(CGRectGetMaxX(_photoView.frame)-20, 15, a, a);
        _count.layer.masksToBounds =YES;
        _count.layer.cornerRadius =_count.frame.size.width/2;
    }
          int a= [dic[@"status"] intValue] ;
    if (a==0) {
        _count.hidden=NO;
    }else
    {
    _count.hidden=YES;
    }
    if ([NSString isBlankString:dic[@"sendName"]]) {
        _nameLabel.text = dic[@"sendName"];
        [_nameLabel sizeToFit];
        _nameLabel.frame = CGRectMake(_photoView.right+15, _photoView.center.y-2-_nameLabel.height, _nameLabel.width, _nameLabel.height);
    }
    
    if ([NSString isBlankString:dic[@"createDate"]]) {
        _timeLabel.text = dic[@"createDate"];
        _timeLabel.frame=CGRectMake(WIDTH-15-[NSString singeWidthForString:_timeLabel.text fontSize:15 Height:20]-5,_nameLabel.top, [NSString singeWidthForString:_timeLabel.text fontSize:15 Height:20]+5, 20);
    }
    
    if ([NSString isBlankString:dic[@"message"]]) {
        _content.text = dic[@"message"];
        [_content sizeToFit];
        _content.frame = CGRectMake(_photoView.right+15, _photoView.center.y+5, WIDTH-95, _content.height);
    }
    
    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, cellLineH));
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
