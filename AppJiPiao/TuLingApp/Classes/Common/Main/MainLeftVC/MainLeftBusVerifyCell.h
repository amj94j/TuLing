//
//  MainLeftBusVerifyCell.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackBtnClick)();

@interface MainLeftBusVerifyCell : UITableViewCell

@property (nonatomic, copy) BackBtnClick backBtn;

@end
