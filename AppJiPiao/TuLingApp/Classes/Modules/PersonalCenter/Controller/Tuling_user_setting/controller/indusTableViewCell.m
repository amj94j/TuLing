//
//  indusTableViewCell.m
//  TuLingApp
//
//  Created by hua on 16/11/23.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "indusTableViewCell.h"
#import "NSString+StrCGSize.h"
#import "UIColor+ColorChange.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
@implementation indusTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"detail1";
    // 1.缓存中取
    indusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[indusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell被点击选择时的背景色为无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 2.创建
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(15,12, kScreenW-15-60, 25)];
        _name.textColor = [UIColor colorWithHexString:@"#434343"];
        _name.lineBreakMode = NSLineBreakByTruncatingTail;
        _name.textAlignment = NSTextAlignmentLeft;
        _name.font = [UIFont systemFontOfSize:15];
        [self addSubview:_name];
        
        
        _Btn =[LXTControl createButtonWithFrame:CGRectMake(kScreenW-15-35, 12, 20, 20) ImageName:@"" Target:self Action:@selector(clickBtn:) Title:@""];
         
        [_Btn setImage:[UIImage imageNamed:@"hangye"] forState:UIControlStateNormal];
        [self addSubview:_Btn];
        
    }
     return self;
}

-(void)clickBtn:(UIButton *)btn
{
    [self.delegate IsseceltView11:btn];


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
