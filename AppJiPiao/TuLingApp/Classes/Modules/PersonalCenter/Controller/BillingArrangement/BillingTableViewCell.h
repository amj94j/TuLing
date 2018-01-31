//
//  BillingTableViewCell.h
//  TuLingApp
//
//  Created by hua on 17/4/17.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *leftLabel;

@property(nonatomic,strong)UILabel *leftDownLabel;

@property(nonatomic,strong)UILabel *leftDownValueLabel;

@property(nonatomic,strong)UILabel *rightLabel;


@property(nonatomic,strong)UILabel *rightTimeLabel;

@property(nonatomic,strong)UILabel *rightTime1Label;

@property(nonatomic,strong)UIImageView *iconImg;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)addValue:(NSMutableDictionary *)dic type:(NSString *)str;
@end
