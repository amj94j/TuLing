//
//  MainLeftSecondCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MainLeftSecondCell.h"

@implementation MainLeftSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createContentSubview];
    }
    return self;
}

- (void) createContentSubview
{
    NSArray *items = @[@"行程", @"订单", @"收藏", @"关注的人", @"商品评价", @"消息", @"分享统计", @"我要推荐"];
    NSInteger count = items.count;
    int rankCount = 3;
    
    CGFloat width = kLeftVCWidth/rankCount;
    CGFloat height = 80*kHeightScale;
    
    NSInteger row = 0;
    if (count % rankCount == 0) {
        row = count/rankCount;
    } else {
        row = count/rankCount + 1;
    }
    NSInteger rank = rankCount;
    for (int i = 0; i<row; i++) {
        
        if (i == row-1) {
            if (count % rankCount != 0) {
                rank = count % rankCount;
            }
        }
        for (int j=0; j<rank; j++) {
            
            NSInteger page = i*rankCount+j;
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(width*j, height*i, width, height)];
            bgView.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:bgView];
            
            
            CGFloat viewWidth = bgView.frame.size.width;
            
            UILabel *titleLab = [LXTControl createLabelWithFrame:CGRectMake(0, 47*kHeightScale, viewWidth, 18*kHeightScale) Font:15 Text:items[page]];
            titleLab.textColor = [UIColor colorWithHexString:@"#434343"];
            titleLab.textAlignment = NSTextAlignmentCenter;
            [bgView addSubview:titleLab];
            
            UIImage *img = nil;
            if (page==5) {
                if (![_isNews isEqualToString:@"0"]&&_isNews) {
                    img = [UIImage imageNamed:@"btn_mineItem20"];
                }else{
                    img = [UIImage imageNamed:[NSString stringWithFormat:@"btn_mineItem%zd", page+1]];
                }
            }else{
                img = [UIImage imageNamed:[NSString stringWithFormat:@"btn_mineItem%zd", page+1]];
            }
            CGFloat imgWidth = img.size.width;
            CGFloat imgHeight = img.size.height;
            
            UIImageView *imgView = [LXTControl createImageViewWithFrame:CGRectMake(viewWidth/2-imgWidth/2, 44*kHeightScale-imgHeight, imgWidth, imgHeight) ImageName:nil];
            imgView.image = img;
            imgView.tag=page+5000;
            [bgView addSubview:imgView];
            
            
            
            UIButton *btn = [LXTControl createButtonWithFrame:bgView.bounds ImageName:nil Target:self Action:@selector(onItemClick:) Title:nil];
            btn.tag = page + 100;
            [bgView addSubview:btn];
        }
    }
}

- (void) onItemClick:(UIButton *) sender
{
    if (self.itemsClick) {
        self.itemsClick(sender);
    }
}

@end
