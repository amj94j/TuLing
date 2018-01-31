//
//  OrderDetailPopView.m
//  ticket
//
//  Created by LQMacBookPro on 2017/12/12.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "OrderDetailPopView.h"
#import "TicketPassengerModel.h"
#import "TLOrderDetailViewCell.h"
#import "YIWaiBottomView.h"
#import "YIWaiBottomTableViewCell.h"
#import "TLTicketModel.h"
#import "TicketInsuranceModel.h"
#import "TicketOrderModel.h"
#import "SearchFlightsModel.h"


@interface OrderDetailPopView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)NSInteger rowCount;

@property (nonatomic, weak)UIButton * maskBtn;

@property (nonatomic, weak)UITableView * myTableView;

@property (nonatomic, strong)NSMutableArray * baoXianArray;

@property (nonatomic, strong)SearchFlightsModel * goTicketModle;

@property (nonatomic, strong)SearchFlightsModel * backTicketModel;

@property (nonatomic, assign)BOOL isWangFan;

@property (nonatomic, strong)TicketOrderModel * ticketOrderModel;


/**
 cell标题数组
 */
@property (nonatomic, strong)NSMutableArray * cellTitleArray;

/**
 成人个数
 */
@property (nonatomic, assign)NSInteger adultCount;

/**
 儿童个数
 */
@property (nonatomic, assign)NSInteger childCount;

/**
 婴儿个数
 */
@property (nonatomic, assign)NSInteger babyCount;

#define kHeardHeight 49

#define kFooterHeight 49

#define kBaoXianViewHeight 30

#define kBaoxianCount 3

@end
@implementation OrderDetailPopView

- (NSMutableArray *)baoXianArray
{
    if (!_baoXianArray) {
        _baoXianArray = [NSMutableArray array];
    }
    return _baoXianArray;
}

- (OrderDetailPopView *)initPopWithModel:(TicketOrderModel *)model postageStr:(NSString *)postageStr
{
    CGRect rect = CGRectMake(0, 0, TLScreenWidth, TLScreenHeight - kFooterHeight);
    
    if (self = [super initWithFrame:rect]) {
        
        //添加蒙版
        [self addMasView];
        
        //添加tableView
        [self addTableView];

        self.ticketOrderModel = model;
        
//        self.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.5];
        self.backgroundColor = [UIColor clearColor];
        
        //获取机票模型
        TLTicketModel * ticketModel = model.ticketModel;
        
        //获取乘机人数组
        NSMutableArray * passageArray = model.passengerModels;
        
        NSMutableArray * temPagArray = [NSMutableArray array];
        
        //成年人数组
        NSMutableArray * adultArray = [NSMutableArray array];
        
        //儿童数组
        NSMutableArray * childArray = [NSMutableArray array];
        
        //婴儿数组
        NSMutableArray * babyArray = [NSMutableArray array];
        
        for (TicketPassengerModel * passage in passageArray) {
            
            if (passage.isBaby) {
                [babyArray addObject:passage];
            }else if (passage.isChild){
                [childArray addObject:passage];
            }else if (passage.isAudlt){
                [adultArray addObject:passage];
            }
            
            //判断是否有婴儿，儿童，成人
            if (passage.isAudlt && ([temPagArray containsObject:@"adult"])) {
                [temPagArray addObject:@"adult"];
            }else if (passage.isChild && ([temPagArray containsObject:@"child"])){
                
                [temPagArray addObject:@"child"];
                
            }else if (passage.isBaby && ([temPagArray containsObject:@"baby"])){
                [temPagArray addObject:@"baby"];
            }
            
        }
        
        if (ticketModel.orderType ==2) {
            self.isWangFan = YES;
        }else{
            self.isWangFan = NO;
        }
        
        self.adultCount = adultArray.count;
        
        self.babyCount = babyArray.count;
        
        self.childCount = childArray.count;
        
        self.cellTitleArray = [NSMutableArray array];
        
        //判断返回cell个数
        if (adultArray.count > 0) {
            self.rowCount +=1;
            [self.cellTitleArray addObject:@"成人票"];
        }else if (childArray.count > 0)
        {
            self.rowCount +=1;
            [self.cellTitleArray addObject:@"儿童票"];
        }else if (babyArray.count > 0)
        {
            self.rowCount +=1;
            [self.cellTitleArray addObject:@"婴儿票"];
        }
        
        //一下4行是测试数据
//        [self.cellTitleArray addObject:@"成人票"];
//
//        [self.cellTitleArray addObject:@"儿童票"];
//
//        [self.cellTitleArray addObject:@"婴儿票"];
//        self.rowCount = 4;
        //判断是否是往返
        if (ticketModel.orderType == 2) {
            //去成机票
            self.goTicketModle = model.goFlightModel;
            
            //返程机票
            self.backTicketModel = model.backFlightModel;
            
            self.rowCount = self.rowCount * 2;
            
            //如果往返把标题再添加一遍
            NSMutableArray * temTitleArray = [NSMutableArray arrayWithArray:self.cellTitleArray];
            
            [self.cellTitleArray addObjectsFromArray:temTitleArray];
            
            
        }else{
            //单程
            self.goTicketModle = model.goFlightModel;
        }
        
        //获取意外险数组,前提是有人买的时候才显示
        for (TicketInsuranceTradeModel * tradModel in model.insuranceTradeModels) {
            
            if (tradModel.isSelected) {
                
                if (tradModel.buyPassengerModels.count > 0) {
                    [self.baoXianArray addObject:tradModel];
                }
            }
        
        }
        
//        self.baoXianArray = [NSMutableArray arrayWithArray:model.insuranceTradeModels];
        
        //如果有保险类型
        if (self.baoXianArray.count > 0) {
            self.rowCount += 1;
        }
        
        //报销凭证是打开
        if (self.ticketOrderModel.isNeedBaoXiaoPingZheng) {
            //显示快递费
            TicketInsuranceTradeModel * model = [[TicketInsuranceTradeModel alloc]init];
            
            model.insuranceModel = [[TicketInsuranceModel alloc]init];
            
            model.insuranceModel.insuranceName = @"快递费";
            
            model.insuranceModel.costFee = [postageStr doubleValue];
            // 展示的
            model.insuranceModel.insuranceFee = [postageStr doubleValue];
            [self.baoXianArray addObject:model];
        }
        
        [self.myTableView reloadData];
        
    }return self;
}




- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //添加蒙版
        [self addMasView];
        
        //添加tableView
        [self addTableView];
        
        self.cellTitleArray = [NSMutableArray array];
    }
    return self;
}

- (void)addMasView
{
    UIButton * btn = [[UIButton alloc]initWithFrame:self.bounds];
    
    btn.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.5];
    
    [self addSubview:btn];
    
    self.maskBtn = btn;
    
    [btn addTarget:self action:@selector(disMaskViewDismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)disMaskViewDismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.myTableView.y = TLScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)addTableView
{
    
    CGRect temF = CGRectMake(0, TLScreenHeight * 0.4, TLScreenWidth, (TLScreenHeight-64) * 0.6);
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TLScreenHeight, TLScreenWidth, self.height * 0.6) style:UITableViewStylePlain];
    
    [self.maskBtn addSubview:tableView];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.maskBtn.bottom-1, TLScreenWidth, 1)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
    [self.maskBtn addSubview:footerView];
    [self.maskBtn bringSubviewToFront:footerView];
    
    [UIView animateWithDuration:0.25 animations:^{
       
        tableView.y = self.height *0.4;
        
    }];
    
    self.myTableView = tableView;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitleArray.count +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.cellTitleArray.count) {
        YIWaiBottomTableViewCell * cell = [YIWaiBottomTableViewCell yiwaiBottomCellWithArray:self.baoXianArray tableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        
        TLOrderDetailViewCell * cell = [TLOrderDetailViewCell orderDetailCellWithTableView:tableView];
        
        cell.personType = self.cellTitleArray[indexPath.row];
        
        cell.adultCount = self.adultCount;
        
        cell.childCount = self.childCount;
        
        cell.babyCount = self.babyCount;
        
        if (self.isWangFan) {
            
//            if (indexPath.row < self.rowCount) {
//                cell.searchFlightModel = self.goTicketModle;
//
//                cell.goOrBackLabel.text = @"去";
//            }else{
//                cell.searchFlightModel = self.backTicketModel;
//                cell.goOrBackLabel.text = @"返";
//            }
            if (indexPath.row < self.cellTitleArray.count * 0.5) {
                
                cell.searchFlightModel = self.goTicketModle;
                
                cell.goOrBackLabel.text = @"去程";
                
            }else{
                cell.searchFlightModel = self.backTicketModel;
                cell.goOrBackLabel.text = @"返程";
            }
            
//            if (indexPath.row < self.rowCount) {
//
//            }
            
            
        }else{
            cell.searchFlightModel = self.goTicketModle;
            cell.goOrBackLabel.hidden = YES;
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.cellTitleArray.count) {
        return  self.baoXianArray.count * 30 + 30;
    }else{
            return 100;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TLScreenWidth, kFooterHeight)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:view.bounds];
    
    label.textAlignment = NSTextAlignmentCenter;
//    [UIFont systemFontOfSize:kFitRatio(15)];
    label.font = [UIFont boldSystemFontOfSize:15];
    
    label.textColor = TLColor(67, 67, 67, 1);
    
    label.text = @"费用明细";
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, kFooterHeight -1, TLScreenWidth - 30, 1)];
    
    lineView.backgroundColor = TLColor(226, 226, 226, 1);
    
    [view addSubview:lineView];
    
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kFooterHeight;
}

@end
