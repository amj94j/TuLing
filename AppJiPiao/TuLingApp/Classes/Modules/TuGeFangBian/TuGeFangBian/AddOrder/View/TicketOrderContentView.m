//
//  TicketOrderContentView.m
//  TuLingApp
//
//  Created by abner on 2017/12/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketOrderContentView.h"
#import "TicketOrderHeaderFlightInfoView.h"
#import "ZJWriteInfoView.h"
#import "TicketInsuranceCell.h"
#import "TicketPassengerCell.h"
#import "HeadInfoView.h"
#import "TicketAddressCell.h"
#import "TicketOrderModel.h"
#import "TicketPassengerModel.h"
#import "TicketInsuranceModel.h"
#import "TicketAddressModel.h"
#import "TicketOrderCommitViewController.h"
#import "TicketAddPassengerViewController.h"
#import "TicketSelectPassengerViewController.h"
#import "TicketAddAddressViewController.h"
#import "TicketSelectAddressViewController.h"
#import "Masonry.h"
#import "TicketHeaderViewController.h"
#import "ShowFlightInforView.h"

static const CGFloat ticketPassengerCellH = 78.0f;
static const CGFloat ticketInsuranceCellH = 50.0f;
static NSString *TicketInsuranceCellID = @"TicketInsuranceCell";
static NSString *TicketPassengerCellID = @"TicketPassengerCell";

@interface TicketOrderContentView ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isFirstShow;//是否第一次显示
    NSMutableArray *_selectInsuranceTradeList; // 选择的保险数据
    NSMutableArray *_insuranceTradeList; // 保险数据
    NSMutableArray *_passengerList;      // 乘机人数据
}

@property (weak, nonatomic) IBOutlet TicketOrderHeaderFlightInfoView *goFlightInfoView; // 去程机票信息视图
@property (weak, nonatomic) IBOutlet TicketOrderHeaderFlightInfoView *backFlightInfoView; // 返程机票信息视图
@property (weak, nonatomic) IBOutlet UITableView *passengerTableView; // 乘机人表格
@property (weak, nonatomic) IBOutlet UITableView *insuranceTableView; // 保险表格
@property (weak, nonatomic) IBOutlet UIView *baoxiaopingzhengView; // 报销凭证视图
@property (weak, nonatomic) IBOutlet UISwitch *baoxiaopingzhengSwitch; // 报销凭证开关
@property (weak, nonatomic) IBOutlet UIView *phoneInfoBGView; // 手机号码背景视图
@property (strong, nonatomic) ZJWriteInfoView *phoneInfoView; // 手机号码视图
@property (weak, nonatomic) IBOutlet HeadInfoView *headInfoView; // 发票抬头视图
@property (weak, nonatomic) IBOutlet TicketAddressCell *addressInfoView; // 地址视图

// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backFlightInfoViewHCons; // 返程机票信息视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passengerViewHCons; // 乘机人视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneBGViewTCons; // 手机号码背景顶部
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insuranceViewHCons; // 保险视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baoxiaopingzhengHcons; // 报销凭证视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewHCons;
@property (weak, nonatomic) IBOutlet UILabel *strokeLabel; // 行程和差额label
@property (weak, nonatomic) IBOutlet UILabel *postageLabel; // 快递费

@end

@implementation TicketOrderContentView

+ (instancetype)xib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _isFirstShow = YES;
    
    _selectInsuranceTradeList = [NSMutableArray array];
    _insuranceTradeList = [NSMutableArray array];
    _passengerList = [NSMutableArray array];
    
    // 添加手机号码视图
    [self addPhoneInfoView];
    
    [self.insuranceTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TicketInsuranceCell class]) bundle:nil] forCellReuseIdentifier:TicketInsuranceCellID];
    [self.passengerTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TicketPassengerCell class]) bundle:nil] forCellReuseIdentifier:TicketPassengerCellID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emptyInvoiceNotification) name:@"EmptyInvoiceNotification" object:nil];
}

#pragma mark 添加手机号码视图
- (void)addPhoneInfoView
{
    WS(ws)
    self.phoneInfoView = [ZJWriteInfoView zj_WriteInfoView];
    self.phoneInfoView.keyboardType = UIKeyboardTypePhonePad;
    [self.phoneInfoView zj_updateInfoWithName:@"联系手机" tipType:ZJWriteInfoViewTipTypeNot actionType:ZJWriteInfoViewActionTypeWrite data:@"便于接收航班短信" actionCallBack:^(BOOL isSelectAction) {
        if (isSelectAction) { // 结束输入
            ws.orderModel.phoneNum = [ws.phoneInfoView zj_getWriteContent];
        }
    }];
    [self.phoneInfoBGView addSubview:self.phoneInfoView];
    
    [self.phoneInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.phoneInfoBGView);
        make.left.equalTo(ws.phoneInfoBGView);
        make.width.equalTo(ws.phoneInfoBGView);
        make.height.equalTo(ws.phoneInfoBGView);
    }];
    
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.insuranceTableView]) {
        return _insuranceTradeList.count;
    } else {
        return _passengerList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.insuranceTableView]) {
        TicketInsuranceCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketInsuranceCellID];
        if (!cell) {
            cell = [[TicketInsuranceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TicketInsuranceCellID];
        }
        TicketInsuranceTradeModel *tradeModel = _insuranceTradeList[indexPath.row];
        cell.tradeModel = tradeModel;
        cell.currentVC = self.currentVC;
        
        // 选择保险
        WS(ws)
        cell.selectInsuranceBlock = ^{
            tradeModel.isSelected = !tradeModel.isSelected;
            if (tradeModel.isSelected) {
                [_selectInsuranceTradeList addObject:tradeModel];
            } else {
                [_selectInsuranceTradeList removeObject:tradeModel];
            }
            [ws setOrderModel:ws.orderModel];
        };
        
        // 更新选择购买保险的乘机人数据
        cell.selectInsurancePassengerModelsBlock = ^(NSMutableArray *selectInsurancePassengerModels) {
//            [ws.orderModel.insuranceTradeModels enumerateObjectsUsingBlock:^(TicketInsuranceTradeModel *tradeModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [tradeModel.buyPassengerModels removeAllObjects];
                [tradeModel.buyPassengerModels addObjectsFromArray:selectInsurancePassengerModels];
//            }];
            [ws setOrderModel:ws.orderModel];
        };
        
        return cell;
    } else {
        TicketPassengerCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketPassengerCellID];
        if (!cell) {
            cell = [[TicketPassengerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TicketPassengerCellID];
        }
        
        TicketPassengerModel *passengerModel = _passengerList[indexPath.row];
        cell.model = passengerModel;
        
        WS(ws)
        cell.deleteAction = ^{
            [ws.orderModel.passengerModels removeObjectAtIndex:indexPath.row];
            
            // 保险交易模型删除乘机人模型
            [ws.orderModel.insuranceTradeModels enumerateObjectsUsingBlock:^(TicketInsuranceTradeModel *tradeModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [tradeModel.passengerModels removeObject:passengerModel];
                [tradeModel.buyPassengerModels removeObject:passengerModel];
            }];
            [ws setOrderModel:ws.orderModel];
        };
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.phoneInfoView resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.insuranceTableView]) {
        return ticketInsuranceCellH;
    } else {
        return ticketPassengerCellH;
    }
}

- (void)setOrderModel:(TicketOrderModel *)orderModel
{
    _orderModel = orderModel;
    
    TLTicketModel *ticketModel = orderModel.ticketModel;
    
    // 1.是否单程
    if (ticketModel.orderType == 1) {
        self.backFlightInfoView.hidden = YES;
        self.backFlightInfoViewHCons.constant = 0.0f;
        self.goFlightInfoView.flightModel = orderModel.goFlightModel;
        
    } else { // 往返
        self.backFlightInfoView.hidden = NO;
        self.backFlightInfoViewHCons.constant = self.goFlightInfoView.height;
        self.goFlightInfoView.flightModel = orderModel.goFlightModel;
        self.backFlightInfoView.flightModel = orderModel.backFlightModel;
    }
    
    // 2.乘机人数据
    [_passengerList removeAllObjects];
    [_passengerList addObjectsFromArray:orderModel.passengerModels];
    self.passengerViewHCons.constant = _passengerList.count > 0 ? _passengerList.count * ticketPassengerCellH + 10.0f + 100.0f : 100.0f;
    self.phoneBGViewTCons.constant = _passengerList.count > 0 ? 10.0f : 0.0f;
    [_passengerTableView reloadData];
    
    // 3.保险数据
    [_insuranceTradeList removeAllObjects];
    [_insuranceTradeList addObjectsFromArray:orderModel.insuranceTradeModels];
    self.insuranceViewHCons.constant = _insuranceTradeList.count > 0 ?_insuranceTradeList.count * ticketInsuranceCellH + 10.0f : 0.0f;
    [_insuranceTableView reloadData];
    
    // 4.报销凭证:调整frame
    [self baoxiaopingzhengSwitchAction:self.baoxiaopingzhengSwitch];
}

#pragma mark 添加乘机人
- (IBAction)addPassengerAction:(id)sender
{
    [self.phoneInfoView resignFirstResponder];
    WS(ws)
    [TicketPassengerModel asyncQuerySelctedFlightPersonWithPersonId:2306 successBlock:^(NSArray *dataArray) {
        // 去添加、选择乘客界面
        if (dataArray.count == 0) {
            TicketAddPassengerViewController *vc = [[TicketAddPassengerViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.addComplete = ^(TicketPassengerModel *addModel) {
                [ws.orderModel.passengerModels addObject:addModel];
                
                // 保险交易模型添加乘机人模型
                [ws.orderModel.insuranceTradeModels enumerateObjectsUsingBlock:^(TicketInsuranceTradeModel *tradeModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tradeModel.passengerModels addObject:addModel];
                    [tradeModel.buyPassengerModels addObject:addModel];
                }];
                
                [ws setOrderModel:ws.orderModel];
            };
            [ws.currentVC.navigationController pushViewController:vc animated:YES];
        } else {
            TicketSelectPassengerViewController *vc = [[TicketSelectPassengerViewController alloc] init];
            
            // 有已选乘客，添加已选标示
            if (_passengerList.count) {
                [vc.selectedModels addObjectsFromArray:_passengerList];
                [vc.selectedModels enumerateObjectsUsingBlock:^(TicketPassengerModel *selectModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    [dataArray enumerateObjectsUsingBlock:^(TicketPassengerModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([selectModel.personIdentityCode isEqualToString:model.personIdentityCode]) {
                            model.isSelected = YES;
                            *stop = YES;
                        }
                    }];
                }];
            }
            [vc.passengerModels addObjectsFromArray:dataArray];
            
            vc.selectComplete = ^(NSMutableArray *selectedModels) {
                [ws.orderModel.passengerModels removeAllObjects];
                [ws.orderModel.passengerModels addObjectsFromArray:selectedModels];
                
                // 保险交易模型添加乘机人模型
                [ws.orderModel.insuranceTradeModels enumerateObjectsUsingBlock:^(TicketInsuranceTradeModel *tradeModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tradeModel.passengerModels removeAllObjects];
                    [tradeModel.passengerModels addObjectsFromArray:selectedModels];
                    // 重新选择乘机人后，之前选择购买保险的乘机人数据都重新设置
                    [tradeModel.buyPassengerModels removeAllObjects];
                    [tradeModel.buyPassengerModels addObjectsFromArray:selectedModels];
                }];
                
                [ws setOrderModel:ws.orderModel];
            };
            vc.hidesBottomBarWhenPushed = YES;
            [ws.currentVC.navigationController pushViewController:vc animated:YES];
        }
    } errorBlock:^(NSError *errorResult) {
    }];
}

#pragma mark 报销凭证开关
- (IBAction)baoxiaopingzhengSwitchAction:(UISwitch *)sender
{
    [self.phoneInfoView resignFirstResponder];
    self.postageLabel.text = [NSString stringWithFormat:@"¥%@",self.postageStr];
    BOOL isOn = self.baoxiaopingzhengSwitch.isOn;
    self.strokeLabel.hidden = !isOn;
    self.orderModel.isNeedBaoXiaoPingZheng = isOn;
    [self.baoxiaopingzhengView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            obj.hidden = !isOn;
        }
    }];
    
    // 发票、地址信息
    self.headInfoView.hidden = !self.orderModel.headModel;
    self.headInfoView.model = self.orderModel.headModel;
    self.addressInfoView.hidden = !self.orderModel.addrssModel;
    self.addressInfoView.model = self.orderModel.addrssModel;
    
    // 调整frame
    // 发票、地址、报销凭证
    CGFloat headOrAddressH = 50.0f; // 发票或地址未选择时高度
    CGFloat headIncreaseH = self.orderModel.headModel ? 25.0f : 0.0f; // 选择发票后的增长高度
    CGFloat addressIncreaseH = self.orderModel.addrssModel ? 50.0f : 0.0f; // 选择地址后的增长高度
    CGFloat baoxiaopingzhengH = isOn  ? 275.0f : 75.0f;
    baoxiaopingzhengH += isOn  ? headIncreaseH : 0;
    baoxiaopingzhengH += isOn  ? addressIncreaseH : 0;
    self.headViewHCons.constant = headIncreaseH + headOrAddressH;
    self.addressViewHCons.constant = addressIncreaseH + headOrAddressH;
    self.baoxiaopingzhengHcons.constant = baoxiaopingzhengH;
    
    [self layoutIfNeeded];
    CGFloat selfH = CGRectGetMaxY(self.baoxiaopingzhengView.frame);
    if (self.updateLayoutBlock) {
        self.updateLayoutBlock(selfH);
    }
    // 父视图
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *superView = (UIScrollView *)self.superview;
        superView.contentSize = CGSizeMake(0, selfH);
        if (_isFirstShow) {
            _isFirstShow = NO;
        } else {
            // 滚动到最底部
            if (superView.contentSize.height > superView.frame.size.height) {
                [UIView animateWithDuration:0.2f animations:^{
                    superView.contentOffset = CGPointMake(0, superView.contentSize.height - superView.frame.size.height);
                }];
            }
        }
    }
    
    // 更新所有费用明细和乘机人数量
    if (self.updateAllCostAndPassenger) {
        self.orderModel.allCost = [self calcueTotalPrice];
        self.updateAllCostAndPassenger(self.orderModel.allCost, self.orderModel.passengerModels.count);
    }
}

#pragma mark 选择发票
- (IBAction)selectHead:(id)sender
{
    [self.phoneInfoView resignFirstResponder];
    WS(ws)
    TicketHeaderViewController * headVc = [[TicketHeaderViewController alloc] init];
    headVc.selectedModel = self.orderModel.headModel;
    headVc.ticketHeaderBlock = ^(TicketHeadModel *model) {
        ws.orderModel.headModel = model;
        [ws setOrderModel:ws.orderModel];
    };
    
    [self.currentVC.navigationController pushViewController:headVc animated:YES];

}

- (void)emptyInvoiceNotification {
    self.orderModel.headModel = nil;
    [self setOrderModel:self.orderModel];
}

#pragma mark 选择地址
- (IBAction)selectAddress:(id)sender {
    [self.phoneInfoView resignFirstResponder];
    WS(ws)
    TicketAddressModel *model = [[TicketAddressModel alloc] init];
    [TicketAddressModel asyncAddressActionWithActionType:AddressActionQuery addressModel:model successBlock:^(NSArray *dataArray) {
        // 去添加、选择乘客界面
        if (dataArray.count == 0) {
            TicketAddAddressViewController *vc = [[TicketAddAddressViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.addComplete = ^(TicketAddressModel *addModel) {
                ws.orderModel.addrssModel = addModel;
                [ws setOrderModel:ws.orderModel];
            };
            [self.currentVC.navigationController pushViewController:vc animated:YES];
        } else {
            TicketSelectAddressViewController *vc = [[TicketSelectAddressViewController alloc] init];

            // 有已选乘客，添加已选标示
            if (ws.orderModel.addrssModel) {
                vc.selectedModel = ws.orderModel.addrssModel;
                [dataArray enumerateObjectsUsingBlock:^(TicketAddressModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (ws.orderModel.addrssModel.createTime == model.createTime &&
                        ws.orderModel.addrssModel.addressId == model.addressId) {
                        model.isSelected = YES;
                        *stop = YES;
                    }
                }];
            }
            [vc.addressModels addObjectsFromArray:dataArray];
            
            vc.selectComplete = ^(TicketAddressModel *selectedModel) {
                ws.orderModel.addrssModel = selectedModel;
                [ws setOrderModel:ws.orderModel];
            };
            vc.hidesBottomBarWhenPushed = YES;
            [ws.currentVC.navigationController pushViewController:vc animated:YES];
        }
    } errorBlock:^(NSError *errorResult) {
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.height =CGRectGetMaxY(self.baoxiaopingzhengView.frame);
}

#pragma mark 计算机票价格
- (double)calcueTotalPrice
{
    //遍历乘客
    
    //成人数组
    NSMutableArray * adultArray = [NSMutableArray array];
    
    //儿童数组
    NSMutableArray * childArray = [NSMutableArray array];
    
    //婴儿数组
    NSMutableArray * babyArray = [NSMutableArray array];
    
    NSMutableArray * passagesArray = _orderModel.passengerModels;
    
    for (TicketPassengerModel * passageModel in passagesArray) {
        
        if (passageModel.isAudlt) {
            [adultArray addObject:passageModel];
        }else if (passageModel.isChild){
            [childArray addObject:passageModel];
        }else if (passageModel.isBaby){
            [babyArray addObject:passageModel];
        }
    }
    
    //成人销售价
    //        NSString * adultPrice = [NSString stringWithFormat:@"%ld",_model.goFlightModel.spacePolicyModel.belongSpcaceModel.ticketprice];
    
    NSInteger adultPrice = _orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.ticketprice * adultArray.count;
    
    //儿童票面价
    //        NSString * childPrice = [NSString stringWithFormat:@"%ld",_model.goFlightModel.spacePolicyModel.belongSpcaceModel.chdticketprice];
    
    NSInteger childPrice = _orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.chdticketprice * childArray.count;
    
    
    //婴儿票面价
    //        NSString * babyPrice = [NSString stringWithFormat:@"%f",_model.goFlightModel.spacePolicyModel.belongSpcaceModel.babyticketprice];
    
    NSInteger babyPrice = _orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.babyticketprice * babyArray.count;
    
    //返程销售价
    if (_orderModel.backFlightModel) {
        NSInteger adultBackPrice = _orderModel.backFlightModel.spacePolicyModel.belongSpcaceModel.ticketprice * adultArray.count;
        
        adultPrice += adultBackPrice;
        
        NSInteger childBackPrice = _orderModel.backFlightModel.spacePolicyModel.belongSpcaceModel.chdticketprice * childArray.count;
        
        childPrice += childBackPrice;
        
        NSInteger babyBackPrice = _orderModel.backFlightModel.spacePolicyModel.belongSpcaceModel.babyticketprice * babyArray.count;
        
        babyPrice += babyBackPrice;
        
    }
    
    //计算燃油+机建费
    //        NSString * adultJiJianPrice = [NSString stringWithFormat:@"%.1f+%.1f",_orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.fee,_orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.tax];
    
    double adultJiJianPrice = (_orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.fee + _orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.tax) * adultArray.count;
    
    //        NSString * childJiJianPrice = [NSString stringWithFormat:@"%.1f+%.1f",_orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.chdfee,_orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.chdtax];
    
    double childJiJianPrice = (_orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.chdfee + _orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.chdtax) * childArray.count;
    
    //        NSString * babyJiJianPrice = [NSString stringWithFormat:@"%.1f+%.1f",_orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.babyfee,_orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.babytax];
    
    double babyJiJianPrice = (_orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.babyfee + _orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.babytax) * babyArray.count;
    
    if (_orderModel.backFlightModel) {
        
        double adultBackJIJianPrice = (_orderModel.backFlightModel.spacePolicyModel.belongSpcaceModel.fee + _orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.tax) * adultArray.count;
        
        adultJiJianPrice += adultBackJIJianPrice;
        
        double childBackJiJianPrice = (_orderModel.backFlightModel.spacePolicyModel.belongSpcaceModel.chdfee + _orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.chdtax) * childArray.count;
        
        childJiJianPrice += childBackJiJianPrice;
        
        double babyBackJiJianPrice = (_orderModel.backFlightModel.spacePolicyModel.belongSpcaceModel.babyfee + _orderModel.goFlightModel.spacePolicyModel.belongSpcaceModel.babytax) * babyArray.count;
        
        babyJiJianPrice += babyBackJiJianPrice;
    }
    
    //保险费用
    CGFloat baoXianPrice = 0.0;
    for (TicketInsuranceTradeModel * baoXianModel in _orderModel.insuranceTradeModels) {
        if (baoXianModel.isSelected) {
            baoXianPrice += baoXianModel.buyPassengerModels.count * baoXianModel.insuranceModel.insuranceFee * (baoXianModel.isDanCheng ? 1 : 2);
        }
    }
    
    CGFloat kuaiDiPrice = 0.0;
    //快递,开关打开的
    if (_orderModel.isNeedBaoXiaoPingZheng) {
        kuaiDiPrice += 20;
    }
    
    //总费用
    CGFloat totalPrice = adultPrice + childPrice + babyPrice + adultJiJianPrice + childJiJianPrice + babyJiJianPrice + baoXianPrice + kuaiDiPrice;
    
    return totalPrice;
}

@end
