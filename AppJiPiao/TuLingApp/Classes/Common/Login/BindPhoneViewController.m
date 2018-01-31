//
//  BindPhoneViewController.m
//  TuLingApp
//
//  Created by 李立达 on 2017/8/10.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "chatViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "codeVC.h"
@interface BindPhoneViewController ()
<
UITextFieldDelegate
>
@property(nonatomic,strong)UIView *topBar;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UIButton*backButton;
@property(nonatomic,strong)UIView *discriptionView;
@property(nonatomic,strong)UILabel *discriptionLable;
@property(nonatomic,strong)UITextField *phoneInput;
@property(nonatomic,strong)UITextField *inspectionInput;
@property(nonatomic,strong)UIView *phoneView;
@property(nonatomic,strong)UIView *inspectionView;
@property(nonatomic,strong)UILabel*phoneLabel;
@property(nonatomic,strong)UILabel*inspectionLable;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,strong)UILabel *separateline;
@property(nonatomic,strong)UILabel *countDownLable;
@end

@implementation BindPhoneViewController
{
    BOOL _isCountDown;
    NSTimer *_timer;
    NSInteger count;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isCountDown = NO;
    count = 60;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    [self setupView];
}

-(void)setupView
{
    self.topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainScreenWidth, 64)];
    self.topBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topBar];
    
    self.titleLable = [[UILabel alloc]init];
    self.titleLable.text = @"绑定手机";
    self.titleLable.font = [UIFont fontWithName:FONT_REGULAR size:20];
    self.titleLable.textColor = [UIColor colorWithHexString:@"#434343"];
    [self.titleLable sizeToFit];
    self.titleLable.center = CGPointMake(mainScreenWidth/2,((self.topBar.height-20)/2)+20);
    [self.topBar addSubview:self.titleLable];
    
    self.backButton = [[UIButton alloc]init];
    [self.backButton setImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton sizeToFit];
    self.backButton.center = CGPointMake(15+self.backButton.width/2, self.titleLable.center.y);
    [self.topBar addSubview:self.backButton];
    
    self.discriptionView = [[UIView alloc]initWithFrame:CGRectMake(0, self.topBar.bottom, mainScreenWidth, 35)];
    self.discriptionView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self.view addSubview:self.discriptionView];
    
    self.discriptionLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, mainScreenWidth-30, 35)];
    self.discriptionLable.textAlignment = NSTextAlignmentLeft;
    self.discriptionLable.text = @"为了给您更好的订单追踪服务，请绑定手机号！";
    self.discriptionLable.textColor = [UIColor colorWithHexString:@"#919191"];
    self.discriptionLable.font = [UIFont fontWithName:FONT_REGULAR size:13];
    [self.discriptionView addSubview:self.discriptionLable];
    
    _phoneView = [[UIView alloc]initWithFrame:CGRectMake(0,self.discriptionView.bottom,mainScreenWidth,44)];
    _phoneView.backgroundColor = [UIColor whiteColor];
    _phoneView.layer.masksToBounds=YES;
    _phoneView.layer.cornerRadius =2.5;
    [self.view addSubview:_phoneView];
    
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.text = @"手机号";
    self.phoneLabel.font = [UIFont fontWithName:FONT_REGULAR size:16];
    _phoneLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    [self.phoneLabel sizeToFit];
    self.phoneLabel.center = CGPointMake(15+self.phoneLabel.width/2, self.phoneView.height/2);
    [self.phoneView addSubview:self.phoneLabel];
    
    _phoneInput = [[UITextField alloc]initWithFrame:CGRectMake(self.phoneLabel.right+30,15,mainScreenWidth-self.phoneLabel.right-30-15,18 )];
    [_phoneInput setLeftViewMode:UITextFieldViewModeAlways];
    //_userNameText.clearButtonMode = UITextFieldViewModeAlways;
    _phoneInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _phoneInput.font = [UIFont fontWithName:FONT_REGULAR size:15];
    _phoneInput.returnKeyType = UIReturnKeyDone;
    _phoneInput.keyboardType = UIKeyboardTypeNumberPad;
    _phoneInput.delegate = self;
    [_phoneInput addTarget:self action:@selector(usernameValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [_phoneInput setBorderStyle:UITextBorderStyleNone];
    _phoneInput.layer.borderWidth=0.0;
    _phoneInput.backgroundColor = [UIColor clearColor];
    _phoneInput.tintColor = [UIColor colorWithHexString:@"#434343"];
    _phoneInput.textColor = [UIColor colorWithHexString:@"#434343"];
    _phoneInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#919191"],NSFontAttributeName : [UIFont fontWithName:FONT_REGULAR size:15],}];
    [self.phoneView addSubview:_phoneInput];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.phoneView.bottom, mainScreenWidth, SINGLE_LINE_WIDTH)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self.view addSubview:lineView];
    
    _inspectionView = [[UIView alloc]initWithFrame:CGRectMake(0,self.phoneView.bottom,mainScreenWidth,44)];
    _inspectionView.backgroundColor = [UIColor whiteColor];
    _inspectionView.layer.masksToBounds=YES;
    [self.view addSubview:_inspectionView];
    
    self.inspectionLable = [[UILabel alloc]init];
    self.inspectionLable.text = @"验证码";
    self.inspectionLable.font = [UIFont fontWithName:FONT_REGULAR size:16];
    self.inspectionLable.textColor = [UIColor colorWithHexString:@"#434343"];
    [self.inspectionLable sizeToFit];
    self.inspectionLable.center = CGPointMake(15+self.inspectionLable.width/2, self.inspectionView.height/2);
    [self.inspectionView addSubview:self.inspectionLable];
    
    _inspectionInput = [[UITextField alloc]initWithFrame:CGRectMake(self.inspectionLable.right+30,15,120,18 )];
    [_inspectionInput setLeftViewMode:UITextFieldViewModeAlways];
    _inspectionInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _inspectionInput.returnKeyType = UIReturnKeyDone;
    _inspectionInput.keyboardType = UIKeyboardTypeNumberPad;
    _inspectionInput.delegate = self;
    [_inspectionInput addTarget:self action:@selector(usernameValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [_inspectionInput setBorderStyle:UITextBorderStyleNone];
    _inspectionInput.layer.borderWidth=0.0;
    _inspectionInput.backgroundColor = [UIColor clearColor];
    _inspectionInput.textColor = [UIColor colorWithHexString:@"#434343"];
    _inspectionInput.tintColor = [UIColor colorWithHexString:@"#434343"];
    _inspectionInput.font = [UIFont fontWithName:FONT_REGULAR size:15];
    _inspectionInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"4位短信验证码" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#919191"],NSFontAttributeName : [UIFont fontWithName:FONT_REGULAR size:15],}];
    [self.inspectionView addSubview:_inspectionInput];
    
    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(15, self.inspectionView.bottom+60, mainScreenWidth-30, 44)];
    self.nextButton.layer.cornerRadius = 3;
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self.view addSubview:self.nextButton];
    
    self.countDownLable = [[UILabel alloc]init];
    self.countDownLable.text = @"获取验证码";
    self.countDownLable.textAlignment = NSTextAlignmentRight;
    [self.countDownLable addTapGestureWithTarget:self action:@selector(getNumberClick)];
    self.countDownLable.font = [UIFont fontWithName:FONT_REGULAR size:15];
    self.countDownLable.textColor = [UIColor colorWithHexString:@"#017e44"];
    [self.inspectionView addSubview:self.countDownLable];
    
    self.separateline = [[UILabel alloc]init];
    self.separateline.text = @"|";
    self.separateline.textColor =[UIColor colorWithHexString:@"#e2e2e2"];
    [self.inspectionView addSubview:self.separateline];
    
    [self.countDownLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inspectionView).offset(-15);
        make.centerY.equalTo(self.inspectionView.mas_centerY);
    }];
    [self.separateline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countDownLable.mas_left).offset(-15);
        make.centerY.equalTo(self.inspectionView.mas_centerY);
    }];
    
}

-(void)nextButtonClick
{
    if(![self ISPhone:self.phoneInput.text])
    {
        if(self.phoneInput.text.length<1)
        {
            [MBProgressHUD showError:@"请输入手机号"];
        }else
        {
            [MBProgressHUD showError:@"请输入正确的手机号"];
        }
        return;
    }
    if(![self ISNumber:self.inspectionInput.text])
    {
        if(self.inspectionInput.text.length<1)
        {
            [MBProgressHUD showError:@"请输入验证码"];
        }else
        {
            [MBProgressHUD showError:@"请输入正确的验证码"];
        }
        return;
    }
    [self submitPhonetoServer];
}

-(void)submitPhonetoServer
{
    NSString *code = self.inspectionInput.text;
    NSString *phone = self.phoneInput.text;
    NSString *account = [_dataDict objectForKey:@"token"];
     NSInteger isNew = [[_dataDict objectForKey:@"isNew"]integerValue];
    NSDictionary *params = @{@"code":code,@"uuid":account,@"phone":phone,@"isNew":@(isNew)};
    [NetAccess getJSONDataWithUrl:kBindPhone  parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        
        NSInteger code = [responseObject[@"header"][@"code"]integerValue];
        if(code==0)
        {
            BOOL haveCode = [ [[responseObject objectForKey:@"date"]objectForKey:@"haveCode"] boolValue];
            //用户名可以使用
            NSString *token =[[responseObject objectForKey:@"date"]objectForKey:@"token"];
            TLAccount *account = [TLAccount accountWithUUID:token];
            [TLAccountSave saveAccountWithAccount:account];
            
            NSString *name=  [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"date"]objectForKey:@"huanXinKey"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = [[EMClient sharedClient] registerWithUsername:name password:@"0"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (!error) {
                        
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                    }
                    int code=[[NSString stringWithFormat:@"%u",error.code] intValue];
                    if (code==203) {
                        //                        EMError *error2 = [[EMClient sharedClient] loginWithUsername:name password:@"0"];
                        [[EMClient sharedClient]loginWithUsername:name password:@"0" completion:^(NSString *aUsername, EMError *aError) {
                            if (!aError) {
                                
                                NSLog(@"登陆成功");
                                EMPushOptions *emoptions = [[EMClient sharedClient] pushOptions];
                                //设置有消息过来时的显示方式:1.显示收到一条消息 2.显示具体消息内容.
                                //自己可以测试下
                                emoptions.displayStyle = EMPushDisplayStyleMessageSummary;
                                // [[EMClient sharedClient] updatePushOptionsToServer];
                            }
                        }];
                    }
                });
                
                
            });
            [[TLUploadSystemInfo shareIntens]uploadSystemBaseDatatoServer];
            [MBProgressHUD showSuccess:@"登录成功"];
            AppDelegate * app1 = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app1.lvc geticon:token];
            
            MJWeakSelf
            //haveCode= YES;
            [weakSelf.view endEditing:YES];
            if (haveCode) {
                codeVC *vc1 =[[codeVC alloc]init];
                vc1.myVC=weakSelf;
                [weakSelf.navigationController pushViewController:vc1 animated:YES];
                
            }else
            {
                [weakSelf  dismissViewControllerAnimated:YES completion:nil];
            }
            
        }else
        {
            NSString *message = responseObject[@"header"][@"message"];
            [MBProgressHUD showError:message];
        }
        
    } fail:^{
        
    }];
    
}

-(void)phoneNumberisReginst:(NSString *)phoneNumber
{
    NSString *USER = phoneNumber;
    NSDictionary *params = @{@"userName":USER};
    [NetAccess getJSONDataWithUrl:ksendEmail  parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject[@"date"]);
    } fail:^{
        [StaticTools showAlert:@"请求网络失败!"];
    }];
}


-(void)sendVerificationCode:(NSString *)phoneNumber
{
    NSString *USER = phoneNumber;
    NSString *account = [_dataDict objectForKey:@"token"];
      NSInteger isNew = [[_dataDict objectForKey:@"isNew"]integerValue];
    NSDictionary *params = @{@"phone":USER,@"uuid":account,@"isNew":@(isNew)};
    [NetAccess getJSONDataWithUrl:ksendBindPhone  parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        
        _isCountDown = YES;
        _countDownLable.textColor= [UIColor colorWithHexString:@"#919191"];
        _countDownLable.text = [NSString stringWithFormat:@"(%@s重新获取)",@(count)];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        NSLog(@"%@",responseObject[@"date"]);
        [MBProgressHUD showSuccess:@"发送验证码成功"];
    } fail:^{
        [StaticTools showAlert:@"请求网络失败!"];
    }];
}

-(void)onTimer
{
    count--;
    if (count==0)
    {
        [_timer invalidate];
        _timer = nil;
        _countDownLable.textColor = [UIColor colorWithHexString:@"#017e44"];
        _countDownLable.text = @"获取验证码";
        count = 60;
        _isCountDown = NO;
    }else
    {
        _countDownLable.text = [NSString stringWithFormat:@"(%@s重新获取)",@(count)];
    }
}
-(void)getNumberClick
{
    if(!_isCountDown)
    {
        if([self ISPhone:self.phoneInput.text])
        {
            [self sendVerificationCode:self.phoneInput.text];
        }else
        {
            [MBProgressHUD showError:@"请输入正确的手机号"];
        }
    }
}

-(void)usernameValueChanged:(UITextField*)textfield
{
    if(textfield == self.inspectionInput)
    {
        
    }else
    {
        
    }
    if(self.inspectionInput.text.length<1&&self.phoneInput.text.length<1)
    {
        [self nextButtonChangeColor:NO];
        
    }else
    {
        [self nextButtonChangeColor:YES];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.phoneInput)
    {
        
        if(![self ISNumber:self.inspectionInput.text]&&self.inspectionInput.text.length!=0)
        {
            [MBProgressHUD showError:@"请输入正确的验证码"];
        }
        
    }else
    {
        if(![self ISPhone:self.phoneInput.text]&&self.phoneInput.text.length!=0)
        {
            [MBProgressHUD showError:@"请输入正确的手机号"];
        }
    }
    
    
}


-(void)nextButtonChangeColor:(BOOL)isAccord
{
    self.nextButton.enabled = isAccord;
    if(isAccord)
    { [self.nextButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#017e44"];
        
    }else
    {
        [self.nextButton setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    }
}

-(void)backButtonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)ISNumber:(NSString *)Str
{
    NSString *regex =  @"[0-9]{4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:Str];
    return isMatch;
}
- (BOOL)ISPhone:(NSString *)Str
{
    NSString *regex =  @"[1][0-9]{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:Str];
    return isMatch;
}
@end
