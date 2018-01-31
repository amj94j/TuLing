//
//  ShopOrderReturnDetailCell.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/22.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ShopOrderReturnDetailCell.h"

@implementation ShopOrderReturnDetailCell
{
    UILabel *_titleLab;
    UILabel *_timeLab;
    UILabel *_contentLab;
    
    UIView *_imgView;
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
    _titleLab = [createControl labelWithFrame:CGRectMake(15*kHeightScale, 20*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:16 Text:@"" LabTextColor:kColorFontBlack1];
    [self.contentView addSubview:_titleLab];
    
    
    _timeLab = [createControl labelWithFrame:CGRectMake(15*kHeightScale, 20*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:13 Text:@"" LabTextColor:kColorFontBlack3];
    _timeLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLab];
    
    
    _contentLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 50*kHeightScale, WIDTH-30*kWidthScale, 20*kHeightScale) Font:15 Text:@"" LabTextColor:kColorFontBlack1];
    _contentLab.numberOfLines = 0;
    [self.contentView addSubview:_contentLab];
    
    
    _imgView = [[UIView alloc]init];
    [self.contentView addSubview:_imgView];
}

- (void)setModel:(ShopOrderREturnDetailConsultsModel *)model
{
    _model = model;
    

    _timeLab.text = model.createTime;
    
    if (model.isShop) { // 商家
        _titleLab.text = @"商家:";
    } else {
        _titleLab.text = @"买家:";
    }
    
    _contentLab.text = model.content;
    CGSize size = [model.content sizeWithFont:15 andMaxSize:CGSizeMake(WIDTH-30*kHeightScale, 200)];
    CGRect frame = _contentLab.frame;
    frame.size.height = size.height;
    _contentLab.frame = frame;
    
    
    CGFloat imgViewY = CGRectGetMaxY(_contentLab.frame);
    
    
    NSInteger count = model.shopOrderRetrunImgs.count;
    NSInteger rowCount = 3;
    if (count != 0) {
        
        _imgView.hidden = NO;
        
        CGFloat width = 94*kWidthScale;
        
        NSInteger row = 0;
        if (count % rowCount == 0) {
            row = count/rowCount;
        } else {
            row = count/rowCount+1;
        }
        
        NSInteger rank = rowCount;
        for (int i = 0; i<row; i++) {
            if (i == row-1) {
                if (count % rowCount != 0) {
                    rank = count % rowCount;
                }
            }
            for (int j=0; j<rank; j++) {
                
                NSDictionary *imgDict = model.shopOrderRetrunImgs[i*rowCount+j];
                
                UIImageView *imgView = [LXTControl createImageViewWithFrame:CGRectMake((width+5)*j, (width+5*kWidthScale)*i, width, width) ImageName:nil];
                [imgView sd_setImageWithURL:[NSURL URLWithString:imgDict[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@""]];
                [_imgView addSubview:imgView];
            }
        }
        
        _imgView.frame = CGRectMake(15*kWidthScale, imgViewY+15*kHeightScale, WIDTH-30*kWidthScale, row*(width+5*kHeightScale));
        
        imgViewY = imgViewY + 15*kHeightScale + row*(width+5*kHeightScale);
    } else {
        _imgView.hidden = YES;
    }
}

@end
