//
//  MyOrderFormVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/22.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MyOrderFormVC.h"
#import "MyOrderFormListModel.h"
#import "MyOrderFormListCell.h"
#import "TLOrderWaitReceiveCell.h"
#import "TLMyOrderLogisticsView.h"
#import "TLMyOrderRemainEvaluateCell.h"

#import "MyOrderDetailVC.h" // 详情

#import "WXApiRequestHandler.h"
#import "AlipayRequestConfig.h"
#import "TLKeTaoSortBarView.h"

#import "HMSegmentedControl.h"
#import "KeTaoOrderlistView.h"
#import "HaoChiOrderlistView.h"

@interface MyOrderFormVC ()<UIScrollViewDelegate>
{
   
}

@property (nonatomic, strong) UIScrollView *BackScrollView;
@property (nonatomic,strong) UIButton * messageButton;
@property (nonatomic,strong) HMSegmentedControl *control;
@property (nonatomic,strong) KeTaoOrderlistView *KeTaoListview;
@property (nonatomic,strong) HaoChiOrderlistView *HaoChiListview;
@end

@implementation MyOrderFormVC

/*
 关闭右滑返回
 */
- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    self.HaoChiListview.currentPage = 1;
    self.KeTaoListview.currentPage = 1;
    [self.HaoChiListview requestGetData];
    [self.KeTaoListview requestGetData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    [self rightBarItemSet];
    [self buildSubviews];
}

- (void) buildSubviews
{
    self.control = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 44)];
    self.control.sectionTitles = @[@"特产", @"美食"];
    self.control.selectedSegmentIndex = 0;
    self.control.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#919191"],NSFontAttributeName: [UIFont fontWithName:FONT_REGULAR size:16]};
    self.control.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#434343"],NSFontAttributeName: [UIFont fontWithName:FONT_REGULAR size:16]};
    
    self.control.selectionIndicatorColor = [UIColor colorWithHexString:@"#017E44"];
    self.control.selectionIndicatorHeight = 2;
    self.control.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, -10, 0, -20);
    self.control.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    self.control.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.control.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    __weak typeof(self) weakSelf = self;
    [self.control setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.BackScrollView scrollRectToVisible:CGRectMake(mainScreenWidth * index, 0, mainScreenWidth, mainScreenHeight-64-44) animated:YES];
    }];
    
    [self.view addSubview:self.control];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.control.bottom, mainScreenWidth, SINGLE_LINE_WIDTH)];
    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.view addSubview:line];
    
    self.BackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, line.bottom, mainScreenWidth, mainScreenHeight-64-44)];
    self.BackScrollView.backgroundColor = [UIColor whiteColor];
    self.BackScrollView.pagingEnabled = YES;
    self.BackScrollView.showsHorizontalScrollIndicator = NO;
    self.BackScrollView.contentSize = CGSizeMake(mainScreenWidth * 2, mainScreenHeight-64-44);
    self.BackScrollView.delegate = self;
    [self.view addSubview:self.BackScrollView];
    
    _KeTaoListview = [[KeTaoOrderlistView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenHeight-self.control.bottom-64)];
    [self.BackScrollView addSubview:_KeTaoListview];
    
    _HaoChiListview = [[HaoChiOrderlistView alloc]initWithFrame:CGRectMake(mainScreenWidth, 0, mainScreenWidth, _KeTaoListview.height)];
    [self.BackScrollView addSubview:_HaoChiListview];
    
}
-(void)rightBarItemSet{

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 18.5, 18.5);
    [button addTarget:self action:@selector(searchOrderButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"TLMyOrder_searchIcon"] forState:UIControlStateNormal];
    
    UIBarButtonItem * itmeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
   UIButton * messageButton1 = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 20, 22) ImageName:@"TLKeTao_messagesIcon" Target:self Action:@selector(messageButtonClick:) Title:nil];;
    
    UIBarButtonItem * cartItmeButton = [[UIBarButtonItem alloc] initWithCustomView:messageButton1];

    UIButton * tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIBarButtonItem * tempItmeButton = [[UIBarButtonItem alloc] initWithCustomView:tempButton];
    
    self.navigationItem.rightBarButtonItems = @[cartItmeButton,tempItmeButton,itmeButton];
}

#pragma mark ---- 搜索订单
-(void)searchOrderButton:(UIButton*)button{

}

#pragma mark ---- 查看消息
-(void)messageButtonClick:(UIButton*)button{
   
}


-(void)onBackBarBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.tab showLeftView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.control setSelectedSegmentIndex:page animated:YES];
}

@end
