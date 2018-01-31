//
//  topicCell1.m
//  TuLingApp
//
//  Created by hua on 17/4/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "topicCell1.h"
#import "UIView+SDAutoLayout.h"
@implementation topicCell1
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"stcatrrsduwdsf";
    // 1.缓存中取
    topicCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[topicCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell被点击选择时的背景色为无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _name = [[UILabel alloc]init];
        _name.frame = CGRectMake(15, 15, WIDTH, 20);
        _name.font = [UIFont systemFontOfSize:17];
        _name.textColor = [UIColor colorWithHexString:@"#6DCB99"];
        _name.text = @"驳回原因";
        [self addSubview:_name];
        
        _lineLabel = [createControl createLineWithFrame:CGRectMake(15, CGRectGetMaxY(_name.frame)+15, WIDTH-30, 0.5) labelLineColor:RGBCOLOR(238, 238, 238)];
        [self addSubview:_lineLabel];
        
        _content = [[UILabel alloc] init];
        _content.textColor = [UIColor colorWithHexString:@"#434343"];;
        _content.text = @"";
        _content.numberOfLines = 0;//根据最大行数需求来设置
//        CGSize maximumLabelSize = CGSizeMake(WIDTH-30, 9999);
//        CGSize expectSize = [_content sizeThatFits:maximumLabelSize];
        _content.frame = CGRectMake(15,CGRectGetMaxY(_lineLabel.frame)+10, WIDTH-30, 83);
        _content.lineBreakMode = NSLineBreakByCharWrapping;
        _content.textAlignment = NSTextAlignmentLeft;
        _content.font = [UIFont systemFontOfSize:15];
        [self addSubview:_content];
        
        
        
        
    }
    return self;
}

-(void)setTopicModel1:(topicModel *)topicModel1
{

    if ([NSString isBlankString:topicModel1.auditCause]) {
        _content.text =topicModel1.auditCause;
//         _content.frame = CGRectMake(15,CGRectGetMaxY(_lineLabel.frame)+10, WIDTH-30,  [NSString getSpaceLabelHeight:_content.text withFont:[UIFont systemFontOfSize:15] withWidth:WIDTH-30 lineSpace:6 fontSpace:@1.5]);
        
        
    }else
    {
    
    
    
    }
    
    [self setupAutoHeightWithBottomViewsArray:@[_content,_lineLabel] bottomMargin:30];


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
