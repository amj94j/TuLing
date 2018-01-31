//
//  TicketHeaderViewController.m
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketHeaderViewController.h"

#import "TicketHeadModel.h"

#import "TicketHeadViewCell.h"

#import "AddTicketHeadController.h"


@interface TicketHeaderViewController ()<UITableViewDelegate,UITableViewDataSource,TicketHeadViewCellDelegate>

@property (nonatomic, weak)UITableView * tableView;

@property (nonatomic, strong)NSMutableArray * headModelArray;

@property (nonatomic, strong)TicketHeadModel * currentModel;

@property (nonatomic, strong)UIView *blankBGView;
@end

@implementation TicketHeaderViewController

- (NSMutableArray *)headModelArray
{
    if (!_headModelArray) {
        _headModelArray  = [NSMutableArray array];
    }
    return _headModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发票抬头";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    //添加tableView
    [self addTableView];
    
    //添加“添加”按钮
    [self addAddBtn];
}

- (UIView *)blankBGView {
    if (!_blankBGView) {
        _blankBGView = [[UIView alloc] initWithFrame:CGRectMake(0, PXChange(210), ScreenWidth, PXChange(320))];
        _blankBGView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_blankBGView];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(206))];
        bgImageView.image = [UIImage imageNamed:@"tickethead_blankbg"];
        bgImageView.contentMode = UIViewContentModeCenter;
        [_blankBGView addSubview:bgImageView];
        
        UILabel *blankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bgImageView.bottom+PXChange(44), ScreenWidth, PXChange(40))];
        blankLabel.text = @"暂无发票抬头，快来新增吧~";
        blankLabel.textColor = [UIColor colorWithHexString:@"#919191"];
        blankLabel.textAlignment = NSTextAlignmentCenter;
        blankLabel.font = [UIFont systemFontOfSize:18];
        [_blankBGView addSubview:blankLabel];
        
    }
    return _blankBGView;
}

- (void)loadDataWithFlag:(HeadFlogType)flag {
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"flag"] = [NSString stringWithFormat:@"%d",flag];
    
    param[@"token"] = kToken;
    
    if (flag == HeadFlogTypeDele) {
        param[@"lookedUpId"] = self.currentModel.lookedUpId;
        param[@"versionNum"] = self.currentModel.versionNum;
    }
    
    [self.headModelArray removeAllObjects];
    
    NSString *urlStr = [kDomainName stringByAppendingString:@"basics/queryInvoiceLookedUpList"];
    
    [NetAccess postJSONWithUrl:urlStr parameters:param WithLoadingView:YES andLoadingViewStr:@"加载中..." success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            
            NSLog(@"%@",responseObject);
            
            NSArray * dictArray = responseObject[@"content"];
            
            for (NSDictionary * dict in dictArray) {
                
                TicketHeadModel * headModel = [[TicketHeadModel alloc]initTicketHeadModelWithDic:dict];
                if (self.selectedModel &&
                    [self.selectedModel.createTime isEqualToString:headModel.createTime] &&
                    [self.selectedModel.ID isEqualToString:headModel.ID]) { // 之前已选择的发票
                    headModel.isSelected = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmptyInvoiceNotification" object:nil];
                    
                } else {
                    headModel.isSelected = NO;
                }
                [self.headModelArray addObject:headModel];
            }
            
            if (self.headModelArray.count > 0) {
                self.blankBGView.hidden = YES;
            } else {
                self.blankBGView.hidden = NO;
            }
            [self.tableView reloadData];
        }
        
    } fail:^{
        
    }];
}

- (void)addAddBtn {
    CGFloat btnY = CGRectGetMaxY(self.tableView.frame);
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, btnY, TLScreenWidth, 50)];
    
    btn.backgroundColor = TLColor(16, 124, 61, 1);
    
    [btn setTitle:@"新增发票抬头" forState:UIControlStateNormal];
    
    btn.titleLabel.textColor = [UIColor whiteColor];
//    btn.layer.cornerRadius = 2.0f;
//    btn.layer.masksToBounds = YES;
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(addNewHeadBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTableView
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TLScreenWidth, TLScreenHeight - 64 - 50) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kFitRatio(10), 0);
    
    self.tableView.rowHeight = kFitRatio(80);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.headModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketHeadViewCell * cell = [TicketHeadViewCell cellWithTableView:tableView];
    
    cell.index = indexPath;
    
    TicketHeadModel * model = self.headModelArray[indexPath.row];
    
    cell.model = model;
    
    cell.headCellDelegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketHeadModel * model = self.headModelArray[indexPath.row];
    
    [self.tableView reloadData];
    
    TicketHeaderBlock ticketHeaderBlock = self.ticketHeaderBlock;
    if (ticketHeaderBlock) {
        ticketHeaderBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //请求网络
    [self loadDataWithFlag:HeadFlogTypeAll];
    
    [self.headModelArray removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNewHeadBtnClick
{
    AddTicketHeadController * addNewVc = [[AddTicketHeadController alloc]init];
    
    [self.navigationController pushViewController:addNewVc animated:YES];
}

- (void)delegteItemAtIndex:(NSIndexPath *)index
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"确定要删除该发票抬头?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              TicketHeadModel * model = self.headModelArray[index.row];
                                                              
                                                              self.currentModel = model;
                                                              
                                                              [self loadDataWithFlag:HeadFlogTypeDele];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
