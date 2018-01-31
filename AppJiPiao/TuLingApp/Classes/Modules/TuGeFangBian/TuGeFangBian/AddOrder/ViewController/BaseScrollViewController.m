//
//  BaseScrollViewController.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseScrollViewController.h"

@interface BaseScrollViewController ()

@end

@implementation BaseScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.baseScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.baseScrollView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.baseScrollView belowSubview:self.navigationController.navigationBar];
    
    WS(ws)
    [self.baseScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view);
        make.bottom.equalTo(ws.view);
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
    }];
    
    if (@available(iOS 11.0, *)) {
        if ([self.baseScrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]){
            self.baseScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    } else {
        if ([self.baseScrollView respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

#pragma mark 更新滚动视图的四周间距
- (void)updateBaseScrollViewEdgeMargin:(UIEdgeInsets)edgeInsets
{
    WS(ws)
    [self.baseScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).mas_offset(edgeInsets.top);
        make.left.equalTo(ws.view).mas_offset(edgeInsets.left);
        make.bottom.equalTo(ws.view).mas_offset(edgeInsets.bottom);
        make.right.equalTo(ws.view).mas_offset(edgeInsets.right);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
