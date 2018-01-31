//
//  topicCell3.m
//  TuLingApp
//
//  Created by hua on 17/4/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "topicCell3.h"
#import "UIView+SDAutoLayout.h"
@implementation topicCell3


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"ddddddd";
    // 1.缓存中取
    topicCell3 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[topicCell3 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _name.textColor = [UIColor colorWithHexString:@"#434343"];
        _name.text = @"我的感受";
        [self addSubview:_name];
        
        _lineLabel = [createControl createLineWithFrame:CGRectMake(15, CGRectGetMaxY(_name.frame)+15, WIDTH-30, 0.5) labelLineColor:RGBCOLOR(238, 238, 238)];
        [self addSubview:_lineLabel];
        
        
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_lineLabel.frame)+17, WIDTH-30, 83)];
        [_textView setTextColor:[UIColor colorWithHexString:@"#434343"]];
        [_textView setFont:[UIFont systemFontOfSize:15]];
        [_textView.layer setBorderWidth:0.5f];
        _textView.layer.borderColor = RGBCOLOR(238, 238, 238).CGColor;
        //[_textView setDelegate:self];
        _textView.layer.masksToBounds=YES;
        _textView.layer.cornerRadius=2.5;
        _textView.backgroundColor =[UIColor whiteColor];
        //_textView.userInteractionEnabled=NO;
        self.textView.returnKeyType
        = UIReturnKeyDone;//返回键的类型
        _textView.scrollEnabled=YES;
        self.textView.keyboardType
        = UIKeyboardTypeDefault;//键盘类型
        _textView.editable = NO;
        _textView.tag=777;
        [self addSubview:_textView];
        
        
    }
    return self;
}

-(void)setTopicModel1:(topicModel *)topicModel1
{
    
    if ([NSString isBlankString:topicModel1.goodsFell]) {
        _textView.text = topicModel1.goodsImpression;
    }
    
    [self setupAutoHeightWithBottomViewsArray:@[_textView] bottomMargin:15];
    
    
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
