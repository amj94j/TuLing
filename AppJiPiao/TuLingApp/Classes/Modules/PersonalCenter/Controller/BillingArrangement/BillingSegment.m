//
//  BillingSegment.m
//  TuLingApp
//
//  Created by hua on 17/4/17.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BillingSegment.h"
@interface BillingSegment()
{
    CGFloat witdthFloat;
    UIView *buttonDownView;
    NSInteger selectSeugment;
    CGFloat lineFloat;
}
@end
@implementation BillingSegment
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.btnTitleSource=[NSMutableArray array];
        selectSeugment = 0;
    }
    return self;
}
+(BillingSegment *)segmentedControlFrame:(CGRect)frame titDataSource:(NSArray *)titleDataSouce backgorundColor:(UIColor *)backgroundColror titleColor:(UIColor *)titleColor
                               titleFont:(UIFont *)titleFont selectColor:(UIColor *)selectColor buttonDownColor:(UIColor *)buttonDoewnColor Delegate:(id)delegate;

{
    BillingSegment *smc = [[self alloc]initWithFrame:frame];
    smc.backgroundColor =backgroundColror;
    smc.buttonDownColor =buttonDoewnColor;

    smc.titleColor=titleColor;
    smc.titleFont=titleFont;
    smc.selectColor =selectColor;
    smc.delegate =delegate;
    [smc AddSegumentArray:titleDataSouce Frame:frame];
    
    return smc;
}
#pragma mark--根据数组长度创建滑竿Button
- (void)AddSegumentArray:(NSArray *)SegumentArray Frame:(CGRect)frame{
    //1.按钮的个数
    NSInteger seugemtNumber =SegumentArray.count;
    
    //2,按钮的宽度
    witdthFloat =(self.bounds.size.width)/seugemtNumber;
    lineFloat =[NSString singeWidthForString:SegumentArray[0] fontSize:15 Height:20]+30*WIDTH/375;
    //3.创建按钮
    
    
    for (int i=0; i<SegumentArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*witdthFloat, 0, witdthFloat, self.bounds.size.height)];
        [btn setTitle:SegumentArray[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:self.titleFont];
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        btn.tag =i;
        [btn addTarget:self action:@selector(changeSegumentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i==0) {
            buttonDownView=[[UIView alloc]initWithFrame:CGRectMake((WIDTH/2-lineFloat)/2, self.bounds.size.height-2, lineFloat, 1)];
            [buttonDownView setBackgroundColor:self.buttonDownColor];
            [self addSubview:buttonDownView];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-0.25, self.frame.size.height/2-10, 0.5, 20)];
            lab.backgroundColor = RGBCOLOR(198, 198, 198);
            [self addSubview:lab];

        }
        self.layer.borderWidth=1;
        self.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
        [self.btnTitleSource addObject:btn];
    }
    
    [[self.btnTitleSource firstObject] setSelected:YES];
    
}
-(void)changeSegumentAction:(UIButton *)btn
{
    [self selectTheSegument:btn.tag];
    
}

-(void)selectTheSegument:(NSInteger)segument{
    if (selectSeugment!=segument) {
        [self.btnTitleSource[selectSeugment] setSelected:NO];
        [self.btnTitleSource[segument] setSelected:YES];
        [buttonDownView setFrame:CGRectMake(segument*WIDTH/2+(WIDTH/2-lineFloat)/2, self.bounds.size.height-2, lineFloat, 1)];
        selectSeugment=segument;
        [self.delegate segumentSelectionChange:selectSeugment];
        
    }
    
}



@end
