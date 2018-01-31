//
//  BillDetailCell3.h
//  TuLingApp
//
//  Created by hua on 17/4/19.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "baseCell.h"

@interface BillDetailCell3 : baseCell
@property(nonatomic,strong)UILabel *leftLabel;
@property(nonatomic,strong)UILabel *twoLabel;

@property(nonatomic,strong)UILabel *rightLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


-(void)addValue:(NSMutableDictionary *)dic;
@end
