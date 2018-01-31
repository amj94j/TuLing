//
//  OrderTableViewCell.h
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/20.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TicketOrderModel;

@interface OrderTableViewCell : UITableViewCell

@property (nonatomic, strong)TicketOrderModel * model;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

+ (OrderTableViewCell *)cellWithTableView:(UITableView *)tableView;

@end
