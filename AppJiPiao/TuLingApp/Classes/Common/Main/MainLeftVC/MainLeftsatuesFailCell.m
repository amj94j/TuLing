//
//  MainLeftsatuesFailCell.m
//  TuLingApp
//
//  Created by hua on 2017/5/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MainLeftsatuesFailCell.h"

@implementation MainLeftsatuesFailCell
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
    
    UIImageView *myImage = [[UIImageView alloc]init];
    myImage.frame = CGRectMake((kLeftVCWidth-105*kHeightScale)/2, 62*kWidthScale, 20*kHeightScale, 20*kHeightScale);
    myImage.image =[UIImage imageNamed:@"error1.png"];
    [self.contentView addSubview:myImage];
    
    _title = [LXTControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(myImage.frame)+5*kHeightScale, 62*kWidthScale,80*kHeightScale , 20*kHeightScale) Font:18 Text:@"认证失败"];
    _title.font =[UIFont boldSystemFontOfSize:18];
    _title.textColor = kColorFontBlack2;
    [self.contentView addSubview:_title];
    
    
    NSString *str = @"失败原因: ";
    CGSize size = [str sizeWithFont:15 andMaxSize:CGSizeMake(kLeftVCWidth-30*kWidthScale, 300)];
    CGFloat titleY = CGRectGetMaxY(_title.frame);
    _detail = [LXTControl createLabelWithFrame:CGRectMake(15*kWidthScale, titleY+15*kWidthScale, size.width, size.height) Font:15 Text:str];
    
    [self.contentView addSubview:_detail];
    
    
    NSString *str1 = @"您提交的身份信息客服正在验证中，请稍等......\n\n如有任何问题，可以和我们的客服联系，联系电话：400-6218-116";
    CGSize size1 = [str1 sizeWithFont:15 andMaxSize:CGSizeMake(kLeftVCWidth-30*kWidthScale, 300)];
    CGFloat titleY1 = CGRectGetMaxY(_detail.frame);
    UILabel *detail1 = [LXTControl createLabelWithFrame:CGRectMake(15*kWidthScale, titleY1+15*kWidthScale, size1.width, size1.height) Font:15 Text:str1];
    [self.contentView addSubview:detail1];
    
    
    
    
    CGFloat detailY = CGRectGetMaxY(_detail1.frame);
    _mybackBtn = [LXTControl createBtnWithFrame:CGRectMake(65*kWidthScale, detailY+34*kWidthScale, kLeftVCWidth-130*kWidthScale, 34) titleName:@"返回个人中心" imgName:nil selImgName:nil target:self action:@selector(onBackBtnClick:)];
    _mybackBtn.titleLabel.font = kFontNol16;
    _mybackBtn.layer.masksToBounds = YES;
    _mybackBtn.layer.cornerRadius = 3;
    _mybackBtn.layer.borderWidth = 1;
    _mybackBtn.layer.borderColor = kColorAppGreen.CGColor;
    [_mybackBtn setTitleColor:kColorAppGreen forState:UIControlStateNormal];
    [self.contentView addSubview:_mybackBtn];
}

- (void) onBackBtnClick:(UIButton *) sender
{
    if (self.backBtn) {
        self.backBtn();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
