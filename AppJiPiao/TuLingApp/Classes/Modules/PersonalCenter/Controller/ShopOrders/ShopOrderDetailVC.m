//
//  ShopOrderDetailVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/20.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ShopOrderDetailVC.h"
#import "ShopOrderDetailModel.h"
#import "MyOrderFormListModel.h"

#import "ShopOrderDetailBaseInfoCell.h"
#import "MyOrderFormListCell.h"
#import "ShopOrderDetailAddressCell.h"
#import "ShopOrderDetailCancelView.h"

#import "ShopOrderSendVC.h"
#import "ShopOrderReturnDetailVC.h"


@interface ShopOrderDetailVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titles;
    UIButton *_sendProductBtn;
    
    NSString *_reasonStr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ShopOrderDetailModel *detailModel;
@property (nonatomic, strong) NSMutableArray *cancelReasonData; // 退款理由
@property (nonatomic, strong) UIView *cancelBgView;

@end

@implementation ShopOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _titles = @[@"订单基本信息", @"商品信息", @"收货信息", @"快递信息", @"", @""];
    _cancelReasonData = [[NSMutableArray alloc]init];

    [self createSubView];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestGetDate];
}

- (void) requestGetDate
{
    NSDictionary *params = @{@"uuid":[TLAccountSave account].uuid, @"orderId":_orderId};
    
    [NetAccess getJSONDataWithUrl:kShopOrderDetail parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
      
        if (reswponse[@"header"] == nil) {
            return;
        }
        if ([reswponse[@"header"][@"code"] intValue] != 0) {
            return ;
        }
        if (reswponse[@"date"] == nil) {
            return;
        }
        NSDictionary *date = [reswponse objectForKey:@"date"];
        NSArray *products = date[@"priducts"];
        
        _detailModel = [[ShopOrderDetailModel alloc]init];
        [_detailModel setValuesForKeysWithDictionary:date];
        
        _detailModel.priducts = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dict in products) {
            OrderFormProductsModel *productsModel = [[OrderFormProductsModel alloc]init];
            [productsModel setValuesForKeysWithDictionary:dict];
            [_detailModel.priducts addObject:productsModel];
        }
        
        self.title = _detailModel.status;

        
        if (_detailModel.statusId == 2) { // 待发货
            if (!_detailModel.isReturn) {
                [self createViewFootView];
            } else {
                _tableView.frame = CGRectMake(0, 5*kHeightScale, WIDTH, HEIGHT-64-5*kHeightScale);
                [_sendProductBtn removeFromSuperview];
            }
            
        } else {
            _tableView.frame = CGRectMake(0, 5*kHeightScale, WIDTH, HEIGHT-64-5*kHeightScale);
            [_sendProductBtn removeFromSuperview];
        }

        [_tableView reloadData];
    } fail:^{
    }];
}

- (void) createSubView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5*kHeightScale, WIDTH, HEIGHT-64-5*kHeightScale) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorClear;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void) createViewFootView
{
    _tableView.frame = CGRectMake(0, 5*kHeightScale, WIDTH, HEIGHT-64-55*kHeightScale);
    
    _sendProductBtn = [LXTControl createBtnWithFrame:CGRectMake(0, HEIGHT-64-50*kHeightScale, WIDTH, 50*kHeightScale) titleName:_detailModel.buttons[@"buttonName"] imgName:nil selImgName:nil target:self action:@selector(onSendProductBtnClick)];
    _sendProductBtn.backgroundColor = kColorAppGreen;
    [_sendProductBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [self.view addSubview:_sendProductBtn];
}


/**
 发货按钮
 */
- (void) onSendProductBtnClick
{
    
    
    ShopOrderSendVC *sendVC = [[ShopOrderSendVC alloc]init];
    sendVC.orderId = @(_detailModel.orderId).stringValue;
    [self.navigationController pushViewController:sendVC animated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_detailModel.statusId == 1) { // 待付款
        
        return 4;
    } else if (_detailModel.statusId == 2) { // 待发货
        if (_detailModel.isReturn) { // 退款
            return 2;
        }
        return 3;
    } else if (_detailModel.statusId == 5 || _detailModel.statusId == 7 || _detailModel.statusId == 8) { //交易失败
        return 3;
    } else if (_detailModel.statusId == 3 || _detailModel.statusId == 4 || _detailModel.statusId == 6) { // 4交易成功、6评价、3已发货
        return 4;
    }
    
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _detailModel.priducts.count;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_detailModel.statusId == 1) { // 待付款
        if (section == 3) {
            return 0.01;
        }
    }
    return 49*kHeightScale;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (_detailModel.remarks.length == 0) {
            return 55*kHeightScale;
        }
        
        CGSize size = [_detailModel.remarks sizeWithFont:15 andMaxSize:CGSizeMake(WIDTH-100*kWidthScale, 200)];
        if (size.height < 15*kHeightScale) {
            size.height = 15*kHeightScale;
        }
        return size.height + 85*kHeightScale;
    }
    return 10*kHeightScale;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_detailModel.statusId == 2) { // 待发货
            if (_detailModel.isReturn) {
                return 225*kHeightScale;
            }
            return 155*kHeightScale;
        } else if (_detailModel.statusId == 3) { // 已发货
            return 155*kHeightScale;
        } else if (_detailModel.statusId == 4 || _detailModel.statusId == 6) { // 成功、评价
            return 180*kHeightScale;
        }
        return 110 *kHeightScale;
    } else if (indexPath.section == 1) {
        
        return 115*kHeightScale;
    } else if (indexPath.section == 2) {
        
        CGSize nameSize = [_detailModel.consignee sizeWithFont:15 andMaxSize:CGSizeMake(WIDTH-30*kWidthScale, 20)];
        CGSize addSize = [_detailModel.address sizeWithFont:15 andMaxSize:CGSizeMake(WIDTH-30*kWidthScale, 200)];
        
        return nameSize.height + addSize.height + 55*kHeightScale;
    } else if (indexPath.section == 3) {
        if (_detailModel.statusId == 1) {
            return 100*kHeightScale;
        }
        return 90*kHeightScale;
    }
    return 0.01;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_detailModel.statusId == 1) { // 待付款
        if (section == 3) {
            return nil;
        }
    }
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50*kHeightScale)];
    bgView.backgroundColor = kColorWhite;
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*kHeightScale, 3*kWidthScale, 20*kHeightScale)];
    line.backgroundColor = kColorAppGreen;
    [bgView addSubview:line];
    
    
    UILabel *title = [LXTControl createLabelWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-15*kWidthScale, 50*kHeightScale) Font:16 Text:nil];
    title.textColor = kColorFontBlack1;
    title.text = _titles[section];
    [bgView addSubview:title];
    
    
    UILabel *line1 = [createControl createLineWithFrame:CGRectMake(15*kWidthScale, 49*kHeightScale, WIDTH-30*kWidthScale, 1*kHeightScale) labelLineColor:kColorLine];
    [bgView addSubview:line1];
    
    
    if (section == 0) {
        if (_detailModel.returnStatus.length != 0) {
            
            UILabel *retrunStatusLab = [createControl labelWithFrame:CGRectMake(WIDTH-200*kWidthScale, 0, 185*kWidthScale, 50*kHeightScale) Font:13 Text:_detailModel.returnStatus LabTextColor:kColorAppRed];
            retrunStatusLab.textAlignment = NSTextAlignmentRight;
            [bgView addSubview:retrunStatusLab];
        }
    }
    
    if (section == 3) {
        UILabel *statusLab = [createControl labelWithFrame:CGRectMake(WIDTH-100*kWidthScale, 0, 85*kWidthScale, 50*kHeightScale) Font:13 Text:_detailModel.logisticsStatus LabTextColor:kColorAppGreen];
        statusLab.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:statusLab];
    }
    
    return bgView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != 1) {
        return nil;
    }
    
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = kColorClear;
    
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = kColorWhite;
    [footView addSubview:bgView];
    
    
    UILabel *line1 = [createControl createLineWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-30*kWidthScale, 0.5*kHeightScale) labelLineColor:kColorLine];
    [bgView addSubview:line1];
    
    
    CGFloat viewHeight = 0;
    
    if (_detailModel.remarks.length != 0) {
        
        UILabel *titleLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, viewHeight, 70*kHeightScale, 45*kHeightScale) Font:13 Text:@"买家留言：" LabTextColor:kColorFontBlack3];
        [bgView addSubview:titleLab];
        

        CGSize size = [_detailModel.remarks sizeWithFont:15 andMaxSize:CGSizeMake(WIDTH-100*kWidthScale, 200)];
        if (size.height < 15*kHeightScale) {
            size.height = 15*kHeightScale;
        }
        UILabel *remarkLab = [createControl labelWithFrame:CGRectMake(85*kWidthScale, 15*kHeightScale, WIDTH-100*kWidthScale, size.height) Font:15 Text:_detailModel.remarks LabTextColor:kColorFontBlack1];
        remarkLab.numberOfLines = 0;
        [bgView addSubview:remarkLab];
        
        
        viewHeight = CGRectGetMaxY(remarkLab.frame) + 15*kHeightScale;

        
        UILabel *line = [createControl createLineWithFrame:CGRectMake(15*kWidthScale, viewHeight, WIDTH-30*kWidthScale, 0.5*kHeightScale) labelLineColor:kColorLine];
        [bgView addSubview:line];
    }
    
    UILabel *detailLab = [LXTControl createLabelWithFrame:CGRectMake(15*kWidthScale, viewHeight, WIDTH-30*kWidthScale, 45*kHeightScale) Font:13 Text:@""];
    detailLab.textColor = [UIColor colorWithHexString:@"#434343"];
    [bgView addSubview:detailLab];
    NSString *nameStr = [NSString stringWithFormat:@"合计：¥%0.2lf（含运费¥%0.2lf）", _detailModel.totle, _detailModel.cost];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:nameStr];
    NSRange range = [nameStr rangeOfString:[NSString stringWithFormat:@"¥%0.2f", _detailModel.totle]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
    detailLab.attributedText = attStr;
    detailLab.textAlignment = NSTextAlignmentRight;
    
    
    bgView.frame = CGRectMake(0, 0, WIDTH, viewHeight + 45*kHeightScale);
    footView.frame = CGRectMake(0, 0, WIDTH, viewHeight + 55*kHeightScale);
    
    return footView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *cellId = @"FristCellIdentifier";
        ShopOrderDetailBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ShopOrderDetailBaseInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _detailModel;
        cell.returnBtnClick = ^{
           
            if (_shouldBack) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                ShopOrderReturnDetailVC *returnDetailVC = [[ShopOrderReturnDetailVC alloc]init];
                returnDetailVC.orderId = @(_detailModel.orderId).stringValue;
                returnDetailVC.shouldBack = YES;
                [self.navigationController pushViewController:returnDetailVC animated:YES];
            }
        };
        return cell;
    } else if (indexPath.section == 1) {
        
        static NSString *cellId = @"SecondCellIdentifier";
        MyOrderFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyOrderFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _detailModel.priducts[indexPath.row];
        return cell;
    } else if (indexPath.section == 2) {
        
        static NSString *cellId = @"thriddCellIdentifier";
        ShopOrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ShopOrderDetailAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _detailModel;
        return cell;
    } else if (indexPath.section == 3) {
        
        static NSString *cellId = @"FourthCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        if (_detailModel.statusId == 1) { // 待付款
            UIButton *cancelBtn = [LXTControl createBtnWithFrame:CGRectMake(WIDTH/2-40*kWidthScale, 30*kHeightScale, 80*kWidthScale, 30*kHeightScale) titleName:_detailModel.buttons[@"buttonName"] imgName:nil selImgName:nil target:self action:@selector(onCancelBtnClick)];
            cancelBtn.titleLabel.font = kFontNol15;
            cancelBtn.layer.masksToBounds = YES;
            cancelBtn.layer.cornerRadius = 2.5;
            cancelBtn.layer.borderWidth = 0.5;
            cancelBtn.layer.borderColor = kColorAppRed.CGColor;
            [cancelBtn setTitleColor:kColorAppRed forState:UIControlStateNormal];
            [cell.contentView addSubview:cancelBtn];
        } else {
            
            UILabel *title = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 20*kHeightScale, WIDTH-30*kWidthScale, 20*kHeightScale) Font:15 Text:[NSString stringWithFormat:@"%@：%@",_detailModel.logisticsName, _detailModel.logisticsNumber] LabTextColor:kColorFontBlack1];
            [cell.contentView addSubview:title];
            
            
            UIButton *logisticsBtn = [LXTControl createBtnWithFrame:CGRectMake(WIDTH-95*kWidthScale, 45*kHeightScale, 80*kWidthScale, 30*kHeightScale) titleName:@"查看物流" imgName:nil selImgName:nil target:self action:@selector(onLogisticsBtnClick)];
            logisticsBtn.titleLabel.font = kFontNol15;
            logisticsBtn.layer.masksToBounds = YES;
            logisticsBtn.layer.cornerRadius = 2.5;
            logisticsBtn.layer.borderWidth = 0.5;
            logisticsBtn.layer.borderColor = kColorAppRed.CGColor;
            [logisticsBtn setTitleColor:kColorAppRed forState:UIControlStateNormal];
            [cell.contentView addSubview:logisticsBtn];
        }
        
        return cell;
    }
    
    static NSString *cellId = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


/**
 取消订单
 */
- (void) onCancelBtnClick
{
    [MobClick event:@"TC221"];
    if (_cancelReasonData.count != 0) {
        
        ShopOrderDetailCancelView *alertView = [[ShopOrderDetailCancelView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [alertView storyBoardPopViewWithReasonDataSource:_cancelReasonData];
        alertView.cancelFinish = ^(NSString *reason) {
            
            [self onCancelFinishWithReason:reason];
        };
        return;
    } else {
        
        TLAccount * account = [TLAccountSave account];
        NSDictionary *params = @{@"uuid":account.uuid, @"dicType":@"8"};
        
        [NetAccess getJSONDataWithUrl:kShopOrderDicItem parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
            
          
            if (reswponse[@"header"] == nil) {
                return;
            }
            if ([reswponse[@"header"][@"code"] intValue] != 0) {
                return ;
            }
            if (reswponse[@"date"] == nil) {
                return;
            }
            
            [_cancelReasonData removeAllObjects];
            for (NSDictionary *dict in reswponse[@"date"]) {
                
                CancelOrderReasonModel *cancelReasonModel = [[CancelOrderReasonModel alloc]init];
                [cancelReasonModel setValuesForKeysWithDictionary:dict];
                cancelReasonModel.reasonId = [dict[@"id"] integerValue];
                [_cancelReasonData addObject:cancelReasonModel];
            }
            
            
            ShopOrderDetailCancelView *alertView = [[ShopOrderDetailCancelView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [alertView storyBoardPopViewWithReasonDataSource:_cancelReasonData];
            alertView.cancelFinish = ^(NSString *reason) {
                
                [self onCancelFinishWithReason:reason];
            };
            
            
        } fail:^{
            [MBProgressHUD showSuccess:@"网络出错了"];
        }];
    }
}

// 取消订单完成按钮
- (void) onCancelFinishWithReason:(NSString *)reason
{
    TLAccount * account = [TLAccountSave account];
    NSDictionary *params = @{@"uuid":account.uuid, @"orderId":@(_detailModel.orderId), @"reason":reason};
    
    [NetAccess getJSONDataWithUrl:kShopOrderCancel parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
     
        
        if ([reswponse[@"header"][@"code"] intValue] != 0) {
            return ;
        }
        [self requestGetDate];
        [MBProgressHUD showSuccess:@"取消订单成功"];
    } fail:^{
        [MBProgressHUD showSuccess:@"网络出错了"];
    }];
}


@end
