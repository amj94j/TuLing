//
//  ShopOrderReturnListVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ShopOrderReturnListVC.h"
#import "MyOrderFormListModel.h"
#import "MyOrderFormListCell.h"
#import "ShopOrderReturnDetailVC.h"

#define kPageSize @"10"
@interface ShopOrderReturnListVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *_titleLab;
    UIButton *_leftBtn;
    UIButton *_rigthBtn;
}

@property (nonatomic, strong) NSString *returnType;  // 1进行中  2全部
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ShopOrderReturnListVC

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

    self.title = @"退货退款";
    _returnType = @"1";
    _currentPage = 1;
    _dataSource = [[NSMutableArray alloc]init];
    
    [self createSubviews];
    [self requestGetData];
    [self setUpRefreshView];
}

#pragma mark--上拉刷新，下拉加载
- (void)setUpRefreshView
{
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf requestGetData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage ++;
        [weakSelf requestGetData];
    }];
    self.tableView.mj_footer.hidden = YES;
}

- (void) createSubviews
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50*kHeightScale)];
    topView.backgroundColor = kColorWhite;
    [self.view addSubview:topView];
    
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/4 - 45*kWidthScale, 49*kHeightScale, 90*kWidthScale, 1*kHeightScale)];
    _titleLab.backgroundColor = kColorAppGreen;
    [topView addSubview:_titleLab];
    
    _leftBtn = [LXTControl createBtnWithFrame:CGRectMake(0, 0, WIDTH/2, 50*kHeightScale) titleName:@"进行中" imgName:nil selImgName:nil target:self action:@selector(onTopBtnClick:)];
    _leftBtn.titleLabel.font = kFontNol15;
    _leftBtn.tag = 1;
    [_leftBtn setTitleColor:kColorFontBlack1 forState:UIControlStateNormal];
    [_leftBtn setTitleColor:kColorAppGreen forState:UIControlStateSelected];
    [topView addSubview:_leftBtn];
    _leftBtn.selected = YES;
    
    UILabel *line = [createControl createLineWithFrame:CGRectMake(WIDTH/2, 15*kHeightScale, 1*kWidthScale, 20*kHeightScale) labelLineColor:kColorLine];
    [topView addSubview:line];
    
    
    _rigthBtn = [LXTControl createBtnWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2, 50*kHeightScale) titleName:@"全部" imgName:nil selImgName:nil target:self action:@selector(onTopBtnClick:)];
    _rigthBtn.titleLabel.font = kFontNol15;
    _rigthBtn.tag = 2;
    [_rigthBtn setTitleColor:kColorFontBlack1 forState:UIControlStateNormal];
    [_rigthBtn setTitleColor:kColorAppGreen forState:UIControlStateSelected];
    [topView addSubview:_rigthBtn];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60*kHeightScale, WIDTH, HEIGHT-64-60*kHeightScale) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorClear;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void) onTopBtnClick:(UIButton *)sender
{
    if (sender.tag == 1) { // 进行中
        _returnType = @"1";
        
        _leftBtn.selected = YES;
        _rigthBtn.selected = NO;
        _titleLab.frame = CGRectMake(WIDTH/4-45*kWidthScale, 49*kHeightScale, 90*kWidthScale, 1*kHeightScale);
        
    } else if (sender.tag == 2) { // 全部
        
        _returnType = @"2";
        
        _leftBtn.selected = NO;
        _rigthBtn.selected = YES;
        _titleLab.frame = CGRectMake(WIDTH/4*3-45*kWidthScale, 49*kHeightScale, 90*kWidthScale, 1*kHeightScale);
    }
    _currentPage = 1;
    [_tableView.mj_header beginRefreshing];
}


- (void) requestGetData
{
    TLAccount * account = [TLAccountSave account];
    NSDictionary *params = @{@"uuid":account.uuid, @"returnType":_returnType, @"page":@(_currentPage),@"size":@"10"};
    MJWeakSelf;
    [NetAccess getJSONDataWithUrl:kShopOrderReturnList parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
       
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
            
            listModel.products = [[NSMutableArray alloc]init];
            
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
        
        
        [_leftBtn setTitle:[NSString stringWithFormat:@"进行中（%@）", date[@"startRow"]] forState:UIControlStateNormal];
        [_rigthBtn setTitle:[NSString stringWithFormat:@"全部（%@）", date[@"endRow"]] forState:UIControlStateNormal];
        
        [weakSelf.tableView reloadData];
    } fail:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:@"网络出错了"];
    }];
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
    if (section == 0) {
        return 70*kHeightScale;
    }
    return 80*kHeightScale;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 45*kHeightScale;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115*kHeightScale;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 80*kHeightScale)];
    headerView.backgroundColor = kColorClear;
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 70*kHeightScale)];
    bgView.backgroundColor = kColorWhite;
    [headerView addSubview:bgView];
    
    if (section == 0) {
        headerView.frame = CGRectMake(0, 0, WIDTH, 70);
        bgView.frame = CGRectMake(0, 0, WIDTH, 70*kHeightScale);
    }
    
    
    MyOrderFormListModel *listModel = _dataSource[section];
    
    UILabel *numLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 15*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:15 Text:[NSString stringWithFormat:@"退款编号：%@", listModel.orderNumber] LabTextColor:kColorFontBlack1];
    [bgView addSubview:numLab];
    
    
    UILabel *nameLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 40*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:15 Text:[NSString stringWithFormat:@"买家：%@",listModel.shopName] LabTextColor:kColorFontBlack1];
    [bgView addSubview:nameLab];
    
    

    UILabel *statusLab = [createControl labelWithFrame:CGRectMake(WIDTH-150*kWidthScale, 26*kHeightScale, 135*kWidthScale, 30*kHeightScale) Font:15 Text:listModel.retrunStatus LabTextColor:kColorAppRed];


    statusLab.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:statusLab];
    
    
    UILabel *line = [createControl createLineWithFrame:CGRectMake(15*kWidthScale, 69*kHeightScale, WIDTH-30*kWidthScale, 1*kHeightScale) labelLineColor:kColorLine];
    [bgView addSubview:line];
    
    return headerView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    MyOrderFormListModel *listModel = _dataSource[section];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 45*kHeightScale)];
    footView.backgroundColor = kColorWhite;
    
    
    UILabel *line = [createControl createLineWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-30*kWidthScale, 0.5*kHeightScale) labelLineColor:kColorLine];
    [footView addSubview:line];
    
    
    UILabel *detailLab = [LXTControl createLabelWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-30*kWidthScale, 45*kHeightScale) Font:13 Text:@""];
    detailLab.textColor = [UIColor colorWithHexString:@"#434343"];
    [footView addSubview:detailLab];
    NSString *nameStr = [NSString stringWithFormat:@"退款金额：¥%0.2f", listModel.totle];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:nameStr];
    NSRange range = [nameStr rangeOfString:[NSString stringWithFormat:@"¥%0.2f",listModel.totle]];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff5c36"] range:range];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:range];
    detailLab.attributedText = attStr;
    detailLab.textAlignment = NSTextAlignmentRight;
    
    
    return footView;
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
    MyOrderFormListModel *listModel = _dataSource[indexPath.section];
    
    ShopOrderReturnDetailVC *detailVC = [[ShopOrderReturnDetailVC alloc]init];
    detailVC.orderId = @(listModel.orderId).stringValue;
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
