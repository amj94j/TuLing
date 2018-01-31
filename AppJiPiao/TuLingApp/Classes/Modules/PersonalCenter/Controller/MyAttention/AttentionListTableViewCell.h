//
//  AttentionListTableViewCell.h
//  TuLingApp
//
//  Created by hua on 17/4/17.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionListTableViewCell : UITableViewCell

/**
 头像
 */
@property(nonatomic,strong)UIImageView *MyImg;

/**
 用户名称
 */
@property(nonatomic,strong)UILabel *nameLabel;


/**
 商户图片
 */
@property(nonatomic,strong)UIImageView *shopImg;


/**
 认证图片
 */
@property(nonatomic,strong)UIImageView *AuthenticationImg;



/**
 性别图片
 */
@property(nonatomic,strong)UIImageView *sexImg;

/**
 公司
 */
@property(nonatomic,strong)UIImageView *companyImg;


@property(nonatomic,strong)UILabel *decLabel;

/**
 跳转图片
 */
@property(nonatomic,strong)UIImageView *iconImg;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)addValue:(NSMutableDictionary *)dic;
@end
