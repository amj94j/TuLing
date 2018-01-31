//
//  SelectFlightConditionCell.m
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "SelectFlightConditionCell.h"

@implementation SelectFlightConditionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isSelect = NO;
        [self createContentSubview];
    }
    return self;
}

- (void)createContentSubview {
    self.topTextLabel = [[UILabel alloc] initWithFrame:CGRectMake( PXChange(30), 0, self.width-PXChange(200), self.height)];
    self.topTextLabel.textColor = [UIColor colorWithHexString:@"#919191"];
    self.topTextLabel.font = [UIFont systemFontOfSize:PXChange(30)];
    [self addSubview:self.topTextLabel];
    
    WS(ws)
    
    self.tailImage = [[UIImageView alloc] init];
    self.tailImage.image = [UIImage imageNamed:@"selectflight_uncheck"];
    self.tailImage.contentMode = UIViewContentModeCenter;
    
    [self addSubview:self.tailImage];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottom-PXChange(1), self.width, PXChange(1))];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    [self addSubview:lineView];
    
    [ws.tailImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws);
        make.right.offset(-PXChange(30));
    }];
    
    [ws.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws);
        make.left.offset(PXChange(30));
        make.size.mas_equalTo(CGSizeMake(ws.width-PXChange(60)-ws.tailImage.width, ws.height));
    }];
    
}

- (void)hiddenIconImageWith:(NSString *)airlineCode hidden:(BOOL)hidden {
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PXChange(30), (self.height-15)/2, 15, 15)];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://images.touring.com.cn/images/air/%@.png",airlineCode]] placeholderImage:[UIImage imageNamed:@"logo_l"]];
    [self addSubview:iconImageView];
    iconImageView.hidden = hidden;
    self.topTextLabel.frame = CGRectMake(iconImageView.right+3, 0, self.width-PXChange(200)-18, self.height);
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
