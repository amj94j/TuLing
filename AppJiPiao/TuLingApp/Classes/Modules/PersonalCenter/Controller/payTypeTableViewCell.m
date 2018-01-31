//
//  payTypeTableViewCell.m
//  TuLingApp
//
//  Created by hua on 16/11/6.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "payTypeTableViewCell.h"
#import "NSString+StrCGSize.h"
#import "UIColor+ColorChange.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
@implementation payTypeTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"afrgfg566";
    // 1.缓存中取
    payTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[payTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.lineView=[[UIView alloc] initWithFrame:CGRectMake(15, 44-0.5, kScreenW-30, 0.5)];
//        cell.lineView.backgroundColor = [UIColor colorWithHexString:@"C6C6C6"];
//        [cell.contentView addSubview:cell.lineView];
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
        _photoView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 20, 20)];
        [_photoView setImage:[UIImage imageNamed:@"weixin1.png"]];
        [self addSubview:_photoView];
        
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_photoView.frame.size.width+ _photoView.frame.origin.x+10,12, 100, 20)];
        _name.textColor = [UIColor colorWithHexString:@"#434343"];
        _name.text = @"收货人：吕玉凤";
        _name.lineBreakMode = NSLineBreakByTruncatingTail;
        _name.textAlignment = NSTextAlignmentLeft;
        _name.font = [UIFont systemFontOfSize:15];
        [self addSubview:_name];
        
        
        _cellBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW-35, 12, 20, 20)];
        //_cellBtn.tag = 3000;
        [_cellBtn addTarget:self action:@selector(SelectBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cellBtn];
      
        
    }
    return self;
}

-(void)SelectBtnClick1:(UIButton *)btn
{
    [self.delegate confirmIssecelt:self];

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
