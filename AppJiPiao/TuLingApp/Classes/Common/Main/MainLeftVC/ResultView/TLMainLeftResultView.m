//
//  TLMainLeftResultView.m
//  TuLingApp
//
//  Created by 最印象 on 2017/10/11.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLMainLeftResultView.h"
#import "TLMainLeftEnterResultView.h"
#import "TLMainLeftEnterHintView.h"
#import "TLMainLeftBottomHintView.h"

@interface TLMainLeftResultView(){
   
    TLMainLeftEnterHintView * _hintView;
    TLMainLeftEnterResultView * _resultView;
    UIButton * _confrimButton;
    TLMainLeftBottomHintView * _inforView;
}
@property (nonatomic,copy) TLMainLeftResultViewEventBlock eventBlock;
@property (nonatomic,strong) NSDictionary * resultDic;
@end

@implementation TLMainLeftResultView

-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary*)dic{
    self = [super initWithFrame:frame];
    if (self){
        self.resultDic = dic;
        [self viewUISet];
    }
    return self;
}

-(void)resultEvent:(TLMainLeftResultViewEventBlock)block{
    self.eventBlock = block;
}

-(void)viewUISet{
    
    _inforView = [[TLMainLeftBottomHintView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 94, self.frame.size.width, 94)];
    [self addSubview:_inforView];
    
    CGFloat topspace = 0;
    int style = [self.resultDic[@"style"] intValue];
    NSString* titleString = self.resultDic[@"pointDesc"];
    if (style == 1){
        //提示信息
        _hintView = [[TLMainLeftEnterHintView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200) title:titleString];
        [self addSubview:_hintView];
        topspace = 200 + 50;
    }else{
        //结果icon
        int result = 0;
        if (style == 2){
            result = 1;
        }else{
            result = 2;
        }
        _resultView = [[TLMainLeftEnterResultView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200) result:result title:titleString];
        [self addSubview:_resultView];
        topspace = 200 + 50;
    }

    NSString* buttonString = self.resultDic[@"button"];

    [self createButton:CGRectMake((self.frame.size.width - 200) / 2.0, topspace, 200, 30) title:buttonString];
}

-(void)createButton:(CGRect)frame title:(NSString*)title{
    if (![NSString isBlankString:title]){
        return;
    }
    _confrimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confrimButton.frame = frame;
    [self addSubview:_confrimButton];
    _confrimButton.titleLabel.font = TLFont_Regular_Size(16, 0);
    [_confrimButton setTitle:title forState:UIControlStateNormal];
    _confrimButton.backgroundColor = [UIColor whiteColor];
    [_confrimButton setTitleColor:[UIColor colorWithHexString:@"#6dcb99"] forState:UIControlStateNormal];
    _confrimButton.layer.cornerRadius = 2.5;
    _confrimButton.layer.borderColor = [UIColor colorWithHexString:@"#6dcb99"].CGColor;
    _confrimButton.layer.borderWidth = 0.5;
    [_confrimButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonClick:(UIButton*)button{
    if(self.eventBlock){
        self.eventBlock();
    }
}

-(void)updateInfomation:(NSDictionary *)dictionary{
    if (self.resultDic != dictionary){
        self.resultDic = dictionary;
        [_hintView removeFromSuperview];
        [_resultView removeFromSuperview];
        [_confrimButton removeFromSuperview];
        [_inforView removeFromSuperview];
        [self viewUISet];
    }
}



@end
