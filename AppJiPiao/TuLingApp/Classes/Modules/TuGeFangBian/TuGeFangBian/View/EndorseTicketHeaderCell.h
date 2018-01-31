//
//  EndorseTicketHeaderCell.h
//  TuLingApp
//
//  Created by apple on 2017/12/23.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndorseTicketHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel; // 07-10 10:30 周一
@property (weak, nonatomic) IBOutlet UILabel *flightNumLabel; // 航班号码
@property (weak, nonatomic) IBOutlet UILabel *cabinTypeLabel; // 机舱型号
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView; // 选中状态
//- (void)refreshData:(id)data;

@end
