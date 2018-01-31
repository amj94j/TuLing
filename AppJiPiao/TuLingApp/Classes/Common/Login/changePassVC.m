//
//  changePassVC.m
//  TuLingApp
//
//  Created by MacBook on 2017/1/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "changePassVC.h"
#import "APRoundedButton.h"
#define backGroundAlpha 0.4f
@interface changePassVC ()<UITextFieldDelegate>
{
    UIButton *backBtn;
    UILabel *titleLab;
    UIButton *loginBtn;
    UIButton *registBtn;
    APRoundedButton *sendEmailBtn;
    UIButton *forgetBtn;
    NSTimer *_timer;
    int count;
    
    BOOL _isVerifyImageRequesting;
}
@property(nonatomic,strong)UITextField *userNameText;
@property(nonatomic,strong)UITextField *emailText;
@property(nonatomic,strong)UITextField *secondPassText;
@property(nonatomic,strong)UIView *userNameView;
@property(nonatomic,strong)UIView *emailView;
@property(nonatomic,strong)UIView *secondWordView;

@property (nonatomic,strong) UIButton * verifyCodeButton;
@property (nonatomic,strong) UIImageView * verifyCodeImageView;
@property (nonatomic,strong) UITextField *verifyCodeTextField;
@end

@implementation changePassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    count=60;
    self.navigationItem.hidesBackButton =YES;
    [self myBackGround];
    backBtn = [LXTControl createButtonWithFrame:CGRectMake(15, 32, 22, 22) ImageName:@"back2" Target:self Action:@selector(ButtonClick) Title:@""];
    [self.view addSubview:backBtn];
    
    titleLab = [LXTControl createLabelWithFrame:CGRectMake(WIDTH/2-50, 32, 100, 20) Font:22 Text:@"忘记密码"];
    titleLab.textColor =[UIColor colorWithHexString:@"#434343"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    [self loginContentView];

}
- (void)ButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)myBackGround
{
    
    UIImageView *ima = [LXTControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) ImageName:@"loginNew1"];
    
    [self.view addSubview:ima];
}
-(void)loginContentView
{
    NSArray *name = @[@"手机号码",@"设置密码",@"确认密码"];
    NSArray *passStr = @[@"请输入手机号码",@"请输入6-15位密码",@"请输入6-15位密码"];
    
    for (int i=0; i<3; i++) {
        if (i==2||i==1) {
             _userNameView = [[UIView alloc]initWithFrame:CGRectMake(15, 88*HEIGHT/667+(i+2)*(40+25*HEIGHT/667), WIDTH-30, 40)];
        }else
        {
            _userNameView = [[UIView alloc]initWithFrame:CGRectMake(15, 88*HEIGHT/667+i*(40+25*HEIGHT/667), WIDTH-30, 40)];
        }

        _userNameView.backgroundColor = RGBCOLOR(185, 185, 185);
        _userNameView.layer.masksToBounds=YES;
        _userNameView.layer.cornerRadius =2.5;
        _userNameView.alpha=backGroundAlpha;
        _userNameView.tag=20+i;
        [self.view addSubview:_userNameView];
        
        UILabel *typeLab = [LXTControl createLabelWithFrame:CGRectMake(10+_userNameView.frame.origin.x, 10+_userNameView.frame.origin.y, 93, 20) Font:15 Text:name[i]];
        typeLab.textColor = [UIColor colorWithHexString:@"#434343"];
        [self.view addSubview:typeLab];
        
        _userNameText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(typeLab.frame), 10+_userNameView.frame.origin.y, _userNameView.frame.size.width-typeLab.frame.size.width-10, 20)];
        [_userNameText setLeftViewMode:UITextFieldViewModeAlways];
        //_userNameText.clearButtonMode = UITextFieldViewModeAlways;
        _userNameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _userNameText.returnKeyType = UIReturnKeyDone;
        if (i==0) {
            _userNameText.keyboardType = UIKeyboardTypeNumberPad;
        }else
        {
            _userNameText.keyboardType = UIKeyboardTypeDefault;
            _userNameText.secureTextEntry = YES;
        }
        
        _userNameText.delegate = self;
        [_userNameText addTarget:self action:@selector(usernameValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [_userNameText setBorderStyle:UITextBorderStyleNone];
        _userNameText.layer.borderWidth=0.0;
        _userNameText.backgroundColor = [UIColor clearColor];
        _userNameText.tintColor = [UIColor blackColor];
        _userNameText.tag=500+i;
        _userNameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:passStr[i] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#919191"],NSFontAttributeName : [UIFont systemFontOfSize:16.0],}];
        [self.view addSubview:_userNameText];

    }
    
    loginBtn = [LXTControl createButtonWithFrame:CGRectMake(15, HEIGHT-207*HEIGHT/667, WIDTH-30, 40) ImageName:@"" Target:self Action:@selector(loginbutton:)Title:@"确认修改"];
    loginBtn.layer.masksToBounds=YES;
    loginBtn.layer.cornerRadius=2.5;
    loginBtn.backgroundColor = RGBCOLOR(1, 126, 68);
    loginBtn.alpha=0.9;
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    loginBtn.tag=10000;
    [self.view addSubview:loginBtn];
    
    
    //短信验证码校验
    _userNameView = [[UIView alloc]initWithFrame:CGRectMake(15,88*HEIGHT/667+40+25*HEIGHT/667, WIDTH-135, 40)];
    _userNameView.backgroundColor = RGBCOLOR(185, 185, 185);
    _userNameView.layer.masksToBounds=YES;
    _userNameView.layer.cornerRadius =2.5;
    _userNameView.alpha=backGroundAlpha;
    _userNameView.tag=23;
    [self.view addSubview:_userNameView];
    
    UILabel *typeLab = [LXTControl createLabelWithFrame:CGRectMake(10+_userNameView.frame.origin.x, 10+_userNameView.frame.origin.y, 105, 20) Font:15 Text:@"请输入验证码"];
    typeLab.textColor = [UIColor colorWithHexString:@"#434343"];
    [self.view addSubview:typeLab];
    
    _userNameText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(typeLab.frame), 10+_userNameView.frame.origin.y, _userNameView.frame.size.width-typeLab.frame.size.width-10, 20)];
    [_userNameText setLeftViewMode:UITextFieldViewModeAlways];
    //_userNameText.clearButtonMode = UITextFieldViewModeAlways;
    _userNameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userNameText.returnKeyType = UIReturnKeyDone;
    _userNameText.keyboardType = UIKeyboardTypeDefault;
    _userNameText.delegate = self;
    [_userNameText addTarget:self action:@selector(usernameValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [_userNameText setBorderStyle:UITextBorderStyleNone];
    _userNameText.layer.borderWidth=0.0;
    _userNameText.backgroundColor = [UIColor clearColor];
    _userNameText.tintColor = [UIColor blackColor];
    _userNameText.tag=503;
    _userNameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#919191"],NSFontAttributeName : [UIFont systemFontOfSize:16.0],}];
    [self.view addSubview:_userNameText];
    
    
    _verifyCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userNameView.frame) + 15, _userNameView.frame.origin.y, 90, 40)];
    _verifyCodeImageView.userInteractionEnabled = YES;
    [self.view addSubview:_verifyCodeImageView];
    _isVerifyImageRequesting = NO;
    [self verifyCodeRequest:nil];
    
    _verifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyCodeButton.frame = _verifyCodeImageView.bounds;
    [_verifyCodeImageView addSubview:_verifyCodeButton];
    [_verifyCodeButton addTarget:self action:@selector(verifyCodeRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    _emailView = [[UIView alloc]initWithFrame:CGRectMake(15,88*HEIGHT/667+(40+25*HEIGHT/667)*2, WIDTH-30, 40)];
    _emailView.backgroundColor = RGBCOLOR(185, 185, 185);
    _emailView.layer.masksToBounds=YES;
    _emailView.layer.cornerRadius =2.5;
    _emailView.alpha=backGroundAlpha;
    [self.view addSubview:_emailView];
    
    UILabel *typeLab2 = [LXTControl createLabelWithFrame:CGRectMake(10+_emailView.frame.origin.x, 10+_emailView.frame.origin.y, 93, 20) Font:15 Text:@"短信验证码"];
    typeLab2.textColor = [UIColor colorWithHexString:@"#434343"];
    [self.view addSubview:typeLab2];
    
    
    _emailText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(typeLab2.frame), 10+_emailView.frame.origin.y, _emailView.frame.size.width-typeLab2.frame.size.width-10-80*WIDTH/375, 20)];
    [_emailText setLeftViewMode:UITextFieldViewModeAlways];
    //_userNameText.clearButtonMode = UITextFieldViewModeAlways;
    _emailText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _emailText.returnKeyType = UIReturnKeyDone;
    _emailText.keyboardType = UIKeyboardTypeNumberPad;
    _emailText.delegate = self;
    [_emailText addTarget:self action:@selector(emailValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [_emailText setBorderStyle:UITextBorderStyleNone];
    _emailText.layer.borderWidth=0.0;
    _emailText.backgroundColor = [UIColor clearColor];
    _emailText.tintColor = [UIColor blackColor];
    _emailText.tag=1000;
    _emailText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#919191"],NSFontAttributeName : [UIFont systemFontOfSize:16.0],}];
    [self.view addSubview:_emailText];
    
    
    
    
    sendEmailBtn =[[APRoundedButton alloc]init];
    sendEmailBtn.frame =CGRectMake(_emailView.frame.size.width-80*WIDTH/375+15, _emailView.frame.origin.y, 80*WIDTH/375, 40);
    [sendEmailBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [sendEmailBtn addTarget:self action:@selector(sendEmailbutton:) forControlEvents:UIControlEventTouchUpInside];
    sendEmailBtn.adjustsImageWhenHighlighted=NO;
    sendEmailBtn.style = 7;
    sendEmailBtn.backgroundColor =RGBCOLOR(1, 126, 68);
    sendEmailBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [sendEmailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendEmailBtn.tag=1001;
    [self.view addSubview:sendEmailBtn];
    [sendEmailBtn awakeFromNib];

    
}

#pragma mark ------- 获取校验验证码
-(void)verifyCodeRequest:(UIButton*)sender{
    
    if (_isVerifyImageRequesting){
        return;
    }
    _isVerifyImageRequesting = YES;
    NSString * urlString = nil;
    NSString * uuidString = [StaticTools deviceID];
    if([NSString isBlankString:uuidString]){
        NSTimeInterval timeNum = [NSDate timeIntervalSinceReferenceDate];
        urlString = [NSString stringWithFormat:@"%@?appSign=%@&random=%f",kVerifyCodeImageURL,uuidString,timeNum];
    }else{
        urlString = kVerifyCodeImageURL;
    }
    
    [_verifyCodeImageView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        _isVerifyImageRequesting = NO;
    }];
}

#pragma mark--发送验证码点击事件
-(void)sendEmailbutton:(UIButton *)sender
{
    UITextField *textfie =(UITextField *)[self.view viewWithTag:500];
    if (textfie.text.length==11) {
       
        UITextField *textfie3 =(UITextField *)[self.view viewWithTag:503];
        if (textfie3.text.length == 4){
            [self sendEmail];
        }else{
            [MBProgressHUD showError:@"请输入验证码"];
        }
    }else
    {
        [MBProgressHUD showError:@"请输入正确的手机号"];
    
    }
    
}
#pragma mark--修改点击
-(void)loginbutton:(UIButton *)sender
{
    UITextField *textfie =(UITextField *)[self.view viewWithTag:500];
    UITextField *textfie1 =(UITextField *)[self.view viewWithTag:501];
    UITextField *textfie2 =(UITextField *)[self.view viewWithTag:502];
    UITextField *textfie3 =(UITextField *)[self.view viewWithTag:1000];
    
    if (textfie3.text.length!=0&&textfie2.text.length!=0&&textfie1.text.length!=0&&textfie.text.length!=0) {
        
        if ([textfie1.text isEqualToString:textfie2.text]) {
            if (textfie2.text.length>=6&&textfie2.text.length<=15) {
                [self checkEmail];
            }else{
                [MBProgressHUD showError:@"请输入6-9位密码"];
                
            }
        }else{
            [MBProgressHUD showError:@"两次输入不一致"];
        }
    }else{
        [MBProgressHUD showError:@"请按要求填写"];
    }
}
#pragma mark - UITextField代理及自定义方法
// 点击
- (void)usernameValueChanged:(UITextField *)sender {
    if (sender.text.length==0||sender.text==nil) {
        
        
        
    }else
    {
        if (sender.tag==501||sender.tag==502) {
            if ([regular checkPassword1:sender.text]) {
                
            }else
            {
                
                sender.text = [sender.text substringToIndex:sender.text.length-1];
            }

        }
        
        
    }
    
}
//验证码输入框
- (void)emailValueChanged:(UITextField *)sender {
    if (sender.text.length==0||sender.text==nil) {
        
        
        
    }else
    {
        
    }
    
}

// 点击return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
        if (textField==self.userNameText) {
            [self.userNameText resignFirstResponder];
            //[self.passWordText becomeFirstResponder];
        }else
        {
            [textField resignFirstResponder];
        }
        
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--检查用户名
-(void)requestCheckUser
{
    __weak __typeof(self)weakSelf = self;
    UITextField *textfie =(UITextField *)[self.view viewWithTag:500];
    NSString *USER =textfie.text;
    NSDictionary *params = @{@"userName":USER};
    [NetAccess getJSONDataWithUrl:kcheckUser parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        NSMutableDictionary *dic1 ;
        dic1 = [responseObject objectForKey:@"header"];
        NSString *code = [NSString stringWithFormat:@"%@",dic1[@"code"]];
        if ([code isEqualToString:@"0"]) {
            //用户名可以使用
            [weakSelf sendEmail];
            
            
        }else
        {
            //用户名存在或者不对
            NSString *message = dic1[@"message"];
            //[MBProgressHUD showError:message];
            [StaticTools showAlert:message];
        }
        
    } fail:^{
        [StaticTools showAlert:@"请求网络失败!"];
        
    }];
    
    
    
    
    
}

#pragma mark--发送验证码
-(void)sendEmail
{
    //用户名可以使用
    sendEmailBtn.enabled = NO;
    //__weak __typeof(self)weakSelf = self;
    UITextField *textfie =(UITextField *)[self.view viewWithTag:500];
   UITextField *textfie3 =(UITextField *)[self.view viewWithTag:503];
    NSString *USER =textfie.text;
    NSDictionary *params = nil;
    NSString * uuidString = [StaticTools deviceID];
    if([NSString isBlankString:uuidString]){
        params = @{@"userName":USER,@"userCode":textfie3.text,@"appSign":uuidString};
    }else{
        params = @{@"userName":USER,@"userCode":textfie3.text};
    }
    [NetAccess getJSONHeaderWithUrl:ksendEmail parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        NSMutableDictionary *dic1 ;
        dic1 = [responseObject objectForKey:@"header"];
        NSString *code = [NSString stringWithFormat:@"%@",dic1[@"code"]];
        if ([code isEqualToString:@"0"]) {
            //用户名可以使用
            sendEmailBtn.enabled = NO;

            [sendEmailBtn setTitle:@"60(s)" forState:UIControlStateNormal];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            
        }else
        {
            //用户名存在或者不对
            NSString *message = dic1[@"message"];
            //[MBProgressHUD showError:message];
            sendEmailBtn.enabled = YES;
            [StaticTools showAlert:message];
        }
        
    } fail:^{
        sendEmailBtn.enabled = YES;
        [StaticTools showAlert:@"请求网络失败!"];
        
    }];
    
}

#pragma mark--验证验证码
-(void)checkEmail
{
    __weak __typeof(self)weakSelf = self;
    UITextField *textfie =(UITextField *)[self.view viewWithTag:500];
    
    UITextField *textfie2 =(UITextField *)[self.view viewWithTag:1000];
    NSString *USER =textfie.text;
    NSDictionary *params = @{@"userName":USER,@"sms":textfie2.text};
    [NetAccess getJSONDataWithUrl:kcheckEmail  parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        NSMutableDictionary *dic1 ;
        dic1 = [responseObject objectForKey:@"header"];
        NSString *code = [NSString stringWithFormat:@"%@",dic1[@"code"]];
        if ([code isEqualToString:@"0"]) {
            //用户名可以使用
            [weakSelf commitRequest];
        }else
        {
            //用户名存在或者不对
            NSString *message = dic1[@"message"];
            //[MBProgressHUD showError:message];
            [StaticTools showAlert:message];
        }
        
    } fail:^{
        [StaticTools showAlert:@"请求网络失败!"];
        
    }];
    
}

#pragma mark--修改密码
-(void)commitRequest
{
   // __weak __typeof(self)weakSelf = self;
    UITextField *textfie =(UITextField *)[self.view viewWithTag:500];
    UITextField *textfie1 =(UITextField *)[self.view viewWithTag:501];
    UITextField *textfie2 =(UITextField *)[self.view viewWithTag:1000];
    NSString *USER =textfie.text;
    NSDictionary *params = @{@"userName":USER,@"passWord":textfie1.text,@"sms":textfie2.text};
    [NetAccess getJSONDataWithUrl:kchangePass  parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        NSMutableDictionary *dic1 ;
        dic1 = [responseObject objectForKey:@"header"];
        NSString *code = [NSString stringWithFormat:@"%@",dic1[@"code"]];
        if ([code isEqualToString:@"0"]) {
            //用户名可以使用
            [MBProgressHUD showSuccess:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //用户名存在或者不对
            NSString *message = dic1[@"message"];
            //[MBProgressHUD showError:message];
            [StaticTools showAlert:message];
        }
        
    }fail:^{
        [StaticTools showAlert:@"请求网络失败!"];
        
    }];
    
}
-(void)onTimer
{
    count--;
    [sendEmailBtn setTitle:[NSString stringWithFormat:@"%d(s)",count] forState:UIControlStateNormal];
    if (count==0)
    {
        [_timer invalidate];
        _timer = nil;
//        sendEmailBtn.backgroundColor = [UIColor colorWithRed:109/255.0 green:219/255.0 blue:233/255.0 alpha:1];
        [sendEmailBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        count = 60;
        sendEmailBtn.enabled = YES;
    }
}

@end
