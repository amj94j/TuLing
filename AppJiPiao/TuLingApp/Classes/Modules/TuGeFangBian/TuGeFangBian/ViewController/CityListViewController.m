//
//  CityListViewController.m
//  TuLingApp
//
//  Created by apple on 2017/12/6.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "CityListViewController.h"
#import "ZYPinYinSearch.h"
#import "CityListCollectionReusableView.h"
#import "CityModel.h"

@interface CityListViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIButton *_domesticBtn;
    UIView *_domesticLine;
    UIButton *_foreignBtn;
    UIView *_foreignLine;
    
    NSArray *_citysAry; //要显示的城市数组
    NSMutableArray *_lettersArray; //索引数组
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray  *cityListArray;
@property (nonatomic, copy) NSArray *allCityListArray;
@property (nonatomic, strong) NSMutableArray  *searchDataSource;//search到的array
@property (nonatomic, strong) UITableView *tableView;
@property (assign, nonatomic) BOOL isSearch;

// 保存item数据的数组
@property (nonatomic , strong) NSMutableArray *hotCityArray;
@property (nonatomic , strong) UICollectionView *collectionView;
@end

@implementation CityListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
}
//显示
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.hidesBackButton = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = self.searchBar;
    _isSearch = NO;
    if (@available(iOS 11.0, *)) {
        [[self.searchBar.heightAnchor constraintEqualToConstant:44.0] setActive:YES];
    }
    
    NSArray *arr = @[];
    self.searchDataSource = [NSMutableArray arrayWithArray:arr];
    self.allCityListArray = [NSArray new];
    
    [self.view addSubview:self.tableView];
    
    [self requestDate];
}

- (void)requestDate {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        [CityModel asyncPostHotCitySuccessBlock:^(NSArray *hotCityArray) {
            self.hotCityArray = [hotCityArray mutableCopy];
            [self.collectionView reloadData];
            [self.tableView reloadData];
        } errorBlock:nil];
    });
    dispatch_group_async(group, queue, ^{
        [CityModel asyncPostCityListSuccessBlock:^(NSDictionary *cityListDic) {
            self.allCityListArray = [cityListDic objectForKey:@"allcity"];
            self.cityListArray = [[cityListDic objectForKey:@"citylist"] mutableCopy];
            _lettersArray = [[cityListDic objectForKey:@"letters"] mutableCopy];
            [self.tableView reloadData];
        } errorBlock:^(NSError *errorResult) {
        }];
    });
    //4.都完成后会自动通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    });
}

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-69) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#e7e7e7"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//        _tableView.sectionIndexColor = [UIColor blueColor];//设置默认时索引值颜色
//        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];//设置选中时，索引背景颜色
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];// 设置默认时，索引的背景颜色
//        _tableView.sectionIndex
//        if (@available(iOS 11.0, *)) {
//            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            // est和代理 可选1个
//            self.tableView.estimatedSectionFooterHeight = 0;
//            self.tableView.estimatedSectionHeaderHeight = 0;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
    }
    return _tableView;
}

- (UIView *)topHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(92))];
    headerView.backgroundColor = [UIColor whiteColor];
    
    _domesticBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _domesticBtn.frame = CGRectMake(0, 0, (ScreenWidth-PXChange(2))/2, PXChange(90));
    [_domesticBtn setTitle:[NSString stringWithFormat:@"国内"] forState:UIControlStateNormal];
    [_domesticBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    [_domesticBtn setTitleColor:[UIColor colorWithHexString:@"#008C4E"] forState:UIControlStateSelected];
    [_domesticBtn addTarget:self action:@selector(nationalityClick:) forControlEvents:UIControlEventTouchUpInside];
    [_domesticBtn setSelected:YES];
    _domesticBtn.userInteractionEnabled = NO;
    _domesticBtn.tag = 1000;
    [headerView addSubview:_domesticBtn];
    
    _domesticLine = [[UIView alloc] initWithFrame:CGRectMake(_domesticBtn.left, _domesticBtn.bottom, _domesticBtn.width, PXChange(5))];
    _domesticLine.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
    [headerView addSubview:_domesticLine];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_domesticBtn);
        make.centerX.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(PXChange(2), PXChange(80)));
    }];
    
    // 往返
    _foreignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _foreignBtn.frame = CGRectMake(ScreenWidth/2+PXChange(1), 0, (ScreenWidth-PXChange(2))/2, PXChange(90));
    [_foreignBtn setTitle:[NSString stringWithFormat:@"国际/港澳台"] forState:UIControlStateNormal];
    [_foreignBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    [_foreignBtn setTitleColor:[UIColor colorWithHexString:@"#008C4E"] forState:UIControlStateSelected];
    [_foreignBtn addTarget:self action:@selector(nationalityClick:) forControlEvents:UIControlEventTouchUpInside];
    _foreignBtn.tag = 2000;
    [headerView addSubview:_foreignBtn];
    
    _foreignLine = [[UIView alloc] initWithFrame:CGRectMake(_foreignBtn.left, _foreignBtn.bottom, _foreignBtn.width, PXChange(5))];
    _foreignLine.backgroundColor = [UIColor clearColor];
    [headerView addSubview:_foreignLine];
    
    return headerView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.navigationItem.titleView.height)];
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.placeholder = @"请输入城市名或拼音查询";
        for(UIView *view in  [[[_searchBar subviews] objectAtIndex:0] subviews]) {
            if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
                UIButton *cancel = (UIButton *)view;
                [cancel setEnabled:YES];
                [cancel setTitle:@"取消" forState:UIControlStateNormal];
                cancel.titleLabel.font = [UIFont systemFontOfSize:16];
                [cancel setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
            }
        }
    }
    return _searchBar;
}

- (NSMutableArray *)cityListArray {
    if (!_cityListArray) {
        _cityListArray = [NSMutableArray new];
    }
    return _cityListArray;
}

- (NSMutableArray *)hotCityArray {
    if (!_hotCityArray) {
        _hotCityArray = [NSMutableArray new];
    }
    return _hotCityArray;
}
- (void)setpositioningCity:(CityModel *)positioningCity {
    if (!_positioningCity) {
        _positioningCity = [CityModel new];
    }
    if (![_positioningCity isEqual:positioningCity] || _positioningCity != positioningCity) {
        _positioningCity = positioningCity;
    }
}

#pragma mark - Click
- (void)nationalityClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.tag == 1000)
    {
        _domesticBtn.userInteractionEnabled = NO;
        _foreignBtn.userInteractionEnabled = YES;
        [_foreignBtn setSelected:NO];
        _domesticLine.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
        _foreignLine.backgroundColor = [UIColor clearColor];
    }
    else if (sender.tag == 2000)
    {
        _foreignBtn.userInteractionEnabled = NO;
        _domesticBtn.userInteractionEnabled = YES;
        [_domesticBtn setSelected:NO];
        _foreignLine.backgroundColor = [UIColor colorWithHexString:@"#008C4E"];
        _domesticLine.backgroundColor = [UIColor clearColor];
    }
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.searchDataSource removeAllObjects];
    NSArray *ary = nil;
    if (searchText.length == 0) {
        [self.searchDataSource removeAllObjects];
    } else {
        _isSearch = YES;
        ary = [ZYPinYinSearch searchWithOriginalArray:self.allCityListArray andSearchText:searchText andSearchByPropertyName:@"name"];
        self.searchDataSource = [ary mutableCopy];
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length>0) {

    } else {
        _isSearch = YES;
        [self.tableView reloadData];
    }
}

//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    _isSearch = NO;
//    [self.tableView reloadData];
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar  {
    [self.searchBar endEditing:YES];
    
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"];
    cancelBtn.enabled = YES;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    [self.searchDataSource removeAllObjects];
    _searchBar.text = @"";
    _isSearch = NO;
    [self.tableView reloadData];
    [self.searchBar endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableViewDelegate & tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isSearch) {
        return 1;
    }
    return _lettersArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearch) {
        return self.searchDataSource.count;
    } else {
        if (section!=0) {
            NSArray *arr = self.cityListArray[section-1];
            return arr.count;
        } else {
            return 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isSearch) {
        return 0;
    } else {
        if (section == 0) {
            return PXChange(92);
        } else {
            return PXChange(40);
        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = nil;
    if (_isSearch) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        return headerView;
    } else {
        if (section == 0) {
            headerView = [self topHeaderView];
        } else {
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(40))];
            headerView.backgroundColor = [UIColor colorWithHexString:@"#e7e7e7"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PXChange(30), 0, ScreenWidth-PXChange(60), PXChange(40))];
            label.textColor = [UIColor colorWithHexString:@"#434343"];
            label.font = [UIFont systemFontOfSize:14];
            NSString *str = _lettersArray[section-1];
            label.text = str;
            [headerView addSubview:label];
        }
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && !_isSearch) {
        return PXChange(435)+(PXChange(75)*ceilf(self.hotCityArray.count/3));
    } else {
        return PXChange(130);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0 && !_isSearch) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(435)+(PXChange(75)*ceilf(self.hotCityArray.count/3))) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
        layout.itemSize = CGSizeMake(PXChange(210), PXChange(75));
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 0;
        collectionView.scrollEnabled = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
        [cell.contentView addSubview:collectionView];
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        CityModel *model = [CityModel new];
        if (_isSearch) {
            model = self.searchDataSource[indexPath.row];
        } else {
            NSArray *arr = self.cityListArray[indexPath.section-1];
            model = arr[indexPath.row];
        }
        
        cell.textLabel.text = model.name;
        
    }
    
    return cell;
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && !_isSearch) {
        return;
    } else {
        CityModel *model = [CityModel new];
        if (_isSearch) {
            model = self.searchDataSource[indexPath.row];
        } else {
            NSArray *arr = self.cityListArray[indexPath.section-1];
            model = arr[indexPath.row];
        }
        CityListViewControllerBlock block = self.block;
        if (block) {
            block(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_lettersArray objectAtIndex:section];
}
#pragma mark 右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (_isSearch) {
        return nil;
    }
    return _lettersArray;
}

#pragma mark - collectionViewDelegate & collectionViewDateSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (self.hotCityArray.count > 9) {
            return 9;
        }
        return self.hotCityArray.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, PXChange(80));
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //注册段头部视图
    [collectionView registerClass:[CityListCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerViewIdentifier"];
    
    UICollectionReusableView *reusableView =nil;
    //返回段头段尾视图 UICollectionReusableView
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CityListCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerViewIdentifier" forIndexPath:indexPath];
        //添加头视图的内容
        header.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PXChange(30), PXChange(45), ScreenWidth-PXChange(60), PXChange(35))];
        label.textColor = [UIColor colorWithHexString:@"#919191"];
        label.font = [UIFont systemFontOfSize:14];
        if (indexPath.section==0) {
            label.text = @"定位城市";
        } else {
            label.text = @"热门城市";
        }
        [header addSubview:label];
        
        reusableView = header;
        return reusableView;
    }
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"collection";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
    view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    view.layer.cornerRadius = PXChange(5);
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = PXChange(1);
    view.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
    [cell addSubview:view];
    
    if (indexPath.section == 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, view.width, view.height);
        
        if (self.positioningCity.name.length>0) {
            NSString *cityDing = [NSString stringWithFormat:@" %@",self.positioningCity.name];
            [btn setTitle:cityDing forState:UIControlStateNormal];
        } else {
            [btn setTitle:@"" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"city_positioning"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:btn];
        
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height)];
        label.textColor = [UIColor colorWithHexString:@"#434343"];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        CityModel *model = [CityModel new];
        model = self.hotCityArray[indexPath.row];
        label.text = model.name;
        [view addSubview:label];
    }
    
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(PXChange(30), PXChange(30), PXChange(30), PXChange(30));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CityListViewControllerBlock block = self.block;
    if (block) {
        if (indexPath.section == 0) {
            // 这个需要传过来的再次传过去
            if (self.positioningCity.name.length>0) {
                block(self.positioningCity);
            } else {
                [MBProgressHUD showSuccess:@"请选择有效的地址"];
                return;
            }
            
        } else {
            block(self.hotCityArray[indexPath.row]);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
