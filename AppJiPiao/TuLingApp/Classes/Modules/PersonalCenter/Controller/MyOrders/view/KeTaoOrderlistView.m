//
//  KeTaoOrderlistView.m
//  TuLingApp
//
//  Created by 李立达 on 2017/8/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "KeTaoOrderlistView.h"

#import "TLKeTaoSortModel.h"
#import "TLKeTaoSortBarView.h"
#import "MyOrderFormListModel.h"
#import "TLOrderWaitReceiveCell.h"
#import "TLMyOrderRemainEvaluateCell.h"
#import "MyOrderDetailVC.h"
#import "MyOrderFormListCell.h"
#import "payTypeVC.h"

@interface KeTaoOrderlistView ()
<
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource,
UIActionSheetDelegate
>

@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *cancelReasonData;

@property (nonatomic,strong) UIButton * messageButton;
@end


@implementation KeTaoOrderlistView
{
    NSInteger _selectOrderId;
    UIView *_cancelBgView;
    NSString *_reason;
}
-(instancetype)initWithFrame:(CGRect)frame
{

    if(self == [super initWithFrame:frame])
    {
        _orderType = @"0";
        _currentPage=1;
        self.backgroundColor = [UIColor whiteColor];
        _dataSource = [[NSMutableArray alloc]init];
        _cancelReasonData = [[NSMutableArray alloc]init];
        [self initSubViews];
        [self requestGetData];
    }
    return self;
}

-(void)initSubViews
{
    NSArray *titleArr = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
    
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
        if (_cancelBgView != nil) {
            [_cancelBgView removeFromSuperview];
            _cancelBgView = nil;
            return;
        }
        weakSelf.currentPage = 1;
        weakSelf.orderType = [NSString stringWithFormat:@"%d",index];
        [weakSelf requestGetData];
    }];
    
    
    [backView2 addSubview:barView];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, WIDTH,self.height-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
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


- (void) requestGetData
{
    TLAccount * account = [TLAccountSave account];
    NSDictionary *params = @{@"uuid":account.uuid, @"orderType":_orderType, @"page":@(_currentPage),@"size":@"5"};
    MJWeakSelf;
    NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"orderType=%@",_orderType]];
    [array addObject:[NSString stringWithFormat:@"uuid=%@",account.uuid]];
    [array addObject:[NSString stringWithFormat:@"time=%@",@(time)]];
    [array addObject:[NSString stringWithFormat:@"page=%@",@(_currentPage)]];
    [array addObject:[NSString stringWithFormat:@"size=%@",@(10)]];
    
    [NetAccess getForEncryptJSONDataWithUrl:kOrderFormList parameters:array  WithLoadingView:YES andLoadingViewStr:nil success:^(id reswponse){
        
        NSDictionary * hedaerDic = [reswponse objectForKey:@"header"];
        int code = [weakSelf requetsResutlCode:reswponse];
        if (code == 0){
            
        }else if (code == 100){
            [weakSelf showProgressError:@""];
        }else{
            NSString * mess = [hedaerDic objectForKey:@"message"];
            [weakSelf showProgressError:mess];
        }
        
        if ([reswponse[@"header"][@"code"] intValue] != 0) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        
        if (_currentPage == 1) {
            [_dataSource removeAllObjects];
        }
        
        NSArray *list = reswponse[@"date"][@"list"];
        
        for (NSDictionary *dict in list) {
            
            MyOrderFormListModel *listModel = [[MyOrderFormListModel alloc]init];
            
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
            listModel.cost = [dict[@"cost"] doubleValue];
            listModel.count = [dict[@"count"] integerValue];
            listModel.isReturn = [dict[@"isReturn"] boolValue];
            listModel.orderId = [dict[@"orderId"] integerValue];
            listModel.orderNumber = dict[@"orderNumber"];
            listModel.retrunStatus = dict[@"retrunStatus"];
            listModel.status = dict[@"status"];
            listModel.totle = [dict[@"totle"] doubleValue];
            
            [_dataSource addObject:listModel];
        }
        
        if (list.count == 0 || list.count<5) {
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

-(void)showProgressError:(NSString*)messageString{
    
    if ([NSString isBlankString:messageString]){
        [MBProgressHUD showError:messageString];
    }else{
        [MBProgressHUD showError:@"网络出错啦"];
    }
    
}

#pragma mark UITablviewDataSource 

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MyOrderFormListModel *listModel = _dataSource[section];
    return listModel.products.count;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    if ([_orderType isEqualToString:@"3"]){
    //
    //        MyOrderFormListModel *listModel = _dataSource[section];
    //        if(![NSString isBlankString:listModel.logisticsContent])
    //        {
    //            return nil;
    //        }else
    //        {
    //        TLMyOrderLogisticsView * view = [[TLMyOrderLogisticsView alloc] init];;
    //        view.model = listModel;
    //        return view;
    //        }
    //    }
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 55)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    MyOrderFormListModel *listModel = _dataSource[section];
    NSString *numberStr = [NSString stringWithFormat: @"订单编号：%@",listModel.orderNumber];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:numberStr];
    NSRange range = [numberStr rangeOfString:@"订单编号："];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#919191"] range:range];
    
    UILabel *orderNumber = [LXTControl createLabelWithFrame:CGRectMake(15, 10, WIDTH-100, 35) Font:15 Text:@""];
    orderNumber.attributedText = attStr;
    [bgView addSubview:orderNumber];
    
    
    UILabel *status = [LXTControl createLabelWithFrame:CGRectMake(WIDTH-100, 0, 85, 55) Font:15 Text:listModel.status];
    if ([listModel.status isEqualToString:@"已取消"]) {
        status.textColor = [UIColor colorWithHexString:@"#434343"];
    } else {
        status.textColor = [UIColor colorWithHexString:@"#FF4861"];
    }
    
    status.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:status];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, 54.5, WIDTH-30, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"C8C7CC"];
    [bgView addSubview:line];
    
    return bgView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    MyOrderFormListModel *listModel = _dataSource[section];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:view];
    
    CGFloat topSpcae = 0;
    CGFloat lineSpace = 0;
    //    if([_orderType isEqualToString:@"3"]){
    //        bgView.frame = CGRectMake(0, 0, WIDTH, 60);
    //        view.frame = CGRectMake(0, 0, WIDTH, 50);
    //        topSpcae = 10;
    //        lineSpace = 0;
    //    }else{
    
    if (listModel.buttons.count != 0) {
        bgView.frame = CGRectMake(0, 0, WIDTH, 115);
        view.frame = CGRectMake(0, 0, WIDTH, 100);
    } else {
        bgView.frame = CGRectMake(0, 0, WIDTH, 65);
        view.frame = CGRectMake(0, 0, WIDTH, 50);
    }
    topSpcae = 60;
    lineSpace = 50;
    //    }
    
    int count = (int)listModel.buttons.count;
    //    if(![_orderType isEqualToString:@"3"]){
    UILabel *detailLab = [LXTControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-30, 44) Font:13 Text:@""];
    detailLab.textColor = [UIColor colorWithHexString:@"#434343"];
    [view addSubview:detailLab];
    NSString *nameStr = [NSString stringWithFormat:@"共%zd件商品，合计：¥%0.2f（含运费¥%0.2f）", listModel.count, listModel.totle, listModel.cost];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:nameStr];
    NSRange range = [nameStr rangeOfString:[NSString stringWithFormat:@"¥%0.2f",listModel.totle]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
    detailLab.attributedText = attStr;
    detailLab.textAlignment = NSTextAlignmentRight;
    
    if (count != 0) {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, lineSpace, WIDTH-30, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#C8C7CC"];
        [view addSubview:line];
    }
    //    }else{
    //
    //    }
    CGFloat buttonWidth = floor((WIDTH - 60 ) / 3);
    for (int i=1; i<=count; i++) {
        
        OrderFormButtonsModel *buttonsModel = listModel.buttons[count-i];
        
        UIButton *btn = [LXTControl createButtonWithFrame:CGRectMake(WIDTH-15-buttonWidth*i-15*(i-1), topSpcae, buttonWidth, 30) ImageName:nil Target:self Action:@selector(onFootBtnClick:) Title:buttonsModel.buttonName];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.tag = section*10000+(count-i);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        btn.layer.borderWidth = 0.5;
        
        if ([buttonsModel.buttonName isEqualToString:@"取消订单"] || [buttonsModel.buttonName isEqualToString:@"删除订单"] || [buttonsModel.buttonName isEqualToString:@"查看物流"]) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
        } else {
            [btn setTitleColor:[UIColor colorWithHexString:@"#FF5C36"] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor colorWithHexString:@"#FF5C36"].CGColor;
        }
        
        
        [view addSubview:btn];
    }
    
    return bgView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_orderType isEqualToString:@"3"]){
        
        TLOrderWaitReceiveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TLOrderWaitReceiveCell_ID"];
        if (!cell){
            cell = [[TLOrderWaitReceiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TLOrderWaitReceiveCell_ID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        MyOrderFormListModel *model = _dataSource[indexPath.section];
        cell.model = model.products[indexPath.row];
        return cell;
    }else
        if ([_orderType isEqualToString:@"4"]){
            
            TLMyOrderRemainEvaluateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TLMyOrderRemainEvaluateCell_ID"];
            if (!cell){
                cell = [[TLMyOrderRemainEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TLMyOrderRemainEvaluateCell_ID"];
                
            }
            MJWeakSelf
            MyOrderFormListModel *model = _dataSource[indexPath.section];
            OrderFormProductsModel *productmodel = model.products[indexPath.row];
            cell.model =productmodel;
            cell.eventBlock = ^{
                [weakSelf shareFenXiangZhuan:productmodel.productId];
            };
            
            return cell;
            
            
        }
    
    static NSString *cellId = @"MyOrderFormListCell_ID";
    MyOrderFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyOrderFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, 114.5, WIDTH-30, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#C8C7CC"];
        [cell.contentView addSubview:line];
    }
    
    MyOrderFormListModel *model = _dataSource[indexPath.section];
    cell.model = model.products[indexPath.row];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if ([_orderType isEqualToString:@"3"]){
    //        MyOrderFormListModel *listModel = _dataSource[section];
    //        if([NSString isBlankString:listModel.logisticsContent])
    //        {
    //        return 15 + 32 + 7 + 16 + 15;
    //        }else
    //        {
    //            return 0.01;
    //        }
    //    }
    return 55;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    MyOrderFormListModel *listModel = _dataSource[section];
    
    //    if([_orderType isEqualToString:@"3"]){
    //        if (listModel.buttons.count != 0) {
    //            return 60;
    //        } else {
    //            return 1;
    //        }
    //    }else{
    if (listModel.buttons.count != 0) {
        return 115;
    } else {
        return 65;
    }
    //    }
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cancelBgView != nil) {
        [_cancelBgView removeFromSuperview];
        _cancelBgView = nil;
        return;
    }
    MyOrderFormListModel *model = _dataSource[indexPath.section];
    MyOrderDetailVC *detailVC = [[MyOrderDetailVC alloc]init];
    detailVC.orderId = model.orderId;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}

- (void) onFootBtnClick:(UIButton *)sender
{
    if (_cancelBgView != nil) {
        [_cancelBgView removeFromSuperview];
        _cancelBgView = nil;
        return;
    }
    
    NSInteger section = sender.tag/10000;
    NSInteger row = sender.tag%10000;
    
    MyOrderFormListModel *listModel = _dataSource[section];
    OrderFormButtonsModel *buttomsModel = listModel.buttons[row];
    
    if (buttomsModel.buttonId == 1) { // 取消订单
        // 友盟统计
        [MobClick event:@"TC221"];
        _selectOrderId = listModel.orderId;
        [self cancelOrder];
    } else if (buttomsModel.buttonId == 2) { // 付款
        [MobClick event:@"TC222"];
        _selectOrderId = listModel.orderId;
        payTypeVC *vc = [[payTypeVC alloc]init];
        vc.orderID =[NSString stringWithFormat:@"%ld",(long)_selectOrderId];
        [self.viewController.navigationController pushViewController:vc animated:YES];
        //[self payType];
        
    } else if (buttomsModel.buttonId == 3) { // 查看物流
   
        
    } else if (buttomsModel.buttonId == 4) { // 确认收货
        
        [self confirmOrderRequest:listModel.orderId];
        
    } else if (buttomsModel.buttonId == 5) { // 删除订单
        [MobClick event:@"TC224"];
        [self deleteOrderRequest:listModel.orderId];
        
    } else if (buttomsModel.buttonId == 6) { // 评价
        
    } else if (buttomsModel.buttonId == 7) { // 重新购买
       
    } else if (buttomsModel.buttonId == 8){ //分享赚
       
    }
}

- (void) onCancelFinishBtnClick:(UIButton *)sender
{
    //    [_cancelBgView removeFromSuperview];
    _cancelBgView.hidden = YES;
    
    
  
}
- (void) confirmOrderRequest:(NSInteger)orderId
{
    TLAccount * account = [TLAccountSave account];
    NSDictionary *params = @{@"uuid":account.uuid, @"orderId":@(orderId)};
    
    [NetAccess getJSONDataWithUrl:kOrderFormConfirm parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
        
        
        if ([reswponse[@"header"][@"code"] intValue] != 0) {
            return ;
        }
        //        _currentPage = 1;
        //        [self requestGetData];
        [self.tableView.mj_header beginRefreshing];
        [MBProgressHUD showSuccess:@"交易成功"];
    } fail:^{
        [MBProgressHUD showSuccess:@"网络出错了"];
    }];
}

- (void) deleteOrderRequest:(NSInteger)orderId
{
   
}
- (void) cancelOrder
{
    _cancelBgView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-64-250, WIDTH, 250)];
    _cancelBgView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self addSubview:_cancelBgView];
    
    
    if (_cancelReasonData.count != 0) {
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.frame = CGRectMake(WIDTH-60, 0, 60, 30);
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [finishBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(onCancelFinishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBgView addSubview:finishBtn];
        UIButton *cacenl = [UIButton buttonWithType:UIButtonTypeCustom];
        cacenl.frame = CGRectMake(15, 0, 60, 30);
        cacenl.titleLabel.font = [UIFont systemFontOfSize:12];
        [cacenl setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        [cacenl setTitle:@"取消" forState:UIControlStateNormal];
        [cacenl addTarget:self action:@selector(onCancelClickWith:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBgView addSubview:cacenl];
        UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, WIDTH, 220)];
        picker.dataSource = self;
        picker.delegate = self;
        picker.backgroundColor = [UIColor whiteColor];
        [_cancelBgView addSubview:picker];
        CancelOrderReasonModel *model = _cancelReasonData[0];
        _reason = model.dicName;
        
        return;
    } else {
        TLAccount * account = [TLAccountSave account];
        NSDictionary *params = @{@"uuid":account.uuid};
        
        [NetAccess getJSONDataWithUrl:kOrderFormCancelReason parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
            
            
            
            if ([reswponse[@"header"][@"code"] intValue] != 0) {
                return ;
            }
            
            [_cancelReasonData removeAllObjects];
            for (NSDictionary *dict in reswponse[@"date"]) {
                CancelOrderReasonModel *cancelReasonModel = [[CancelOrderReasonModel alloc]init];
                [cancelReasonModel setValuesForKeysWithDictionary:dict];
                cancelReasonModel.reasonId = [dict[@"id"] integerValue];
                [_cancelReasonData addObject:cancelReasonModel];
            }
            
            UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            finishBtn.frame = CGRectMake(WIDTH-60, 0, 60, 30);
            finishBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [finishBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
            [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
            [finishBtn addTarget:self action:@selector(onCancelFinishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_cancelBgView addSubview:finishBtn];
            UIButton *cacenl = [UIButton buttonWithType:UIButtonTypeCustom];
            cacenl.frame = CGRectMake(15, 0, 60, 30);
            cacenl.titleLabel.font = [UIFont systemFontOfSize:12];
            [cacenl setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
            [cacenl setTitle:@"取消" forState:UIControlStateNormal];
            [cacenl addTarget:self action:@selector(onCancelClickWith:) forControlEvents:UIControlEventTouchUpInside];
            [_cancelBgView addSubview:cacenl];
            UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, WIDTH, 220)];
            picker.dataSource = self;
            picker.delegate = self;
            picker.backgroundColor = [UIColor whiteColor];
            [_cancelBgView addSubview:picker];
            CancelOrderReasonModel *model = _cancelReasonData[0];
            _reason = model.dicName;
        } fail:^{
            [MBProgressHUD showSuccess:@"网络出错了"];
        }];
    }
}
-(void)onCancelClickWith:(UIButton *)sender
{
    if(_cancelBgView!=nil)
    {
        [_cancelBgView removeFromSuperview];
        _cancelBgView = nil;
    }
}

-(void)shareFenXiangZhuan:(NSInteger)productId{
    
}
-(void)btnClickShareRule
{

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
    
    [_cancelBgView removeFromSuperview];
    _cancelBgView = nil;
}


- (void)WxResult:(NSNotification *)text{
    
    NSString *str= text.userInfo[@"result"];
    if ([str isEqualToString:@"0"]) {
       
    }else
    {
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *str1= [defaults objectForKey:@"orderId1"];
        if ([str1 isEqualToString:@"0"]) {
            //列表页
            
        }else
        {
            
            MyOrderDetailVC *fail = [[MyOrderDetailVC alloc]init];
            fail.orderId=[str1 integerValue];
            [self.viewController.navigationController pushViewController:fail animated:YES];
            
            
        }
        
    }
}

@end
