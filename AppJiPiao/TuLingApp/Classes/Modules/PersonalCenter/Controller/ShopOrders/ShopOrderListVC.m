
//
//  ShopOrderListVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/18.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ShopOrderListVC.h"
#import "MyOrderFormListCell.h"
#import "MyOrderFormListModel.h"
#import "ShopOrderSearchVC.h"
#import "ShopOrderDetailVC.h"
#import "LiuXSegmentView.h"
@interface ShopOrderListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *orderType;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ShopOrderListVC

/*
 关闭右滑返回
 */
- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"订单管理";
    _orderType = @"0";
    _currentPage = 1;
    _dataSource = [[NSMutableArray alloc]init];
    
    [self createSubViews];
    [self setUpRefreshView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestGetDate];
}

#pragma mark--上拉刷新，下拉加载
- (void)setUpRefreshView
{
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
       
        // 重新请求数据
        [weakSelf requestGetDate];
    }];
    
    // 设置上拉加载
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage ++;
        [weakSelf requestGetDate];
    }];
    self.tableView.mj_footer.hidden = YES;
}

- (void) requestGetDate
{
    TLAccount * account = [TLAccountSave account];
    NSDictionary *params = @{@"uuid":account.uuid, @"orderType":_orderType, @"page":@(_currentPage),@"size":@"5"};
    MJWeakSelf;
    [NetAccess getJSONDataWithUrl:kShopOrderList parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
      
        if (reswponse[@"header"] == nil) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:@"网络出错了"];
            return;
        }
        if ([reswponse[@"header"][@"code"] intValue] != 0) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:@"网络出错了"];
            return ;
        }
        if (reswponse[@"date"] == nil) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:@"网络出错了"];
            return;
        }
        NSDictionary *date = [reswponse objectForKey:@"date"];
        NSArray *list = date[@"list"];
        
        if (_currentPage == 1) {
            [_dataSource removeAllObjects];
        }
        
        for (NSDictionary *dict in list) {
            
            MyOrderFormListModel *listModel = [[MyOrderFormListModel alloc]init];
            [listModel setValuesForKeysWithDictionary:dict];
            
            listModel.buttons = [[NSMutableArray alloc]init];
            listModel.products = [[NSMutableArray alloc]init];
            
            for (NSDictionary *dic in dict[@"buttons"]) {
                OrderFormButtonsModel *buttonsModel = [[OrderFormButtonsModel alloc]init];
                [buttonsModel setValuesForKeysWithDictionary:dic];
                [listModel.buttons addObject:buttonsModel];
            }
            for (NSDictionary *dic in dict[@"products"]) {
                OrderFormProductsModel *productsModel = [[OrderFormProductsModel alloc]init];
                [productsModel setValuesForKeysWithDictionary:dic];
                [listModel.products addObject:productsModel];
            }
            
            [_dataSource addObject:listModel];
        }
        

        
        if (list.count == 0 || list.count<5) {
            weakSelf.tableView.mj_footer.hidden = YES;
        } else {
            weakSelf.tableView.mj_footer.hidden = NO;
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        [_tableView reloadData];
    } fail:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络出错了"];
    }];
}

- (void) createSubViews
{
    UIButton *rightBarBtn = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 80, 25) ImageName:nil Target:self Action:@selector(onRightBarBtnClick) Title:@"搜索"];
    rightBarBtn.titleLabel.font = kFontNol16;
    rightBarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBarBtn setTitleColor:kColorFontBlack1 forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    
    NSArray *titleArr = @[@"全部", @"待付款", @"待发货", @"已发货", @"交易成功", @"交易失败"];
    
    UIView *backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 5*kHeightScale, WIDTH, 44*kHeightScale)];
    backView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView2];
    
    __weak __typeof(self) weakSelf = self;
    LiuXSegmentView *topView = [[LiuXSegmentView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44*kHeightScale) titles:titleArr clickBlick:^(NSInteger index) {
        
        weakSelf.currentPage = 1;
       
        //  index 从1开始，使用时需-1使用
        weakSelf.orderType = [NSString stringWithFormat:@"%zd",index-1];
        [weakSelf requestGetDate];
        
    }];
    topView.titleNomalColor = [UIColor colorWithHexString:@"#919191"];
    topView.titleSelectColor = [UIColor colorWithHexString:@"#017E44"];
    [backView2 addSubview:topView];
    topView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50*kHeightScale, WIDTH, HEIGHT-64-50*kHeightScale) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorClear;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}


/**
 导航搜索
 */
- (void) onRightBarBtnClick
{
    ShopOrderSearchVC *orderSearchVC = [[ShopOrderSearchVC alloc] init];
    [self.navigationController pushViewController:orderSearchVC animated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MyOrderFormListModel *listModel = _dataSource[section];
    return listModel.products.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 95*kHeightScale;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50*kHeightScale;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115*kHeightScale;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 95*kHeightScale)];
    bgView.backgroundColor = kColorWhite;
    
    
    MyOrderFormListModel *listModel = _dataSource[section];
    
    NSArray *titleName = @[@"订单编号：", @"下单时间：", @"买家名称："];
    NSArray *detailStr = @[listModel.orderNumber, listModel.createDate, listModel.shopName];
    for (int i=0; i<3; i++) {
        
        UILabel *title = [createControl createLabelWithFrame:CGRectMake(15*kWidthScale, 20*kHeightScale+20*kHeightScale*i, 100*kWidthScale, 15*kHeightScale) Font:15 Text:titleName[i] LabTextColor:kColorFontBlack3];
        [bgView addSubview:title];
        
        
        CGFloat titleX = CGRectGetMaxX(title.frame)+10;
        UILabel *detailLab = [createControl createLabelWithFrame:CGRectMake(titleX, 20*kHeightScale+20*kHeightScale*i, 100*kWidthScale, 15*kHeightScale) Font:15 Text:detailStr[i] LabTextColor:kColorFontBlack1];
        [bgView addSubview:detailLab];
    }
    
    UILabel *line = [createControl createLineWithFrame:CGRectMake(15*kWidthScale, 94.5*kHeightScale, WIDTH-30*kWidthScale, 0.5*kHeightScale) labelLineColor:kColorLine];
    [bgView addSubview:line];
    
    
    
    CGSize size = [listModel.status sizeWithFont:13 andMaxSize:CGSizeMake(150, 22*kHeightScale)];
    UILabel *statusLab = [createControl labelWithFrame:CGRectMake(WIDTH-25*kWidthScale-size.width, (95*kHeightScale-size.height)/2, size.width+10*kWidthScale, 22*kHeightScale) Font:13 Text:listModel.status LabTextColor:kColorWhite];
    statusLab.layer.masksToBounds = YES;
    statusLab.layer.cornerRadius = 2.5;
    if ([listModel.status isEqualToString:@"待付款"] || [listModel.status isEqualToString:@"待发货"]) {
        statusLab.backgroundColor = kColorAppRed;
    } else if ([listModel.status isEqualToString:@"已发货"] || [listModel.status isEqualToString:@"交易成功"]) {
        statusLab.backgroundColor = kColorAppGreen;
    } else {
        statusLab.backgroundColor = [UIColor colorWithHexString:@"#FF4861"];
    }
    statusLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:statusLab];
    
    
    if (listModel.retrunStatus.length != 0) {
        statusLab.frame = CGRectMake(WIDTH-25*kWidthScale-size.width, 31*kHeightScale, size.width+10*kWidthScale, 22*kHeightScale);
        
        UILabel *retrunStatusLab = [createControl labelWithFrame:CGRectMake(WIDTH-150*kWidthScale, 53*kHeightScale, 135*kWidthScale, 23*kHeightScale) Font:13 Text:listModel.retrunStatus LabTextColor:kColorAppRed];
        retrunStatusLab.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:retrunStatusLab];
    }
    
    return bgView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    MyOrderFormListModel *listModel = _dataSource[section];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50*kHeightScale)];
    bgView.backgroundColor = kColorClear;
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 45*kHeightScale)];
    footView.backgroundColor = kColorWhite;
    [bgView addSubview:footView];
    
    
    UILabel *line = [createControl createLineWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-30*kWidthScale, 0.5*kHeightScale) labelLineColor:kColorLine];
    [footView addSubview:line];
    
    
    UILabel *detailLab = [LXTControl createLabelWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-30*kWidthScale + 6, 45*kHeightScale) Font:13 Text:@""];
    detailLab.textColor = [UIColor colorWithHexString:@"#434343"];
    [footView addSubview:detailLab];
    NSString *nameStr = [NSString stringWithFormat:@"合计：¥%0.2f（含运费¥%0.2f）", listModel.totle, listModel.cost];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:nameStr];
    NSRange range = [nameStr rangeOfString:[NSString stringWithFormat:@"¥%0.2f",listModel.totle]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
    detailLab.attributedText = attStr;
    detailLab.textAlignment = NSTextAlignmentRight;
    
    
    return bgView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellIdentifier";
    MyOrderFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyOrderFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyOrderFormListModel *model = _dataSource[indexPath.section];
    cell.model = model.products[indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderFormListModel *model = _dataSource[indexPath.section];
    
    ShopOrderDetailVC *detailVC = [[ShopOrderDetailVC alloc]init];
    detailVC.orderId = @(model.orderId).stringValue;
    [self.navigationController pushViewController:detailVC animated:YES];
}


/**
 返回按钮
 */
- (void) onBackBarBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.tab showLeftView];
}

@end
