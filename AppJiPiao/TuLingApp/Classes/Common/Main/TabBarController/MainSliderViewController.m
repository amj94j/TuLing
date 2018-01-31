//
//  MainSliderViewController.m
//  TuLingApp
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "MainSliderViewController.h"
#import "HzCustomTabBarController.h"
#import "BaseNavigationController.h"

#import "MainLeftBackgroundVC.h"
#import "HzTabarBtn.h"
#import "AppDelegate.h"

#import "MyOrderDetailVC.h"
#import "OrderReturnDetailVC.h"
@interface MainSliderViewController ()
 

@end

@implementation MainSliderViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTabbarsVC];
    
}
- (void)createTabbarsVC
{
    // 这里HzCustomTabBarController必须设置成全局变量否则切换时会被释放到只程序崩溃
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    app.lvc = [[MainLeftBackgroundVC alloc]init];
    
    [self.view addSubview:app.lvc.view];

    app.tab = [[HzCustomTabBarController alloc] init];
    // 正常图片
    NSArray * normalImamges =  @[@"tugefangbian",@"tuyouhaochi",@"tuyouhaowan",@"tuyouketao"];
    // 选中图片
    NSArray * selectedImages = @[@"tugefangbiandianji",@"tuyouhaochidianji",@"tuyouhaowandianji",@"tuyouketaodianji"];
 
     NSArray * arr = @[@"newServiceVC",@"TasteWorldViewController",@"SceneViewController",@"TripViewController"];
    
    // 文字
    NSArray *titles = @[@"途个方便",@"途有好吃",@"途有好玩",@"途有可淘"];
    
    [app.tab creatTabbarVCWithControllersArray:arr andTabbarNormalImageArr:normalImamges andTabbarSelectedImageArr:selectedImages andTabbarsTitlesArr:titles];
    // 设置默认选中的视图
    app.tab.selectedIndex = 0;
    // 设置默认选中的tabbar按钮
    
    ((HzTabarBtn *)[app.tab.tabBarView.subviews objectAtIndex:0]).selected = YES;
    [self.view addSubview:app.tab.view];
    
}

@end
