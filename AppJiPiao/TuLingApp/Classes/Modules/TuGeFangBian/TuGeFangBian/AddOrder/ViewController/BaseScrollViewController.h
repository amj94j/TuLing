//
//  BaseScrollViewController.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseVC.h"
#import "Masonry.h"

@interface BaseScrollViewController : BaseVC

@property (nonatomic, strong) UIScrollView *baseScrollView;

#pragma mark 更新滚动视图的四周间距
- (void)updateBaseScrollViewEdgeMargin:(UIEdgeInsets)edgeInsets;

@end
