//
//  BaseTicketViewController.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseScrollViewController.h"

@interface BaseTicketViewController : BaseScrollViewController

// 定制标题
- (void)addCustomTitleWithTitle:(NSString *)titleName;
// 标题 城市→城市
- (void)layoutNavigationItemViewGo:(NSString *)go back:(NSString *)back;
- (void)layoutNavigationItemViewGo:(NSString *)go back:(NSString *)back image:(NSString *)image;
@end
