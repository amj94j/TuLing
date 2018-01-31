//
//  TicketOrderCell.h
//  TuLingApp
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel; // 价钱
@property (weak, nonatomic) IBOutlet UILabel *cabinTypeLabel; // 机舱类型
@property (weak, nonatomic) IBOutlet UILabel *discountLabel; // 折扣
@property (weak, nonatomic) IBOutlet UILabel *moreTicketLabel; // 余票

@property(nonatomic, copy)void(^bookingActionBlock)();
// 点击订
- (IBAction)bookingClick:(UIButton *)sender;
@property(nonatomic, copy)void(^backToRuleActionBlock)();
// 点击退改规程
- (IBAction)backToRuleClick:(UIButton *)sender;
- (void)reloadData:(TicketSpacePolicyModel *)model;
- (void)reloadDataDic:(NSDictionary *)model;
@end
