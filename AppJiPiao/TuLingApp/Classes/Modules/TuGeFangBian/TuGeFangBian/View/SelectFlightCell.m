//
//  SelectFlightCell.m
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "SelectFlightCell.h"

@implementation SelectFlightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.arrowImageView.image = [UIImage imageNamed:@"selectflight_arrow_x"];
    self.arrowImageView.contentMode = UIViewContentModeCenter;
}

- (void)assignmentUISearchFlihtsModel:(SearchFlightsModel *)model {
    if (model) {
        if (model.isSharing) {
            self.sharedLabel.hidden = NO;
            self.sharedLabel.text = @"(共享)";
        } else {
            self.sharedLabel.hidden = YES;
            self.sharedLabel.text = @"";
        }
        self.cabinTypeLabel.text = model.classtype; // 机舱型号
        self.beginTimeLabel.text = model.beginTime; // 起飞时间 23:25
        self.beginAirportLabel.text = [NSString stringWithFormat:@"%@%@机场%@",model.beginCityName,model.beginAirPortName,model.fromterminal];
        self.beginCompanyLabel.text = model.airlineCompany;
        //stringByAppendingString:model.airlineCode]; // 开始的公司
        self.flightNumLabel.text = model.flightNumber; // 航班号码
        
        if (model.stopCity.length>0) {
            self.afterStopLabel.hidden = NO;
            self.afterStopLabel.text = [@"经停" stringByAppendingString:model.stopCity]; // 经停
        } else {
            self.afterStopLabel.hidden = YES;
        }
        self.nextDayLabel.hidden = !model.twoDay;
        
        self.endTimeLabel.text = model.endTime; // 到达时间
        self.endAirportLabel.text = [NSString stringWithFormat:@"%@%@机场%@",model.endCityName,model.endAirPortName,model.arrterminal];
        self.companyLabel.text = [NSString stringWithFormat:@"%@ (%@)",  model.planeType,model.planeSize];
        [self.companyIocnImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://images.touring.com.cn/images/air/%@.png",model.airlineCode]] placeholderImage:[UIImage imageNamed:@"logo_l"]];
        
//        self.companyLabel.text = model.endAirPortName; // 右下角 "空客 320(中)"
        self.endPlaneModelLabel.text = model.endAirPort; // 到达的机型
        
        if (model.stopCityName.length>0) {
            self.afterStopLabel.hidden = NO;
            self.afterStopLabel.text = [@"经停" stringByAppendingString:model.stopCityName]; // 经停
        } else {
            self.afterStopLabel.hidden = YES;
        }
        
        // 折扣
        if ([model.rate floatValue] == 100) {
            self.discountLabel.text = @"全价";
        } else if ([model.rate floatValue] == 0) {
            self.discountLabel.text = @"";
        } else {
//            CGFloat old = [model.rate floatValue];
            self.discountLabel.text = [[NSString stringWithFormat:@"%@",model.rate] stringByAppendingString:@"折"];
        }
        self.priceLabel.text = model.lowprice; // 价钱
        if (model.realCompany.length>0) {
            self.actualCompanyLabel.text = model.realCompany; // 实际公司
            self.actualPlaneModelLabel.text = model.realFlightNum; // 实际型号
            self.actualCompanyLabel.hidden = NO; // 实际公司
            self.actualPlaneModelLabel.hidden = NO; // 实际型号
            self.actualLabel.hidden = NO;
        } else {
            self.actualCompanyLabel.hidden = YES; // 实际公司
            self.actualPlaneModelLabel.hidden = YES; // 实际型号
            self.actualLabel.hidden = YES;
        }
       
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
