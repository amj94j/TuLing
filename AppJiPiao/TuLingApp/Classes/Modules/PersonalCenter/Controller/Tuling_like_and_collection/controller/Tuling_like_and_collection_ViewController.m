#define SEGMENT_HEIGHT 40
/*
 要做的东西
 1、收藏、点赞的segment
 2、收藏接口、点赞接口获取数据
 3、取消收藏和取消点赞接口
 4、收藏和点赞公用一个controller
 
 */

#import "Tuling_like_and_collection_ViewController.h"
#import "Tuling_like_and_collection_Cell.h"
#import "DescriptionViewController.h"
#import "CommonDescriptionTableViewCell.h"
#import "DescriptionViewController.h"
#import "CollectModel.h"
#import "ProductOfArticlesViewController.h"

@interface Tuling_like_and_collection_ViewController () <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
/**
 *  对象数组
 */
@property (nonatomic, strong) NSMutableArray * model_object_array;
@property(nonatomic,strong)CollectModel *lineModel;
@property(nonatomic,copy)NSString *count;
@property(nonatomic,strong)UIWebView *productView;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,strong)UILabel *showLabel;

@end

@implementation Tuling_like_and_collection_ViewController

- (void)viewWillAppear:(BOOL)animated
{ [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewWillDisappear:(BOOL)animated
{  [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden=YES;
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 60, 18) ImageName:@"" Target:self Action:@selector(ButtonClick) Title:@""];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 45)];
    [button setImage:[UIImage imageNamed:@"arrowback"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    [self createTitleView];
    [self requestData];
    [self init_tableview];
}
- (void)ButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createTitleView
{
    self.productView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    self.productView.delegate = self;
    self.productView.tag = 11;
    self.productView.scrollView.bounces = NO;
    self.productView.scrollView.delegate= self;
    TLAccount *account = [TLAccountSave account];
    NSString *str = [kProductCollect stringByAppendingString:[NSString stringWithFormat:@"?uuid=%@&client=ios",account.uuid]];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.productView loadRequest:request];
    [self.view addSubview:self.productView];

    
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(ButtonClick) Title:@""];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    UIImageView *titleImageView = [LXTControl createImageViewWithFrame:CGRectMake(0, 0, 140, 30) ImageName:nil];
    titleImageView.layer.masksToBounds = YES;
    titleImageView.layer.cornerRadius = 15.0;
    titleImageView.backgroundColor = RGBCOLOR(27, 125, 65);
    titleImageView.userInteractionEnabled = YES;
    self.navigationItem.titleView = titleImageView;
    NSArray *titleArray = @[@"吃玩",@"商品"];
    for (int i = 0; i<2; i++) {
        UIButton *titleButton = [LXTControl createButtonWithFrame:CGRectMake(3+i*68, 3, 65, 24) ImageName:nil Target:self Action:@selector(titleButtonClick:) Title:titleArray[i]];
        titleButton.selected = NO;
        titleButton.tag = i+10;
        if (i == 0) {
            titleButton.selected = YES;
            [titleButton setBackgroundImage:[UIImage imageNamed:@"huakuai.png"] forState:UIControlStateNormal];
            [titleButton setTitleColor:RGBCOLOR(50, 220, 120) forState:UIControlStateNormal];
        }
        [titleImageView addSubview:titleButton];
    }
}
//标题按钮
- (void)titleButtonClick:(UIButton *)button
{
    self.selectedIndex = button.tag-10;
    if (button.tag == 11) {
        _showLabel.text = @"";
    }else{
        _showLabel.text = @"您目前还没有收藏哟！";
    }
}
//
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex) {
        UIView *prewebView = [self.view viewWithTag:_selectedIndex+10];
        prewebView.hidden = YES;
        
        UIView *curWebView = [self.view viewWithTag:selectedIndex+10];
        curWebView.hidden = NO;
        
        UIButton *lastBtn = [self.navigationItem.titleView viewWithTag:_selectedIndex+10];
        [lastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [lastBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        UIButton *currentBtn = [self.navigationItem.titleView viewWithTag:selectedIndex+10];
        [currentBtn setTitleColor:RGBCOLOR(50, 220, 120) forState:UIControlStateNormal];
        [currentBtn setBackgroundImage:[UIImage imageNamed:@"huakuai.png"] forState:UIControlStateNormal];
        _selectedIndex = selectedIndex;
    }
}
/**
 *  初始化tableview
 */
- (void)init_tableview
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CELL_WIDTH, [[UIScreen mainScreen]bounds].size.height - 64) style:UITableViewStylePlain];
    tableView.tag = 10;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, WIDTH, 15)];
    _showLabel.text = @"您目前还没有收藏哟！";
    _showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel.font = [UIFont systemFontOfSize:15];
    _showLabel.textColor = RGBCOLOR(67, 67, 67);
    _showLabel.hidden = YES;
    [self.view addSubview:_showLabel];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.model_object_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellName = @"CellIDNew";
    CommonDescriptionTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellName];
    //如果没有找到
    if (cell == nil) {
        //只能重新创建cell对象 并设置样式  同时赋值可重用标识符
        cell = [[CommonDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBCOLOR(232, 232, 232);
    }
    _lineModel=[[CollectModel alloc]initWithDictionary:self.model_object_array[indexPath.row]];
    [cell.backImageView sd_setImageWithURL:[NSURL URLWithString:_lineModel.spot_image] placeholderImage:[UIImage imageNamed:@""]];
    cell.midLabel.text = [NSString stringWithFormat:@"%@",_lineModel.consumption];
    cell.midLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(WIDTH-50, 9999);
    CGSize expectSize = [cell.midLabel sizeThatFits:maximumLabelSize];
    [cell.midLabel setFrame:CGRectMake(CGRectGetMaxX(cell.leftImageView.frame), CGRectGetHeight(cell.backImageView.frame)-37, expectSize.width, 27)];
    [cell.rightImageView setFrame:CGRectMake(20+expectSize.width, CGRectGetHeight(cell.backImageView.frame)-37, 30, 27)];
    
    cell.titleLabel.text = _lineModel.spot_title;
    cell.nameLabel.text = _lineModel.spot_name;
    cell.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize NamemaximumLabelSize = CGSizeMake(WIDTH-50, 9999);
    CGSize NameexpectSize = [cell.nameLabel sizeThatFits:NamemaximumLabelSize];
    [cell.nameLabel setFrame:CGRectMake(10, CGRectGetHeight(cell.backImageView.frame)+36, NameexpectSize.width, 16)];
    [cell.positionImageView setFrame: CGRectMake(CGRectGetMaxX(cell.nameLabel.frame)+20, CGRectGetMaxY(cell.nameLabel.frame)-12, 8, 10)];
    [cell.addressLabel setFrame: CGRectMake(CGRectGetMaxX(cell.positionImageView.frame)+5,CGRectGetMaxY(cell.nameLabel.frame)-14, WIDTH-CGRectGetMaxX(cell.positionImageView.frame)-5-10, 12)];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic =self.model_object_array[indexPath.row];
    DescriptionViewController *description = [[DescriptionViewController alloc]init];
    description.scenic_spotID = [[dic objectForKey:@"scenic_spot_id"] integerValue];
    description.block = ^(NSString *str){
    };
    [self.navigationController pushViewController:description animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic =self.model_object_array[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        NSDictionary * params = @{@"scenic_spot_id":[dic objectForKey:@"scenic_spot_id"]};
        [self cancel_like_or_collect_from_server_with_scenic_spot_id:params];
        [self.model_object_array removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationTop];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Scence_Taste_CELLHEIGHT;
}
#pragma mark webView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    
    if ([requestString containsString:@"ketao/product"]) {
        ProductOfArticlesViewController *article = [[ProductOfArticlesViewController alloc]init];
        article.ProductOfArticlesString = requestString;
        [self.navigationController pushViewController:article animated:YES];
        return NO;
    }
    return YES;
}
#pragma mark 中引文转换-delete
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark AFNetworking

/**
 *  加载服务器数据方法
 */
- (void)requestData
{
    TLAccount * account = [TLAccountSave account];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:account.uuid,@"uuid",nil];
    __weak __typeof(self)weakSelf = self;
    [NetAccess getJSONDataWithUrl:kUSER_GET_COLLECT_INFORMATION parameters:params  WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        weakSelf.model_object_array = [[responseObject objectForKey:@"user_collect"] mutableCopy];
        if (weakSelf.model_object_array.count == 0) {
            _showLabel.hidden = NO;
        }
        [weakSelf.tableView reloadData];
    } fail:^{
    }];
}

/**
 *  取消收藏的方法
 */
- (void)cancel_like_or_collect_from_server_with_scenic_spot_id : (NSDictionary*) dict
{
    TLAccount * account = [TLAccountSave account];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{@"uuid":account.uuid}];
    [params addEntriesFromDictionary:dict];
    [NetAccess getJSONDataWithUrl:kCANCEL_COLLECT_FROM_SERVER parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
    } fail:^{
    }];
}
@end
