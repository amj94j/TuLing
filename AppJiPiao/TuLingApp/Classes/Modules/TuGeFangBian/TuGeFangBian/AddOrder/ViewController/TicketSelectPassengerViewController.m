//
//  TicketSelectPassengerViewController.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketSelectPassengerViewController.h"
#import "TicketAddPassengerViewController.h"
#import "PassengerInfoCell.h"
#import "TicketPassengerModel.h"

static NSString *CellID = @"PassengerInfoCell";

@interface TicketSelectPassengerViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_selectedModels;
}

@property (weak, nonatomic) IBOutlet UITableView *passengerTabelView;
@property (weak, nonatomic) IBOutlet UILabel *passengerNumLabel;

@end

@implementation TicketSelectPassengerViewController

- (NSMutableArray *)passengerModels
{
    if (!_passengerModels) {
        _passengerModels = [NSMutableArray array];
    }
    return _passengerModels;
}

- (NSMutableArray *)selectedModels
{
    if (!_selectedModels) {
        _selectedModels = [NSMutableArray array];
    }
    return _selectedModels;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addCustomTitleWithTitle:@"选择乘机人"];
    [self addRightBtnWithTitle:nil iconName:@"addOrder_icon_add_passger" target:self selector:@selector(addNewPassenger)];
    
    self.passengerNumLabel.text = [NSString stringWithFormat:@"乘机人数：%lu人", (unsigned long)self.selectedModels.count];
    
    [self.passengerTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([PassengerInfoCell class]) bundle:nil] forCellReuseIdentifier:CellID];
    [self.passengerTabelView reloadData];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.passengerModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PassengerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[PassengerInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }

    cell.model = self.passengerModels[indexPath.row];
    
    WS(ws)
    __weak typeof(cell) weakcell = cell;
    cell.userAction = ^ (NSUInteger tag) {
        if (tag == 0) { // 0选择乘客，先判断乘客是否是成人，如果不是成人不能选择
            [ws checkPassengerIsAdult:weakcell];;
        } else if (tag == 1) { // 1编辑乘客
            [ws editPassenger:weakcell];
        } else if (tag == 2) { // 2删除乘客
            [ws deletePassenger:weakcell];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self checkPassengerIsAdult:[tableView cellForRowAtIndexPath:indexPath]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

#pragma mark 选择新乘客
- (IBAction)sureAction:(UIButton *)sender
{
    if (self.selectedModels.count == 0) {
        [self showProgress:@"请选择乘机人"];
        return;
    }
    
    if (self.selectComplete) {
        self.selectComplete(self.selectedModels);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 添加新乘客
- (void)addNewPassenger
{
    [self editPassenger:nil];
}

#pragma mark 编辑乘客
- (void)editPassenger:(PassengerInfoCell *)cell
{
    __block TicketPassengerModel *model = cell.model;
    
    WS(ws)
    TicketAddPassengerViewController *vc = [[TicketAddPassengerViewController alloc] init];
    
    vc.model = model;
    vc.addComplete = ^(TicketPassengerModel *editedModel) {
        if (model) { // 编辑
            editedModel.isSelected = model.isSelected;
            model = editedModel;
            [ws.passengerTabelView reloadRowsAtIndexPaths:@[[ws.passengerTabelView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
        } else { // 添加
            [ws.passengerModels insertObject:editedModel atIndex:0];
            [ws.passengerTabelView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
    };
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 删除乘客:暂时不需要
- (void)deletePassenger:(PassengerInfoCell *)cell
{
    TicketPassengerModel *model = cell.model;
    
    WS(ws)
    [TicketPassengerModel asyncPassengerActionWithActionType:PassengerActionDelete passengerModel:model successBlock:^(NSArray *dataArray) {
        [dataArray enumerateObjectsUsingBlock:^(TicketPassengerModel *tempModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([tempModel.personIdentityCode isEqualToString:model.personIdentityCode]) {
                if (model.isSelected) {
                    [ws.selectedModels removeObject:model];
                }
                [ws.passengerModels removeObject:model];
                [ws.passengerTabelView deleteRowsAtIndexPaths:@[[ws.passengerTabelView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationRight];
                *stop = YES;
            }
        }];
    } errorBlock:^(NSError *errorResult) {
        
    }];
}

#pragma mark 检查乘客是否成年
- (void)checkPassengerIsAdult:(PassengerInfoCell *)cell
{
    WS(ws)
    TicketPassengerModel *model = cell.model;
    NSIndexPath *indexPath = [self.passengerTabelView indexPathForCell:cell];
    
    if (model.isSelected) {
        model.isSelected = NO;
        [self.passengerTabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        __block TicketPassengerModel *tempModel = nil;
        [self.selectedModels enumerateObjectsUsingBlock:^(TicketPassengerModel *selectModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([selectModel.personIdentityCode isEqualToString:model.personIdentityCode]) {
                tempModel = selectModel;
                *stop = YES;
            }
        }];
        [self.selectedModels removeObject:tempModel];
        self.passengerNumLabel.text = [NSString stringWithFormat:@"乘机人数：%lu人", (unsigned long)self.selectedModels.count];
    } else {
        // 先判断是否是成年人
        [TicketPassengerModel asyncCheckPersonIsAdultWithPersonIdentityCode:model.personIdentityCode successBlock:^(NSInteger passengerType) {
            
            // 成员类型
            if (passengerType == 0) {
                model.isBaby = YES;
            } else if (passengerType == 1) {
                model.isChild = YES;
            } else if (passengerType == 2) {
                model.isAudlt = YES;
            }
            
            model.isSelected = YES;
            [ws.selectedModels addObject:model];
            [ws.passengerTabelView reloadRowsAtIndexPaths:@[[ws.passengerTabelView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
            ws.passengerNumLabel.text = [NSString stringWithFormat:@"乘机人数：%lu人", (unsigned long)ws.selectedModels.count];
        } errorBlock:^(NSError *errorResult) {
            [ws showProgressError:errorResult.localizedDescription];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
