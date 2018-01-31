//
//  perTableViewCell.m
//  TuLingApp
//
//  Created by hua on 16/11/22.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "perTableViewCell.h"
#import "NSString+StrCGSize.h"
#import <Masonry.h>
#import "UIColor+ColorChange.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kColor(r , g ,b) [UIColor colorWithRed:(r)/255.0  green:(g)/255.0  blue:(b)/255.0 alpha:1]
@implementation perTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"statusww";
    // 1.缓存中取
    perTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[perTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell被点击选择时的背景色为无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
        _leftLabel = [LXTControl createLabelWithFrame:CGRectMake(15, 12, 120, 20) Font:17 Text:@""];
        _leftLabel.textColor =kColor(67, 67, 67);
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_leftLabel];
        
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
        
        self.textField =  [[UITextField alloc]initWithFrame:CGRectMake(kScreenW-25-200, 12, 200, 20)];
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.layer.borderWidth=0.0;
       // self.textField.backgroundColor = kColor(231, 231, 231);
        self.textField.textAlignment =NSTextAlignmentRight;
        self.textField.userInteractionEnabled = NO;
        self.textField.textColor = kColor(145, 145, 145);
        self.textField.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:self.textField];
        
        _rightArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 15 - 8 , 12, 8, 15)];
        _rightArrowImageView.image = [UIImage imageNamed:@"AirNext"];
        [self addSubview:_rightArrowImageView];
        
        [_rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}


-(void)addValue:(NSMutableDictionary *)dic
{
//    [_photoView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
//    _titleLabel.text = dic[@"heading"];
//    _cegateLabel.text = dic[@"name"];
//    _cegateLabel.frame =CGRectMake(15, _photoView.frame.origin.y+_photoView.frame.size.height+10, [NSString singeWidthForString:dic[@"name"] fontSize:13 Height:20]+16, 20) ;
//    _commentLabel.text = dic[@"cmt_count"];
//    _browseLabel.text = dic[@"look_count"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  
}

@end
