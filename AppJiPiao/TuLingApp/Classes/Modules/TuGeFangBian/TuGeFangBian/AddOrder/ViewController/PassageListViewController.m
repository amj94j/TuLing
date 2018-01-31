//
//  PassageListViewController.m
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "PassageListViewController.h"

@interface PassageListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak)UITableView * myTableView;

@end

@implementation PassageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)addTableView
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TLScreenWidth, TLScreenHeight) style:UITableViewStylePlain];
    
    [self.view addSubview:tableView];
    
    [UIView animateWithDuration:2 animations:^{
        
        tableView.y = TLScreenHeight * 0.4;
        
    }];
    
    self.myTableView = tableView;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    
    return cell;
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
