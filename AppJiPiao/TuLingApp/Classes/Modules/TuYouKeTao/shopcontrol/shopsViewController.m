//
//  shopsViewController.m
//  search
//
//  Created by hua on 16/11/2.
//  Copyright © 2016年 huazhuo. All rights reserved.
//

#import "shopsViewController.h"
#import "shopSementControl.h"
#import "UIColor+ColorChange.h"
#import "shopCollectionViewCell.h"

#import "commodityDetailViewController.h"
#define kColor(r , g ,b) [UIColor colorWithRed:(r)/255.0  green:(g)/255.0  blue:(b)/255.0 alpha:1]
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
@interface shopsViewController ()<shopSementControlDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
    NSArray * btnDataSource;
    UICollectionView *shopcollectionView;
    int orderType;
    
}

@property int pageindex;
@property int page;
@property int maxpage;
@property(nonatomic,strong)NSMutableDictionary *pageDic;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation shopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    orderType=0;
    //self.title = _shopName;
    _pageDic = [[NSMutableDictionary alloc]init];
    [self requestData];
    self.view.backgroundColor = kColor(238, 238, 238);
//    _dataArray = [[NSMutableArray alloc]initWithObjects:@"北京",@"北京",@"北京",@"北京",@"北京",@"北京",@"北京",@"北京",@"北京",@"北京", nil];
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(ButtonClick) Title:@""];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    _dataArray = [NSMutableArray new];
    [self setsegment];
    [self setcollectionView];
    
    
}
-(void)ButtonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)setsegment
{
    btnDataSource = @[@"全部", @"销量",@"价格", @"上线时间"];
    shopSementControl * segment = [shopSementControl segmentedControlFrame:CGRectMake(0, 5, kScreenW, 44) titDataSource:btnDataSource backgorundColor:[UIColor whiteColor] titleColor:[UIColor colorWithHexString:@"#919191"] titleFont:[UIFont systemFontOfSize:16] selectColor:[UIColor colorWithHexString:@"#017E44"] buttonDownColor:[UIColor colorWithHexString:@"#017E44"] Delegate:self];
    [self.view addSubview:segment];

}
#pragma mark -- 滑竿遵守代理 实现代理方法
-(void)segumentSelectionChange:(NSInteger)selection priceSort:(int)priceSort{
    
    
    //初始页码设置
    self.pageindex = 1;
    
    if (selection == 0) {
        orderType=0;
        
        NSLog(@"0");
//        _dataArray = [[NSMutableArray alloc]initWithObjects:@"北京",@"北京",@"北京",@"北京", nil];
//        [shopcollectionView reloadData];
        [self requestData];
    }
    if (selection == 1){
        //友盟统计
        [MobClick event:@"87"];
        orderType=-1;
        NSLog(@"1");
        [self requestData];
        
    }
   if (selection == 2){
       //友盟统计
      [MobClick event:@"88"];
       //0代表升序,1代表降序
       if (priceSort==0) {
           orderType=2;
          [self requestData];
       }else
       {
           orderType=-2;
           [self requestData];
       }
        NSLog(@"2");
       
    }
    if (selection == 3) {
        //友盟统计
        [MobClick event:@"89"];
        orderType=3;
        
        [self requestData];
    }
}

#pragma mark--collectionView
-(void)setcollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //flowLayout.headerReferenceSize = CGSizeMake(0,kScreenH);
    //2.设置分区的缩进量  参数的顺序 上左下 右
    //flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 0);
    //网格布局
    shopcollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 49, kScreenW, kScreenH-113) collectionViewLayout:flowLayout];
    shopcollectionView.backgroundColor = [UIColor whiteColor];
    shopcollectionView.alwaysBounceHorizontal = NO;
    shopcollectionView.alwaysBounceVertical = NO;
    shopcollectionView.showsHorizontalScrollIndicator = NO;
    shopcollectionView.showsVerticalScrollIndicator = NO;
    shopcollectionView.dataSource = self;
    shopcollectionView.delegate = self;
    //shopcollectionView.frame = CGRectMake(0, 49, kScreenW, kScreenH-49);
    //[collectionView setCollectionViewLayout:flowLayout];
    [shopcollectionView registerClass:[shopCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:shopcollectionView];
    [self setUpRefreshView];

}

#pragma mark--上拉刷新，下拉加载
- (void)setUpRefreshView{
    //初始页码设置
    self.pageindex = 1;
    
    
    __weak __typeof(self) weakSelf = self;
    //self.tableView.mj_footer.hidden = YES;
    //设置上拉加载
    shopcollectionView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

-(void)loadMoreData
{
    self.pageindex++;
    if (_pageindex<=_maxpage) {
        __weak __typeof(self)weakSelf = self;
        
        TLAccount *account = [TLAccountSave account];
        
        NSDictionary *params;
        if (account.uuid != nil) {
            params = @{@"shop_id":_shop_ID,@"sortType":[NSString stringWithFormat:@"%d",orderType],@"uuid":account.uuid,@"pageNumber":[NSString stringWithFormat:@"%d",self.pageindex],@"pageSize":@"10"};
        }else
        {
            params = @{@"shop_id":_shop_ID,@"sortType":[NSString stringWithFormat:@"%d",orderType],@"pageNumber":[NSString stringWithFormat:@"%d",self.pageindex],@"pageSize":@"10"};
            
        }
        [NetAccess getJSONDataWithUrl:kTestGetShop parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            
             [shopcollectionView.mj_footer endRefreshing];
           
            [weakSelf.dataArray addObjectsFromArray:[[responseObject objectForKey:@"datas"]objectForKey:@"list"]];
            
                       
            [shopcollectionView reloadData];
            
        } fail:^{
             [shopcollectionView.mj_footer endRefreshing];
            NSLog(@"asdas");
        }];

        
        
    }else
    {
        [shopcollectionView.mj_footer   endRefreshingWithNoMoreData];
        
        
    }
    
    
    
}





#pragma mark - UICollectionViewDataSource,UICollectionDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    shopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //[cell.itemImage setImage:[UIImage imageNamed:@"22.png"]];
    if ([NSString isBlankString:_dataArray[indexPath.row][@"head_image"]]) {
        [cell.itemImage sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"head_image"]]];
  
    }else
    {
    [cell.itemImage setImage:[UIImage imageNamed:@"169.png"]];
    }
    
    if ([NSString isBlankString:_dataArray[indexPath.row][@"heading"]]) {
       cell.titleLab.text = _dataArray[indexPath.row][@"heading"];
    }else
    {
    cell.titleLab.text =@"";
    }
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"price"]]]) {
        cell.pricrLab.text = [NSString stringWithFormat:@"￥%@",_dataArray[indexPath.row][@"price"]];
    }else
    {
    cell.pricrLab.text = [NSString stringWithFormat:@"￥%@",@"0"];
    }
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"org_price"]]]) {
        cell.pricrLab1.text = [NSString stringWithFormat:@"价格:￥%@",_dataArray[indexPath.row][@"org_price"]];
            }else
            {
                cell.pricrLab1.text = [NSString stringWithFormat:@"价格:￥%@",@"0"];
            }
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"sale_count"]]]) {
        cell.SeeCount.text = [NSString stringWithFormat:@"已售%@",_dataArray[indexPath.row][@"sale_count"]];
            }else
            {
            cell.SeeCount.text = [NSString stringWithFormat:@"已售%@",@"0"];
            }

    
     cell.titleLab.frame= CGRectMake(7, CGRectGetHeight(cell.itemImage.frame)+5, CGRectGetWidth(cell.frame)-7, 20);
    cell.pricrLab1.frame =CGRectMake(7, CGRectGetMaxY(cell.pricrLab.frame)-3, [NSString singeWidthForString:cell.pricrLab1.text fontSize:10 Height:20]+5, 20);
    cell.pricrLab2.frame =CGRectMake(7, CGRectGetMaxY(cell.pricrLab.frame)+7, [NSString singeWidthForString:cell.pricrLab1.text fontSize:10 Height:20]+1, 1);
    cell.SeeCount.frame =CGRectMake(CGRectGetWidth(cell.frame)-[NSString singeWidthForString:cell.SeeCount.text fontSize:10 Height:20]-5-7,cell.pricrLab1.frame.origin.y, [NSString singeWidthForString:cell.SeeCount.text fontSize:10 Height:20]+5, 20);

    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *ID = _dataArray[indexPath.row][@"id"];
    commodityDetailViewController *vc= [[commodityDetailViewController alloc]init];
    vc.commodityID = ID;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}


//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.0f, 15.0f, 2.0f, 15.0f);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenW-41)/2, (kScreenW-41)/2*9/16+67.5);
}
#pragma mark--网络请求(列表)
- (void)requestData
{
    __weak __typeof(self)weakSelf = self;
    
    TLAccount *account = [TLAccountSave account];
    _dataArray = [[NSMutableArray alloc]init];
    NSDictionary *params;
    if (account.uuid != nil) {
        params = @{@"shop_id":_shop_ID,@"sortType":[NSString stringWithFormat:@"%d",orderType],@"uuid":account.uuid,@"pageNumber":@"1",@"pageSize":@"10"};
    }else
    {
    params = @{@"shop_id":_shop_ID,@"sortType":[NSString stringWithFormat:@"%d",orderType],@"pageNumber":@"1",@"pageSize":@"10"};
        
    }kShopDetailsURL
    [NetAccess getJSONDataWithUrl:kTestGetShop parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        weakSelf.pageDic =[responseObject objectForKey:@"datas"];
        weakSelf.maxpage =[_pageDic[@"totalPage"] intValue];
        [weakSelf.dataArray addObjectsFromArray:[[responseObject objectForKey:@"datas"]objectForKey:@"list"]];
        
        if (weakSelf.dataArray.count<10) {
            shopcollectionView.mj_footer.hidden=YES;
        }else
        {
            shopcollectionView.mj_footer.hidden=NO;
            
        }
        [shopcollectionView.mj_footer endRefreshing];
        [shopcollectionView reloadData];
        
    } fail:^{
         [shopcollectionView.mj_footer endRefreshing];
        NSLog(@"asdas");
    }];
}
@end
