//
//  BillDetailCell4.h
//  TuLingApp
//
//  Created by hua on 17/4/19.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillDetailCell4 : UITableViewCell
@property(nonatomic,strong)UILabel *leftLabel;

@property(nonatomic,strong)UILabel *rightLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


-(void)addValue:(NSMutableDictionary *)dic;
@end
