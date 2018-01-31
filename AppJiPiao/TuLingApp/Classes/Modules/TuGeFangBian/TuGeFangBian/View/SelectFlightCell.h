//
//  SelectFlightCell.h
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFlightCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *flightNumLabel; // 航班号码
@property (weak, nonatomic) IBOutlet UILabel *sharedLabel; // 共享 不共享的时候字符串设置为@"" 共享的时候"(共享)"
@property (weak, nonatomic) IBOutlet UILabel *cabinTypeLabel; // 机舱型号
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel; // 起飞时间 23:25
@property (weak, nonatomic) IBOutlet UILabel *beginAirportLabel; // 起飞机场
@property (weak, nonatomic) IBOutlet UILabel *afterStopLabel; // 经停
@property (weak, nonatomic) IBOutlet UILabel *nextDayLabel; // 次日
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel; // 到达时间
@property (weak, nonatomic) IBOutlet UILabel *endAirportLabel; // 到达机场
@property (weak, nonatomic) IBOutlet UILabel *companyLabel; // 右下角 "空客 320(中)"
@property (weak, nonatomic) IBOutlet UILabel *discountLabel; // 折扣
@property (weak, nonatomic) IBOutlet UILabel *beginCompanyLabel; // 开始的公司
@property (weak, nonatomic) IBOutlet UILabel *endPlaneModelLabel; // 到达的机型
@property (weak, nonatomic) IBOutlet UILabel *priceLabel; // 价钱
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView; // 箭头
@property (weak, nonatomic) IBOutlet UILabel *actualCompanyLabel; // 实际公司
@property (weak, nonatomic) IBOutlet UILabel *actualPlaneModelLabel; // 实际型号
@property (weak, nonatomic) IBOutlet UILabel *actualLabel;
@property (weak, nonatomic) IBOutlet UIImageView *companyIocnImageView;


- (void)assignmentUISearchFlihtsModel:(SearchFlightsModel *)model;

@end
