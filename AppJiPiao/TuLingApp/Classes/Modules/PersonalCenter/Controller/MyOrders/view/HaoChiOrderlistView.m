//
//  HaoChiOrderlistView.m
//  TuLingApp
//
//  Created by 李立达 on 2017/8/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "HaoChiOrderlistView.h"
#import "TLKeTaoSortModel.h"
#import "TLKeTaoSortBarView.h"
#import "HCOrderListCell.h"
#import "orderButton.h"
#import "HCOrderlistPruductModel.h"
#import "MyOrderFormListModel.h"
@interface HaoChiOrderlistView ()
<
  UITableViewDelegate,
  UITableViewDataSource,
  UIPickerViewDelegate,
  UIPickerViewDataSource
>
@property(nonatomic,strong)NSString *orderStatus;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *cancelReasonData;

@end

@implementation HaoChiOrderlistView
{
    NSString *_selectOrderId;
    UIView *_cancelBgView;
    NSString *_reason;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    
    if(self == [super initWithFrame:frame])
    {
        _orderStatus = @"";
        _currentPage= 1;
        self.backgroundColor = [UIColor whiteColor];
        _dataSource = [[NSMutableArray alloc]init];
        _cancelReasonData = [NSMutableArray array];
        [self initSubViews];
        [self requestGetData];
    }
    return self;
}


-(void)initSubViews
{
    NSArray *titleArr = @[@"全部",@"待付款",@"待使用",@"待评价",@"退款"];
    
    UIView *backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 5, WIDTH, 45)];
    backView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView2];
    MJWeakSelf;
    NSMutableArray * modelArray = [NSMutableArray array];
    for (NSString * name in titleArr) {
        TLKeTaoSortModel * model = [[TLKeTaoSortModel alloc] init];
        model.isNeedSort = NO;
        model.isNeedChoose = NO;
        model.name = name;
        [modelArray addObject:model];
    }
    
    
    TLKeTaoSortBarView * barView = [[TLKeTaoSortBarView alloc] initWithTitles:modelArray];
    barView.textFont = [UIFont fontWithName:FONT_REGULAR size:15];
    barView.selectTextColor = [UIColor colorWithHexString:@"#0A6524"];
    barView.bottomMarkViewColor = [UIColor clearColor];
    [barView chooseEvent:^(int index, BOOL isNeedSort, BOOL isUp, TLKeTaoSortModel *model) {
        
        weakSelf.currentPage = 1;
       
        switch (index) {
            case 0:
                weakSelf.orderStatus = @"";
                break;
            case 1:
                weakSelf.orderStatus = @"1";
                break;
            case 2:
                weakSelf.orderStatus = @"2";
                break;
            case 3:
                weakSelf.orderStatus = @"3";
                break;
            case 4:
                weakSelf.orderStatus = @"8";
                break;
            default:
                break;
        }
        [weakSelf requestGetData];
    }];
    [backView2 addSubview:barView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, WIDTH,self.height-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[HCOrderListCell class] forCellReuseIdentifier:@"HCOrderListCell"];
    [self addSubview:_tableView];
    UIView *view  = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, mainScreenWidth, 10);
    view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    self.tableView.tableFooterView = view;
    [self setUpRefreshView];
}

- (void)setUpRefreshView
{
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        
        // 重新请求数据
        [weakSelf requestGetData];
    }];
    
    //设置上拉加载
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage ++;
        [weakSelf requestGetData];
    }];
    self.tableView.mj_footer.hidden = YES;
}
-(void)requestGetData
{
    TLAccount * account = [TLAccountSave account];
    NSDictionary *params;

    params = @{@"orderStatus":self.orderStatus,@"uuid":account.uuid, @"page":@(_currentPage),@"size":@"10",@"businessType":@"2"};
    MJWeakSelf;
    [NetAccess getJSONDataWithUrl:kHaoChiOrderList parameters:params  WithLoadingView:YES andLoadingViewStr:nil success:^(id reswponse){
        
        if ([reswponse[@"code"] intValue] != 0) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        
        if (_currentPage == 1) {
            [_dataSource removeAllObjects];
        }
        
    
        
        NSArray *list = reswponse[@"data"][@"list"];
        [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict =obj;
            HCOrderlistPruductModel *model = [[HCOrderlistPruductModel alloc]initWithDictionary:dict error:nil];
            [_dataSource addObject:model];
        }];
        
        if (list.count == 0 || list.count<10) {
            weakSelf.tableView.mj_footer.hidden = YES;
        } else {
            weakSelf.tableView.mj_footer.hidden = NO;
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    } fail:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];

}

#pragma mark UITablviewDeleGate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section!=0)
    {
        return 10;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 0)
    {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    view.frame = CGRectMake(0, 0, mainScreenWidth, 10);
    return view;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 168*SCALEPhoneWIDTH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCOrderListCell"];
    cell.modle = _dataSource[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_cancelBgView != nil) {
        [_cancelBgView removeFromSuperview];
        _cancelBgView = nil;
        return;
    }
   
   
}
-(NSArray *)buttonsWithArray:(NSArray *)buttonsStauts withSection:(NSInteger)section;
{
    NSMutableArray *array = [NSMutableArray array];
    [buttonsStauts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        orderButton *button = [[orderButton alloc]init];
        CGFloat buttonWidth = 80*SCALEPhoneWIDTH;
        NSDictionary *dict = obj;
        NSString *string = dict[@"name"];
        button.bounds = CGRectMake(0, 0, buttonWidth, 30*SCALEPhoneWIDTH);
        [button setTitle:string forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15*SCALEPhoneWIDTH];
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = SINGLE_LINE_WIDTH;
        if ([string isEqualToString:@"取消订单"] || [string isEqualToString:@"查看"] || [string isEqualToString:@"退款"]||[string isEqualToString:@"删除订单"]|| [string isEqualToString:@"退款详情"]) {
            [button setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
        } else {
            [button setTitleColor:[UIColor colorWithHexString:@"#FF5C36"] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor colorWithHexString:@"#FF5C36"].CGColor;
        }
        button.tag = section;
        button.orderButtonType = [dict[@"id"]integerValue];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [array insertObject:button atIndex:0];
    }];
    return array;
}
-(void)buttonClick:(orderButton*)sender
{
 
    
}


-(void)showProgressError:(NSString*)messageString{
    
    if ([NSString isBlankString:messageString]){
        [MBProgressHUD showError:messageString];
    }else{
        [MBProgressHUD showError:@"网络出错啦"];
    }
    
}
-(int)requetsResutlCode:(NSDictionary *)responseDic{
    
    if ([responseDic objectForKey:@"header"]){
        NSDictionary * headerDic = [responseDic objectForKey:@"header"];
        if (!headerDic){
            return -1;
        }
        int code = [headerDic[@"code"] intValue];
        
        return code;
    }
    
    return -1;
}
-(NSArray *)OrderStatusReturnBottons:(NSInteger )orderStatus
{
    NSArray *array;
    switch (orderStatus) {
        case 1:
            array =@[@{@"name":@"取消订单",@"id":@"2"},@{@"name":@"继续支付",@"id":@"1"}];
            break;
        case 2:
            array =@[@{@"name":@"退款",@"id":@"3"}];
            break;
        case 3:
            array =@[@{@"name":@"评价",@"id":@"4"}];
            break;
        case 4:
            array = @[@{@"name":@"删除订单",@"id":@"7"}];
            break;
        case 5:
            array = @[@{@"name":@"删除订单",@"id":@"7"}];
            break;
        case 6:
            array =@[];
            break;
        case 8:
            array =@[@{@"name":@"退款详情",@"id":@"5"}];
            break;
        case 0:
            array =@[@{@"name":@"退款详情",@"id":@"5"}];
            break;
        default:
            array=@[];
            break;
    }

    return array;
}
#pragma PickViewDeleGate
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_cancelReasonData.count < 5) {
        return _cancelReasonData.count;
    } else
        return 5;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CancelOrderReasonModel *model = _cancelReasonData[row];
    return model.dicName;
}
// 哪一行被选中
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CancelOrderReasonModel *model = _cancelReasonData[row];
    _reason = model.dicName;
}
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
    if(_cancelBgView!=nil)
    {
    [_cancelBgView removeFromSuperview];
    _cancelBgView = nil;
    }
}

- (void)onCancelFinishBtnClickWith
{
    TLAccount * account = [TLAccountSave account];
    _cancelBgView.hidden = YES;
    NSDictionary *params = @{@"uuid":account.uuid,@"orderId":_selectOrderId,@"cancelReason":_reason};
    [NetAccess getJSONDataWithUrl:kHaoChiOrderCancel parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
        if ([reswponse[@"code"] intValue] != 0) {
            NSString *msg = reswponse[@"msg"];
            [MBProgressHUD showError:msg];
            return ;
        }
        [self.tableView.mj_header beginRefreshing];
        [MBProgressHUD showSuccess:@"取消订单成功"];
    } fail:^{
        [MBProgressHUD showSuccess:@"网络出错了"];
    }];
    
}
- (void) deleteOrderRequest:(NSString*)orderId
{
    TLAccount * account = [TLAccountSave account];
    NSDictionary *params = @{@"uuid":account.uuid, @"orderId":orderId};
    
    [NetAccess getJSONDataWithUrl:kHaoChiOrderDelete parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
        
        
        if ([reswponse[@"code"] intValue] != 0) {
            NSString *msg = reswponse[@"msg"];
            [MBProgressHUD showError:msg];
            return ;
        }
        //        _currentPage = 1;
        //        [self requestGetData];
        [self.tableView.mj_header beginRefreshing];
        [MBProgressHUD showSuccess:@"删除订单成功"];
    } fail:^{
        [MBProgressHUD showSuccess:@"网络出错了"];
    }];
}
@end
