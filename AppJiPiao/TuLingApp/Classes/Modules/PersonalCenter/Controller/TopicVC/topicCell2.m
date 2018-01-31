//
//  topicCell2.m
//  TuLingApp
//
//  Created by hua on 17/4/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "topicCell2.h"
#import "UIView+SDAutoLayout.h"
#import <Masonry.h>
#define kMaxWordNumber 200

@interface topicCell2 ()<UITextViewDelegate>
@property (nonatomic,strong) UILabel * residueLabel;

@property (nonatomic,strong) UILabel * hintLabel;
@end

@implementation topicCell2
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"topicCell2ID";
    // 1.缓存中取
    topicCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[topicCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _name.text = @"评价";
        [self addSubview:_name];
        
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(15);
            make.width.equalTo(self).offset(-15);
            make.height.equalTo(@20);
        }];
        
        _lineLabel = [createControl createLineWithFrame:CGRectMake(15, CGRectGetMaxY(_name.frame)+15, WIDTH-30, 0.5) labelLineColor:RGBCOLOR(238, 238, 238)];
        [self addSubview:_lineLabel];
        
        
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_lineLabel.frame)+17, WIDTH-30, 83)];
        [_textView setTextColor:[UIColor colorWithHexString:@"#434343"]];
        [_textView setFont:[UIFont systemFontOfSize:15]];
//        [_textView.layer setBorderWidth:0.5f];
//        _textView.layer.borderColor = RGBCOLOR(238, 238, 238).CGColor;
        //[_textView setDelegate:self];
//        _textView.layer.masksToBounds=YES;
//        _textView.layer.cornerRadius=2.5;
        _textView.backgroundColor =[UIColor whiteColor];
        //_textView.userInteractionEnabled=NO;
        _textView.delegate = self;
        self.textView.returnKeyType
        = UIReturnKeyDone;//返回键的类型
        _textView.scrollEnabled=YES;
        self.textView.keyboardType
        = UIKeyboardTypeDefault;//键盘类型
        _textView.editable = NO;
        _textView.tag=666;
        [self addSubview:_textView];
        self.hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 4, _textView.frame.size.width - 10, 25)];
        _hintLabel.textAlignment = NSTextAlignmentLeft;
        _hintLabel.font = [UIFont systemFontOfSize:14];
        _hintLabel.text = @"(听小伙伴们说15个字以上的评价能够生金~)";
        _hintLabel.textColor = [UIColor colorWithHexString:@"#939393"];
        [_textView addSubview:_hintLabel];
        
        self.residueLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 15 - 50, CGRectGetMaxY(_textView.frame) + 2, 50, 13)];
        _residueLabel.textColor = [UIColor colorWithHexString:@"#939393"];
        _residueLabel.textAlignment = NSTextAlignmentRight;
        
        NSString * num = @"0";
        NSString * string =@"0/200";
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:string];
        NSRange range = [string rangeOfString:num];
        
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6dcb99"] range:range];
        self.residueLabel.attributedText = attStr;
        
        _residueLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.residueLabel];
    }
    return self;
}

-(void)showTextViewHint{
    
    if ([NSString isBlankString:_textView.text]){
    self.hintLabel.hidden = YES;
    }else{
    self.hintLabel.hidden = NO;
    }
    
}
-(void)hiddenTextViewHint{
    self.hintLabel.hidden = YES;
}
-(void)setTopicModel1:(topicModel *)topicModel1
{
    
    if ([NSString isBlankString:topicModel1.goodsComment]) {
        _textView.text = topicModel1.goodsComment;
        [self hiddenTextViewHint];
        [self stringLength:_textView];
    }else{
        [self showTextViewHint];
    }
     [self setupAutoHeightWithBottomViewsArray:@[_textView] bottomMargin:15];
}

-(void)changeWordNumber:(NSInteger)change total:(NSInteger)totalNumber{

    NSString * num = [NSString stringWithFormat:@"%ld",change];
    
    NSString * string = [NSString stringWithFormat:@"%@/%ld",num,totalNumber];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:num];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6dcb99"] range:range];
    
    self.residueLabel.attributedText = attStr;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [self hiddenTextViewHint];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    [self showTextViewHint];
    return YES;
}

#pragma mark--textView代理方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    //博客园-FlyElephant
    
    static CGFloat maxHeight = 83.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<=frame.size.height) {
        size.height=frame.size.height;
    }else{
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    
    if (kMaxWordNumber > 0){
        [self stringLength:textView];
    }
    if (self.topicModel1){
        self.topicModel1.goodsComment = textView.text;
    }
//    if (_dataModelArr.count!=0) {
//        model =_dataModelArr[0];
//        model.goodsComment =textView.text;
//    }else{
//        impressStr=textView.text;
//    }
    
}

-(void)stringLength:(UITextView*)textView{
    
    NSString *toBeString = textView.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > kMaxWordNumber)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:kMaxWordNumber];
            if (rangeIndex.length == 1)
            {
                textView.text = [toBeString substringToIndex:kMaxWordNumber];
                [self changeWordNumber:200 total:200];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, kMaxWordNumber)];
                textView.text = [toBeString substringWithRange:rangeRange];
                [self changeWordNumber:200 total:200];
            }
        }else{
            
            [self hiddenTextViewHint];
            [self changeWordNumber:toBeString.length total:kMaxWordNumber];
        }
    }
}



@end
