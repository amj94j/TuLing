//
//  payTypeTableViewCell.h
//  TuLingApp
//
//  Created by hua on 16/11/6.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class payTypeTableViewCell;
@protocol payTypeTableViewCellDelegate <NSObject>
-(void)confirmIssecelt:(payTypeTableViewCell *)cell;
@end
@interface payTypeTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *photoView;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UIButton *cellBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *lineView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(assign,nonatomic)id<payTypeTableViewCellDelegate>delegate;
@end
