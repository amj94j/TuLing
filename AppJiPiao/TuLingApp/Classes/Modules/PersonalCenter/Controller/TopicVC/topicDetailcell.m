//
//  topicDetailcell.m
//  TuLingApp
//
//  Created by hua on 17/4/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "topicDetailcell.h"

@implementation topicDetailcell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"stcatuwdsf";
    // 1.缓存中取
    topicDetailcell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[topicDetailcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell被点击选择时的背景色为无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _myImage = [[UIImageView alloc]init];
        _myImage.frame = CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].bounds.size.width*9/16);
        _myImage.image =[UIImage imageNamed:@"169.png"];
        
        [self addSubview:_myImage];
        
        
        _name = [[UILabel alloc] init];
        _name.textColor = [UIColor whiteColor];
        //_name.text = _dataSourceDic[@"name"];
        _name.numberOfLines = 0;//根据最大行数需求来设置/Users/hua/Desktop/tuling_ios-master/TuLingApp.xcodeproj
        _name.lineBreakMode = NSLineBreakByCharWrapping;
        _name.textAlignment = NSTextAlignmentCenter;
        _name.font = [UIFont boldSystemFontOfSize:21];
        
        //阴影透明度
        _name.layer.shadowOpacity = 0.75;
        //阴影宽度
        _name.layer.shadowRadius = 0.5;
        //阴影颜色
        _name.layer.shadowColor = [UIColor blackColor].CGColor;
        //映影偏移
        _name.layer.shadowOffset = CGSizeMake(1, 1);
        [self addSubview:_name];
        
    }
    return self;
}



-(void)addValue:(NSMutableDictionary *)dic
{
    if ([NSString isBlankString:dic[@"shoppingImage"]]) {
        [_myImage sd_setImageWithURL:[NSURL URLWithString:dic[@"shoppingImage"]]];
    }

    if ([NSString isBlankString:dic[@"goodsName"]]) {
        _name.text = dic[@"goodsName"];
        CGSize maximumLabelSize = CGSizeMake(WIDTH-30, 40);
        CGSize expectSize = [_name sizeThatFits:maximumLabelSize];
        _name.frame = CGRectMake(15,(_myImage.frame.size.height-expectSize.height)/2 ,WIDTH-30, expectSize.height);
    }
   

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
