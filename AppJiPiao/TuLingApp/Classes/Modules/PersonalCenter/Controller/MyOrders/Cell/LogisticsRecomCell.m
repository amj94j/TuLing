//
//  LogisticsRecommend.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/27.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "LogisticsRecomCell.h"

#define kTag 30000

@implementation LogisticsRecomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    CGFloat width = WIDTH/2-20;
    CGFloat height = 180;
    
    NSInteger row = 0;
    if (dataSource.count%2 == 0) {
        row = dataSource.count/2;
    } else {
        row = dataSource.count/2+1;
    }
    NSInteger rank = 2;
    for (int i = 0; i<row; i++) {
        
        if (i == row-1) {
            if (dataSource.count%2 != 0) {
                rank = 1;
            }
        }
        for (int j=0; j<rank; j++) {
            BrandProductPojoModel *model = _dataSource[i*2+j];
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15+(width+10)*j, 10+(height+10)*i, width, height)];
            bgView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
            bgView.layer.masksToBounds = YES;
            bgView.layer.cornerRadius = 3;
            bgView.layer.borderWidth = 0.5;
            bgView.layer.borderColor = [UIColor colorWithHexString:@"#CDCDCD"].CGColor;
            [self.contentView addSubview:bgView];
        
            CGFloat viewWidth = bgView.frame.size.width;
            UIImageView *imgView = [LXTControl createImageViewWithFrame:CGRectMake(0, 0, viewWidth, 110) ImageName:nil];
            [imgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@""]];
            [bgView addSubview:imgView];
            
            UILabel *titleLab = [LXTControl createLabelWithFrame:CGRectMake(7, 120, viewWidth-14, 20) Font:15 Text:model.name];
            titleLab.textColor = [UIColor colorWithHexString:@"#434343"];
            [bgView addSubview:titleLab];
            
            UILabel *moneyLab = [LXTControl createLabelWithFrame:CGRectMake(7, 155, viewWidth-14, 20) Font:15 Text:[NSString stringWithFormat:@"¥%0.2f", model.price]];
            moneyLab.textColor = [UIColor colorWithHexString:@"#F96500"];
            [bgView addSubview:moneyLab];
            
            
            UILabel *numLab = [LXTControl createLabelWithFrame:CGRectMake(7, 155, viewWidth-14, 20) Font:15 Text:[NSString stringWithFormat:@"已售%zd",model.saleCount]];
            numLab.textAlignment = NSTextAlignmentRight;
            numLab.textColor = [UIColor colorWithHexString:@"#919191"];
            [bgView addSubview:numLab];
            
            
            UIButton *btn = [LXTControl createButtonWithFrame:bgView.bounds ImageName:nil Target:self Action:@selector(onBtnClick:) Title:nil];
            btn.tag = kTag+i*rank+j;
            [bgView addSubview:btn];
            
            
            if (isIPHONE6) {
                numLab.font = [UIFont systemFontOfSize:10];
            } else if (isIPHONE6P) {
                numLab.font = [UIFont systemFontOfSize:10];
            }
        }
    }
}

- (void) onBtnClick:(UIButton *) sender
{
    if (self.likeProductBtn) {
        self.likeProductBtn(sender.tag-kTag);
    }
}

@end
