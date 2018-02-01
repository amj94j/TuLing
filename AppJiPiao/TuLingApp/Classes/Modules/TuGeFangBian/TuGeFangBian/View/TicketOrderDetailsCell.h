//
//  TicketOrderDetailsCell.h
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketOrderDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *banckLineLayout;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIView *bgView; // 背景
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight; // 背景view高度
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel; // 07-10 10:30 周一
@property (weak, nonatomic) IBOutlet UILabel *flightNumLabel; // 航班号码
@property (weak, nonatomic) IBOutlet UILabel *sharedLabel; // 共享 不共享的时候字符串设置为@"" 共享的时候"(共享)"
@property (weak, nonatomic) IBOutlet UILabel *cabinTypeLabel; // 机舱型号
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel; // 起飞时间 23:25
@property (weak, nonatomic) IBOutlet UILabel *beginAirportLabel; // 起飞机场
@property (weak, nonatomic) IBOutlet UILabel *lengthTimeLabel; // 飞行时长 约1h15m
@property (weak, nonatomic) IBOutlet UILabel *afterStopLabel; // 经停
@property (weak, nonatomic) IBOutlet UILabel *nextDayLabel; // 次日
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel; // 到达时间
@property (weak, nonatomic) IBOutlet UILabel *endAirportLabel; // 到达机场
@property (weak, nonatomic) IBOutlet UILabel *punctualityLabel; // 准点率 "准点率 80%"
@property (weak, nonatomic) IBOutlet UILabel *mealsLabel; // 有无餐食
@property (weak, nonatomic) IBOutlet UILabel *companyLabel; // 右下角 "空客 320(中)"
@property (weak, nonatomic) IBOutlet UILabel *actualRideLabel; // 实际乘坐 "实际乘坐 东航 MU5136"这样拼接一下
@property (weak, nonatomic) IBOutlet UILabel *returnLabel; // 返
@property (weak, nonatomic) IBOutlet UIButton *endorseBackRulesBtn; // 退改签规则btn
@property (weak, nonatomic) IBOutlet UIView *articleGreyView;

@property (nonatomic) BOOL isBGImage;
@property (nonatomic, copy) NSDictionary *dataDic;
- (void)refreshData:(id)data type:(NSString *)type;

@end
