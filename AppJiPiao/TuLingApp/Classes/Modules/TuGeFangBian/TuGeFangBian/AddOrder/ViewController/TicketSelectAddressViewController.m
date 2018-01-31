//
//  TicketSelectAddressViewController.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketSelectAddressViewController.h"
#import "TicketAddAddressViewController.h"
#import "AddressInfoCell.h"
#import "TicketAddressModel.h"

static NSString *CellID = @"AddressInfoCell";

@interface TicketSelectAddressViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *addressTabelView;

@end

@implementation TicketSelectAddressViewController

- (NSMutableArray *)addressModels
{
    if (!_addressModels) {
        _addressModels = [NSMutableArray array];
    }
    return _addressModels;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addCustomTitleWithTitle:@"常用地址"];
    
    [self.addressTabelView registerNib:[UINib nibWithNibName:NSStringFromClass([AddressInfoCell class]) bundle:nil] forCellReuseIdentifier:CellID];
    [self.addressTabelView reloadData];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[AddressInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    
    TicketAddressModel *model = self.addressModels[indexPath.row];
    cell.model = model;

    WS(ws)
    cell.userAction = ^ (BOOL isDelete) {
        if (isDelete) { // 删除地址
            [ws deleteAddress:model];
        } else { // 选择地址
            if (ws.selectComplete) {
                ws.selectComplete(model);
            }
            [ws.navigationController popViewControllerAnimated:YES];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectComplete) {
        self.selectComplete(_addressModels[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

#pragma mark 添加常用地址
- (IBAction)addNewAddressAction:(UIButton *)sender
{
    WS(ws)
    TicketAddAddressViewController *vc = [[TicketAddAddressViewController alloc] init];
    vc.addComplete = ^(TicketAddressModel *editedModel) {
        [ws.addressModels insertObject:editedModel atIndex:0];
        [ws.addressTabelView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 删除地址
- (void)deleteAddress:(TicketAddressModel *)model
{
    WS(ws)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除该常用地址吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [TicketAddressModel asyncAddressActionWithActionType:AddressActionDelete addressModel:model successBlock:^(NSArray *dataArray) {
                                                                  [ws.addressModels removeObject:model];
                                                                  [ws.addressTabelView reloadData];
                                                              } errorBlock:^(NSError *errorResult) {
                                                                  [ws showProgressError:errorResult.localizedDescription];
                                                              }];
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
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
