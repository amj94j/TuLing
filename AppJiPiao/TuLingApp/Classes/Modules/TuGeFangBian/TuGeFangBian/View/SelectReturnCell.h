//
//  SelectReturnCell.h
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectReturnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *returnLabel; // 返
@property (weak, nonatomic) IBOutlet UILabel *timerLabel; // 07-10 10:30 周一
@property (weak, nonatomic) IBOutlet UILabel *flightNumLabel; // 航班号码
@property (weak, nonatomic) IBOutlet UILabel *sharedLabel; // 共享 不共享的时候字符串设置为@"" 共享的时候"(共享)"
@property (weak, nonatomic) IBOutlet UILabel *cabinTypeLabel; // 机舱型号
- (void)refreshData:(id)data;
@end
