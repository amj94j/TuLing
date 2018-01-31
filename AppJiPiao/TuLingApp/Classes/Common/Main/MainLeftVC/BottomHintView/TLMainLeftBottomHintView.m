//
//  TLMainLeftBottomHintView.m
//  TuLingApp
//
//  Created by 最印象 on 2017/10/11.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLMainLeftBottomHintView.h"
#import "createControl.h"
@implementation TLMainLeftBottomHintView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self viewUISet];
    }
    return self;
}

-(void)viewUISet{
    UIView * topView  = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 30, 0.5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self addSubview:topView];
    UILabel * label = [createControl createHaveSpaceLabelWithFrame:CGRectMake(15, 15, self.frame.size.width - 30, self.frame.size.height - 30) Font:13 Text:@"如有任何问题，可以和我们的客服联系\n服务时间：周一至周五 09:00-18:00\n联系电话：400-6218-116\n邮箱：tlkf@bjhuazhuo.com" TextAlignment:@"0" LabBackgroundColor:[UIColor whiteColor] LabTextColor:[UIColor colorWithHexString:@"#919191"] cornerRadius:0 labBorderColor:nil lineSpace:3 wordSpace:0];
//    label.font = TLFont_Regular_Size(13, 0);
    [self addSubview:label];
}

@end
