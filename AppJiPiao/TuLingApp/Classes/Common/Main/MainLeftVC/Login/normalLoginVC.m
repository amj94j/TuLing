//
//  normalLoginVC.m
//  TuLingApp
//
//  Created by hua on 17/1/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "normalLoginVC.h"
#import "registVC.h"
#import "quictLoginVC.h"
#import "changePassVC.h"
#import "regular.h"
#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>
#import "codeVC.h"
@interface normalLoginVC ()<UITextFieldDelegate>
{
    UIButton *backBtn;
    UILabel *titleLab;
    UIButton *loginBtn;
    UIButton *registBtn;
    UIButton *quictBtn;
    UIButton *forgetBtn;
    UIButton *newRegistBtn;
}
@property(nonatomic,strong)UITextField *userNameText;
@property(nonatomic,strong)UITextField *passWordText;
@property(nonatomic,strong)UIView *userNameView;
@property(nonatomic,strong)UIView *passWordView;

@end

@implementation normalLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton =YES;
    //returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    [self myBackGround];
    backBtn = [LXTControl createButtonWithFrame:CGRectMake(15, 32, 22, 22) ImageName:@"back2" Target:self Action:@selector(ButtonClick) Title:@""];
    [self.view addSubview:backBtn];
    
    
    newRegistBtn = [LXTControl createButtonWithFrame:CGRectMake(WIDTH-15-40, 32, 40, 22) ImageName:@"" Target:self Action:@selector(registbutton:)Title:@"注册"];
    
    newRegistBtn.backgroundColor = [UIColor clearColor];
    newRegistBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [newRegistBtn setTitleColor:[UIColor colorWithHexString:@"#6A6A6A"] forState:UIControlStateNormal];
    newRegistBtn.tag=501;
    [self.view addSubview:newRegistBtn];
    
    
    titleLab = [LXTControl createLabelWithFrame:CGRectMake(WIDTH/2-25, 32, 50, 20) Font:22 Text:@"登录"];
    titleLab.textColor =[UIColor colorWithHexString:@"#434343"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    [self loginContentView];
    //    //监听键盘是否呼出
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upViews:) name:UIKeyboardWillShowNotification object:nil];
    //
    //    //添加手势
    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    //    [self.view addGestureRecognizer:tap];
    
}

#pragma mark - 键盘弹出时界面上移及还原
-(void)upViews:(NSNotification *) notification{
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyBoardHeight = keyboardRect.size.height;
    
    //使视图上移
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = -keyBoardHeight;
    self.view.frame = viewFrame;
    
}
-(void)tapAction {
    
    if (UIKeyboardDidShowNotification)
    {
        [self.userNameText resignFirstResponder];
        [self.passWordText resignFirstResponder];
        
        //使视图还原
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = 0;
        self.view.frame = viewFrame;
    }
}
- (void)ButtonClick
{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    _userNameView = [[UIView alloc]initWithFrame:CGRectMake(15, 174*HEIGHT/667, WIDTH-30, 40)];
    _userNameView.backgroundColor = RGBCOLOR(185, 185, 185);
    _userNameView.layer.masksToBounds=YES;
    _userNameView.layer.cornerRadius =2.5;
    _userNameView.alpha=0.4;
    [self.view addSubview:_userNameView];
    
    _passWordView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_userNameView.frame)+25*HEIGHT/667, WIDTH-30, 40)];
    _passWordView.backgroundColor = RGBCOLOR(185, 185, 185);
    _passWordView.layer.masksToBounds=YES;
    _passWordView.layer.cornerRadius =2.5;
    _passWordView.alpha=0.4;
    [self.view addSubview:_passWordView];
    
    
    UIImageView *userImage = [LXTControl createImageViewWithFrame:CGRectMake(10+_userNameView.frame.origin.x, 10+_userNameView.frame.origin.y, 15, 20) ImageName:@"login1"];
    [self.view addSubview:userImage];
    
    UIImageView *passImage = [LXTControl createImageViewWithFrame:CGRectMake(10+_passWordView.frame.origin.x, 11.25+_passWordView.frame.origin.y, 14.5, 17.5) ImageName:@"login2"];
    [self.view addSubview:passImage];
    
    _userNameText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImage.frame)+15, 10+_userNameView.frame.origin.y, _passWordView.frame.size.width-userImage.frame.size.width-25, 20)];
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
    
    
    
    _passWordText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImage.frame)+15, 10+_passWordView.frame.origin.y, _passWordView.frame.size.width-userImage.frame.size.width-25, 20)];
    [_passWordText setLeftViewMode:UITextFieldViewModeAlways];
    //_passWordText.clearButtonMode = UITextFieldViewModeAlways;
    _passWordText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passWordText.returnKeyType = UIReturnKeyDone;
    _passWordText.keyboardType = UIKeyboardTypeDefault;
    _passWordText.delegate = self;
    [_passWordText addTarget:self action:@selector(passWordValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [_passWordText setBorderStyle:UITextBorderStyleNone];
    _passWordText.layer.borderWidth=0.0;
    _passWordText.backgroundColor = [UIColor clearColor];
    _passWordText.tintColor = [UIColor blackColor];
    _passWordText.tag=1;
    _passWordText.secureTextEntry = YES;
    _passWordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"434343"],NSFontAttributeName : [UIFont systemFontOfSize:16.0],}];
    [self.view addSubview:_passWordText];
    
    
    
    loginBtn = [LXTControl createButtonWithFrame:CGRectMake(15, CGRectGetMaxY(_passWordView.frame)+25*HEIGHT/667, (WIDTH-30), 40) ImageName:@"" Target:self Action:@selector(loginbutton:)Title:@"登录"];
    loginBtn.layer.masksToBounds=YES;
    loginBtn.layer.cornerRadius=2.5;
    loginBtn.backgroundColor = RGBCOLOR(1, 126, 68);
    loginBtn.alpha=0.9;
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    loginBtn.tag=500;
    [self.view addSubview:loginBtn];
    
    
    
    
    
    
    
    
    //    registBtn = [LXTControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(loginBtn.frame)+5, HEIGHT-232*HEIGHT/667-40, 100*WIDTH/375, 40) ImageName:@"" Target:self Action:@selector(registbutton:)Title:@"注册"];
    //    registBtn.layer.masksToBounds=YES;
    //    registBtn.layer.cornerRadius=2.5;
    //    registBtn.layer.borderWidth = 0.5;
    //    registBtn.layer.borderColor = RGBCOLOR(1, 126, 68).CGColor;
    //    registBtn.backgroundColor = [UIColor whiteColor];
    //
    //    registBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //    [registBtn setTitleColor:RGBCOLOR(1, 126, 68) forState:UIControlStateNormal];
    //    registBtn.tag=501;
    //    [self.view addSubview:registBtn];
    
    
    
    
    //    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH-1)/2, HEIGHT-40, 1, 20)];
    //    lineLab.backgroundColor = [UIColor colorWithHexString:@"#919191"];
    //    [self.view addSubview:lineLab];
    
    
    
    quictBtn = [LXTControl createButtonWithFrame:CGRectMake(15, CGRectGetMaxY(loginBtn.frame)+15*HEIGHT/667, (WIDTH-1-36)/2, 20) ImageName:@"" Target:self Action:@selector(quictbutton:)Title:@"快捷登录"];
    
    quictBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    quictBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [quictBtn setTitleColor:RGBCOLOR(145, 145, 145) forState:UIControlStateNormal];
    quictBtn.tag=502;
    [self.view addSubview:quictBtn];
    
    forgetBtn = [LXTControl createButtonWithFrame:CGRectMake(WIDTH-15-(WIDTH-1-36)/2, quictBtn.frame.origin.y, (WIDTH-1-36)/2, 20) ImageName:@"" Target:self Action:@selector(forgetbutton:)Title:@"忘记密码?"];
    
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [forgetBtn setTitleColor:RGBCOLOR(145, 145, 145) forState:UIControlStateNormal];
    forgetBtn.tag=503;
    [self.view addSubview:forgetBtn];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(quictBtn.frame)+100*HEIGHT/667, WIDTH, 20)];
    lab.text = @"你还可以使用以下方式登录";
    lab.textColor = RGBCOLOR(145, 145, 145);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:lab];
    
    NSArray *arr =@[@"wx2.png",@"wx1.png"];
    NSArray *arr1 =@[@"QQ",@"微信"];
    float Qwidth = 60*WIDTH/375;
    for (int i=0; i<2; i++) {
        
        UIButton *quiBtn = [LXTControl createButtonWithFrame:CGRectMake((WIDTH/2-15)-Qwidth+(30+Qwidth)*i, CGRectGetMaxY(lab.frame)+20*HEIGHT/667, Qwidth, Qwidth) ImageName:arr[i] Target:self Action:@selector(QQLogin:)Title:@""];
        
        //quiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        quiBtn.layer.masksToBounds=YES;
        quiBtn.layer.cornerRadius=Qwidth/2;
        quiBtn.tag=50000+i;
        [self.view addSubview:quiBtn];
        
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH/2-15)-Qwidth+(30+Qwidth)*i, CGRectGetMaxY(quiBtn.frame)+7*HEIGHT/667, Qwidth, 20)];
        lab1.text = arr1[i];
        lab1.textColor = RGBCOLOR(177, 177, 177);
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:lab1];
        
        
    }
    
}


-(void)QQLogin:(UIButton *)sender
{
    if (sender.tag==50000) {
        
        [self qqClick];
        
    }else
    {
        [self weixinClick];
        
        
    }
    
    
    
    
}
#pragma mark--忘记密码点击
-(void)forgetbutton:(UIButton *)sender
{
    changePassVC *vc = [[changePassVC alloc]init];
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark--快捷登录点击
-(void)quictbutton:(UIButton *)sender
{
    
    quictLoginVC *vc = [[quictLoginVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark--登录点击
-(void)loginbutton:(UIButton *)sender
{
    
    if (self.userNameText.text.length!=0&&self.passWordText.text!=0) {
        
        
        if (self.userNameText.text.length==11) {
            [self requestLogin];
        }else{
            [MBProgressHUD showError:@"请输入正确的手机号"];
            
        }
        
        
    }else
    {
        [StaticTools showAlert:@"请填写用户名或密码"];
        
    }
    
    
}

#pragma mark--注册点击
-(void)registbutton:(UIButton *)sender
{
    
    registVC *vc = [[registVC alloc]init];
    vc.myVC =self;
    [self.navigationController pushViewController:vc animated:YES];

    
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
        if ([regular checkPassword1:sender.text]) {
            
        }else
        {
            _passWordText.text = [sender.text substringToIndex:sender.text.length-1];
        }
        
        
        //         if (_passWordText.text.length > 9) {
        //        if ([regular checkPassword:sender.text]) {
        //            NSLog(@"dsfds");
        //
        //        }else
        //        {
        //
        //        _passWordText.text = [sender.text substringToIndex:9];
        //        }
        //
        //         }
        //
    }
    
}

// 点击return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        if (textField==self.userNameText) {
            [self.userNameText resignFirstResponder];
            [self.passWordText becomeFirstResponder];
        }else
        {
            [self.passWordText resignFirstResponder];
        }
        
        
    }else
    {
        [MBProgressHUD showError:@"账户或密码不能为空"];
        
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

-(void)requestLogin
{
    
    loginBtn.userInteractionEnabled=NO;
    
    __weak __typeof(self)weakSelf = self;
    NSDictionary *params = @{@"userName":self.userNameText.text,@"passWord":self.passWordText.text,};
    [NetAccess getJSONDataWithUrl:kuserLogin parameters:params WithLoadingView:YES andLoadingViewStr:@"正在登录" success:^(id responseObject) {
        
        loginBtn.userInteractionEnabled=YES;
        NSMutableDictionary *dic1 ;
        dic1 = [responseObject objectForKey:@"header"];
        NSString *code = [NSString stringWithFormat:@"%@",dic1[@"code"]];
        
        if ([code isEqualToString:@"0"]) {
            //登录成功
            NSString *token =[[responseObject objectForKey:@"date"]objectForKey:@"token"];
            TLAccount *account = [TLAccount accountWithUUID:token];
            
            BOOL haveCode = [[[responseObject objectForKey:@"date"]objectForKey:@"haveCode"] boolValue];
            [TLAccountSave saveAccountWithAccount:account];
            [[NSNotificationCenter defaultCenter] postNotificationName:TLLoginNotification object:nil];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"date"]objectForKey:@"userName"]] forKey:@"phone"];
        
            AppDelegate * app1 = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app1.lvc geticon:token];
            [[TLUploadSystemInfo shareIntens]uploadSystemBaseDatatoServer];
            [MBProgressHUD showSuccess:@"登录成功"];
            
            // haveCode=YES;
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
            //登录失败
            NSString *message = dic1[@"message"];
            [StaticTools showAlert:message];
        }
        
        
    } fail:^{
        
        [StaticTools showAlert:@"请求网络失败!"];
        
    }];
}


-(void)requestCheckUser
{
    __weak __typeof(self)weakSelf = self;
    NSDictionary *params = @{@"userName":self.userNameText.text};
    [NetAccess getJSONDataWithUrl:kcheckUser parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        
        NSMutableDictionary *dic1 ;
        dic1 = [responseObject objectForKey:@"header"];
        NSString *code = [NSString stringWithFormat:@"%@",dic1[@"code"]];
        if ([code isEqualToString:@"0"]) {
            //用户名可以使用
            
            [weakSelf requestLogin];
            
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


-(void)qqClick
{
    
    
    [self getUserInfoForPlatform:UMSocialPlatformType_QQ type:@"2"];
    
}

-(void)weixinClick
{
    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession type:@"3"];
    
}
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType type:(NSString *)myType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
//        NSLog(@" uid: %@", resp.uid);
//        NSLog(@" openid: %@", resp.openid);
//        NSLog(@" accessToken: %@", resp.accessToken);
//        NSLog(@" refreshToken: %@", resp.refreshToken);
//        NSLog(@" expiration: %@", resp.expiration);
//        
//        // 用户数据
//        NSLog(@" name: %@", resp.name);
//        NSLog(@" iconurl: %@", resp.iconurl);
//        NSLog(@" gender: %@", resp.gender);
        
        // 第三方平台SDK原始数据
//        NSLog(@" originalResponse: %@", resp.originalResponse);
        NSString *sex;
        
        
        if ([NSString isBlankString:resp.uid]) {
            if ([resp.gender isEqualToString:@"m"]) {
                sex=@"男";
            }else
            {
                sex=@"女";
            }
            
            [self loginRequest:resp.uid name:resp.name gender:sex iconurl:resp.iconurl channelType:myType openId:resp.openid];
        }
        
    }];
}
#pragma mark--三方登陆网络请求
-(void)loginRequest:(NSString *)uid name:(NSString *)name gender:(NSString *)gender iconurl:(NSString *)iconurl channelType:(NSString *)channelType  openId:(NSString *)openId;
{
    //channelType 2QQ 3微信
    
    __weak __typeof(self)weakSelf = self;
    
    NSDictionary *params = @{@"uid":openId,@"name":name,@"gender":gender,@"iconurl":iconurl,@"channelType":channelType};
    [NetAccess getJSONDataWithUrl:kotherLogin parameters:params WithLoadingView:YES andLoadingViewStr:@"正在登录" success:^(id responseObject) {
        
        NSMutableDictionary *dic1 ;
        dic1 = [responseObject objectForKey:@"header"];
        NSString *code = [NSString stringWithFormat:@"%@",dic1[@"code"]];
        if ([code isEqualToString:@"0"]) {
            
            BOOL haveCode = [ [[responseObject objectForKey:@"date"]objectForKey:@"haveCode"] boolValue];
            //用户名可以使用
            NSString *token =[[responseObject objectForKey:@"date"]objectForKey:@"token"];
            NSString *name=  [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"date"]objectForKey:@"huanXinKey"]];
            
            BOOL isBindPhone = [[[responseObject objectForKey:@"date"]objectForKey:@"isRelevancePhone"]boolValue];
            if(isBindPhone)
            {
                TLAccount *account = [TLAccount accountWithUUID:token];
                [TLAccountSave saveAccountWithAccount:account];
                [[NSNotificationCenter defaultCenter] postNotificationName:TLLoginNotification object:nil];
               
               [MBProgressHUD showSuccess:@"登录成功"];
                AppDelegate * app1 = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app1.lvc geticon:token];
                
                [[TLUploadSystemInfo shareIntens]uploadSystemBaseDatatoServer];
                //haveCode= YES;
                if (haveCode) {
                    codeVC *vc1 =[[codeVC alloc]init];
                    vc1.myVC=weakSelf;
                    [weakSelf.navigationController pushViewController:vc1 animated:YES];
                    
                }else
                {
                    [weakSelf  dismissViewControllerAnimated:YES completion:^{
                        
                        
                    }];
                }
            }else
            {
                
            }
        }else
        {
            //用户名存在或者不对
            NSString *message = dic1[@"message"];
            [StaticTools showAlert:message];
        }
        
    } fail:^{
        [StaticTools showAlert:@"请求网络失败!"];
        
    }];
    
}


@end
