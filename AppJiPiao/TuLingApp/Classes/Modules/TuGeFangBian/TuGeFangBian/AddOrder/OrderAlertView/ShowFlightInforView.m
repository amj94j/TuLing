//
//  ShowFlightInforView.m
//  ticket
//
//  Created by LQMacBookPro on 2017/12/13.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "ShowFlightInforView.h"

#import "FlightInforAlertView.h"

#import "TicketOrderDetailsCell.h"

#import "SearchFlightsModel.h"
#import "TLTicketModel.h"

@interface ShowFlightInforView()

@property (nonatomic, weak)UIButton * maskBtn;

@property (nonatomic, strong)SearchFlightsModel * model;

@end

@implementation ShowFlightInforView

+ (ShowFlightInforView *)showFlightInforWithModel:(SearchFlightsModel *)model
{
    ShowFlightInforView * showFlightView = [[ShowFlightInforView alloc]init];
    
    showFlightView.frame = CGRectMake(0, 0, TLScreenWidth, TLScreenHeight);
    
    showFlightView.model = model;
    
    return showFlightView;
}

- (ShowFlightInforView *)initFlightInfoWithModel:(SearchFlightsModel *)model
{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, TLScreenWidth, TLScreenHeight);
        
        self.model = model;
        
        //添加蒙版
        [self addMasView];
        
        //添加cellView
        [self addFlightCell];
        
        self.model = model;
        
    }
    return self;
}

//- (instancetype)init
//{
//    if (self = [super init]) {
//
//        //添加蒙版
//        [self addMasView];
//
//        //添加cellView
//        [self addFlightCell];
//
//    }
//    return self;
//}

- (void)addMasView
{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TLScreenWidth, TLScreenHeight)];
    
    btn.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.5];
    //    btn.backgroundColor = [UIColor redColor];
    
    [self addSubview:btn];
    
    self.maskBtn = btn;
    
    [btn addTarget:self action:@selector(disMaskViewDismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addFlightCell
{
    TicketOrderDetailsCell * cellView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TicketOrderDetailsCell class]) owner:nil options:nil][0];
    cellView.backgroundColor = [UIColor clearColor];
    cellView.isBGImage = YES;
    CGFloat cellY = TLScreenHeight * 0.2;
    
    cellView.y = cellY;
    
    CGFloat cellWidth = PXChange(697);
    
    cellView.width = cellWidth;
    
    cellView.centerX = self.maskBtn.centerX;
    
    if (self.model.flightType == OrderFlightTypeDanCheng) {
        [cellView refreshData:self.model type:@""];
    }else if (self.model.flightType == OrderFlightTypeWangFanGo){
        [cellView refreshData:self.model type:@"去"];
    }else if (self.model.flightType == OrderFlightTypeWangFanBack){
        [cellView refreshData:self.model type:@"返"];
    }else{
        [cellView refreshData:self.model type:@""];
    }
    
    
    
    //模型赋值
    [self.maskBtn addSubview:cellView];
}


- (void)disMaskViewDismiss
{
    [self removeFromSuperview];
}

@end

