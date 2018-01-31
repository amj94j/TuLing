#import "MainViewController.h"

#import "verification_button.h"
#import "MainSliderViewController.h"
#import "AppDelegate.h"



@interface MainViewController () <verification_buttonDelegate,UITextFieldDelegate>

@property (nonatomic, strong) verification_button * verification_btn;

@property (nonatomic, strong) UITextField * codefield;

@property (nonatomic, strong) UITextField * textfield;
@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self firstView];
    
    [self notification_textfield];
    
    self.verification_btn.userInteractionEnabled = NO;
}
//监听
- (void)notification_textfield
{
    [self.textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange :(UITextField *)theTextField {
    
    self.verification_btn.userInteractionEnabled = NO;
    if (theTextField.text.length == 11) {
        self.verification_btn.userInteractionEnabled = YES;
    }
}
- (void)firstView
{
    //返回按钮
    if(isIPHONE6P){
        UIButton *btnBack = [LXTControl createButtonWithFrame:CGRectMake(0, 34, 40*1.5, 20*1.5) ImageName:nil Target:self Action:nil Title:nil];
        [btnBack addTarget:self action:@selector(backAcitonClick) forControlEvents:UIControlEventTouchUpInside];
        [btnBack setImage:[UIImage imageNamed:@"loginBack.png"] forState:UIControlStateNormal];
        [self.view addSubview:btnBack];
    }else{
        UIButton *btnBack = [LXTControl createButtonWithFrame:CGRectMake(0, 34, 40, 20) ImageName:nil Target:self Action:nil Title:nil];
        [btnBack addTarget:self action:@selector(backAcitonClick) forControlEvents:UIControlEventTouchUpInside];
        [btnBack setImage:[UIImage imageNamed:@"loginBack.png"] forState:UIControlStateNormal];
        [self.view addSubview:btnBack];
    }
    //中间标题
    UILabel *midLabel = [LXTControl createLabelWithFrame:CGRectMake(WIDTH/2-20, 34, 40, 18) Font:18 Text:@"登录"];
    midLabel.textColor = RGBCOLOR(67, 67, 67);
    [self.view addSubview:midLabel];
    //logo背景
    if (isIPHONE6P) {
        UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-87.5*1.5, 108, 175*1.5, 60*1.5)];
        logoImageView.image = [UIImage imageNamed:@"logo.png"];
        [self.view addSubview:logoImageView];
    }else{
        UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-87.5, 108, 175, 60)];
        logoImageView.image = [UIImage imageNamed:@"logo.png"];
        [self.view addSubview:logoImageView];
    }
    //手机行
    UITextField *textfield = [[UITextField alloc]init];
    textfield.placeholder = @"请输入手机号码";
    textfield.keyboardType = UIKeyboardTypeNumberPad;
    if (isIPHONE6P) {
        UIImageView *phoneView = [LXTControl createImageViewWithFrame:CGRectMake(20, 233*1.5, 12.5*1.5, 22*1.5) ImageName:@"phone.png"];
        [self.view addSubview:phoneView];
        textfield.frame = CGRectMake(45, 233*1.5, WIDTH-53, 22*1.5);
    }else{
        UIImageView *phoneView = [LXTControl createImageViewWithFrame:CGRectMake(20, 233, 12.5, 22) ImageName:@"phone.png"];
        [self.view addSubview:phoneView];
        textfield.frame = CGRectMake(43, 233, WIDTH-53, 22);
    }
    self.textfield = textfield;
    [self.view addSubview:textfield];
    
    UIImageView *firstLineImageView = [[UIImageView alloc]init];
    if (isIPHONE6P) {
        firstLineImageView.frame = CGRectMake(10, 260*1.5, WIDTH-20, 1);
    }else{
        firstLineImageView.frame = CGRectMake(10, 260, WIDTH-20, 1);
    }
    firstLineImageView.backgroundColor = RGBCOLOR(226, 226, 226);
    [self.view addSubview:firstLineImageView];
    //验证码行
    if (isIPHONE6P) {
        UIImageView *yanzhengImageView = [LXTControl createImageViewWithFrame:CGRectMake(18, CGRectGetMaxY(firstLineImageView.frame)+10, 17*1.5, 19*1.5) ImageName:@"yanzheng.png"];
        [self.view addSubview:yanzhengImageView];
    }else{
        UIImageView *yanzhengImageView = [LXTControl createImageViewWithFrame:CGRectMake(20, CGRectGetMaxY(firstLineImageView.frame)+20, 17, 19) ImageName:@"yanzheng.png"];
        [self.view addSubview:yanzhengImageView];
    }
    
    UITextField *codefield = [[UITextField alloc]init];
    if (isIPHONE6P) {
     codefield.frame = CGRectMake(textfield.frame.origin.x,CGRectGetMaxY(textfield.frame)+10,200-33,45);
    }else{
     codefield.frame = CGRectMake(textfield.frame.origin.x,CGRectGetMaxY(textfield.frame)+20,200-33,30);
    }
    codefield.placeholder = @"请输入验证码";
    codefield.keyboardType = UIKeyboardTypeNumberPad;
    self.codefield = codefield;
    [self.view addSubview:codefield];
    
    verification_button *btn = [verification_button buttonWithTotal_seconds:30];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [RGBCOLOR(226, 226, 226) CGColor];
    btn.delegate = self;
    self.verification_btn = btn;
    if (isIPHONE6P) {
        btn.frame = CGRectMake(CGRectGetMaxX(codefield.frame)+10, codefield.frame.origin.y, WIDTH-CGRectGetMaxX(codefield.frame)-20, 45);
    }else{
        btn.frame = CGRectMake(CGRectGetMaxX(codefield.frame)+10, codefield.frame.origin.y, WIDTH-CGRectGetMaxX(codefield.frame)-20, 30);
    }
    UIImageView *secondLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(firstLineImageView.frame)+44, 200, 1)];
    secondLineImageView.backgroundColor = RGBCOLOR(226, 226, 226);
    [self.view addSubview:secondLineImageView];
    
    UIButton *qudingButton = [[UIButton alloc]init];
    if(isIPHONE6P){
        qudingButton.frame = CGRectMake(10, CGRectGetMaxY(codefield.frame) + 40, WIDTH-20, 40*1.5);
    }else{
        qudingButton.frame = CGRectMake(10, CGRectGetMaxY(codefield.frame) + 40, WIDTH-20, 40);
    }
    qudingButton.layer.masksToBounds = YES;
    qudingButton.layer.cornerRadius = 5.0;
    [qudingButton setTitle:@"确定" forState:UIControlStateNormal];
    [qudingButton setTintColor:[UIColor whiteColor]];
    [qudingButton setBackgroundColor:RGBCOLOR(35, 161, 90)];
    qudingButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [qudingButton addTarget:self action:@selector(qudingButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qudingButton];
    
    [self.view addSubview:btn];
    
}
#pragma 向服务器发送获取验证码请求
- (void) send_mobile_number_to_server:(verification_button *)maleAndFemale
{
   
   
}
//确定登录
- (void)qudingButton
{
    NSDictionary *params = @{@"mobile":self.textfield.text,@"token":self.codefield.text};
    [NetAccess getJSONDataWithUrl:Login_URL parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        NSString *uuidStr = [responseObject objectForKey:@"uuid"];
        if (uuidStr != nil) {
            [MBProgressHUD showSuccess:@"登录成功"];
            TLAccount *account = [TLAccount accountWithUUID:uuidStr];
            [TLAccountSave saveAccountWithAccount:account];
            [[NSNotificationCenter defaultCenter] postNotificationName:TLLoginNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
            [self dismissViewControllerAnimated:YES completion:^{

            }];
        }else{
            [StaticTools showAlert:@"请输入验证码!"];
        }
    } fail:^{
     [StaticTools showAlert:@"请求网络失败!"];
    }];
}
#pragma mark 返回上一层
- (void)backAcitonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textfield resignFirstResponder];
    [self.codefield resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
