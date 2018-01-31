//
//  OrderReturnDetailVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/6.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "OrderReturnDetailVC.h"
#import "ReturnDetailModel.h"
#import "LogisticsCompanyModel.h"
#import "ReturnDetailFootCell.h"
#import "OnReturnHeaderCell.h"
#import "ReturnSuccessCell.h"

@interface OrderReturnDetailVC ()<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UILabel *_logisCompany;
    UITextField *_logisNum;
    
    UIView *_logisComView;
    NSString *_companyCode;
}
@property (nonatomic, strong) ReturnDetailModel *detailModel;
@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) NSMutableArray *logisComData;
@property (nonatomic, strong) UIView       *footView;
@property (nonatomic, strong) NSString      *phoneNumber;
@end

@implementation OrderReturnDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self requestGetReturnDetailData];
    
    [self buildSubviews];
}

- (void) requestGetReturnDetailData
{
    TLAccount * account = [TLAccountSave account];

    NSInteger time = [[NSDate date]timeIntervalSince1970]*1000;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"orderId=%@",@(_orderId)]];
    [array addObject:[NSString stringWithFormat:@"uuid=%@",account.uuid]];
    [array addObject:[NSString stringWithFormat:@"time=5%@",@(time)]];
    
    [NetAccess getForEncryptJSONDataWithUrl:kOrderFormReturnDetail parameters:array  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
        
        
        if ([reswponse[@"header"][@"code"] intValue] != 0) {
            return ;
        }
        
        NSMutableDictionary *dataDic = [reswponse objectForKey:@"date"];
        self.phoneNumber = dataDic[@"phone"];
        _detailModel = [[ReturnDetailModel alloc]init];
        [_detailModel setValuesForKeysWithDictionary:dataDic];
        
        self.title = _detailModel.title;
        [_tabelView reloadData];
        
        if (_detailModel.orderReturnType == 2) {
            [self getLogisCompanyDate];
        }
    } fail:^{
        [MBProgressHUD showSuccess:@"网络出错了"];
    }];
}
// 获取退款快递公司
- (void) getLogisCompanyDate
{

}

- (void) buildSubviews
{
    _tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.tableFooterView = [[UITableView alloc]init];
    _tabelView.backgroundColor = [UIColor clearColor];
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabelView];
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 110)];
    self.footView.backgroundColor = [UIColor whiteColor];
    UILabel *connectLable = [[UILabel alloc]init];
    connectLable.textColor= [UIColor colorWithHexString:@"#6a6a6a"];
    connectLable.font = [UIFont fontWithName:FONT_REGULAR size:13];
    connectLable.textAlignment = NSTextAlignmentLeft;
   connectLable.text = @"本订单由第三方商家提供售后";
    [connectLable sizeToFit];
    connectLable.frame = CGRectMake(15, 25, mainScreenWidth-30, connectLable.height);
    [self.footView addSubview:connectLable];
    
    UIButton *connectButton  = [[UIButton alloc]init];
    [connectButton setTitle:@" 联系客服" forState:UIControlStateNormal];
    [connectButton setTitleColor:[UIColor colorWithHexString:@"#6a6a6a"] forState:UIControlStateNormal];
    [connectButton setImage:[UIImage imageNamed:@"connectphone"] forState:UIControlStateNormal];
    connectButton.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:15];
    connectButton.layer.borderColor = [UIColor colorWithHexString:@"bbbbbb"].CGColor;
    connectButton.layer.borderWidth = 1;
    connectButton.layer.cornerRadius = 5;
   connectButton.frame = CGRectMake(15, connectLable.bottom +10, mainScreenWidth-30, 34);
    [connectButton addTarget:self action:@selector(connectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footView addSubview:connectButton];
    self.tabelView.tableFooterView = self.footView;
}


-(void)connectButtonClick:(UIButton *)sender
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_detailModel == nil) {
        return 0;
    }
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 && _detailModel.orderReturnType != 5) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
        view.backgroundColor = [UIColor colorWithHexString:@"6dcb99"];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, WIDTH-30, 100)];
        title.text = _detailModel.content;
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont fontWithName:FONT_REGULAR size:17];
        title.textColor = [UIColor colorWithHexString:@"#FEFEFE"];
        [view addSubview:title];
        return view;
    } else
        return nil;
}
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (_detailModel.orderReturnType == 2) {
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 240)];
            bgView.backgroundColor = [UIColor clearColor];
            
            UILabel *dian = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 15, 20)];
            dian.text = @"*";
            dian.textColor = [UIColor colorWithHexString:@"#F9516A"];
            [bgView addSubview:dian];
            
            UILabel *comLab = [LXTControl createLabelWithFrame:CGRectMake(30, 0, WIDTH-45, 40) Font:15 Text:@"快递公司"];
            [bgView addSubview:comLab];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 40, WIDTH-30, 50)];
            view.backgroundColor = [UIColor whiteColor];
            [bgView addSubview:view];
            
            _logisCompany = [LXTControl createLabelWithFrame:CGRectMake(25, 40, WIDTH-30, 50) Font:15 Text:@"请选择快递公司"];
            _logisCompany.textColor = [UIColor colorWithHexString:@"#919191"];
            [bgView addSubview:_logisCompany];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15, 40, WIDTH-30, 50);
            [btn setImage:[UIImage imageNamed:@"bt_arrowDown"] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
            [btn addTarget:self action:@selector(onChooseLogisCompanyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
            
            
            UILabel *dian2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 100, 15, 20)];
            dian2.text = @"*";
            dian2.textColor = [UIColor colorWithHexString:@"#F9516A"];
            [bgView addSubview:dian2];
            
            UILabel *num = [LXTControl createLabelWithFrame:CGRectMake(30, 90, WIDTH-45, 40) Font:15 Text:@"物流单号"];
            [bgView addSubview:num];
            
            _logisNum = [LXTControl createTextFieldWithFrame:CGRectMake(15, 130, WIDTH-30, 50) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:15];
            _logisNum.backgroundColor = [UIColor whiteColor];
            [bgView addSubview:_logisNum];
            
            
            UIButton *saveInfo = [LXTControl createButtonWithFrame:CGRectMake(15, 195, 100, 30) ImageName:nil Target:self Action:@selector(saveLogisInfoBtnClick:) Title:@"保存物流信息"];
            saveInfo.titleLabel.font = [UIFont systemFontOfSize:15];
            [saveInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            saveInfo.backgroundColor = [UIColor colorWithHexString:@"#FF4861"];
            [bgView addSubview:saveInfo];
            
            return bgView;
        } else
            return nil;
    } else{
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, mainScreenWidth, 10);
        view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        return view;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && _detailModel.orderReturnType != 5) {
        return 100;
    } else
        return 0.1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_detailModel.orderReturnType == 2) {
        if (section == 0) {
            return 240;
        }
        return 10;
    } else
        return 10;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (_detailModel.orderReturnType == 1) // 待商家处理退款申请
        {
            if(_detailModel.isReceipt == 2)
            {
            NSString *str = [onReturnStr1 stringByAppendingString:@"\n如果商家未处理：超过00天00时00分钟系统发送商家的默认退货地址给买家"];
            CGSize size = [str sizeWithFont:17 andMaxSize:CGSizeMake(WIDTH-30, 500)];
            return size.height+100;
            }else
            {
                NSString *str = [onReturnStr2 stringByAppendingString:@"\n如果商家未处理：商家还剩下00天00时00分处理退款申请,如果逾期未处理,系统将自动返回给买家"];
                CGSize size = [str sizeWithFont:17 andMaxSize:CGSizeMake(WIDTH-30, 500)];
                return size.height+100;
            }
        }
        else if (_detailModel.orderReturnType == 2)
        {
            NSString *str = @"请在00天00时内寄回退款，并填入运单号码\n如未按时操作，将退款关闭";
            CGSize size = [str sizeWithFont:17 andMaxSize:CGSizeMake(WIDTH-30, 500)];
            
            NSString *addStr = [NSString stringWithFormat:@"退款地址：%@", _detailModel.returnAddress];
            CGSize addressSize = [addStr sizeWithFont:17 andMaxSize:CGSizeMake(WIDTH-30, 500)];
            
            return size.height+addressSize.height+80;
        }
        else if (_detailModel.orderReturnType == 3) // 待商家验货并同意退款
        {
            NSString *str = [onReturnStr3 stringByAppendingFormat:@"\n如果商家未处理：超过00天00时00分钟系统默认进入等待平台退款"];
            CGSize size = [str sizeWithFont:17 andMaxSize:CGSizeMake(WIDTH-30, 500)];
            return size.height+120;
        }
        else if (_detailModel.orderReturnType == 4)
        {
            NSString *str = [NSString stringWithFormat:@"平台会在3日内（遇节假日会有延迟）将退款返还至原支付渠道，请耐心等待"];
//
            CGSize size = [str sizeWithFont:17 andMaxSize:CGSizeMake(WIDTH-30, 500)];
            return size.height+80;
        }
        else if (_detailModel.orderReturnType == 5)
            return 270;

        else if (_detailModel.orderReturnType == 6) {
            CGSize size = [_detailModel.shopMessage sizeWithFont:17 andMaxSize:CGSizeMake(WIDTH-30, 500)];
            return size.height+70;
        } else
            return 0;
        
    } else
        return 135;
    
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        __weak __typeof(self) weakSelf = self;
        if (_detailModel.orderReturnType == 5) { // 退款成功
            static NSString *cellId = @"SuccessIdentifier";
            ReturnSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[ReturnSuccessCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            
            cell.backBtnClick = ^(){
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            };
            return cell;
        }
        
        static NSString *cellId = @"hederIdentifier";
        OnReturnHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[OnReturnHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _detailModel;
        cell.repealBtnCLick = ^(){ // 撤销退款
            [weakSelf onCancelReturn];
        };
 
        cell.phoneNumBtnClick = ^(){
            if (weakSelf.detailModel.orderReturnType == 4||weakSelf.detailModel.orderReturnType == 6)
            {
            NSMutableString* str=[[NSMutableString alloc]initWithFormat:@"telprompt://%@",weakSelf.detailModel.sysPhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }else
            {
                NSMutableString* str=[[NSMutableString alloc]initWithFormat:@"telprompt://%@",weakSelf.detailModel.phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        };
        return cell;
    } else {
    
        static NSString *cellId = @"identifier";
        ReturnDetailFootCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ReturnDetailFootCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _detailModel;
        return cell;
    }
}

// 撤销退款
- (void) onCancelReturn
{
    TLAccount * account = [TLAccountSave account];
    NSInteger time = [[NSDate date]timeIntervalSince1970]*1000;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"orderId=%@",@(_orderId)]];
    [array addObject:[NSString stringWithFormat:@"uuid=%@",account.uuid]];
    [array addObject:[NSString stringWithFormat:@"time=5%@",@(time)]];
    [NetAccess getForEncryptJSONDataWithUrl:kOrderFormReturnCancel parameters:array  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
        if ([reswponse[@"header"][@"code"] intValue] != 0) {
            [MBProgressHUD showSuccess:@"撤销退款失败"];
            return ;
        }
        [MBProgressHUD showSuccess:@"撤销退款成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^{
        [MBProgressHUD showSuccess:@"网络出错了"];
    }];
}

// 选择物流公司
- (void) onChooseLogisCompanyBtnClick:(UIButton *) sneder
{
    if (_logisComView == nil && _logisComData.count != 0) {
        
        
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect = [_logisCompany convertRect:_logisCompany.bounds toView:window];
        
        _logisComView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.origin.y, WIDTH, 190)];
        _logisComView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_logisComView];
        
        UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, WIDTH-30, 190)];
        picker.dataSource = self;
        picker.delegate = self;
        picker.backgroundColor = [UIColor whiteColor];
        [_logisComView addSubview:picker];
        LogisticsCompanyModel *model = _logisComData[0];
        _logisCompany.text = model.logisticsName;
        _companyCode = model.logisticsCode;
        _logisCompany.textColor = [UIColor colorWithHexString:@"#434343"];
        _logisComView.hidden = YES;
    }
    _logisComView.hidden = !_logisComView.hidden;
    if (_logisComView.hidden == YES) {
        _tabelView.bounces = YES;
    } else {
        _tabelView.bounces = NO;
    }
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_logisComData.count > 4) {
        return 5;
    } else
        return _logisComData.count;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    LogisticsCompanyModel *model = _logisComData[row];
    return model.logisticsName;
}
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 哪一行被选中
    LogisticsCompanyModel *model = _logisComData[row];
    _logisCompany.text = model.logisticsName;
    _companyCode = model.logisticsCode;
    _logisComView.hidden = YES;
}

// 保存物流信息
- (void) saveLogisInfoBtnClick:(UIButton *)sender
{
   
}



- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    _logisComView.hidden = YES;
}
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    _logisComView.hidden = YES;
}

@end
