//
//  MainLeftThridCell.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

/*
 * 商家入驻 cell
 */
#import <UIKit/UIKit.h>


typedef void(^BusinessBtnClick)();

@interface MainLeftThridCell : UITableViewCell

@property (nonatomic, copy) BusinessBtnClick businessClick;

@end
