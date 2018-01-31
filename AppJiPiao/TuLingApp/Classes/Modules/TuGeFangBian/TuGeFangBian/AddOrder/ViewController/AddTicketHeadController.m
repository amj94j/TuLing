//
//  AddTicketHeadController.m
//  TuLingApp
//
//  Created by LQMacBookPro on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "AddTicketHeadController.h"

#import "TicketHeadModel.h"

#import "TKCustomSheetView.h"

#import "ShowFlightInforView.h"

#import "SearchFlightsModel.h"
#import "TicketPassengerModel.h"
#import "OrderDetailPopView.h"

@interface AddTicketHeadController ()<TKCustomSheetViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeNoTextField;
@property (weak, nonatomic) IBOutlet UIView *downView;

@property (nonatomic, copy)NSString * isPersonal;

@property (nonatomic, copy)NSString * companyStr;

@end

@implementation AddTicketHeadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增发票抬头";
    
    self.companyStr = @"0";
    
    self.isPersonal = @"1";
    
}

- (IBAction)companySelectClick {
    [self.codeNoTextField resignFirstResponder];
    [self.companyNameTextField resignFirstResponder];
    
    NSArray * array = @[@"企业",@"个人"];
    
    TKCustomSheetView * sheeView = [[TKCustomSheetView alloc]init];
    
    [sheeView showCustSheetInView:self.view WithDataArray:array delegate:self];
    
    sheeView.delegate = self;
    
    [self.view addSubview:sheeView];
}

- (IBAction)addNewBtnClick:(UIButton *)sender {
    
    if ([self.isPersonal isEqualToString:@"0"]) {
        if (self.companyNameTextField.text.length == 0) {
            [self showProgress:@"请输入姓名"];
            return;
        }
    } else {
        if (self.companyNameTextField.text.length == 0) {
            [self showProgress:@"请输入企业名称"];
            return;
        }
        if (self.codeNoTextField.text.length == 0) {
            [self showProgress:@"请输入统一社会信用代码"];
            return;
        }
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    param[@"isPersonal"] = self.isPersonal;
    
    param[@"token"] = kToken;
    
    param[@"voucherCode"] = self.codeNoTextField.text;
    
    param[@"invoiceHead"] = self.companyNameTextField.text;
    
    [TicketHeadModel ticketHeadWithParam:param WithFlog:TicketHeadFlogTypeAdd success:^(id respond) {
        
        if ([respond[@"status"] isEqualToString:@"0"]) {
            
            NSLog(@"%@",respond);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } faild:^(id error) {
        
    }];
    
}

- (void)customerSheetSelect:(NSString *)str
{

    if ([str isEqualToString:@"企业"]) {
        self.isPersonal = @"1";
        self.downView.hidden = NO;
        [self.invoiceTypeBtn setTitle:str forState:UIControlStateNormal];
        self.companyNameTextField.placeholder = @"请输入企业名称";
        
    } else {
        [self.invoiceTypeBtn setTitle:str forState:UIControlStateNormal];
        self.companyNameTextField.placeholder = @"请输入姓名";
        
        self.isPersonal = @"0";
        self.downView.hidden = YES;
        
    }
    [self.view reloadInputViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
////    SearchFlightsModel * model = [[SearchFlightsModel alloc]init];
////
////    ShowFlightInforView * info = [ShowFlightInforView showFlightInforWithModel:model];
////
////    [self.view addSubview:info];
//
////    TicketPassengerModel * model = [[TicketPassengerModel alloc]init];
////
////    NSMutableArray * array = [NSMutableArray arrayWithObject:model];
////
////    OrderDetailPopView * orderView = [OrderDetailPopView orderDetailPopViewWithPassageArray:array];
////
////    [self.view addSubview:orderView];
////    OrderDetailPopView * popView = [OrderDetailPopView orderDetailPopViewWithPassageArray:nil];
//
//    OrderDetailPopView * popView = [[OrderDetailPopView alloc]initPopWithModel:nil];
//
//    [self.view addSubview:popView];
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
