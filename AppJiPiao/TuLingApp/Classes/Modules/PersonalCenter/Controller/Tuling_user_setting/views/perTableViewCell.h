//
//  perTableViewCell.h
//  TuLingApp
//
//  Created by hua on 16/11/22.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface perTableViewCell : UITableViewCell


@property(nonatomic,strong)UILabel *leftLabel;

@property(nonatomic,strong)UITextField *textField;

@property (nonatomic,strong) UIImageView * rightArrowImageView;

@property (nonatomic) BOOL isShowArrow;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)addValue:(NSMutableArray *)Arr;

@end
