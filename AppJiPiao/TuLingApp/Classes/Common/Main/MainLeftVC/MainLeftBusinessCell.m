//
//  MainLeftBusinessCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MainLeftBusinessCell.h"

@implementation MainLeftBusinessCell

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
//    NSArray *items1 = @[@"商品上传", @"我要发货"];
    
    int rankCount = 3;
    
    CGFloat width = kLeftVCWidth/rankCount;
//    CGFloat height = 95*kHeightScale;
    
//    for (int i=0; i<2; i++) {
//
//        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(width*i, 0, width, height)];
//        bgView.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:bgView];
//
//
//        CGFloat viewWidth = bgView.frame.size.width;
//
//        UILabel *titleLab = [LXTControl createLabelWithFrame:CGRectMake(0, 50*kHeightScale, viewWidth, 18*kHeightScale) Font:15 Text:items1[i]];
//        titleLab.textColor = [UIColor colorWithHexString:@"#434343"];
//        titleLab.textAlignment = NSTextAlignmentCenter;
//        [bgView addSubview:titleLab];
//
//
//        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"btn_mineBus%zd", i]];
//        CGFloat imgWidth = img.size.width;
//        CGFloat imgHeight = img.size.height;
//
//        UIImageView *imgView = [LXTControl createImageViewWithFrame:CGRectMake(viewWidth/2-imgWidth/2, 47*kHeightScale-imgHeight, imgWidth, imgHeight) ImageName:nil];
//        imgView.image = img;
//        [bgView addSubview:imgView];
//
//
//
//        UIButton *btn = [LXTControl createButtonWithFrame:bgView.bounds ImageName:nil Target:self Action:@selector(onSection1ItemClick:) Title:nil];
//        btn.tag = i + 200;
//        [bgView addSubview:btn];
//    }
//
//
//    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15*kWidthScale, 95*kWidthScale, kLeftVCWidth-30*kWidthScale, 0.5*kWidthScale)];
//    line.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
//    [self.contentView addSubview:line];
    
    
    //NSArray *items = @[@"商品管理", @"订单管理", @"账单管理", @"退货退款", @"评价回复", @"客服消息"];
     NSArray *items = @[@"券码核销", @"验证历史", @"相册管理", @"商品管理", @"账单管理"];
    NSInteger count = items.count;
    
    CGFloat height2 = 85*kHeightScale;
    
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
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(width*j, height2*i, width, height2)];
            bgView.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:bgView];
            
            
            CGFloat viewWidth = bgView.frame.size.width;
            
            UILabel *titleLab = [LXTControl createLabelWithFrame:CGRectMake(0, 50*kHeightScale, viewWidth, 18*kHeightScale) Font:15 Text:items[page]];
            titleLab.textColor = [UIColor colorWithHexString:@"#434343"];
            titleLab.textAlignment = NSTextAlignmentCenter;
            [bgView addSubview:titleLab];
            
            
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"btn_mineBusItem%zd", page]];
            CGFloat imgWidth = img.size.width;
            CGFloat imgHeight = img.size.height;
            
            UIImageView *imgView = [LXTControl createImageViewWithFrame:CGRectMake(viewWidth/2-imgWidth/2, 47*kHeightScale-imgHeight, imgWidth, imgHeight) ImageName:nil];
            imgView.image = img;
            [bgView addSubview:imgView];
            
            
            
            UIButton *btn = [LXTControl createButtonWithFrame:bgView.bounds ImageName:nil Target:self Action:@selector(onSection2ItemClick:) Title:nil];
            btn.tag = page;
            [bgView addSubview:btn];
        }
    }
}

- (void) onSection1ItemClick:(UIButton *) sender
{
    if (self.item1) {
        self.item1(sender);
    }
}

- (void) onSection2ItemClick:(UIButton *) sender
{
    if (self.item2) {
        self.item2(sender);
    }
}

@end
