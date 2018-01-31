//
//  PassageSelectInsuraCell.m
//  ticket
//
//  Created by LQMacBookPro on 2017/12/13.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "PassageSelectInsuraCell.h"
#import "TicketPassengerModel.h"


static NSString * pasgSeleInsure = @"pasgSeleInsure";

@interface PassageSelectInsuraCell()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewWidthConst;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation PassageSelectInsuraCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lineViewWidthConst.constant = kFitRatio(160);
    
    [self drawDashLine:self.lineView lineLength:3 lineSpacing:2 lineColor:TLColor(238, 238, 238, 1)];
    
}

+ (instancetype)passageSelectInsureCellWithTableView:(UITableView *)tableView
{
    PassageSelectInsuraCell * cell = [tableView dequeueReusableCellWithIdentifier:pasgSeleInsure];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    }
    return cell;
    
}

- (void)setModel:(TicketPassengerModel *)model
{
    _model = model;
    
    self.nameLabel.text = model.personName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
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
