//
//  topicDetailcell.h
//  TuLingApp
//
//  Created by hua on 17/4/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface topicDetailcell : UITableViewCell
/**
 商品
 */
@property(nonatomic,strong)UILabel *name;



/**
 
 */
@property(nonatomic,strong)UIImageView *myImage;



+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)addValue:(NSMutableDictionary *)dic;

@end
