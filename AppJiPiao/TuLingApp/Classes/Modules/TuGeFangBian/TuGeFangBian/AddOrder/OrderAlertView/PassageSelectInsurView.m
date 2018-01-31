//
//  PassageSelectInsurView.m
//  ticket
//
//  Created by LQMacBookPro on 2017/12/13.
//  Copyright © 2017年 LQMacBookPro. All rights reserved.
//

#import "PassageSelectInsurView.h"

#import "PassageSelectInsuraCell.h"

#import "TicketPassengerModel.h"
#import "TicketInsuranceModel.h"
#define kSureBtnHeight kFitRatio(44)

#define kHeadViewSubLabToTitleLab 7

@interface PassageSelectInsurView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)UITableView * myTableView;

@property (nonatomic, weak)UIButton * maskBtn;

@property (nonatomic, weak)UIView * containView;

@property (nonatomic, strong)NSMutableArray * passageArray;

@property (nonatomic, strong)TicketInsuranceTradeModel * insuranceModel;

@property (nonatomic, strong)NSMutableArray * selectPassageArray;

@end

@implementation PassageSelectInsurView

- (NSMutableArray *)selectPassageArray
{
    if (!_selectPassageArray) {
        _selectPassageArray = [NSMutableArray array];
    }
    return _selectPassageArray;
}


- (PassageSelectInsurView *)initPassageSelectInsureWithTicketInsuranceModel:(TicketInsuranceTradeModel *)model
{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, TLScreenWidth, TLScreenHeight);
        
        //        [self.passageArray addObjectsFromArray:passageArray];
        
        self.insuranceModel = model;
        
        self.passageArray = self.insuranceModel.passengerModels;
        
        [self.selectPassageArray addObjectsFromArray:self.insuranceModel.buyPassengerModels];
        
        //添加蒙板
        [self addMasView];
        
        //添加容器view
        [self addContainView];
        
        //添加tableView
        [self addTableView];
        
        //添加确定按钮
        [self addSureBtn];
        
    }return self;
}

//- (instancetype)initSlectInsurViewWithArray:(NSMutableArray<TicketPassengerModel *> *)passageArray
//{
//
//    if (self = [super init]) {
//
//        self.frame = CGRectMake(0, 0, TLScreenWidth, TLScreenHeight);
//
////        [self.passageArray addObjectsFromArray:passageArray];
//        self.passageArray = passageArray;
//
//        //添加蒙板
//        [self addMasView];
//
//        //添加容器view
//        [self addContainView];
//
//        //添加tableView
//        [self addTableView];
//
//        //添加确定按钮
//        [self addSureBtn];
//
//    }return self;

//    PassageSelectInsurView * psSeleInsurView = [[PassageSelectInsurView alloc]init];
    
//    psSeleInsurView.frame = CGRectMake(0, 0, TLScreenWidth, TLScreenHeight);
//
//    [psSeleInsurView.passageArray addObjectsFromArray:passageArray];
//
//    psSeleInsurView.backgroundColor = [UIColor greenColor];
    
//    return psSeleInsurView;

//}

- (instancetype)init
{
    if (self = [super init]) {
        
        //添加蒙板
        [self addMasView];
        
        //添加容器view
        [self addContainView];
        
        //添加tableView
        [self addTableView];
        
        //添加确定按钮
        [self addSureBtn];
        
    }
    return self;
}

- (void)addContainView
{
    UIView * containView = [[UIView alloc]init];
    
    containView.y = (TLScreenHeight -64) * 0.2;

    containView.width = kFitRatio(280);

    containView.height = kFitRatio(268);

    containView.centerX = TLScreenWidth * 0.5;
    
    containView.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:containView];
    
    self.containView = containView;
    
}

- (void)addSureBtn
{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.containView.width, 1)];
    
    lineView.backgroundColor = TLColor(238, 238, 238, 1);
    
    UIButton * sureBtn = [[UIButton alloc]init];
    
    CGFloat sureBtnY = CGRectGetMaxY(self.myTableView.frame);
    
    sureBtn.frame = CGRectMake(0, sureBtnY, self.containView.width, kSureBtnHeight);
    
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [sureBtn setTitleColor:TLColor(112, 202, 154, 1) forState:UIControlStateNormal];
    
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:kFitRatio(17)];
    
    sureBtn.backgroundColor = [UIColor whiteColor];
    
    [sureBtn addSubview:lineView];
    
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.containView addSubview:sureBtn];
}

- (void)sureBtnClick
{
    //先清空买保险人,在从选择的数组中添加
    [self.insuranceModel.buyPassengerModels removeAllObjects];
    
    [self.insuranceModel.buyPassengerModels addObjectsFromArray:self.selectPassageArray];
    
    [self disMaskViewDismiss];
    
    //这里传递乘客模型
    if ([_delegate respondsToSelector:@selector(pasageSelectinsureClickSureWithArray:)]) {
        [_delegate pasageSelectinsureClickSureWithArray:self.selectPassageArray];
    }
}

- (void)addMasView
{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TLScreenWidth, TLScreenHeight)];
    
    btn.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.5];
    
    [self addSubview:btn];
    
    self.maskBtn = btn;
    
    [btn addTarget:self action:@selector(disMaskViewDismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)disMaskViewDismiss
{
//    [UIView animateWithDuration:2 animations:^{
//        self.myTableView.y = TLScreenHeight;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    
    [self removeFromSuperview];
    
}

- (void)addTableView
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.containView.width, self.containView.height - kSureBtnHeight) style:UITableViewStylePlain];
    
    [self.containView addSubview:tableView];
    
    self.myTableView = tableView;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    self.myTableView.rowHeight = kFitRatio(36);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.passageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PassageSelectInsuraCell * cell = [PassageSelectInsuraCell passageSelectInsureCellWithTableView:tableView];
    
    TicketPassengerModel * model = self.passageArray[indexPath.row];
    
    cell.model = model;
    
    if ([self.selectPassageArray containsObject:model]) {//买过保险
        cell.selectIconView.image =[UIImage imageNamed:@"打钩"];
    }else{
        cell.selectIconView.image =[UIImage imageNamed:@"未选中"];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, kFitRatio(60) + kHeadViewSubLabToTitleLab)];
    
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, headView.width, kFitRatio(40))];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:kFitRatio(15)];
    
    titleLabel.textColor = TLColor(67, 67, 67, 1);
    
    CGFloat lineY = CGRectGetMaxY(titleLabel.frame);
    
    CGFloat lineWidth = tableView.width - 30;
    
    if (self.insuranceModel.insuranceModel.insuranceType == 1) {
        titleLabel.text = @"航空意外险";
    } else if (self.insuranceModel.insuranceModel.insuranceType == 2) {
        titleLabel.text = @"航空延误险";
    }
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, lineY, lineWidth, 1)];
    
    lineView.backgroundColor = TLColor(238, 238, 238, 1);
    
    [headView addSubview:titleLabel];
    
    
    [headView addSubview:lineView];
    
    CGFloat subLabelY = CGRectGetMaxY(lineView.frame);
    
    UILabel * subLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, subLabelY + kHeadViewSubLabToTitleLab, 200, kFitRatio(20))];
    
    subLabel.font = [UIFont systemFontOfSize:kFitRatio(13)];
    
    subLabel.textColor = TLColor(106, 106, 106, 1);
    
    subLabel.text = @"请选择被保险人";
    
    [headView addSubview:subLabel];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return kFitRatio(60) + kHeadViewSubLabToTitleLab;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //修改乘客的信息
    TicketPassengerModel * model = self.passageArray[indexPath.row];
    
    if ([self.selectPassageArray containsObject:model]) {
        [self.selectPassageArray removeObject:model];
    }else{
        [self.selectPassageArray addObject:model];
    }
    
    [self.myTableView reloadData];
    
}

@end
