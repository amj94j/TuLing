//
//  LogisticsTopCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/27.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "LogisticsTracesCell.h"

@implementation LogisticsTracesCell
{
    UILabel *_contentLab;
    UILabel *_timeLab;
    UILabel *_line1;
    UILabel *_line2;
    UILabel *_yuan;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void) createSubviews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _contentLab = [LXTControl createLabelWithFrame:CGRectMake(60, 15, WIDTH-75, 20) Font:15 Text:nil];
    _contentLab.numberOfLines = 2;
    [self.contentView addSubview:_contentLab];
    
    CGFloat companyLabY = CGRectGetMaxY(_contentLab.frame);
    _timeLab = [LXTControl createLabelWithFrame:CGRectMake(60, companyLabY+5, WIDTH-75, 15) Font:12 Text:nil];
    [self.contentView addSubview:_timeLab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(60, 84, WIDTH-70, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
    [self.contentView addSubview:line];
    
    
    _line1 = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 1, 20)];
    _line1.backgroundColor = [UIColor colorWithHexString:@"#F2F2F3"];
    [self.contentView addSubview:_line1];
    
    _yuan = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 11, 11)];
    [self.contentView addSubview:_yuan];
    _yuan.layer.masksToBounds = YES;
    _yuan.layer.cornerRadius = 5.5
    ;
    
    _line2 = [[UILabel alloc]initWithFrame:CGRectMake(25, 30, 1, 55)];
    _line2.backgroundColor = [UIColor colorWithHexString:@"#F2F2F3"];
    [self.contentView addSubview:_line2];
}

- (void)setModel:(TracesModel *)model
{
    _model = model;
    
    _contentLab.text = model.acceptStation;
    _timeLab.text = model.acceptTime;
    
    CGSize size = [_contentLab.text sizeWithFont:15 andMaxSize:CGSizeMake(WIDTH-75, 40)];
    CGRect frame = _contentLab.frame;
    frame.size = size;
    _contentLab.frame = frame;
    
    CGFloat companyLabY = CGRectGetMaxY(_contentLab.frame);
    _timeLab.frame = CGRectMake(60, companyLabY+5, WIDTH-75, 15);
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    if (index == 0) {
        _contentLab.textColor = [UIColor colorWithHexString:@"#6dcb99"];
        _timeLab.textColor= [UIColor colorWithHexString:@"#6dcb99"];
        _yuan.backgroundColor = [UIColor colorWithHexString:@"#6dcb99"];
        _line1.hidden = YES;
        _line2.hidden = NO;
    } else {
        _contentLab.textColor = [UIColor colorWithHexString:@"#919191"];
        _timeLab.textColor= [UIColor colorWithHexString:@"#919191"];
        _yuan.backgroundColor = [UIColor colorWithHexString:@"#F2F2F3"];
        if (index == 1) {
            _line1.hidden = NO;
            _line2.hidden = NO;
        } else {
            _line1.hidden = NO;
            _line2.hidden = YES;
        }
    }
}

@end
