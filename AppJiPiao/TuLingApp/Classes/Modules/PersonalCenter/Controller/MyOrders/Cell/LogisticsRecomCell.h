//
//  LogisticsRecommend.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/27.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckLogisticsModel.h"

typedef void(^CaiNiXiHuanProduct)(NSInteger);

@interface LogisticsRecomCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) CaiNiXiHuanProduct likeProductBtn;

@end
