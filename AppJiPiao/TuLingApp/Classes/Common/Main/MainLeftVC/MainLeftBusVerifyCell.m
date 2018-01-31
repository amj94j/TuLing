//
//  MainLeftBusVerifyCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MainLeftBusVerifyCell.h"

@implementation MainLeftBusVerifyCell

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
//    UILabel *title = [LXTControl createLabelWithFrame:CGRectMake(15*kWidthScale, 62*kWidthScale, kLeftVCWidth-30*kWidthScale, 20*kHeightScale) Font:16 Text:@"* 温馨提示"];
//    title.textColor = kColorFontBlack2;
//    [self.contentView addSubview:title];
//
//
//    NSString *str = @"您提交的身份信息客服正在验证中，请稍等......\n\n如有任何问题，可以和我们的客服联系，联系电话：400-6218-116";
//    CGSize size = [str sizeWithFont:15 andMaxSize:CGSizeMake(kLeftVCWidth-30*kWidthScale, 300)];
//    CGFloat titleY = CGRectGetMaxY(title.frame);
//    UILabel *detail = [LXTControl createLabelWithFrame:CGRectMake(15*kWidthScale, titleY+15*kWidthScale, size.width, size.height) Font:15 Text:str];
//
//    [self.contentView addSubview:detail];
//
//    CGFloat detailY = CGRectGetMaxY(detail.frame);
//    UIButton *backBtn = [LXTControl createBtnWithFrame:CGRectMake(65*kWidthScale, detailY+34*kWidthScale, kLeftVCWidth-130*kWidthScale, 34) titleName:@"返回个人中心" imgName:nil selImgName:nil target:self action:@selector(onBackBtnClick:)];
//    backBtn.titleLabel.font = kFontNol16;
//    backBtn.layer.masksToBounds = YES;
//    backBtn.layer.cornerRadius = 3;
//    backBtn.layer.borderWidth = 1;
//    backBtn.layer.borderColor = kColorAppGreen.CGColor;
//    [backBtn setTitleColor:kColorAppGreen forState:UIControlStateNormal];
//    [self.contentView addSubview:backBtn];
}

- (void) onBackBtnClick:(UIButton *) sender
{
//    if (self.backBtn) {
//        self.backBtn();
//    }
}

@end
