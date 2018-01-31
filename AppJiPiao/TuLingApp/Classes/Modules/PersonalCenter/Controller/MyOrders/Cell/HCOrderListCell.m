//
//  HCOrderListCell.m
//  TuLingApp
//
//  Created by 李立达 on 2017/8/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "HCOrderListCell.h"

@interface HCOrderListCell ()
@property (strong,nonatomic)UILabel     *orderNumber;
@property (strong,nonatomic)UILabel     *orderTypeLable;
@property (strong,nonatomic)UIView      *line;
@property (strong,nonatomic)UIImageView *phontView;
@property (strong,nonatomic)UILabel     *titleLable;
@property (strong,nonatomic)UILabel     *proctucCount;
@property (strong,nonatomic)UILabel     *descriptionLable;
@property (strong,nonatomic)UILabel     *pricetLabel;
@property (strong,nonatomic)UILabel     *dateLable;
@end

@implementation HCOrderListCell
{
    NSDateFormatter *formatter;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        formatter =[[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
    }
    return self;
}

-(void)createSubviews
{
    self.orderNumber = [[UILabel alloc]init];
    self.orderNumber.font = [UIFont fontWithName:FONT_REGULAR size:16*SCALEPhoneWIDTH];
    self.orderNumber.textColor =[UIColor colorWithHexString:@"#434343"];
    self.orderNumber.text = @"订单编号：201609231440999";
    [self.orderNumber sizeToFit];
    self.orderNumber.frame = CGRectMake(15, 0, self.orderNumber.width, 50*SCALEPhoneWIDTH);
    [self.contentView addSubview:self.orderNumber];
    
    self.orderTypeLable = [[UILabel alloc]init];
    self.orderTypeLable.font = [UIFont fontWithName:FONT_REGULAR size:16*SCALEPhoneWIDTH];
    self.orderTypeLable.textColor =[UIColor colorWithHexString:@"#FC5D3F"];
    self.orderTypeLable.text = @"退款完成了";
    [self.orderTypeLable sizeToFit];
    self.orderTypeLable.frame = CGRectMake(mainScreenWidth-15-self.orderTypeLable.width, 0, self.orderTypeLable.width, 50*SCALEPhoneWIDTH);
    [self.contentView addSubview:self.orderTypeLable];
    
    
    self.line = [[UIView alloc]init];
    _line.backgroundColor = [UIColor colorWithHexString:@"#C6C6C6"];
    _line.frame = CGRectMake(15, self.orderNumber.bottom, mainScreenWidth-30, SINGLE_LINE_WIDTH);
    [self.contentView addSubview:_line];
    
    self.phontView = [[UIImageView alloc]init];
    CGFloat photoWidth = 150 * SCALEPhoneWIDTH;
    CGFloat photoHeiht = photoWidth/16*9;
    self.phontView.frame = CGRectMake(15, _line.bottom+15, photoWidth, photoHeiht);
    [self.contentView addSubview:self.phontView];
    
    self.proctucCount = [[UILabel alloc]init];
    self.proctucCount.font = [UIFont fontWithName:FONT_REGULAR size:13*SCALEPhoneWIDTH];
    self.proctucCount.textColor =[UIColor colorWithHexString:@"#919191"];
    self.proctucCount.text = @"x100";
    [self.proctucCount sizeToFit];
    self.proctucCount.frame = CGRectMake(mainScreenWidth-15-self.proctucCount.width, self.phontView.top+2, self.proctucCount.width, self.proctucCount.height);
    [self.contentView addSubview:self.proctucCount];
    
    self.titleLable = [[UILabel alloc]init];
    self.titleLable.font = [UIFont fontWithName:FONT_REGULAR size:16*SCALEPhoneWIDTH];
    self.titleLable.textColor = [UIColor colorWithHexString:@"#434343"];
    self.titleLable.text = @"必胜客100元代金券";
    [self.titleLable sizeToFit];
    self.titleLable.frame = CGRectMake(self.phontView.right+10, self.phontView.top-2, self.proctucCount.right-self.phontView.right-10, self.titleLable.height) ;
    [self.contentView addSubview:self.titleLable];
    
    
    self.dateLable = [[UILabel alloc]init];
    self.dateLable.font = [UIFont fontWithName:FONT_REGULAR size:13*SCALEPhoneWIDTH];
    self.dateLable.textColor = [UIColor colorWithHexString:@"#919191"];
    self.dateLable.text = @"有效期至：2017-08-26";
    [self.dateLable sizeToFit];
    self.dateLable.frame = CGRectMake(self.phontView.right+10, self.titleLable.bottom+10*SCALEPhoneWIDTH, self.dateLable.width, self.dateLable.height);
    [self.contentView addSubview:self.dateLable];
    
    self.descriptionLable = [[UILabel alloc]init];
    self.descriptionLable.font = [UIFont fontWithName:FONT_REGULAR size:13*SCALEPhoneWIDTH];
    self.descriptionLable.textColor = [UIColor colorWithHexString:@"#434343"];
    self.descriptionLable.text = @"总价：¥190";
    [self.descriptionLable sizeToFit];
    self.descriptionLable.frame = CGRectMake(self.phontView.right+10, self.phontView.bottom-self.descriptionLable.height, 200, self.descriptionLable.height);
    [self.contentView addSubview:self.descriptionLable];
}

-(void)setModle:(HCOrderlistPruductModel *)modle
{
    _modle = modle;
    self.orderNumber.text = [NSString stringWithFormat:@"订单编号：%@",modle.shopOrderId];
    [self.orderNumber sizeToFit];
    self.orderNumber.frame = CGRectMake(15, 0, self.orderNumber.width, 50*SCALEPhoneWIDTH);
    NSString *statusString = [self orderStatusStringFor:modle.orderStatus];
    self.orderTypeLable.text = statusString;
    [self.orderTypeLable sizeToFit];
    self.orderTypeLable.frame = CGRectMake(mainScreenWidth-15-self.orderTypeLable.width, 0, self.orderTypeLable.width, 50*SCALEPhoneWIDTH);
    [self.phontView sd_setImageWithURL:[NSURL URLWithString:modle.myProduct.productImgUrl.firstObject] placeholderImage:[UIImage imageNamed:@"169"]];
    NSInteger endtime= modle.myProduct.validEndTime/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:endtime];
    NSString *dateString = [formatter stringFromDate:date];
    self.dateLable.text = [NSString stringWithFormat:@"有效期至：%@",dateString];
    [self.dateLable sizeToFit];
    self.dateLable.frame = CGRectMake(self.phontView.right+10, self.titleLable.bottom+10*SCALEPhoneWIDTH, self.dateLable.width, self.dateLable.height);
    self.titleLable.text = modle.myProduct.productName;
    self.proctucCount.text = [NSString stringWithFormat:@"x%@",@(modle.buyCount)];
    [self.proctucCount sizeToFit];
    self.proctucCount.frame = CGRectMake(mainScreenWidth-15-self.proctucCount.width, self.phontView.top+2, self.proctucCount.width, self.proctucCount.height);
    [self.titleLable sizeToFit];
    self.titleLable.frame = CGRectMake(self.phontView.right+10, self.phontView.top-2, self.proctucCount.right-self.phontView.right-20, self.titleLable.height) ;
    self.descriptionLable.text = [NSString stringWithFormat:@"总价：¥%@",modle.payActualAmount];
    NSString *priceString =  [NSString stringWithFormat:@"¥%@",modle.payActualAmount];
    NSString *totalString = self.descriptionLable.text;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:totalString];
    NSRange range = [totalString rangeOfString:priceString];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FC5D3F"] range:range];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_REGULAR size:17*SCALEPhoneWIDTH] range:range];
    self.descriptionLable.attributedText = str;
}

-(NSString *)orderStatusStringFor:(NSInteger)orderNumber
{
    NSString *statusString;
    switch (orderNumber) {
        case 1:
            statusString = @"待付款";
            break;
        case 2:
            statusString = @"待使用";
            break;
        case 3:
            statusString = @"待评价";
            break;
        case 4:
            statusString = @"已取消";
            break;
        case 5:
            statusString = @"已取消";
            break;
        case 6:
            statusString = @"已评价";
            break;
        case 7:
            statusString = @"未评价";
            break;
        case 8:
            statusString = @"退款中";
            break;
        case 0:
            statusString = @"退款完成";
            break;
        default:
            break;
    }
    return statusString;
}

@end
