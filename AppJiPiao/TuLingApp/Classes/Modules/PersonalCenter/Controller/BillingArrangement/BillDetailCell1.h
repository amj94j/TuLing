//
//  BillDetailCell1.h
//  TuLingApp
//
//  Created by hua on 17/4/19.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillDetailCell1 : UITableViewCell
@property(nonatomic,strong)UILabel *Number;


@property(nonatomic,strong)UIImageView *myImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


-(void)addValue:(NSString *)phone;
@end
