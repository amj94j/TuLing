//
//  PayTableViewCell.h
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;

@property (weak, nonatomic) IBOutlet UILabel *zhiFuLabel;

@property (weak, nonatomic) IBOutlet UIImageView *zhiFuIconView;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (nonatomic) BOOL isSelect;

+ (PayTableViewCell *)cellWithTableView:(UITableView *)tableView;

@end
