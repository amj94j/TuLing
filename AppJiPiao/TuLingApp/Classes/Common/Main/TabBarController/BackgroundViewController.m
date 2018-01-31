#import "BackgroundViewController.h"
#import "BaseNavigationController.h"
#import "gerenzhongxinTableViewCell.h"
#import "MainSliderViewController.h"
#import "Tuling_user_setting_ViewController.h"
#import "BaseNavigationController.h"
#import "NewfeatureViewController.h"
#import "Tuling_like_and_collection_ViewController.h"
#import "HelpQuestionViewController.h"
#import "SystemSettingViewController.h"
#import "normalLoginVC.h"
#import "MyAddressViewController.h"
#import "AppDelegate.h"
#import "UIColor+ColorChange.h"
#import "NSString+StrCGSize.h"
#import "feedbackViewController.h"
#import "foodLikeViewController.h"
#import "myCollectionViewController.h"
#import "AboutViewController.h"
#import "normalLoginVC.h"
#import "perInfmationViewController.h"
#import "listViewController.h"
#import "MyOrderFormVC.h" // 我的订单
#import "PersonRecruitmentVC.h" // 个人商家入驻

#import "myMessageViewController.h"
#import "submitCommentViewController.h"

#import "MyOrderDetailVC.h"
#import "OrderReturnDetailVC.h"
#import "myStoreViewController.h"
#define kColor(r , g ,b) [UIColor colorWithRed:(r)/255.0  green:(g)/255.0  blue:(b)/255.0 alpha:1]
@interface BackgroundViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)NSInteger BackViewTag;
@property(nonatomic,strong)Tuling_user_setting_ViewController *tvc;
@property(nonatomic,strong)UIImageView *backImageView;
@property(nonatomic,strong)UITableView *myTableview;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)NSDictionary *userDic;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIButton *editButton;
@property(nonatomic,strong)TLAccount *account;
@property(nonatomic,assign)NSInteger travel_status;
@property(nonatomic,assign)NSInteger travel_id;

@end

@implementation BackgroundViewController
- (void)viewWillAppear:(BOOL)animated
{[super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    _account = [TLAccountSave account];
    if (_account.uuid!=nil) {
        [self requestData:_account.uuid];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.BackViewTag = 0;
    
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi8:) name:@"tongzhi8" object:nil];
    
//    TLAccount *account = [TLAccount accountWithUUID:@"a0d7d9ef-a7e5-356e-ac0c-fd1cdc857217"];
//    [TLAccountSave saveAccountWithAccount:account];
    [self createView];
    _account = [TLAccountSave account];
    if (_account.uuid!=nil) {
        [self requestData:_account.uuid];
    }else
    {
    [_iconImageView setImage:[UIImage imageNamed:@"person0"]];
    _iconImageView.frame =CGRectMake(277*WIDTH/375/2-30, 79*HEIGHT/667, 60, 60);
        _nameLabel.text = @"未登录";
        [NSString singeWidthForString:@"未登录" fontSize:13 Height:20];
        _nameLabel.frame = CGRectMake((_iconImageView.frame.origin.x+30-([NSString singeWidthForString:@"未登录" fontSize:13 Height:20]+20)/2), _iconImageView.frame.size.height+_iconImageView.frame.origin.y+20, [NSString singeWidthForString:@"未登录" fontSize:13 Height:20]+20, 20) ;
    
    }
}
- (void)requestData:(NSString *)UUIDStr
{
    [self geticon:UUIDStr];
}
- (void)geticon:(NSString *)UUIDStr
{
    NSDictionary *params;
    if(UUIDStr != nil){
        params = @{@"uuid":UUIDStr};
    }else{
        params = nil;
    }
    [NetAccess getJSONDataWithUrl:kGET_USER_INFORMATION_FROM_SERVER_URL parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        self.userDic = [responseObject objectForKey:@"date"];
        if ([NSString isBlankString:[self.userDic objectForKey:@"icon"]]) {
           [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[self.userDic objectForKey:@"icon"]] placeholderImage:nil];
        }else
        {
            [_iconImageView setImage:[UIImage imageNamed:@"person0"]];
        
        }
        if ([NSString isBlankString:[self.userDic objectForKey:@"name"]]) {
            _nameLabel.text = [self.userDic objectForKey:@"name"];
        }else
        {
           _nameLabel.text = [self.userDic objectForKey:@"user_name"];
        }
        
        [NSString singeWidthForString:_nameLabel.text fontSize:13 Height:20];
        _nameLabel.frame = CGRectMake((_iconImageView.frame.origin.x+30-([NSString singeWidthForString:_nameLabel.text fontSize:13 Height:20]+20)/2), _iconImageView.frame.size.height+_iconImageView.frame.origin.y+20, [NSString singeWidthForString:_nameLabel.text fontSize:13 Height:20]+20, 20) ;
        //[self.myTableview reloadData];
 
    } fail:^{
        [_iconImageView setImage:[UIImage imageNamed:@"person0"]];
         _nameLabel.text = @"未登录";
        _nameLabel.frame = CGRectMake((_iconImageView.frame.origin.x+30-([NSString singeWidthForString:_nameLabel.text fontSize:13 Height:20]+20)/2), _iconImageView.frame.size.height+_iconImageView.frame.origin.y+20, [NSString singeWidthForString:_nameLabel.text fontSize:13 Height:20]+20, 20) ;
        
    }];
}
- (void)createView
{
    _backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _backImageView.userInteractionEnabled = YES;
    //_backImageView.image = [UIImage imageNamed:@"left.png"];
    _backImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backImageView];
    

    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(277*WIDTH/375/2-30, 79*HEIGHT/667, 60, 60)];
    [_iconImageView setImage:[UIImage imageNamed:@"person0"]];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width/2;
    
    UITapGestureRecognizer *serviceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(serviceTapClick:)];
    serviceTap.numberOfTapsRequired = 1;
    serviceTap.numberOfTouchesRequired = 1;
    [_iconImageView addGestureRecognizer:serviceTap];
    [_backImageView addSubview:_iconImageView];

        _nameLabel = [LXTControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+20, _iconImageView.frame.size.height+_iconImageView.frame.origin.y+20, 280, 20) Font:13 Text:@""];

    _nameLabel.textAlignment =  NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.backgroundColor =kColor(109, 203, 155);
    _nameLabel.layer.masksToBounds=YES;
    _nameLabel.layer.cornerRadius =10;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceTapClick:)];
    [_nameLabel addGestureRecognizer:labelTapGestureRecognizer];
    _nameLabel.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    [_backImageView addSubview:_nameLabel];
    
    
    UILabel *linLabel = [LXTControl createLabelWithFrame:CGRectMake(0, _nameLabel.frame.size.height+_nameLabel.frame.origin.y+40, 277*WIDTH/375, 0.5) Font:12 Text:@""];
    linLabel.backgroundColor = kColor(238, 238, 238);
    
    [_backImageView addSubview:linLabel];
    
    
    
    self.myTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(linLabel.frame)+20, WIDTH, 350) style:UITableViewStylePlain];
    self.myTableview.backgroundColor = [UIColor whiteColor];
    _myTableview.showsHorizontalScrollIndicator = NO;
    _myTableview.showsVerticalScrollIndicator = NO;
    _myTableview.scrollEnabled=NO;
    _myTableview.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableview.delegate = self;
    self.myTableview.dataSource = self;
    [_backImageView addSubview:_myTableview];
    
    UIView *greenBackView = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT-80, linLabel.frame.size.width, 10)];
    greenBackView.backgroundColor = kColor(238, 238, 238);
    [_backImageView addSubview:greenBackView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-70, WIDTH, 70)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_backImageView addSubview:_bottomView];
    
    
    UIImageView *ima2 = [LXTControl createImageViewWithFrame:CGRectMake(linLabel.frame.size.width/4-10, 20, 20, 20) ImageName:@"person5"];
    
    [_bottomView addSubview:ima2];
    
    UILabel *label11 = [LXTControl createLabelWithFrame:CGRectMake(ima2.frame.origin.x-25, ima2.frame.origin.y+ima2.frame.size.height+5, 70, 15) Font:13 Text:@"意见反馈"];
    label11.textAlignment =NSTextAlignmentCenter;
    label11.textColor = kColor(106, 106, 106);
    [_bottomView addSubview:label11];
    
   
    
    UIImageView *ima3 = [LXTControl createImageViewWithFrame:CGRectMake(linLabel.frame.size.width/4*3-11.5, 20, 23, 18) ImageName:@"person6"];
    
    [_bottomView addSubview:ima3];
    
    UILabel *label22 = [LXTControl createLabelWithFrame:CGRectMake(ima3.frame.origin.x-25, ima3.frame.origin.y+ima3.frame.size.height+5, 70, 15) Font:13 Text:@"关于我们"];
    label22.textAlignment =NSTextAlignmentCenter;
    label22.textColor = kColor(106, 106, 106);
    [_bottomView addSubview:label22];
    
    for (int i=0; i<2; i++) {
        //扩大点击区域
        UIButton *select1 = [LXTControl createButtonWithFrame:CGRectMake(0+linLabel.frame.size.width/2*i, 0, linLabel.frame.size.width/2, 70) ImageName:@"" Target:self Action:@selector(selBtn:) Title:@""];
        select1.tag = i+5000;
        [_bottomView addSubview:select1];
    }

}
//扩大点击区域
-(void)selBtn:(UIButton *)sender
{
    if (sender.tag==5000) {
        [MobClick event:@"107"];
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
       [app.tab showMainView];
        feedbackViewController * viewController = [[feedbackViewController alloc]init];
       // [app.nav pushViewController:viewController animated:YES];
        viewController.isFromLeft = YES;
        [app.tab.viewControllers[app.tab.selectedIndex] pushViewController:viewController animated:YES];
        [app.tab showMainView];
//        [(BaseNavigationController*)app.window.rootViewController pushViewController:viewController animated:YES];
        
    }else
    {
        [MobClick event:@"108"];
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        UIViewController * viewController = [[AboutViewController alloc]init];
        //[app.nav pushViewController:viewController animated :YES];
       //[(BaseNavigationController*)app.window.rootViewController pushViewController:viewController animated:YES];
        
        [app.tab.viewControllers[app.tab.selectedIndex] pushViewController:viewController animated:YES];
        [app.tab showMainView];
        
    }
}
//点击头像
- (void)serviceTapClick:(UIGestureRecognizer *)tap
{
    [MobClick event:@"103"];
     TLAccount *account = [TLAccountSave account];
    if (account.uuid != nil) {
        _tvc = [[Tuling_user_setting_ViewController alloc]init];
        
        //perInfmationViewController *vc = [[perInfmationViewController alloc]init];
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:_tvc];
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
        [button setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        _tvc.navigationItem.leftBarButtonItem  = item;

        [self  presentViewController:nv animated:YES completion:nil];
    }else{
        normalLoginVC *mainVc = [[normalLoginVC alloc]init];
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:mainVc];
        [self presentViewController:nv animated:YES completion:nil];
    }
}
- (void)ButtonClick
{
   // TLAccount* acount = [TLAccountSave account];
   
    [_tvc.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cell";
    gerenzhongxinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[gerenzhongxinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.textLabel.textColor = [UIColor whiteColor];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *titles = @[@"我的收藏",@"消息提醒",@"我的订单",@"我的行程",@"设置"];
    NSArray *images = @[@"person1",@"person2",@"person3",@"his",@"person4"];
    
//    NSArray *titles = @[@"我的收藏",@"设置"];
//    NSArray *images = @[@"person1",@"person4"];
    cell.iconImageView.image = [UIImage imageNamed:images[indexPath.row]];
    cell.tltleLabel.text = titles[indexPath.row];
    cell.tltleLabel.textColor = [UIColor colorWithHexString:@"434343"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tab showMainView];
    TLAccount *account = [TLAccountSave account];
    switch (indexPath.row) {
        case 0:
        {
            if (account.uuid != nil) {
                UIViewController * viewController = [[myCollectionViewController alloc]init];
                [app.tab.viewControllers[app.tab.selectedIndex] pushViewController:viewController animated:YES];
                [app.tab showMainView];
//                [(BaseNavigationController*)app.window.rootViewController pushViewController:viewController animated:YES];
            }else{
                normalLoginVC *mainVc = [[normalLoginVC alloc]init];
                UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:mainVc];
                [self presentViewController:nv animated:YES completion:nil];
            }
        }
        
            break;
               case 1:
        {
            [MobClick event:@"104"];
            if (account.uuid != nil) {
                myMessageViewController * viewController = [[myMessageViewController alloc]init];
                viewController.isFromLeft = YES;
                [app.tab.viewControllers[app.tab.selectedIndex] pushViewController:viewController animated:YES];
                [app.tab showMainView];
//                [(BaseNavigationController*)app.window.rootViewController pushViewController:viewController animated:YES];
            } else {
                normalLoginVC *mainVc = [[normalLoginVC alloc]init];
                UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:mainVc];
                [self presentViewController:nv animated:YES completion:nil];
            }
        }
            break;
        case 2:
        {
            [MobClick event:@"105"];
            if (account.uuid != nil) { // 我的订单
                
//                PersonRecruitmentVC *myOrderFormVC = [[PersonRecruitmentVC alloc]init];
                
                MyOrderFormVC *myOrderFormVC = [[MyOrderFormVC alloc]init];
                myOrderFormVC.isFromLeft = YES;
                [app.tab.viewControllers[app.tab.selectedIndex] pushViewController:myOrderFormVC animated:YES];
                [app.tab showMainView];

            } else {
                normalLoginVC *mainVc = [[normalLoginVC alloc]init];
                UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:mainVc];
                [self presentViewController:nv animated:YES completion:nil];
            }
        }
            break;
        case 3:
        {
            // [MobClick event:@"106"];
            if (account.uuid != nil) {
                listViewController * viewController = [[listViewController alloc]init];
                viewController.isFromLeft = YES;
                [app.tab.viewControllers[app.tab.selectedIndex] pushViewController:viewController animated:YES];
                [app.tab showMainView];
//                [(BaseNavigationController*)app.window.rootViewController pushViewController:viewController animated:YES];
            } else {
                normalLoginVC *mainVc = [[normalLoginVC alloc]init];
                UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:mainVc];
                [self presentViewController:nv animated:YES completion:nil];
            }
        }
            break;
        case 4:
        {
            [MobClick event:@"106"];
            if (account.uuid != nil) {
                UIViewController * viewController = [[SystemSettingViewController alloc]init];
                [app.tab.viewControllers[app.tab.selectedIndex] pushViewController:viewController animated:YES];
                [app.tab showMainView];
//                [(BaseNavigationController*)app.window.rootViewController pushViewController:viewController animated:YES];
            } else {
                normalLoginVC *mainVc = [[normalLoginVC alloc]init];
                UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:mainVc];
                [self presentViewController:nv animated:YES completion:nil];
            }
        }
            break;
            
            
            
        default:
            break;
    }
}

- (void)tongzhi8:(NSNotification *)text{
   
     TLAccount *account = [TLAccountSave account];
    if (account.uuid!=nil) {
        [self requestData:account.uuid];
    }
    
    
//
//    NSLog(@"－－－－－接收到通知------");
//    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhi" object:nil];
//    food =[[NSString alloc]init];
//    NSArray *arr11= [text.userInfo allValues];
//    for (NSString *str1 in arr11) {
//        if (food.length!=0) {
//            food = [NSString stringWithFormat:@"%@ %@ ",food, str1];
//        }else
//        {
//            food = [NSString stringWithFormat:@"%@", str1];
//            
//        }
//        
//    }
//    NSString *send = [[NSString alloc]init];
//    for (NSString *str1 in arr11) {
//        if (send.length!=0) {
//            send = [NSString stringWithFormat:@"%@,%@ ",send, str1];
//        }else
//        {
//            send = [NSString stringWithFormat:@"%@", str1];
//            
//        }
//        
//    }
//    
//    NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
//    [dicParams setObject:send forKey:@"foods"];
//    [self send_data_to_server_with_params:dicParams];
//    
//    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
