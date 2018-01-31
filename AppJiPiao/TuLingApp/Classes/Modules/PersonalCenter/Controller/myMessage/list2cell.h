//
//  list2cell.h
//  TuLingApp
//
//  Created by hua on 17/5/5.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface list2cell : UITableViewCell
/**
 头像
 */
@property (nonatomic, strong) UIImageView *photoView;

/**
 系统消息
 */
@property(nonatomic,strong)UILabel *nameLabel;

/**
 系统数量
 */
@property(nonatomic,strong)UILabel *count;


@property(nonatomic,strong)UILabel *content;


@property(nonatomic,strong)UILabel *timeLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)addTheValue:(NSMutableDictionary *)dic;
@end
