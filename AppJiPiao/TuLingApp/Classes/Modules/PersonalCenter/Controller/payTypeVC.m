//
//  payTypeVC.m
//  TuLingApp
//
//  Created by hua on 17/5/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "payTypeVC.h"
#import "payTypeTableViewCell.h"
#import "AlipayRequestConfig.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WXApi.h"

#import "MyOrderDetailVC.h"

@interface payTypeVC ()<UITableViewDelegate,UITableViewDataSource,payTypeTableViewCellDelegate>

{
 int payType;//
    UIButton *btn;
    UILabel *priceLabel1;
    UILabel *priceLabel;
    
    UILabel *contentLabel;
    UILabel *title;
    UILabel *contentLabel1;
    UILabel *title1;
    UILabel *contentLabel2;
    UILabel *title2;

}
@property(nonatomic,strong)NSMutableDictionary *myDic;
@property(nonatomic,strong)UITableView *TableView;
@end

@implementation payTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    payType=1;
    self.title =@"选择支付方式";
    _myDic = [[NSMutableDictionary alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultName:) name:@"resultName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WxResult:) name:@"WxResult" object:nil];
    [self requestData];
    [self creatTableView];
    [self payView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
/**
 tableView相关
 */
- (void)creatTableView
{
    self.TableView= [[UITableView alloc]initWithFrame: CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
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
    
    
    return 10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *BackView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 5)];
    BackView1.backgroundColor = RGBCOLOR(238, 238, 238);
    
    return BackView1;
}
#pragma mark  返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section==0) {
        return 3;
    }
    return 2;

}
#pragma mark 改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

#pragma mark 代理数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   if (indexPath.section==0) {
        
         if (indexPath.row==0)  {
             
            static NSString *cellIdentifiter = @"celwerwerwer2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiter];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifiter];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                title = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, [NSString singeWidthForString:@"订单总金额:" fontSize:18 Height:20], 20)];
                title.text = @"订单总金额:";
                title.font = [UIFont systemFontOfSize:18];
                title.textColor = [UIColor colorWithHexString:@"#434343"];
                [cell.contentView addSubview:title];
                
                
              
                
                contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title.frame)+5, 10, 130, 25)];
               
                contentLabel.font = [UIFont systemFontOfSize:16];
                contentLabel.textColor = [UIColor colorWithHexString:@"#FF5C36"];
                [cell.contentView addSubview:contentLabel];
                
                UILabel *line = [createControl createLineWithFrame:CGRectMake(15, 43.5, WIDTH-30, 0.5) labelLineColor:nil];
                [cell.contentView addSubview:line];
                
            }
             if ([NSString stringWithFormat:@"%@",_myDic[@"productPrice"]]) {
                 //NSLog(@"%@",[NSString stringWithFormat:@"￥%.2f",[_myDic[@"payMoney"] floatValue]]);
                 contentLabel.text =[NSString stringWithFormat:@"￥%.2f",[_myDic[@"productPrice"] floatValue]];
             }else
             {
                 
                 contentLabel.text =[NSString stringWithFormat:@"￥%.2f",[@"0" floatValue]];
             }
             contentLabel.frame =CGRectMake(CGRectGetMaxX(title.frame)+5, 10, [NSString singeWidthForString:contentLabel.text fontSize:16 Height:25], 25);
           
            return cell;
        }else if (indexPath.row==1)
        {
            static NSString *cellIdentifiter = @"ce23dder2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiter];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifiter];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                title1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 25)];
                title1.text = @"途铃积分";
                title1.font = [UIFont systemFontOfSize:15];
                title1.textColor = [UIColor colorWithHexString:@"#434343"];
                [cell.contentView addSubview:title1];
                
                
                contentLabel1=[[UILabel alloc]initWithFrame:CGRectMake(115, 10, 130, 25)];
                
                contentLabel1.font = [UIFont systemFontOfSize:15];
                contentLabel1.textColor = [UIColor colorWithHexString:@"#919191"];
                [cell.contentView addSubview:contentLabel1];
                
                
                UILabel *line = [createControl createLineWithFrame:CGRectMake(15, 43.5, WIDTH-30, 0.5) labelLineColor:nil];
                [cell.contentView addSubview:line];
                
                
            }
            
            NSString *point=@"0";
            if (_myDic[@"point"]) {
                point=[NSString stringWithFormat:@"%@",_myDic[@"point"]];
            }
            if ([point isEqualToString:@"0"]) {
                contentLabel1.text = @"暂无可用积分";
            }else
            {
               // float a=[point floatValue];
                //NSString *money =[NSString stringWithFormat:@"%.2f",a/100];
                contentLabel1.text =[NSString stringWithFormat:@"可以用%@途铃积分抵￥%@",point,[NSString stringWithFormat:@"%@",_myDic[@"pointToMoney"]]];
                
            }
            contentLabel1.frame =CGRectMake(CGRectGetMaxX(title1.frame)+5, 10, [NSString singeWidthForString:contentLabel1.text fontSize:15 Height:25], 25);
            
            return cell;
        
        
        
        
        
        }else
        {
        
            static NSString *cellIdentifiter = @"cellIewrewrcxxvcxvdder2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifiter];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifiter];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                title2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 25)];
                title2.text = @"账户余额";
                title2.font = [UIFont systemFontOfSize:15];
                title2.textColor = [UIColor colorWithHexString:@"#434343"];
                [cell.contentView addSubview:title2];
                
                contentLabel2=[[UILabel alloc]initWithFrame:CGRectMake(115, 10, 130, 25)];
               
                contentLabel2.font = [UIFont systemFontOfSize:15];
                contentLabel2.textColor = [UIColor colorWithHexString:@"#919191"];
                [cell.contentView addSubview:contentLabel2];
                
            
                
                UILabel *line = [createControl createLineWithFrame:CGRectMake(15, 43.5, WIDTH-30, 0.5) labelLineColor:nil];
                [cell.contentView addSubview:line];
            }
            
            if ([NSString isBlankString:[NSString stringWithFormat:@"%@",_myDic[@"balance"]]]) {
                contentLabel2.text = [NSString stringWithFormat:@"￥%.2f",[_myDic[@"balance"] floatValue]];
            }else
            {
                contentLabel2.text = [NSString stringWithFormat:@"￥%.2f",[@"0"floatValue]];
            }
            contentLabel2.frame =CGRectMake(CGRectGetMaxX(title2.frame)+5, 10, [NSString singeWidthForString:contentLabel2.text fontSize:15 Height:25], 25);
                return cell;

        
        
        
        }
            
        
        
    }

    
    
    payTypeTableViewCell *cell = [payTypeTableViewCell cellWithTableView:tableView];
    
    
    if (indexPath.row==0) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        [cell.photoView setImage:[UIImage imageNamed:@"weixin1.png"]];
        cell.name.text =@"微信支付";
        if (!cell.line) {
            cell.line =[createControl createLineWithFrame:CGRectMake(15, 43.5, WIDTH-30, 0.5) labelLineColor:nil];
            [cell.contentView addSubview:cell.line];
        }
        cell.cellBtn.tag = 5000+indexPath.row;
        cell.cellBtn.selected=YES;
        if (payType==2) {
            [cell.cellBtn setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
        }
        if (payType==1) {
            [cell.cellBtn setImage:[UIImage imageNamed:@"confirm1.png"] forState:UIControlStateNormal];
        }
        
        cell.delegate=self;
    }else
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, WIDTH, 0, 15)];
        [cell.photoView setImage:[UIImage imageNamed:@"zhifubao1.png"]];
        cell.name.text =@"支付宝支付";
        if (!cell.line) {
            cell.line =[createControl createLineWithFrame:CGRectMake(15, 43.5, WIDTH-30, 0.5) labelLineColor:nil];
            [cell.contentView addSubview:cell.line];
        }
        cell.cellBtn.tag = 5000+indexPath.row;
        if (payType==1) {
            [cell.cellBtn setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
        }
        if (payType==2) {
            [cell.cellBtn setImage:[UIImage imageNamed:@"confirm1.png"] forState:UIControlStateNormal];
        }
        
        cell.delegate=self;
    }
    return cell;
    

    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        if (payType==2) {
            payType=1;
        }else
        {
            payType=2;
        }
        [self.TableView reloadData];
        
    }




}

#pragma mark--支付方式代理事件
-(void)confirmIssecelt:(payTypeTableViewCell *)cell
{
    NSIndexPath *index = [self.TableView indexPathForCell:cell];
    
    if (index.row==0) {
        if (payType==2) {
            payType=1;
        }else
        {
            payType=2;
        }
        
    }else
    {
        
        if (payType==1) {
            payType=2;
        }else
        {
            payType=1;
        }
        
    }
    [self.TableView reloadData];
    
}
#pragma mark--支付跳转
-(void)payView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-48-64, WIDTH, 48)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *linAb= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    linAb.backgroundColor = RGBCOLOR(178, 178, 178);
    [backView addSubview:linAb];
    
    
    
    btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-112, 0, 112, 48)];
    [btn setTitle:@"付款" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.tag =5009;
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#017e44"]];
    [btn addTarget:self action:@selector(payTypeTiaoZhuan1:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    
    //NSString *tex=[NSString stringWithFormat:@"￥%@",sumPri];
    
    
    priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, [NSString singeWidthForString:@"合计支付:" fontSize:18 Height:20], 20)];
    priceLabel1.textColor = [UIColor colorWithHexString:@"#434343"];
    priceLabel1.text = @"合计支付:";
    priceLabel1.textAlignment = NSTextAlignmentLeft;
    priceLabel1.font = [UIFont systemFontOfSize:18.0];
    [backView addSubview:priceLabel1];

    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel1.frame)+5, 14, [NSString singeWidthForString:@"" fontSize:17.0 Height:20], 20)];
    priceLabel.textColor = [UIColor colorWithHexString:@"#FF5C36"];
    
    //priceLabel.text = tex;
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.font = [UIFont systemFontOfSize:17.0];
    [backView addSubview:priceLabel];
    
}
-(void)payTypeTiaoZhuan1:(UIButton *)btn
{
    [self submitRequest];
    
}



-(void)submitRequest
{

    
    int str = 0;
    
    if (payType==1) {
        str=2;
    }else
    {
        str=1;
    }

    TLAccount * account = [TLAccountSave account];
    NSDictionary *params = @{@"uuid":account.uuid, @"orderId":_orderID, @"payType":[NSString stringWithFormat:@"%d",str],@"balance":@"0",@"point":@"0"};
    
    [NetAccess getJSONDataWithUrl:kOrderFormOrderPay parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
      
        
        int code = [[[reswponse objectForKey:@"header"] objectForKey:@"code"] intValue];
        if (code==0) {
            
            // 支付宝回调通知
            NSMutableDictionary *dataDic = [reswponse objectForKey:@"date"];
            
            [StaticTools SaveOrderId:[NSString stringWithFormat:@"%@",dataDic[@"orderNumber"]] url:@""];
            int type= [dataDic[@"payType"] intValue];
            if (type == 2) {
               
                [WXApiRequestHandler wxPayWithPartnerId:dataDic[@"partnerid"] prepayId:dataDic[@"prepayid"] nonceStr:dataDic[@"noncestr"] timeStamp:[dataDic[@"timestamp"] intValue] sign:dataDic[@"sign"]];
            } else if(type == 1) {
                [AlipayRequestConfig payServerWithAppScheme:@"123" signedString:dataDic[@"aliPayOrder"] orderInfoEncoded:dataDic[@"aliPayOrder"] payBlock:^(NSString *resultCode)
                 {
                    
                     
                 }] ;
            }else
            {
            
            
            
            
            }
        }
        
    } fail:^{
        [MBProgressHUD showSuccess:@"网络出错了"];
    }];


}
#pragma mark--网络请求(列表)
- (void)requestData
{
    __weak __typeof(self)weakSelf = self;
    TLAccount *account = [TLAccountSave account];
  
    NSDictionary *params;
    params = @{@"uuid":account.uuid,@"orderId":_orderID};
    [NetAccess getJSONDataWithUrl:kGetOrder parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
        if (code==0) {
            weakSelf.myDic =[responseObject objectForKey:@"date"];
            
            
            priceLabel.text =[NSString stringWithFormat:@"%.2f",[weakSelf.myDic[@"payMoney"] floatValue]];
            priceLabel.frame =CGRectMake(CGRectGetMaxX(priceLabel1.frame)+5, 14, [NSString singeWidthForString:priceLabel.text fontSize:17.0 Height:20], 20);
            
        }
        [self.TableView reloadData];
    } fail:^{
        [MBProgressHUD showError:@"请求失败"];
        
    }];
}

- (void)resultName:(NSNotification *)text{
    
    NSString *str= text.userInfo[@"result"];
    if ([str isEqualToString:@"0"]) {
        
    }else
    {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *str1= [defaults objectForKey:@"orderId1"];
        if ([str1 isEqualToString:@"0"]) {
            //列表页
            
            
        }else
        {
            
            MyOrderDetailVC *fail = [[MyOrderDetailVC alloc]init];
            fail.orderId=[str1 integerValue];
            [self.navigationController pushViewController:fail animated:YES];
            
        }
        
    }
    
    
    //    [MBProgressHUD showSuccess:@"支付成功"];
}

- (void)WxResult:(NSNotification *)text{
    
    NSString *str= text.userInfo[@"result"];
    if ([str isEqualToString:@"0"]) {
      
        
    }else
    {
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *str1= [defaults objectForKey:@"orderId1"];
        if ([str1 isEqualToString:@"0"]) {
            //列表页
            
        }else
        {
            
            MyOrderDetailVC *fail = [[MyOrderDetailVC alloc]init];
            fail.orderId=[str1 integerValue];
            [self.navigationController pushViewController:fail animated:YES];
            
            
        }
        
    }
}



@end
