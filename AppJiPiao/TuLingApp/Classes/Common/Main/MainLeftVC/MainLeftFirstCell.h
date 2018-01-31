//
//  MainLeftFirstCell.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainUserInfoModel.h"

typedef void(^YuEBtnClick)();
typedef void(^JiFenBtnClick)();

@interface MainLeftFirstCell : UITableViewCell

@property (nonatomic, assign) BOOL isBusiness;
@property (nonatomic, copy) YuEBtnClick yueClick;
@property (nonatomic, copy) JiFenBtnClick jiFenClick;
@property (nonatomic, strong) MainUserInfoModel *model;

@end
