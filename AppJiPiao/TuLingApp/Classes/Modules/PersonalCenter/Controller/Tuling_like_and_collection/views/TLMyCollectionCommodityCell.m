//
//  TLMyCollectionCommodityCell.m
//  TuLingApp
//
//  Created by gyc on 2017/7/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLMyCollectionCommodityCell.h"
#import <Masonry.h>

@interface TLMyCollectionCommodityCell ()
@property (nonatomic,strong) UIButton * shareButton;
@property (nonatomic,strong) UIButton * buyButton;

@property (nonatomic,strong) UILabel * countLabel;

@property (nonatomic,strong) UILabel * priceLabel;
@property(nonatomic,strong) UILabel * orgPriceLabel;
@property(nonatomic,strong) UIView  *line;
@property(nonatomic,strong) UIView  *line2;
@end

@implementation TLMyCollectionCommodityCell{
    // 2.创建
    UIImageView  *photoView;
    UILabel *nameLabel;
   
    UILabel * _markLabel;
    UILabel *invalidLabel;
 
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self cellViewUISet];
    }
    return self;
}


-(void)cellViewUISet{

    
    photoView = [[UIImageView alloc]init];
    nameLabel = [[UILabel alloc]init];
    _markLabel = [[UILabel alloc]init];
    invalidLabel = [[UILabel alloc]init];
    
        photoView.frame = CGRectMake(15, 20, 150, 84);
        [photoView setImage:[UIImage imageNamed:@"22.png"]];
        [self.contentView addSubview:photoView];
        
        nameLabel.frame = CGRectMake(photoView.frame.size.width+ photoView.frame.origin.x+15, 20, WIDTH-40-photoView.frame.size.width- photoView.frame.origin.x, 25);
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        nameLabel.textColor = [UIColor colorWithHexString:@"#434343"];
        nameLabel.text = @"老字号第一大街‘大栅栏’的前世今生";
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:nameLabel];
    
        
        _markLabel.frame=CGRectMake(photoView.frame.size.width+ photoView.frame.origin.x+15, nameLabel.frame.origin.y + nameLabel.frame.size.height + 3, [NSString singeWidthForString:@"前世今" fontSize:13 Height:22]+24, 22);
        _markLabel.backgroundColor =[UIColor colorWithHexString:@"#EEEEEE"];
        _markLabel.textColor = [UIColor colorWithHexString:@"#828282"];
        _markLabel.text = @"四九城";
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.font = [UIFont systemFontOfSize:13];
        _markLabel.layer.masksToBounds=YES;
        _markLabel.layer.cornerRadius =2.5;
        [self.contentView addSubview:_markLabel];
        
    
    
        
//        invalidLabel.frame=CGRectMake(WIDTH-84, Label.frame.size.height+ Label.frame.origin.y+5, 60, 24);
 
        invalidLabel.textColor = [UIColor colorWithHexString:@"#828282"];
        invalidLabel.text = @"";
        invalidLabel.textAlignment = NSTextAlignmentRight;
        invalidLabel.font = [UIFont systemFontOfSize:13];
        invalidLabel.hidden=YES;
        [self.contentView addSubview:invalidLabel];
    [invalidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@18);
        make.bottom.equalTo(photoView).offset(3);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    invalidLabel.hidden = YES;
    
    
    self.priceLabel =  [[UILabel alloc] init];
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.font = TLFont_Regular_Size(13, 2);
    _priceLabel.textColor = [UIColor colorWithHexString:@"#919191"];
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@18);
        make.bottom.equalTo(photoView).offset(6);
        make.left.equalTo(photoView.mas_right).offset(15);
    }];
    
    UILabel * linet = [[UILabel alloc] init];
    linet.backgroundColor  = [UIColor colorWithHexString:@"#919191"];
    [_priceLabel addSubview:linet];
    
    [linet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.centerY.equalTo(_priceLabel);
        make.left.equalTo(_priceLabel).offset(-1);
        make.right.equalTo(_priceLabel).offset(1);
    }];
    
    
    self.orgPriceLabel = [[UILabel alloc] init];
    _orgPriceLabel.textAlignment = NSTextAlignmentLeft;
    _orgPriceLabel.font =[UIFont systemFontOfSize:16];
    _orgPriceLabel.textColor = [UIColor colorWithHexString:@"#ff5d36"];
    [self.contentView addSubview:_orgPriceLabel];
    
    [_orgPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@22);
        make.bottom.equalTo(_priceLabel.mas_top).offset(3);
        make.left.equalTo(photoView.mas_right).offset(15);
    }];
    

    self.countLabel = [[UILabel alloc] init];
    _countLabel.textColor = [UIColor colorWithHexString:@"#919191"];
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.font = TLFont_Regular_Size(14, 3);
    [self.contentView addSubview:_countLabel];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@18);
        make.bottom.equalTo(photoView).offset(6);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(_priceLabel.mas_right).offset(2);
    }];
    
    _countLabel.hidden = YES;
    
    
    
    self.buyButton = [self createButton];
    [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    self.buyButton.frame = CGRectMake(WIDTH - 105 - 15, 115 +11, 105, 28);
    [self.contentView addSubview:self.buyButton];
    self.buyButton.tag = 2;
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, self.buyButton.top-10 , WIDTH, SINGLE_LINE_WIDTH)];
    _line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.contentView addSubview:_line];
    
    self.shareButton = [self createButton];
    [self.shareButton setTitle:@"分享赚" forState:UIControlStateNormal];
    self.shareButton.frame = CGRectMake(WIDTH - 105 - 105 - 15 - 15,   115 +11, 105, 28);
    [self.contentView addSubview:self.shareButton];
    self.shareButton.tag = 1;
    
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@105);
        make.height.equalTo(@28);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-11);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@105);
        make.height.equalTo(@28);
        make.right.equalTo(self.buyButton.mas_left).offset(-15);
        make.centerY.equalTo(self.buyButton);
    }];
}

-(UIButton*)createButton{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 2.5;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor colorWithHexString:@"c6c6c6"].CGColor;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)buttonClick:(UIButton*)button{

    if (self.delegate && [self.delegate respondsToSelector:@selector(myCollectionCommodityCellEvent:cell:)]){
     
        [self.delegate myCollectionCommodityCellEvent:(int)button.tag cell:self];
    }
}

-(void)loadData:(NSDictionary *)dic{
    [photoView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
    nameLabel.text =dic[@"heading"];
    

    NSString  *a=dic[@"shoppingSpecialCategoryName"];
    if ([NSString isBlankString:a]) {
        _markLabel.text = dic[@"shoppingSpecialCategoryName"];
        if ([NSString singeWidthForString:_markLabel.text fontSize:13 Height:22]+24<WIDTH- photoView.frame.origin.x - photoView.frame.size.width - 15-15) {
            _markLabel.frame=CGRectMake(photoView.frame.size.width+ photoView.frame.origin.x+15, nameLabel.frame.origin.y + nameLabel.frame.size.height + 3, [NSString singeWidthForString:_markLabel.text fontSize:13 Height:22]+24, 22);
        }else
        {
            
            _markLabel.frame=CGRectMake(photoView.frame.size.width+ photoView.frame.origin.x+15, nameLabel.frame.origin.y + nameLabel.frame.size.height + 3, WIDTH- photoView.frame.origin.x - photoView.frame.size.width - 15-15, 22);
        }
    }else
    {
        _markLabel.frame=CGRectMake(photoView.frame.size.width+ photoView.frame.origin.x+15, nameLabel.frame.size.height + 3 + nameLabel.frame.origin.y, 0, 22);
    }
    
    if([NSString isBlankString:dic[@"price"]]){
        _orgPriceLabel.hidden = NO;
        _orgPriceLabel.text = [NSString stringWithFormat:@"¥%@",dic[@"price"]];
    }else{
        _orgPriceLabel.text = @"¥";
        _orgPriceLabel.hidden = YES;
    }
    
    if([NSString isBlankString:dic[@"orgPrice"]]){
        _priceLabel.hidden = NO;
        _priceLabel.text = [NSString stringWithFormat:@"市场价：¥%@",dic[@"orgPrice"]];
    }else{
        _priceLabel.text = @"市场价：";
        _priceLabel.hidden = YES;
    }
    
    
    
    
    if ([[NSString stringWithFormat:@"%@",dic[@"onSale"]] isEqualToString:@"0"]) {
      
        invalidLabel.hidden=NO;
        _countLabel.hidden = YES;
        invalidLabel.text=@"已下架";
        self.buyButton.hidden = YES;
        self.shareButton.hidden = YES;
        self.line.hidden = YES;
    }else
    {
        int a=[ [NSString stringWithFormat:@"%@",dic[@"stock"]] intValue];
     
        if (a<1) {
            
            invalidLabel.hidden=NO;
            _countLabel.hidden = YES;
            invalidLabel.text=@"已失效";
            self.buyButton.hidden = YES;
            self.shareButton.hidden = YES;
            self.line.hidden = YES;
        }else
        {
            invalidLabel.hidden=YES;
            _countLabel.hidden = NO;
            int count = [dic[@"count"] intValue];
            if (count < 0){
                count = 0;
            }
            NSString * countString = [NSString stringWithFormat:@"已售:%d",count];
            _countLabel.text = countString;
            self.buyButton.hidden = NO;
            self.shareButton.hidden = NO;
            self.line.hidden = NO;
        }
    }

}

@end
