//
//  indusTableViewCell.h
//  TuLingApp
//
//  Created by hua on 16/11/23.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol indusTableViewCellDelegate <NSObject>
-(void)IsseceltView11:(UIButton *)btn;
@end
@interface indusTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *name;

@property(nonatomic,strong)UIButton *Btn;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(assign,nonatomic)id<indusTableViewCellDelegate>delegate;
@end
