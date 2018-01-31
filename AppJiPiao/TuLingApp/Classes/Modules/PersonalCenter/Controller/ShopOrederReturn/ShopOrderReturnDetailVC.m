//
//  ShopOrderReturnDetailVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ShopOrderReturnDetailVC.h"
#import "ShopOrderReturnDetailModel.h"
#import "MyOrderFormListModel.h"

#import "MyOrderFormListCell.h"
#import "ShopOrderReturnDetailCell.h"
#import "ShopOrderDetailCancelView.h"

#import "ShopOrderDetailVC.h"
#import "ShopOrderSendVC.h"

@interface ShopOrderReturnDetailVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titles;
    
    UIView *_tableHeadView;
    UIView *_btnView;
    UILabel *_titleLab;
    UILabel *_detailLab;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ShopOrderReturnDetailModel *detailModel;
@property (nonatomic, strong) NSMutableArray *cancelReasonData;

@property (nonatomic,strong) UIButton * selectCurrentButton;
@end

@implementation ShopOrderReturnDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    _titles = @[@"退款协商", @"退款信息", @"订单信息", @""];
    _cancelReasonData = [[NSMutableArray alloc]init];
    
    [self createSubviews];
    [self requestGetData];
    [self createTableHeaderView];
}

- (void) createSubviews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorClear;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void) createTableHeaderView
{
    _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100*kHeightScale)];
    _tableHeadView.backgroundColor = kColorClear;
//    _tableView.tableHeaderView = _tableHeadView;
    
    
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100*kHeightScale)];
    redView.backgroundColor = kColorAppRed;
    [_tableHeadView addSubview:redView];
    
    
    _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 100*kHeightScale, WIDTH, 90*kHeightScale)];
    _btnView.backgroundColor = kColorWhite;
    [_tableHeadView addSubview:_btnView];
    
    
    _titleLab = [createControl labelWithFrame:CGRectMake(0, 20*kHeightScale, WIDTH, 20*kHeightScale) Font:17 Text:_detailModel.returnStatus LabTextColor:kColorWhite];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_tableHeadView addSubview:_titleLab];
    
    _detailLab = [createControl labelWithFrame:CGRectMake(0, 50*kHeightScale, WIDTH, 20*kHeightScale) Font:13 Text:@"" LabTextColor:kColorWhite];
    _detailLab.textAlignment = NSTextAlignmentCenter;
    [_tableHeadView addSubview:_detailLab];
    
    
    _leftBtn = [LXTControl createBtnWithFrame:CGRectMake(WIDTH/2-144*kWidthScale, 30*kHeightScale, 120*kWidthScale, 35*kHeightScale) titleName:@"" imgName:nil selImgName:nil target:self action:@selector(onHeadBtnClick:)];
    _leftBtn.titleLabel.font = kFontNol16;
    _leftBtn.layer.masksToBounds = YES;
    _leftBtn.layer.cornerRadius = 2.5;
    _leftBtn.layer.borderWidth = 1;
    _leftBtn.layer.borderColor = [UIColor colorWithHexString:@"#B2B2B2"].CGColor;
    [_btnView addSubview:_leftBtn];
    
    
    _rightBtn = [LXTControl createBtnWithFrame:CGRectMake(WIDTH/2+24*kWidthScale, 30*kHeightScale, 120*kWidthScale, 35*kHeightScale) titleName:@"" imgName:nil selImgName:nil target:self action:@selector(onHeadBtnClick:)];
    _rightBtn.titleLabel.font = kFontNol16;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.layer.cornerRadius = 2.5;
    _rightBtn.layer.borderWidth = 1;
    _rightBtn.layer.borderColor = [UIColor colorWithHexString:@"#B2B2B2"].CGColor;
    [_btnView addSubview:_rightBtn];
}

- (void) requestGetData
{
    NSString *uuid = [TLAccountSave account].uuid;
    NSDictionary *params = @{@"uuid":uuid, @"orderId":_orderId};
    
    [NetAccess getJSONDataWithUrl:kShopOrderReturnDetail parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
        
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

        
        _detailModel = [[ShopOrderReturnDetailModel alloc]init];
        [_detailModel setValuesForKeysWithDictionary:date];
        
        _detailModel.buttons = [[NSMutableArray alloc]init];
        _detailModel.products = [[NSMutableArray alloc]init];
        _detailModel.consults = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dict in date[@"consults"]) {
            ShopOrderREturnDetailConsultsModel *consultModel = [[ShopOrderREturnDetailConsultsModel alloc]init];
            [consultModel setValuesForKeysWithDictionary:dict];
            [_detailModel.consults addObject:consultModel];
        }
        
        for (NSDictionary *dict in date[@"products"]) {
            OrderFormProductsModel *produceModel = [[OrderFormProductsModel alloc]init];
            [produceModel setValuesForKeysWithDictionary:dict];
            [_detailModel.products addObject:produceModel];
        }
        
        for (NSDictionary *dict in date[@"buttons"]) {
            OrderFormButtonsModel *btnModle = [[OrderFormButtonsModel alloc]init];
            [btnModle setValuesForKeysWithDictionary:dict];
            [_detailModel.buttons addObject:btnModle];
        }
        
        [self changeTableView];
        [_tableView reloadData];
    } fail:^{
    }];
}

- (void) changeTableView
{
    _tableView.tableHeaderView = _tableHeadView;
    
    _titleLab.text = _detailModel.returnStatus;
    if (_detailModel.orderReturnType == 5) { // 退款成功
        _detailLab.text = @"商家同意退款";
    } else if (_detailModel.orderReturnType == 4) { // 待平台退款
        _detailLab.text = @"平台将在 3 个工作日内为您完成退款";
    } else if (_detailModel.orderReturnType == 6) { // 退款关闭
        _detailLab.text = @"商家拒绝退款";
    } else {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_detailModel.returnDateEnd/1000];
        //NSInteger time= _detailModel.returnDateEnd-_detailModel.returnDateStart;
        NSTimeInterval time = [date timeIntervalSinceNow];
        
        int value = abs((int)time);
        int minute = value / 60 % 60;// 分
        int house = value / 3600 % 24; // 时
        int day = value / (24 * 3600); // 天
        
        NSString *timeStr = [NSString stringWithFormat:@"%d天 %d小时 %d分", day, house, minute];
        NSString *detailStr = [NSString stringWithFormat:@"还剩 %@（逾期默认同意退款）", timeStr];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:detailStr];
        NSRange range = [detailStr rangeOfString:timeStr];
        [attStr addAttribute:NSFontAttributeName value:kFontNol17 range:range];
        _detailLab.attributedText = attStr;
    }
    
    if (_detailModel.buttons.count == 0) {
        _btnView.hidden = YES;
        _tableHeadView.frame = CGRectMake(0, 0, WIDTH, 100*kHeightScale);
    } else {
        _btnView.hidden = NO;
        _tableHeadView.frame = CGRectMake(0, 0, WIDTH, 190*kHeightScale);
        
        if (_detailModel.buttons.count > 1) {
            OrderFormButtonsModel *leftBtnModel = _detailModel.buttons[0];
            OrderFormButtonsModel *rightBtnModel = _detailModel.buttons[1];
        
            [_leftBtn setTitle:leftBtnModel.buttonName forState:UIControlStateNormal];
            [_rightBtn setTitle:rightBtnModel.buttonName forState:UIControlStateNormal];
            
            _leftBtn.tag = leftBtnModel.buttonId;
            _rightBtn.tag = rightBtnModel.buttonId;
        }
    }
}

// 拒绝退款、继续发货、同意退款
- (void) onHeadBtnClick:(UIButton *)sender
{
    
    if (!sender.enabled){
        return;
    }
    sender.enabled = NO;
    
    self.selectCurrentButton = sender;
    if (sender.tag == 1) { // 继续发货
        ShopOrderSendVC *sendVC = [[ShopOrderSendVC alloc]init];
        sendVC.orderId = @(_detailModel.orderId).stringValue;
        [self.navigationController pushViewController:sendVC animated:YES];
        sender.enabled = YES;
    } else if (sender.tag == 2) { // 同意退款
        
        [self onAgreeBtnClick];
    } else if (sender.tag == 3) { // 拒绝退款（需要理由）
        
        [self popReasonView];
        
    } else if (sender.tag == 5) { // 拒绝退款（不需要理由）
        
        
    }
}

- (void) popReasonView
{
    if (_cancelReasonData.count != 0) {
        
        ShopOrderDetailCancelView *alertView = [[ShopOrderDetailCancelView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [alertView storyBoardPopViewWithReasonDataSource:_cancelReasonData];
        alertView.cancelFinish = ^(NSString *reason) {
            
            [self onDisAgreeBtnClickWithReason:reason];
        };
        _selectCurrentButton.enabled = YES;
        return;
    } else {
        
        TLAccount * account = [TLAccountSave account];
        NSDictionary *params = @{@"uuid":account.uuid, @"dicType":@"6"};
        MJWeakSelf;
        [NetAccess getJSONDataWithUrl:kShopOrderDicItem parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
            weakSelf.selectCurrentButton.enabled = YES;
            
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
                
                [self onDisAgreeBtnClickWithReason:reason];
            };
            
            
        } fail:^{
            weakSelf.selectCurrentButton.enabled = YES;
            [MBProgressHUD showSuccess:@"网络出错了"];
        }];
    }
}

// 同意退款
- (void) onAgreeBtnClick
{
   
    
}

// 拒绝退款需要理由
- (void) onDisAgreeBtnClickWithReason:(NSString *)reason
{
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_detailModel == nil) {
        return 0;
    }
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _detailModel.consults.count;
    } else if (section == 1) {
        return _detailModel.products.count;
    } else {
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65*kHeightScale;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 140*kHeightScale;
    } else if (section == 0) {
        if (_detailModel.logistics) {
            return 60*kHeightScale;
        }
    }
    return 0.01*kHeightScale;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 65*kHeightScale)];
    headerView.backgroundColor = kColorClear;
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10*kHeightScale, WIDTH, 55*kHeightScale)];
    bgView.backgroundColor = kColorWhite;
    [headerView addSubview:bgView];
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*kHeightScale, 3*kWidthScale, 25*kHeightScale)];
    line.backgroundColor = kColorAppGreen;
    [bgView addSubview:line];
    
    
    UILabel *title = [LXTControl createLabelWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-15*kWidthScale, 55*kHeightScale) Font:16 Text:nil];
    title.textColor = kColorFontBlack1;
    title.text = _titles[section];
    [bgView addSubview:title];
    
    
    UILabel *line1 = [createControl createLineWithFrame:CGRectMake(15*kWidthScale, 54*kHeightScale, WIDTH-30*kWidthScale, 1*kHeightScale) labelLineColor:kColorLine];
    [bgView addSubview:line1];
    
    if (section == 2) {
        
        UILabel *statusLab = [createControl labelWithFrame:CGRectMake(WIDTH-150*kWidthScale, 0, 135*kWidthScale, 55*kHeightScale) Font:13 Text:_detailModel.status LabTextColor:kColorAppRed];
        statusLab.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:statusLab];
    }
    
    return headerView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (_detailModel.logistics) {
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 60*kHeightScale)];
            bgView.backgroundColor = kColorWhite;
            
            UIButton *logisticsBtn = [LXTControl createBtnWithFrame:CGRectMake(WIDTH-95*kWidthScale, 5*kHeightScale, 80*kWidthScale, 30*kHeightScale) titleName:@"查看物流" imgName:nil selImgName:nil target:self action:@selector(onLogisBtnClick)];
            logisticsBtn.titleLabel.font = kFontNol15;
            logisticsBtn.layer.masksToBounds = YES;
            logisticsBtn.layer.cornerRadius = 2.5;
            logisticsBtn.layer.borderWidth = 0.5;
            logisticsBtn.layer.borderColor = kColorAppRed.CGColor;
            [logisticsBtn setTitleColor:kColorAppRed forState:UIControlStateNormal];
            [bgView addSubview:logisticsBtn];
            
            return bgView;
        }
    }
    
    if (section != 1) {
        return nil;
    }

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 140*kHeightScale)];
    bgView.backgroundColor = kColorWhite;
    
    
    UILabel *line = [createControl createLineWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-30*kWidthScale, 0.5*kHeightScale) labelLineColor:kColorLine];
    [bgView addSubview:line];
    
    
    NSArray *titles = @[@"退款编号：",@"申请时间：",@"退款原因：",@"退款金额："];
    NSArray *detials = @[_detailModel.returnNumber, _detailModel.returnCreateTime, _detailModel.returnReason, [NSString stringWithFormat:@"¥%0.2f（全额退款）",_detailModel.cost]];
    
    for (int i=0; i<titles.count; i++) {
        
        UILabel *titleLab = [createControl createLabelWithFrame:CGRectMake(15*kWidthScale, 20*kHeightScale+30*kHeightScale*i, 150*kWidthScale, 15*kHeightScale) Font:15 Text:titles[i] LabTextColor:kColorFontBlack3];
        [bgView addSubview:titleLab];
        
        
        CGFloat titleX = CGRectGetMaxX(titleLab.frame);
        UILabel *detailLab = [createControl createLabelWithFrame:CGRectMake(titleX+10*kWidthScale, 20*kHeightScale +30*kHeightScale*i, WIDTH-titleX-25*kWidthScale, 15*kHeightScale) Font:15 Text:detials[i] LabTextColor:kColorFontBlack1];
        [bgView addSubview:detailLab];
        
        if (i==0) {
          UIButton  *_copyBtn =[LXTControl createButtonWithFrame:CGRectMake(WIDTH-15-50, detailLab.frame.origin.y-3, 50, 20) ImageName:nil Target:self Action:@selector(myCopy:) Title:@"复制"];
            [_copyBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
            _copyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            _copyBtn.layer.masksToBounds=YES;
            _copyBtn.layer.cornerRadius = 2.5;
            _copyBtn.layer.borderWidth=0.5;
            _copyBtn.layer.borderColor=[UIColor colorWithHexString:@"#919191"].CGColor;
            [bgView addSubview:_copyBtn];
        }
    }
    
    return bgView;
}

-(void)myCopy:(UIButton *)sender
{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@", _detailModel.returnNumber];
    [MBProgressHUD showSuccess:@"复制成功"];
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        CGFloat cellHeight = 50*kHeightScale;
        
        ShopOrderREturnDetailConsultsModel *model = _detailModel.consults[indexPath.row];
        CGSize size = [model.content sizeWithFont:15 andMaxSize:CGSizeMake(WIDTH-30*kHeightScale, 200)];
        cellHeight = cellHeight + size.height;
        
        NSInteger count = model.shopOrderRetrunImgs.count;
        if (count != 0) {
            
            NSInteger row = 0;
            if (count % 3 == 0) {
                row = count/3;
            } else {
                row = count/3+1;
            }
            
            cellHeight = cellHeight + 15*kHeightScale + row*99*kHeightScale;
        }
        
        return cellHeight + 10*kHeightScale;
        
    } else if (indexPath.section == 1) {
        return 115*kHeightScale;
    } else {
        return 125*kHeightScale;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *cellId = @"consultsCellIdentifier";
        ShopOrderReturnDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ShopOrderReturnDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _detailModel.consults[indexPath.row];
        return cell;
    } else if (indexPath.section ==  1) {
        
        static NSString *cellId = @"productCellIdentifier";
        MyOrderFormListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyOrderFormListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _detailModel.products[indexPath.row];
        return cell;
    } else if (indexPath.section == 2) {
        
        static NSString *cellId = @"orderInfoCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        UILabel *nameLab = [createControl createLabelWithFrame:CGRectMake(15*kWidthScale, 20*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:15 Text:[NSString stringWithFormat:@"买家名称：%@",_detailModel.userName] LabTextColor:kColorFontBlack1];
        [cell.contentView addSubview:nameLab];
        
        
        UILabel *statusLab = [createControl createLabelWithFrame:CGRectMake(15*kWidthScale, 50*kHeightScale, WIDTH-30*kWidthScale, 15*kHeightScale) Font:15 Text:[NSString stringWithFormat:@"订单状态：%@",_detailModel.returnStatus] LabTextColor:kColorFontBlack1];
        [cell.contentView addSubview:statusLab];
        
        
        UIButton *logisticsBtn = [LXTControl createBtnWithFrame:CGRectMake(WIDTH-125*kWidthScale, 75*kHeightScale, 110*kWidthScale, 30*kHeightScale) titleName:@"查看订单详情" imgName:nil selImgName:nil target:self action:@selector(onOrderDetialBtnClick)];
        logisticsBtn.titleLabel.font = kFontNol15;
        logisticsBtn.layer.masksToBounds = YES;
        logisticsBtn.layer.cornerRadius = 2.5;
        logisticsBtn.layer.borderWidth = 0.5;
        logisticsBtn.layer.borderColor = kColorAppRed.CGColor;
        [logisticsBtn setTitleColor:kColorAppRed forState:UIControlStateNormal];
        [cell.contentView addSubview:logisticsBtn];
        
        return cell;
    }
    static NSString *cellId = @"productCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


/**
 查看物流
 */
- (void) onLogisBtnClick
{
   
}

/**
 查看订单详情
 */
- (void) onOrderDetialBtnClick
{
    if (_shouldBack) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    ShopOrderDetailVC *orderDetailVC = [[ShopOrderDetailVC alloc]init];
    orderDetailVC.orderId = [NSString stringWithFormat:@"%zd", _detailModel.orderId];
    orderDetailVC.shouldBack = YES;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

@end
