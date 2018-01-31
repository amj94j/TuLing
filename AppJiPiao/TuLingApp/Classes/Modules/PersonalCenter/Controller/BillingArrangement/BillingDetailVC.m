//
//  BillingDetailVC.m
//  TuLingApp
//
//  Created by hua on 17/4/18.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BillingDetailVC.h"
#import "UIView+SDAutoLayout.h"
#import "BillingDetailCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "BillModel.h"
#import "BillDetailCell1.h"
#import "BillDetailCell2.h"
#import "BillDetailCell3.h"
#import "BillDetailCell4.h"
#import "BillPhotoVC.h"
@interface BillingDetailVC ()<UITableViewDelegate,UITableViewDataSource>


{
    BillModel *model;
    UILabel *stateLabel;
    UILabel *moneyLabel;
    UILabel  *billLabel;
    
     UIView *botView;

}
@property(nonatomic,strong)UITableView *TableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableDictionary *allDataDic;
@property(nonatomic,strong)NSMutableArray *dataModelArr;


@property int pageindex;
@property int page;
@property int maxpage;
@end

@implementation BillingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单管理";
    model = [[BillModel alloc]init];
    _dataModelArr =[[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _allDataDic=[[NSMutableDictionary alloc]init];
    [self requestData];
    [self creatView];
    [self creatTableView];
    [self bottomView];
    
}


-(void)bottomView
{
    
    botView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-48-64, WIDTH, 48)];
    botView.backgroundColor = [UIColor whiteColor];
    
    UILabel *linLab = [[UILabel alloc]init];
    linLab.frame =CGRectMake(0, 0, WIDTH, 0.5);
    linLab.backgroundColor = RGBCOLOR(238, 238, 238);
    [botView addSubview:linLab];
    
    NSArray *arr = @[@"拒绝",@"确认"];
    for (int i=0; i<2; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2*i,0 , WIDTH/2, 48)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:17]];
        if (i==0) {
        [btn setTitleColor:[UIColor colorWithHexString:@"#6DCB99"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        }else
        {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#6DCB99"]];
        }
        btn.tag =500+i;
        [btn addTarget:self action:@selector(settleAccounts:) forControlEvents:UIControlEventTouchUpInside];
        [botView addSubview:btn];
    }
   
}

-(void)settleAccounts:(UIButton *)sender
{
    if (sender.tag==500) {
      //拒绝
        [self requestDataRefuse];
        
    }else
    {
        //接受
        [self requestDataConfirm];
    
    }
    


}

-(void)creatView
{
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 70)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    
    
    UIImageView *myImage = [[UIImageView alloc]init];
    myImage.frame = backview.frame;
    myImage.image = [UIImage imageNamed:@"bill.png"];
    [backview addSubview:myImage];
    
    billLabel = [createControl createLabelWithFrame:CGRectMake(15, 37, 100, 20) Font:15 Text:@"账单结算金额：" LabTextColor:RGBCOLOR(255, 255, 255)];
    [backview addSubview:billLabel];
    
    stateLabel = [[UILabel alloc]init];
    stateLabel.textColor = [UIColor whiteColor];
    stateLabel.font = [UIFont boldSystemFontOfSize:15];
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",_allDataDic[@"status"]]]) {
        stateLabel.text = _allDataDic[@"status"];
    }
   
    
    [backview addSubview:stateLabel];
    
    
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(billLabel.frame), 23, WIDTH-CGRectGetMaxX(billLabel.frame)-15-stateLabel.frame.size.width, 30)];
    moneyLabel.font = [UIFont systemFontOfSize:36];
    moneyLabel.textColor = [UIColor whiteColor];
    
    [backview addSubview:moneyLabel];
    
    


}
/**
 tableView相关
 */
- (void)creatTableView
{
    self.TableView= [[UITableView alloc]initWithFrame: CGRectMake(0, 70, WIDTH, HEIGHT-70-64) style:UITableViewStyleGrouped];
    self.TableView.alwaysBounceHorizontal = NO;
    self.TableView.alwaysBounceVertical = NO;
    self.TableView.showsHorizontalScrollIndicator = NO;
    self.TableView.showsVerticalScrollIndicator = NO;
    self.TableView.dataSource =self;
    self.TableView.delegate = self;
    //self.TableView.scrollEnabled=NO;
    self.TableView.backgroundColor = RGBCOLOR(238, 238, 238);
    self.TableView.bounces=NO;
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.TableView];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==1) {
        return 44;
    }
    return 0.01;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section==0) {
        return 0.01;
    }

    return 5;


}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *BackView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        BackView1.backgroundColor = RGBCOLOR(238, 238, 238);
        
        UILabel *colorLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, 3, 20)];
        colorLab.backgroundColor = [UIColor colorWithHexString:@"#6DCB99"];
        [BackView1 addSubview:colorLab];
        
        
        UILabel *lab = [createControl createLabelWithFrame:CGRectMake(15, 12, WIDTH-30, 20) Font:15 Text:@"账单明细" LabTextColor:RGBCOLOR(67, 67, 67)];
        [BackView1 addSubview:lab];
        
        return BackView1;
        
    }
    return nil;


}
#pragma mark  返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count+1;
    
    //return 1;
}

#pragma mark  每个分区多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    
    return  3;
}

#pragma mark 改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            Class currentClass = [BillingDetailCell class];
            if (_dataModelArr.count!=0) {
                model =_dataModelArr[indexPath.row];
                // 推荐使用此普通简化版方法（一步设置搞定高度自适应，性能好，易用性好）
                return [self.TableView cellHeightForIndexPath:indexPath model:_dataModelArr[indexPath.row] keyPath:@"myModel" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
                
            }
            
        }
        
        
        return 54;
        
    }
    
    

    if (indexPath.row==0&&indexPath.row==2) {
        return 40;
    }
    
    return 45;
    
    
    
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
#pragma mark 代理数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            BillingDetailCell  *cell = [BillingDetailCell  cellWithTableView:tableView];
            if (_dataModelArr.count!=0) {
                cell.myModel = _dataModelArr[indexPath.row];
            }
            __weak __typeof(self)weakSelf = self;
             cell.BtnClick1 = ^{
                 BillPhotoVC *vc = [[BillPhotoVC alloc]init];
                 vc.str=  _allDataDic[@"id"];
                 [weakSelf.navigationController pushViewController:vc animated:YES];
                 
                 
                 
                 
             };
            return cell;
        }
    
    
        BillDetailCell1 *cell = [BillDetailCell1  cellWithTableView:tableView];
        [cell addValue:@"400-6218-116"];
        return cell;
        
    }
    
    if (indexPath.row==0) {
        BillDetailCell2 *cell = [BillDetailCell2  cellWithTableView:tableView];
        [cell addValue:_dataArray[indexPath.section-1]];
        return cell;
    }
    if (indexPath.row==1) {
        BillDetailCell3 *cell = [BillDetailCell3  cellWithTableView:tableView];
        [cell addValue:_dataArray[indexPath.section-1]];
        return cell;
    }
    BillDetailCell4 *cell = [BillDetailCell4  cellWithTableView:tableView];
    [cell addValue:_dataArray[indexPath.section-1]];
    return cell;
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark--网络请求(列表)
- (void)requestData
{
    __weak __typeof(self)weakSelf = self;
    _dataArray = [[NSMutableArray alloc]init];
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid != nil) {
        params = @{@"uuid":account.uuid,@"billId":_BillingId,@"pageNumber":@"1",@"pageSize":@"10"};
        [NetAccess getJSONDataWithUrl:kBillingDetail parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
            if (code==0) {
                _allDataDic = [responseObject objectForKey:@"date"];
                [weakSelf.dataArray addObjectsFromArray:[[[responseObject objectForKey:@"date"]objectForKey:@"details"] objectForKey:@"list"]] ;
                
                
                
                    BillModel *model1 = [[BillModel alloc]initWithDictionary:_allDataDic error:nil];
                   // model1.eva_id =tmpDic[@"id"];
                    [_dataModelArr addObject:model1];
                

                if (weakSelf.dataArray.count<10) {
                    self.TableView.mj_footer.hidden=YES;
                }
                weakSelf.maxpage =[[[[responseObject objectForKey:@"date"] objectForKey:@"details"] objectForKey:@"totalPage"]intValue];
                
                
                if ([NSString isBlankString:[NSString stringWithFormat:@"%@",_allDataDic[@"status"]]]) {
                    stateLabel.text = _allDataDic[@"status"];
                    stateLabel.frame = CGRectMake(WIDTH-15-[NSString singeWidthForString:stateLabel.text fontSize:15 Height:20], billLabel.frame.origin.y, [NSString singeWidthForString:stateLabel.text fontSize:15 Height:20], 20);
                }else
                {
                    stateLabel.text = @"";
                    
                }
                if ([NSString isBlankString:[NSString stringWithFormat:@"%@",_allDataDic[@"settleCost"]]]) {
                    moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[_allDataDic[@"settleCost"] floatValue]];
                }
                
                if ([[NSString stringWithFormat:@"%@",_allDataDic[@"billEnum"]] isEqualToString:@"1"]) {
                    _TableView.frame =CGRectMake(0, 70, WIDTH, HEIGHT-70-64-48);
                    [self.view addSubview:botView];
                }else
                {
                _TableView.frame =CGRectMake(0, 70, WIDTH, HEIGHT-70-64);
                    [botView removeFromSuperview];
                }
                
                [weakSelf.TableView reloadData];
                
                

            }
        } fail:^{
            [MBProgressHUD showError:@"网络请求失败"];
        }];
    }
    
}



#pragma mark--网络请求(确认账单)
- (void)requestDataConfirm
{
    __weak __typeof(self)weakSelf = self;
    _dataArray = [[NSMutableArray alloc]init];
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid != nil) {
        params = @{@"uuid":account.uuid,@"billId":_BillingId};
        [NetAccess getJSONDataWithUrl:kBillingConfirm parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
            if (code==0) {
                
                 [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } fail:^{
            [MBProgressHUD showError:@"网络请求失败"];
        }];
    }
    
}


#pragma mark--网络请求(拒绝账单)
- (void)requestDataRefuse
{
    __weak __typeof(self)weakSelf = self;
    _dataArray = [[NSMutableArray alloc]init];
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid != nil) {
        params = @{@"uuid":account.uuid,@"billId":_BillingId};
        [NetAccess getJSONDataWithUrl:kBillingRefuse parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
            int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
            if (code==0) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
                
            }
        } fail:^{
            [MBProgressHUD showError:@"网络请求失败"];
        }];
    }
    
}



@end
