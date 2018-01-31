//
//  PlaceFoodViewController.m
//  TuLingApp
//
//  Created by 李立达 on 2017/8/17.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "PlaceFoodViewController.h"
#import "searchTextField.h"
#import "Masonry.h"

@interface PlaceFoodViewController ()
<
    UITextFieldDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>
@property(nonatomic,strong)UIView *searchBarView;
@property(nonatomic,strong)NSString *titleString;
@property(nonatomic,strong)UITableView *Tableview;
@property(nonatomic,strong)UIImageView *topImageView;
@end

@implementation PlaceFoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableview];
    [self searchViewClick];
}
-(void)setupTableview
{
    self.Tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenHeight-64) style:UITableViewStylePlain];
    self.Tableview.delegate = self;
    self.Tableview.dataSource = self;
    self.Tableview.rowHeight = 250;
    self.Tableview.showsVerticalScrollIndicator = NO;
    self.Tableview.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.Tableview];
    UIView *tableViewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 200)];
    [tableViewHeader addSubview:self.searchBarView];
    CGFloat tomImageHeigh =111;
    self.topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.searchBarView.bottom, mainScreenWidth, 200)];
}
-(void)stetupSearchView{
    _searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 43)];
    UIImageView * searchView = [LXTControl createImageViewWithFrame:CGRectMake(15, 9.5, WIDTH-30, 24) ImageName:nil];
    searchView.backgroundColor = RGBCOLOR(238, 238, 238);
    [searchView becomeFirstResponder];
    searchView.userInteractionEnabled = YES;
    searchView.layer.masksToBounds=YES;
    searchView.layer.cornerRadius = 12;
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
    leftImageView.image = [UIImage imageNamed:@""];
    [searchView addSubview:leftImageView];
    
    NSString * contentString = @"输入喜欢的特色小吃";

    searchTextField *textInputField = [[searchTextField alloc]initWithFrame:CGRectMake(14, 0, 0, 23)];
    textInputField.font =[UIFont systemFontOfSize:12];
    
    textInputField.placeholder = contentString;
    
    textInputField.userInteractionEnabled = YES;
    if (isIPHONE6P) {
        textInputField.font =[UIFont systemFontOfSize:13];
    }
    textInputField.backgroundColor = RGBCOLOR(238, 238, 238);
    
    textInputField.delegate = self;
    [searchView addSubview:textInputField];
    
    [textInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@(0));
        make.centerY.equalTo(searchView);
        make.height.equalTo(@(23));
        make.centerX.equalTo(searchView).offset(-5);
    }];
    
    UIButton *searchButton = [LXTControl createButtonWithFrame:CGRectMake(CGRectGetWidth(searchView.frame)-30, 4, 15, 15) ImageName:@"search.png" Target:self Action:@selector(searchViewClick) Title:@""];
    [searchView addSubview:searchButton];
    
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@15);
        make.height.equalTo(@15);
        make.centerY.equalTo(searchView);
        make.left.equalTo(textInputField.mas_right).offset(3);
        
    }];
    UIButton *titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, searchView.frame.size.width, searchView.frame.size.height)];
    [titleButton addTarget:self action:@selector(searchViewClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:titleButton];
    [_searchBarView addSubview:searchView];
}


-(void)searchViewClick
{

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}
@end
