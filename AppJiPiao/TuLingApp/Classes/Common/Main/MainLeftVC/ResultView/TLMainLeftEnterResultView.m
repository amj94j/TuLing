//
//  TLMainLeftEnterResultView.m
//  TuLingApp
//
//  Created by 最印象 on 2017/10/11.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLMainLeftEnterResultView.h"

@implementation TLMainLeftEnterResultView

-(instancetype)initWithFrame:(CGRect)frame result:(int)result title:(NSString*)title{
    self = [super initWithFrame:frame];
    if(self){
        [self viewUISet:result title:title];
    }
    return self;
}
-(void)viewUISet:(int)result title:(NSString*)title{
    CGFloat topSpace = 0;
    UIImage * resultImage = nil;
    NSString * reultString = nil;
    if (result == 1){
        topSpace = 40;
        resultImage = [UIImage imageNamed:@"TLMainLeftResutl_falseIcon"];
        reultString = title;
    }else{
        topSpace = 55;
        resultImage = [UIImage imageNamed:@"TLMainLeftResutl_rightIcon"];
        reultString = title;
    }
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 44)/2.0, topSpace, 44, 44)];
    imageView.image = resultImage;
    [self addSubview:imageView];
    
    UILabel * label = [createControl createSpaceLabelWithFrame:CGRectMake(15,CGRectGetMaxY(imageView.frame) + 15, self.frame.size.width - 30, 100) Font:TLFont_Semibold_Size(16, 0) Text:reultString TextAlignment:@"1" LabBackgroundColor:[UIColor whiteColor] LabTextColor:[UIColor colorWithHexString:@"#434343"] cornerRadius:0 labBorderColor:nil lineSpace:0 wordSpace:0];
    [self addSubview:label];
}
@end
