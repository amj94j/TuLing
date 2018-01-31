//
//  topicCell2.h
//  TuLingApp
//
//  Created by hua on 17/4/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "topicModel.h"
@interface topicCell2 : UITableViewCell
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

@property(nonatomic,weak)topicModel *topicModel1;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)changeWordNumber:(NSInteger)change total:(NSInteger)totalNumber;


-(void)showTextViewHint;

-(void)hiddenTextViewHint;

@end
