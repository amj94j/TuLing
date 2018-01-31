//
//  quictLoginVC.m
//  TuLingApp
//
//  Created by MacBook on 2017/1/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "quictLoginVC.h"
#import "APRoundedButton.h"
#import "MainSliderViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
#import "chatViewController.h"

#import "codeVC.h"
#define backGroundAlpha 0.4f
@interface quictLoginVC ()<UITextFieldDelegate>
{
    UIButton *backBtn;
    UILabel *titleLab;
    UIButton *loginBtn;
    APRoundedButton *sendEmailBtn;
    
    NSTimer *_timer;
    int count;
    
    BOOL _isVerifyImageRequesting;
}

@property(nonatomic,strong)UITextField *userNameText;
@property(nonatomic,strong)UITextField *passWordText;

@property (nonatomic,strong) UIButton * verifyCodeButton;
@property (nonatomic,strong) UIImageView * verifyCodeImageView;
@property (nonatomic,strong) UITextField *verifyCodeTextField;

@property(nonatomic,strong)UIView *userNameView;
@property(nonatomic,strong)UIView *passWordView;

@end

@implementation quictLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
     count=60;
    self.navigationItem.hidesBackButton =YES;
    [self myBackGround];
    backBtn = [LXTControl createButtonWithFrame:CGRectMake(15, 32, 22, 22) ImageName:@"back2" Target:self Action:@selector(ButtonClick) Title:@""];
    [self.view addSubview:backBtn];
    
    titleLab = [LXTControl createLabelWithFrame:CGRectMake(WIDTH/2-50, 32, 100, 20) Font:22 Text:@"快捷登录"];
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
    //手机号
    _userNameView = [[UIView alloc]initWithFrame:CGRectMake(15, 161*HEIGHT/667, WIDTH-30, 40)];
    _userNameView.backgroundColor = RGBCOLOR(185, 185, 185);
    _userNameView.layer.masksToBounds=YES;
    _userNameView.layer.cornerRadius =2.5;
    _userNameView.alpha=backGroundAlpha;
    [self.view addSubview:_userNameView];

    UIImageView *userImage = [LXTControl createImageViewWithFrame:CGRectMake(10+_userNameView.frame.origin.x, 10+_userNameView.frame.origin.y, 15, 20) ImageName:@"login1"];
    [self.view addSubview:userImage];
    
    _userNameText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImage.frame)+15, 10+_userNameView.frame.origin.y, _userNameView.frame.size.width-userImage.frame.size.width-40, 20)];
    [_userNameText setLeftViewMode:UITextFieldViewModeAlways];
    //_userNameText.clearButtonMode = UITextFieldViewModeAlways;
    _userNameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userNameText.returnKeyType = UIReturnKeyDone;
    _userNameText.keyboardType = UIKeyboardTypeNumberPad;
    _userNameText.delegate = self;
    [_userNameText addTarget:self action:@selector(usernameValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [_userNameText setBorderStyle:UITextBorderStyleNone];
    _userNameText.layer.borderWidth=0.0;
    _userNameText.backgroundColor = [UIColor clearColor];
    _userNameText.tintColor = [UIColor blackColor];
    _userNameText.tag=1;
    _userNameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"434343"],NSFontAttributeName : [UIFont systemFontOfSize:16.0],}];
    [self.view addSubview:_userNameText];
   
    
    
    //短信校验
    _userNameView = [[UIView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(_userNameView.frame) +25*HEIGHT/667, WIDTH-135, 40)];
    _userNameView.backgroundColor = RGBCOLOR(185, 185, 185);
    _userNameView.layer.masksToBounds=YES;
    _userNameView.layer.cornerRadius =2.5;
    _userNameView.alpha=backGroundAlpha;
    [self.view addSubview:_userNameView];
//
    UIImageView *codeImage = [LXTControl createImageViewWithFrame:CGRectMake(10+_userNameView.frame.origin.x, 11.25+_userNameView.frame.origin.y, 14.5, 17.5) ImageName:@"quict5"];
    [self.view addSubview:codeImage];


    _verifyCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(codeImage.frame) + 15, 10+_userNameView.frame.origin.y, _userNameView.frame.size.width-codeImage.frame.size.width-40, 20)];
    [_verifyCodeTextField setLeftViewMode:UITextFieldViewModeAlways];
    //_userNameText.clearButtonMode = UITextFieldViewModeAlways;
    _verifyCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _verifyCodeTextField.returnKeyType = UIReturnKeyDone;
    _verifyCodeTextField.keyboardType = UIKeyboardTypeDefault;
    _verifyCodeTextField.delegate = self;
    [_verifyCodeTextField addTarget:self action:@selector(usernameValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [_verifyCodeTextField setBorderStyle:UITextBorderStyleNone];
    _verifyCodeTextField.layer.borderWidth=0.0;
    _verifyCodeTextField.backgroundColor = [UIColor clearColor];
    _verifyCodeTextField.tintColor = [UIColor blackColor];
    _verifyCodeTextField.tag=3;
    _verifyCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"434343"],NSFontAttributeName : [UIFont systemFontOfSize:16.0],}];
  
    [self.view addSubview:_verifyCodeTextField];

    _verifyCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userNameView.frame) + 15, _userNameView.frame.origin.y, 90, 40)];
    _verifyCodeImageView.userInteractionEnabled = YES;
    [self.view addSubview:_verifyCodeImageView];
    _isVerifyImageRequesting = NO;
    [self verifyCodeRequest:nil];

    _verifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyCodeButton.frame = _verifyCodeImageView.bounds;
    [_verifyCodeImageView addSubview:_verifyCodeButton];
    [_verifyCodeButton addTarget:self action:@selector(verifyCodeRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //短信验证码
    _passWordView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_userNameView.frame)+25*HEIGHT/667, WIDTH-30, 40)];
    _passWordView.backgroundColor = RGBCOLOR(185, 185, 185);
    _passWordView.layer.masksToBounds=YES;
    _passWordView.layer.cornerRadius =2.5;
    _passWordView.alpha=backGroundAlpha;
    [self.view addSubview:_passWordView];
    
    UIImageView *passImage = [LXTControl createImageViewWithFrame:CGRectMake(10+_passWordView.frame.origin.x, 11.25+_passWordView.frame.origin.y, 14.5, 17.5) ImageName:@"quict5"];
    [self.view addSubview:passImage];
    
    _passWordText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImage.frame)+15, 10+_passWordView.frame.origin.y, _passWordView.frame.size.width-userImage.frame.size.width-25-80*WIDTH/375, 20)];
    [_passWordText setLeftViewMode:UITextFieldViewModeAlways];
    //_passWordText.clearButtonMode = UITextFieldViewModeAlways;
    _passWordText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passWordText.returnKeyType = UIReturnKeyDone;
    _passWordText.keyboardType = UIKeyboardTypeNumberPad;
    _passWordText.delegate = self;
    [_passWordText addTarget:self action:@selector(passWordValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [_passWordText setBorderStyle:UITextBorderStyleNone];
    _passWordText.layer.borderWidth=0.0;
    _passWordText.backgroundColor = [UIColor clearColor];
    _passWordText.tintColor = [UIColor blackColor];
    _passWordText.tag=2;
    _passWordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"434343"],NSFontAttributeName : [UIFont systemFontOfSize:16.0],}];
    [self.view addSubview:_passWordText];
    
    sendEmailBtn =[[APRoundedButton alloc]init];
    sendEmailBtn.frame =CGRectMake(_passWordView.frame.size.width-80*WIDTH/375+15, 0+_passWordView.frame.origin.y, 80*WIDTH/375, 40);
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

    
    loginBtn = [LXTControl createButtonWithFrame:CGRectMake(15, HEIGHT-232*HEIGHT/667-40, WIDTH-30, 40) ImageName:@"" Target:self Action:@selector(loginbutton:)Title:@"快捷登录"];
    loginBtn.layer.masksToBounds=YES;
    loginBtn.layer.cornerRadius=2.5;
    loginBtn.backgroundColor = RGBCOLOR(1, 126, 68);
    loginBtn.alpha=0.9;
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    loginBtn.tag=10000;
    [self.view addSubview:loginBtn];

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

#pragma mark--登录点击
-(void)loginbutton:(UIButton *)sender
{
    UITextField *textfie =(UITextField *)[self.view viewWithTag:1];
    UITextField *textfie1 =(UITextField *)[self.view viewWithTag:2];
    if (textfie.text.length!=0&&textfie1.text.length!=0) {
        [self quitCommitRequest];
    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField代理及自定义方法
// 点击
- (void)usernameValueChanged:(UITextField *)sender {
    if (sender.text.length==0||sender.text==nil) {
        
        
        
    }else
    {
        
    }
    
}
// 点击
- (void)passWordValueChanged:(UITextField *)sender {
    if (sender.text.length==0||sender.text==nil) {
        
        
        
    }else
    {
        
    }
    
}

// 点击return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
        if (textField==self.userNameText) {
            [self.userNameText resignFirstResponder];
        }else if (textField == self.passWordText)
        {
            [self.passWordText resignFirstResponder];
        }else if (textField == self.verifyCodeTextField){
            [self.verifyCodeTextField resignFirstResponder];
        }
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
}
#pragma mark--发送验证码点击事件
-(void)sendEmailbutton:(UIButton *)sender
{
    UITextField *textfie =(UITextField *)[self.view viewWithTag:1];
    //[self requestCheckUser];
    if (textfie.text.length==11) {
        //用户名可以使用
        UITextField *textfie3 =(UITextField *)[self.view viewWithTag:3];
        if(textfie3.text.length == 4){
            [self sendEmail];
        }else{
            [StaticTools showAlert:@"请输入验证码"];
        }
        
    }else
    {
        [StaticTools showAlert:@"请输入正确手机号"];
    }
    
}
#pragma mark--检查用户名
-(void)requestCheckUser
{
    __weak __typeof(self)weakSelf = self;
    UITextField *textfie =(UITextField *)[self.view viewWithTag:1];
    NSString *USER =textfie.text;
    NSDictionary *params = @{@"userName":USER};
    [NetAccess getJSONDataWithUrl:kcheckUser parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        NSMutableDictionary *dic1;
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
    //友盟统计
    [MobClick event:@"99"];
    sendEmailBtn.enabled = NO;
    //__weak __typeof(self)weakSelf = self;
    UITextField *textfie =(UITextField *)[self.view viewWithTag:1];
    NSString *USER =textfie.text;
    UITextField *textfie3 =(UITextField *)[self.view viewWithTag:3];
    NSDictionary *params = nil;
    NSString * uuidString = [StaticTools deviceID];
    if([NSString isBlankString:uuidString]){
        params = @{@"userName":USER,@"userCode":textfie3.text,@"appSign":uuidString};
    }else{
        params = @{@"userName":USER,@"userCode":textfie3.text};
    }
    [NetAccess getJSONHeaderWithUrl:kquickSendEmail parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        NSMutableDictionary *dic1 ;
        dic1 = [responseObject objectForKey:@"header"];
        NSString *code = [NSString stringWithFormat:@"%@",dic1[@"code"]];
        if ([code isEqualToString:@"0"]) {
            //用户名可以使用
            [MBProgressHUD showSuccess:@"发送成功"];
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

#pragma mark--快捷登录
-(void)quitCommitRequest
{
    __weak __typeof(self)weakSelf = self;
    UITextField *textfie =(UITextField *)[self.view viewWithTag:1];
    UITextField *textfie1 =(UITextField *)[self.view viewWithTag:2];
    NSString *USER =textfie.text;
    NSDictionary *params = @{@"userName":USER,@"sms":textfie1.text};
    [NetAccess getJSONDataWithUrl:kquickLogin  parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        NSMutableDictionary *dic1 ;
        dic1 = [responseObject objectForKey:@"header"];
        NSString *code = [NSString stringWithFormat:@"%@",dic1[@"code"]];
        if ([code isEqualToString:@"0"]) {
            [self.userNameText resignFirstResponder];
            [self.passWordText resignFirstResponder];
            //用户名可以使用
            [MBProgressHUD showSuccess:@"登录成功"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"date"]objectForKey:@"userName"]] forKey:@"phone"];
            NSString *token =[[responseObject objectForKey:@"date"]objectForKey:@"token"];
            TLAccount *account = [TLAccount accountWithUUID:token];
            [TLAccountSave saveAccountWithAccount:account];
            

            NSString *name=  [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"date"]objectForKey:@"userName"]];
            
            
            //友盟统计
            [MobClick event:@"102"];
            
            //环信

//            EMOptions *options = [EMOptions optionsWithAppkey:@"13911416463#touring"];
//            [[EMClient sharedClient] initializeSDKWithOptions:options];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = [[EMClient sharedClient] registerWithUsername:name password:@"0"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (!error) {
                        
                        [[EMClient sharedClient].options setIsAutoLogin:YES];
                    }
                    int code=[[NSString stringWithFormat:@"%u",error.code] intValue];
                    if (code==203) {

//                        EMError *error2 = [[EMClient sharedClient] loginWithUsername:name password:@"0"];
                        [[EMClient sharedClient] loginWithUsername:name password:@"0" completion:^(NSString *aUsername, EMError *aError) {
                            if (!aError) {
                                
                                EMPushOptions *emoptions = [[EMClient sharedClient] pushOptions];
                                //设置有消息过来时的显示方式:1.显示收到一条消息 2.显示具体消息内容.
                                //自己可以测试下
                                emoptions.displayStyle = EMPushDisplayStyleMessageSummary;
                                
                            }
                        }];
                    }
                });
                
            });
            AppDelegate * app1 = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app1.lvc geticon:token];
            
            BOOL haveCode = [ [[responseObject objectForKey:@"date"]objectForKey:@"haveCode"] boolValue];
           // haveCode=YES;
            if (haveCode) {
                codeVC *vc1 =[[codeVC alloc]init];
                vc1.myVC=weakSelf;
                [weakSelf.navigationController pushViewController:vc1 animated:YES];
                return ;
                
            }else
            {
                
                [weakSelf  dismissViewControllerAnimated:YES completion:^{
                    
                    
                }];
                
            }
            
            
//            MainSliderViewController * mvc = [[MainSliderViewController alloc] init];
//            BaseNavigationController * nvc = [[BaseNavigationController alloc] initWithRootViewController:mvc];
//            [UIApplication sharedApplication].keyWindow.rootViewController =nvc;
            

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
