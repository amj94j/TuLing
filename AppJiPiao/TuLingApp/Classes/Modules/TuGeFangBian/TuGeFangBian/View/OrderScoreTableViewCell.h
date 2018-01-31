//
//  OrderScoreTableViewCell.h
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderScoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong)void(^cacluePriceBlock)();

@property (nonatomic, strong)void(^openOrCloseBlock)(BOOL isOn);

+ (OrderScoreTableViewCell *)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end
