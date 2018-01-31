//
//  topicCell3.h
//  TuLingApp
//
//  Created by hua on 17/4/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "topicModel.h"
@interface topicCell3 : UITableViewCell
/**
 
 */
@property(nonatomic,strong)UILabel *name;



/**
 
 */
@property(nonatomic,strong)UITextView *textView;



/**
 线条
 */
@property(nonatomic,strong)UILabel *lineLabel;



@property(nonatomic,strong)topicModel *topicModel1;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
