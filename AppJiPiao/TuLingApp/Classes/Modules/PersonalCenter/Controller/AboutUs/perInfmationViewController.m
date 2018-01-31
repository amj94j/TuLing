//
//  perInfmationViewController.m
//  TuLingApp
//
//  Created by hua on 17/1/11.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "perInfmationViewController.h"
#import "Tuling_user_setting_ViewController.h"
@interface perInfmationViewController ()
{

UIButton *rightBtn;
    UILabel *lab1;

}
@property(nonatomic,strong)Tuling_user_setting_ViewController *tvc;
@property(nonatomic,strong)NSMutableDictionary *dicSource;

@property(nonatomic,strong)UIImageView *imaBack;

@property(nonatomic,strong)UIView *backView1;


@property(nonatomic,strong)UIView *backView2;

@property(nonatomic,strong)UILabel *tel;

@end

@implementation perInfmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料展示";
    self.view.backgroundColor =RGBCOLOR(238, 238, 238);
     UIButton * backBtn = [LXTControl createButtonWithFrame:CGRectMake(15, 32, 22, 20) ImageName:@"back2" Target:self Action:@selector(backClick) Title:@""];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    //自定义返回Button
    rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(WIDTH-50, 9, 35, 30);
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [rightBtn setTitleColor:RGBCOLOR(67, 67, 67) forState:UIControlStateNormal];
    //rightBtn.userInteractionEnabled=NO;
    [rightBtn addTarget:self action:@selector(rightback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
   
    [self setMybackground];
     [self request];
    
}
-(void)backClick
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
-(void)rightback
{
    _tvc = [[Tuling_user_setting_ViewController alloc]init];
    [self.navigationController pushViewController:_tvc animated:YES];
    
    
    
}
-(void)setMybackground
{
    _backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, WIDTH*4/5+85*HEIGHT/667)];
    _backView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView1];
    
    
    
    _imaBack =[LXTControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*4/5) ImageName:@"169"];
    [_backView1 addSubview:_imaBack];

    
    UILabel *lab = [LXTControl createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(_imaBack.frame)+35*HEIGHT/667, [NSString singeWidthForString:@"快去编辑个人资料，生成属于你自己的标签吧" fontSize:13 Height:20*HEIGHT/667], 20*HEIGHT/667) Font:13 Text:@"快去编辑个人资料，生成属于你自己的标签吧"];
      lab.textColor = RGBCOLOR(145, 145, 145);
      [_backView1 addSubview:lab];
    
    
    
    
    _backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_backView1.frame)+10, WIDTH, 60*HEIGHT/667)];
    _backView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView2];
    
    
    lab1 = [LXTControl createLabelWithFrame:CGRectMake(15, 20*HEIGHT/667, [NSString singeWidthForString:@"电话:" fontSize:14 Height:20*HEIGHT/667], 20*HEIGHT/667) Font:14 Text:@"电话:"];
    lab1.textColor = RGBCOLOR(106, 106, 106);
    [_backView2 addSubview:lab1];
    
    
    
    
    _tel =[LXTControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(lab1.frame)+20, 20*HEIGHT/667, [NSString singeWidthForString:@"1111111111111" fontSize:14 Height:20*HEIGHT/667], 20*HEIGHT/667) Font:14 Text:@""];
    _tel.textColor = RGBCOLOR(106, 106, 106);

    [_backView2 addSubview:_tel];






}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)request
{
    __weak __typeof(self)weakSelf = self;
    _dicSource =[[NSMutableDictionary alloc]init];
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid != nil) {
        params = @{@"uuid":account.uuid};
    }
    [NetAccess getJSONDataWithUrl:kMyIcon parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        NSLog(@"成功");
        
        
        
        weakSelf.dicSource =[responseObject objectForKey:@"date"];
       
        if ([responseObject objectForKey:@"date"]!=[NSNull null]) {
            
        
        
        //NSString *a=weakSelf.dicSource[@"phone"];
        if ([NSString isBlankString:weakSelf.dicSource[@"phone"]]) {
//               NSString *b= [a stringByReplacingCharactersInRange:NSMakeRange(4, 7) withString:@"****"];
            _tel.text =weakSelf.dicSource[@"phone"];
        }else
        {
            _tel.text =@"";
            
        }
            _tel.frame = CGRectMake(CGRectGetMaxX(lab1.frame)+20, 20*HEIGHT/667, [NSString singeWidthForString:_tel.text fontSize:14 Height:20*HEIGHT/667]+20, 20*HEIGHT/667);
        if ([NSString isBlankString:weakSelf.dicSource[@"icon"]]) {
            [ _imaBack sd_setImageWithURL:[NSURL URLWithString:weakSelf.dicSource[@"icon"]]];
        }else
        {
            [_imaBack setImage:[UIImage imageNamed:@"169"]];
        }
        }
        
        } fail:^{
        [MBProgressHUD showError:@"请求失败"];
        
    }];






}
@end
