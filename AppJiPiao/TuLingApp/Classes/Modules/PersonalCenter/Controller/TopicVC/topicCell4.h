//
//  topicCell4.h
//  TuLingApp
//
//  Created by hua on 17/4/27.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol topicCell4Delegate <NSObject>

//删除图片
-(void)deleteImage:(NSInteger) imageTag;

//添加图片
-(void)addImage;


@end
@interface topicCell4 : UITableViewCell
/**
 上传图片名称
 */
@property(nonatomic,strong)UILabel *labelname;



/**
 
 */
@property(nonatomic,strong)UIImageView *localPhoto;



@property(nonatomic,strong)UIImageView *netWorkPhoto;


/**
 线条
 */
@property(nonatomic,strong)UILabel *lineLabel;





/**
 添加图片
 */
@property(nonatomic,strong)UIView *myView;


@property(assign,nonatomic)id<topicCell4Delegate>delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)addValueNetWork:(NSMutableArray *)netWorkArr local:(NSMutableArray *)localArr;
@end
