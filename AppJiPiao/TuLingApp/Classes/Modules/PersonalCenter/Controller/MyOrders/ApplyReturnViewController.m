//
//  ApplyReturnViewController.m
//  TuLingApp
//
//  Created by 李立达 on 2017/7/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ApplyReturnViewController.h"
#import "MyOrderFormListModel.h"

@interface ApplyReturnViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,strong)UILabel *descriptionLable;
@property(nonatomic,strong)UILabel *descriptionLable1;
@property(nonatomic,strong)UIButton *noReceiveButton;
@property(nonatomic,strong)UIButton *receivedButton;
@property(nonatomic,strong)UIButton *refundReasonBtn;
@property(nonatomic,strong)UIView   *refundReasonView;
@property(nonatomic,strong)UILabel  *refundReason;
@property(nonatomic,strong)UIButton *submitApplyButton;
//练习客服
@property(nonatomic,strong)UILabel  *connectLable;
@property(nonatomic,strong)UIButton *connectButton;
@property(nonatomic,strong)NSMutableArray *reasonArr;
//选择退款的view
@property(nonatomic,strong)UIButton *maskView;
@property(nonatomic,strong)UIView  *pickBackView;
@property(nonatomic,strong)UIPickerView *pickView;
@end

@implementation ApplyReturnViewController
{
    NSInteger isreceive;
    BOOL isfirstAppear;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    self.reasonArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestReasonData];
    [self setupView];
    [self setupPickView];
    isfirstAppear = NO;
}
-(void)setupView
{
    UIButton *putIn = [UIButton buttonWithType:UIButtonTypeCustom];
    putIn.frame = CGRectMake(0, HEIGHT-64-50, WIDTH, 50);
    putIn.backgroundColor = [UIColor colorWithHexString:@"#6dcb99"];
    [putIn setTitle:@"提交申请" forState:UIControlStateNormal];
    [putIn addTarget:self action:@selector(onPutInBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:putIn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.view addSubview:line];
    self.descriptionLable = [self redStartLable:@"您收到货了吗"];
    [self.descriptionLable sizeToFit];
    self.descriptionLable.frame = CGRectMake(15, line.bottom+25, mainScreenWidth-30, self.descriptionLable.height);
    [self.view addSubview:self.descriptionLable];
    
    self.noReceiveButton = [self receiveButtonReturn:@"没收到"];
    self.noReceiveButton.frame = CGRectMake(15, self.descriptionLable.bottom+10, 100, 30);
    self.noReceiveButton.tag = 1;
    [self.view addSubview:self.noReceiveButton];
    
    self.receivedButton = [self  receiveButtonReturn:@"收到了"];
    self.receivedButton.frame = CGRectMake(self.noReceiveButton.right+15, self.descriptionLable.bottom+10, 100, 30);
    self.receivedButton.tag = 2;
    [self.view addSubview:self.receivedButton];
    isreceive = NO;
    [self receivButtonClick:self.noReceiveButton];
    
    self.descriptionLable1 = [self redStartLable:@"退款原因"];
    [self.descriptionLable1 sizeToFit];
    self.descriptionLable1.frame = CGRectMake(15, self.receivedButton.bottom+25, mainScreenWidth-30, self.descriptionLable1.height);
    [self.view addSubview:self.descriptionLable1];
    
    self.refundReasonView = [[UIView alloc]initWithFrame:CGRectMake(15, self.descriptionLable1.bottom+10, mainScreenWidth-30, 30)];
    [self.refundReasonView addTapGestureWithTarget:self action:@selector(appearView)];
    self.refundReasonView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.view addSubview:self.refundReasonView];
    
    self.refundReasonBtn = [[UIButton alloc]init];
    UIImage *refundBtnImage =[UIImage imageNamed:@"returnOrderpull"];
    [self.refundReasonBtn setImage:refundBtnImage forState:UIControlStateNormal];
    self.refundReasonBtn.enabled = NO;
    self.refundReasonBtn.frame = CGRectMake(self.refundReasonView.width-15- refundBtnImage.size.width, 0,refundBtnImage.size.width, 34);
    [self.refundReasonView addSubview:self.refundReasonBtn];
    
    self.refundReason = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, mainScreenWidth-30, 30)];
    self.refundReason.textAlignment = NSTextAlignmentLeft;
    self.refundReason.text = @"请选择退款原因";
    self.refundReason.textColor = [UIColor colorWithHexString:@"#919191"];
    self.refundReason.font = [UIFont fontWithName:FONT_REGULAR size:13];
    [self.refundReasonView addSubview:self.refundReason];
    
    
    
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.refundReasonView.bottom+40, mainScreenWidth, 10)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.view addSubview:line1];
    
    self.connectLable = [[UILabel alloc]init];
    self.connectLable.textColor= [UIColor colorWithHexString:@"#6a6a6a"];
    self.connectLable.font = [UIFont fontWithName:FONT_REGULAR size:13];
    self.connectLable.textAlignment = NSTextAlignmentLeft;
    self.connectLable.text = @"本订单由第三方商家提供售后";
    [self.connectLable sizeToFit];
    self.connectLable.frame = CGRectMake(15, line1.bottom+25, mainScreenWidth-30, self.connectLable.height);
    [self.view addSubview:self.connectLable];
    
    self.connectButton  = [[UIButton alloc]init];
    [self.connectButton setTitle:@" 联系客服" forState:UIControlStateNormal];
    [self.connectButton setTitleColor:[UIColor colorWithHexString:@"#6a6a6a"] forState:UIControlStateNormal];
    [self.connectButton setImage:[UIImage imageNamed:@"connectphone"] forState:UIControlStateNormal];
    self.connectButton.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:15];
    self.connectButton.layer.borderColor = [UIColor colorWithHexString:@"bbbbbb"].CGColor;
    self.connectButton.layer.borderWidth = 1;
    self.connectButton.layer.cornerRadius = 5;
    self.connectButton.frame = CGRectMake(15, self.connectLable.bottom +10, mainScreenWidth-30, 34);
    [self.connectButton addTarget:self action:@selector(connectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.connectButton];
}
-(void)setupPickView
{
    _maskView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, mainScreenHeight)];
    [_maskView addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    
    _pickBackView = [[UIView alloc]initWithFrame:CGRectMake(0, mainScreenHeight, WIDTH, 210)];
    _pickBackView.backgroundColor = [UIColor whiteColor];
    UIView *enterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    enterView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [_pickBackView addSubview:enterView];
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(WIDTH-60, 0, 60, 30);
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [finishBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [enterView addSubview:finishBtn];
    [self.maskView addSubview:self.pickBackView];
    self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, WIDTH, 190)];
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    self.pickView.backgroundColor = [UIColor whiteColor];
    [_pickBackView addSubview:self.pickView];
}

- (void) requestReasonData
{
    TLAccount * account = [TLAccountSave account];
    NSInteger time = [[NSDate date]timeIntervalSince1970]*1000;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"orderId=%@",@(_orderID)]];
    [array addObject:[NSString stringWithFormat:@"uuid=%@",account.uuid]];
    [array addObject:[NSString stringWithFormat:@"time=5%@",@(time)]];
    [NetAccess getForEncryptJSONDataWithUrl:kOrderFormRetrunReason parameters:array  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
       
        
        if ([reswponse[@"header"][@"code"] intValue] != 0) {
            return ;
        }
        
        NSMutableDictionary *dataDic = [reswponse objectForKey:@"date"];
        self.phoneNumber = dataDic[@"phone"];
        for (NSDictionary *dict in dataDic[@"rasons"]) {
            CancelOrderReasonModel *model = [[CancelOrderReasonModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            model.reasonId = [dict[@"id"] integerValue];
            [_reasonArr addObject:model];
        }
        
    } fail:^{
    }];
}

-(void)onPutInBtnClick:(UIButton *)sender
{
    TLAccount *account = [TLAccountSave account];
    if(!isfirstAppear)
    {
        UIAlertView *alartView = [[UIAlertView alloc]initWithTitle:nil message:@"请您选择退货原因" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alartView show];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (account.uuid != 0) {
        [params addEntriesFromDictionary:@{@"uuid":account.uuid}];
    }
    [params setObject:@(_orderID) forKey:@"orderId"];
    [params setObject:_refundReason.text forKey:@"shopOrderReturnReason"];
    [params setObject:@(isreceive) forKey:@"type"];
    
    NSInteger time = [[NSDate date]timeIntervalSince1970]*1000;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"orderId=%@",@(_orderID)]];
    [array addObject:[NSString stringWithFormat:@"shopOrderReturnReason=%@",_refundReason.text]];
    [array addObject:[NSString stringWithFormat:@"uuid=%@",account.uuid]];
    [array addObject:[NSString stringWithFormat:@"time=5%@",@(time)]];
    
    
    [NetAccess postJSONWithUrl:kOrderFormRetrunCreate parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        
        self.view.userInteractionEnabled = YES;
        
       
        
        if ([responseObject[@"header"][@"code"] intValue] != 0) {
            [MBProgressHUD showSuccess:@"提交失败"];
            return ;
        }
        
        [MBProgressHUD showSuccess:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^{
        
        self.view.userInteractionEnabled = YES;
        [MBProgressHUD showSuccess:@"网络出错了"];
    }];

}

-(void)connectButtonClick:(UIButton *)sender
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
}

-(void)receivButtonClick:(UIButton *)sender
{
    if(sender.selected)
    {
        return;
    }
    sender.selected = YES;
    if(sender.tag == 1)
    {
        sender.layer.borderColor = [UIColor colorWithHexString:@"#6dcb99"].CGColor;
        self.receivedButton.selected = NO;
        isreceive = sender.tag;
        self.receivedButton.layer.borderColor =  [UIColor colorWithHexString:@"#bbbbbb"].CGColor;
    }else
    {
        sender.layer.borderColor = [UIColor colorWithHexString:@"#6dcb99"].CGColor;
        self.noReceiveButton.selected = NO;
        isreceive = sender.tag;
        self.noReceiveButton.layer.borderColor =  [UIColor colorWithHexString:@"#bbbbbb"].CGColor;
    }
    
}

-(void)appearView
{
    if(_reasonArr.count>0)
    {
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.maskView.backgroundColor =[[UIColor blackColor]colorWithAlphaComponent:0.3];
        self.pickBackView.frame = CGRectMake(0, mainScreenHeight-190, mainScreenWidth, 200);
        
    } completion:^(BOOL finished) {
        if(!isfirstAppear)
        {
            CancelOrderReasonModel *model = _reasonArr[0];
            _refundReason.text = model.dicName;
            isfirstAppear = YES;
        }
    }];
    }
}
-(void)hiddenView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.backgroundColor =[UIColor clearColor];
        _pickBackView.frame = CGRectMake(0,mainScreenHeight,mainScreenWidth, 190);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_reasonArr.count > 4) {
        return 5;
    } else
        return _reasonArr.count;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CancelOrderReasonModel *model = _reasonArr[row];
    return model.dicName;
}
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 哪一行被选中
    CancelOrderReasonModel *model = _reasonArr[row];
    _refundReason.text = model.dicName;
}


#pragma mark 抽取lable 与button
-(UILabel *)redStartLable:(NSString *)string
{
    UILabel *lable = [[UILabel alloc]init];
    lable.text = [NSString stringWithFormat:@"＊ %@",string];
    lable.font = [UIFont fontWithName:FONT_REGULAR size:13];
    lable.textColor = [UIColor colorWithHexString:@"#6a6a6a"];
    lable.textAlignment = NSTextAlignmentLeft;
    NSString *alltring = lable.text;
    NSString *temp = @"＊";
    NSMutableAttributedString *Attributstring = [[NSMutableAttributedString alloc]initWithString:alltring];
    NSRange range = [alltring rangeOfString:temp];
    [Attributstring addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FC3439"] range:range];
    [Attributstring addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_REGULAR size:15] range:range];
    lable.attributedText = Attributstring;
    return lable;
}

-(UIButton *)receiveButtonReturn:(NSString *)string
{
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:string forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:15];
    [button setTitleColor:[UIColor colorWithHexString:@"434343"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#6dcb99"] forState:UIControlStateSelected];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithHexString:@"#bbbbbb"].CGColor;
    [button addTarget:self action:@selector(receivButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}



@end
