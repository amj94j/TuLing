//
//  FlightInforAlertView.m
//  ticket
//
//  Created by LQMacBookPro on 2017/12/13.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "FlightInforAlertView.h"

#import "TicketOrderDetailsCell.h"

@interface FlightInforAlertView()

@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation FlightInforAlertView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    TicketOrderDetailsCell * cellView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TicketOrderDetailsCell class]) owner:nil options:nil][0];
    
    cellView.frame = self.bounds;
    
    [self addSubview:cellView];
    
}

- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end
