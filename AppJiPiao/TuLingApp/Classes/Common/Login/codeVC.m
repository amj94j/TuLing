//
//  codeVC.m
//  TuLingApp
//
//  Created by hua on 2017/5/11.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "codeVC.h"

@interface codeVC ()<UITextFieldDelegate>
{
    UIButton *newRegistBtn;
    UILabel *lineLabel;
    UIButton *quictBtn;
    NSString *myCode;
}
@property(nonatomic,strong)UIImageView *backImageVIew;
@property(nonatomic,strong)UITextField *userNameText;
@property(nonatomic,strong)UIImageView *inputBackView;
@property(nonatomic,strong)UIView *fieldBakcVIew;
@end

@implementation codeVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写邀请码";
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton =YES;
    
    self.backImageVIew = [[UIImageView alloc]init];
    self.backImageVIew.image = [UIImage imageNamed:@"codeback"];
    self.backImageVIew.frame = CGRectMake(0, 64, mainScreenWidth, self.view.height-64);
    [self.view addSubview:self.backImageVIew];
    
    self.inputBackView = [[UIImageView alloc]init];
    UIImage *backImage = [UIImage imageNamed:@"codeinputback"];
    self.inputBackView.image =backImage;
    self.inputBackView.bounds = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    self.inputBackView.center = CGPointMake(mainScreenWidth/2,84+self.inputBackView.height/2);
    [self.view addSubview:self.inputBackView];
    newRegistBtn = [LXTControl createButtonWithFrame:CGRectMake(WIDTH-15-40, 32, 40, 22) ImageName:@"" Target:self Action:@selector(registbutton:)Title:@"跳过"];
    [newRegistBtn sizeToFit];
    newRegistBtn.center = CGPointMake(mainScreenWidth/2,self.inputBackView.bottom+20+newRegistBtn.height/2);
    newRegistBtn.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:15];
    [newRegistBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    newRegistBtn.tag=508;
    [self.view addSubview:newRegistBtn];
    [self setcontentView];
    [_userNameText becomeFirstResponder];
    
}


-(void)setcontentView
{

    UILabel *descriLabel = [[UILabel alloc]init];
    descriLabel.text = @"邀请码";
    descriLabel.textColor = [UIColor colorWithHexString:@"C78824"];
    descriLabel.font = [UIFont fontWithName:FONT_REGULAR size:15];
    [descriLabel sizeToFit];
    descriLabel.center = CGPointMake(mainScreenWidth/2,self.inputBackView.top+24+descriLabel.height/2);
    [self.view addSubview:descriLabel];
    
    self.fieldBakcVIew = [[UIView alloc]init];
    self.fieldBakcVIew.bounds = CGRectMake(0, 0, 190, 44);
    self.fieldBakcVIew.center = CGPointMake(mainScreenWidth/2, descriLabel.bottom+5+self.fieldBakcVIew.height/2);
    self.fieldBakcVIew.layer.cornerRadius =self.fieldBakcVIew.height/2;
    self.fieldBakcVIew.layer.borderWidth = 2;
    self.fieldBakcVIew.layer.borderColor = [UIColor colorWithHexString:@"6DCB99"].CGColor;
    [self.view addSubview:self.fieldBakcVIew];
    
    _userNameText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 130, 25)];
    _userNameText.center = CGPointMake(self.fieldBakcVIew.width/2, _fieldBakcVIew.height/2);

    [_userNameText setLeftViewMode:UITextFieldViewModeAlways];
//    _userNameText.clearButtonMode = UITextFieldViewModeAlways;
    _userNameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userNameText.returnKeyType = UIReturnKeyDone;
    _userNameText.keyboardType = UIKeyboardTypeNumberPad;
    _userNameText.delegate = self;
    _userNameText.textAlignment = NSTextAlignmentLeft;
    [_userNameText addTarget:self action:@selector(usernameValueChanged:) forControlEvents:UIControlEventEditingChanged];

    _userNameText.backgroundColor = [UIColor clearColor];
    _userNameText.tintColor = [UIColor blackColor];
    _userNameText.tag=1;
    [self.fieldBakcVIew addSubview:_userNameText];

    lineLabel = [[UILabel alloc]init];
    lineLabel.text = @"输入邀请码即可获得200积分，积分可抵现";
    lineLabel.textColor = [UIColor colorWithHexString:@"#6a6a6a"];
    lineLabel.font = [UIFont fontWithName:FONT_REGULAR size:15];
    lineLabel.numberOfLines = 0;
    lineLabel.textAlignment = NSTextAlignmentLeft;
    lineLabel.bounds = CGRectMake(0, 0, 190, 44);
    lineLabel.center = CGPointMake(mainScreenWidth/2,self.fieldBakcVIew.bottom+15+lineLabel.height/2);

    [self.view addSubview:lineLabel];
    
    quictBtn = [LXTControl createButtonWithFrame:CGRectZero ImageName:@"" Target:self Action:@selector(quictbutton:)Title:@"确认"];
    quictBtn.bounds = CGRectMake(0, 0, 190, 44);
    quictBtn.center =CGPointMake(mainScreenWidth/2, self.inputBackView.bottom-20-quictBtn.height/2);
    //quictBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    quictBtn.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:17];
    [quictBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quictBtn.layer.masksToBounds=YES;
    [quictBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    quictBtn.layer.cornerRadius =quictBtn.height/2;
    quictBtn.tag=502;
    quictBtn.backgroundColor =[UIColor colorWithHexString:@"#6DCB99"];
    [self.view addSubview:quictBtn];
}

-(void)keyboard:(NSNotification*)noti{

    NSDictionary * dic = noti.userInfo;
    
    NSValue* value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    

    if (value){
       
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)dealloc{
    
}

#pragma mark _TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    myCode=textField.text;
    if (myCode.length!=0) {
        [self checkEmail];
    }

    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - UITextField代理及自定义方法
// 点击
- (void)usernameValueChanged:(UITextField *)sender {
    NSInteger wordCount = sender.text.length;
    if(wordCount<11)
    {
        myCode =sender.text;
        
    }else
    {
        NSString *tempstring = sender.text;
        NSString *result = [tempstring substringToIndex:11];
        sender.text = result;
        myCode = sender.text;
    }
}


#pragma mark--下一步点击
-(void)quictbutton:(UIButton *)sender
{
    if(self.userNameText.text.length==4||self.userNameText.text.length==11)
    {
        
        if (myCode.length!=0) {
            [self checkEmail];
        }
    }
    else
    {
        [MBProgressHUD showError:@"邀请码必须是4位和11位"];
    }
}

#pragma mark--跳过点击
-(void)registbutton:(UIButton *)sender
{
    [_myVC  dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark--验证验证码
-(void)checkEmail
{
    __weak __typeof(self)weakSelf = self;
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params = @{@"uuid":account.uuid,@"check":myCode};
    [NetAccess getJSONDataWithUrl:ksubmitEmail  parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        NSMutableDictionary *dic1 ;
        dic1 = [responseObject objectForKey:@"header"];
        NSString *code = [NSString stringWithFormat:@"%@",dic1[@"code"]];
        if ([code isEqualToString:@"0"]) {
            //用户名可以使用
         //   [weakSelf commitRequest];
            
            [weakSelf.myVC  dismissViewControllerAnimated:YES completion:^{
                
            }];

        }else
        {
            [MBProgressHUD showError:@"邀请码错误" ];
            
        }
        
    } fail:^{
        [StaticTools showAlert:@"请求网络失败!"];
        
    }];
    
}


@end
