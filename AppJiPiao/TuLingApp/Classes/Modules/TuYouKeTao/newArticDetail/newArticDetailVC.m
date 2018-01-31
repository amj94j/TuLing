//
//  newArticDetailVC.m
//  TuLingApp
//
//  Created by hua on 17/5/3.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "newArticDetailVC.h"
#import "LZBInifiteScrollView.h"
#import "DetailTableViewCell.h"
#import "newArticDetailCell.h"
#import "productAttributeViewController.h"
#import "categoryModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "categoryArticCell.h"
#import "userTopicModel.h"
#import "userTopicCell.h"
#import "shopCell.h"
#import "goodDetailsTableViewCell.h"
#import "shopsViewController.h"
#import "nowBuyOrderViewController.h"
#import "brandShopViewController.h"
#import "BrandStoryView.h"
#import "TLCommodityTopicAndCommentViewController.h"
#import "shopCartViewController.h"
#import "popupMenuView.h"
#import "sanjiao.h"
#import "myMessageViewController.h"
#import "parameterPopView.h"
#import "chatViewController.h"
#import "TLImageBrowseViewController.h"
#import "shareRuleVC.h"
#import "sharePopView.h"
#import "ShareApperView.h"
#import "topicSearchProVC.h"
#import "TLCommodityTopicShareViewController.h"
#import "MyAttentionDetailVC.h"

#import "TLCommodityTopicDetailsViewController.h"

#import "RecommendCell.h"


#import "newRecentPopView.h"
#import "chiWanDetailViewController.h"
#import "articleDetailViewController.h"

#import "commodityDetailViewController.h"

#import "ZFVideoResolution.h"
#import "ZFPlayer.h"
#import "shareRuleVC.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface newArticDetailVC ()<LZBInifiteScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,newArticDetailCellDelegate,goodDetailsTableViewCellDelegate,BrandStoryViewDelegate,userTopicCellDelegate,UIScrollViewDelegate,SCXCreatePopViewDelegate,parameterPopViewDelegate,newRecentPopViewDelegate,shareApperViewDelegate>
{
    UIButton *moreBtn;
    UIButton *shareBtn;
    UIButton *shoucangBtn;
    UIButton *backBtn;
    UIButton *carButton;
    int collect;
    CGFloat alpha2;
    NSString *contentstr;
    double contentstrHeight;
    int isNews; //是否有新消息
    UIImageView *ima11;//轮播图遮罩
     categoryModel *model;
    userTopicModel *userModel;
      BrandStoryView *BrandView;
    int MarkCount;
    UILabel *changeLine;
    UILabel *cornerMark;
    int chooseType;
    NSString *shareStr;
    UILabel *myzhuanLab;
    NSMutableDictionary *zhuanShareDic;
    NSString *myName;
    UILabel *artName;
    int evaluate;
    BOOL _isShareRequest;
}

@property(nonatomic,strong)UIImageView *imaShare;
@property(nonatomic,strong)sanjiao *menu;
@property(nonatomic,strong)UITableView *TableView;

@property(nonatomic,strong)UIView *topView;//自定义导航栏view


@property (nonatomic, strong) LZBInifiteScrollView *carousel; //轮播图

@property(nonatomic,copy)NSMutableDictionary *dataSourceDic;//总的数据源字典

@property(nonatomic,strong)NSMutableArray *productArr;//商品相关数据源

@property(nonatomic,strong)NSMutableArray *categoryArr;//分类相关数据源

@property(nonatomic,strong)NSMutableArray *subjectsArr;//话题相关数据源

@property(nonatomic,strong)NSMutableArray *recommendArr;//推荐商品相关数据源

@property(nonatomic,strong)NSMutableArray *evaluateArr;//评论相关数据源

@property(nonatomic,strong)NSString *shareTitleLabel;
@property(nonatomic,strong)NSString *shareImageLabel;
@property(nonatomic,strong)NSString *shareUrlLabel;

@property(nonatomic,strong)UIButton *editButton;




@property (nonatomic, strong) ZFPlayerView        *playerView;

@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation newArticDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //_productId= @"238";
    
    if (self.invalidProduct){
        self.invalidProduct = [NSString stringWithFormat:@"%@",self.invalidProduct];
    }
    collect=1;
    MarkCount=0;
    chooseType=0;
    evaluate=0;
   // labelCon = [[UILabel alloc]init];
    contentstr = [[NSString alloc]init];
    zhuanShareDic =[[NSMutableDictionary alloc]init];
    self.view.backgroundColor =RGBCOLOR(238, 238, 238);
    _dataSourceDic = [[NSMutableDictionary alloc]init];
    _productArr = [[NSMutableArray alloc]init];
     _categoryArr = [[NSMutableArray alloc]init];
     _subjectsArr = [[NSMutableArray alloc]init];
     _recommendArr = [[NSMutableArray alloc]init];
     _evaluateArr = [[NSMutableArray alloc]init];
    model = [[categoryModel alloc]init];
    UIButton  *backBtn5 = [LXTControl createButtonWithFrame:CGRectMake(15, 32, 12, 20) ImageName:@"" Target:self Action:nil Title:@""];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn5];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self requestData];
    [self setTableview];
    [self setNav];
    
    artName = [[UILabel alloc] init];
    
    _editButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-10.5-50, HEIGHT-50-64, 50, 50)];
    [_editButton setImage:[UIImage imageNamed:@"editTopic.png"] forState:UIControlStateNormal];
    _editButton.layer.masksToBounds=YES;
    _editButton.layer.cornerRadius =50/2;
    [_editButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    
   

    
}



-(void)myNamefuntion
{

    
    artName.textColor = [UIColor whiteColor];
    artName.text = myName;
    artName.numberOfLines = 0;//根据最大行数需求来设置/Users/hua/Desktop/tuling_ios-master/TuLingApp.xcodeproj
    CGSize maximumLabelSize = CGSizeMake(kScreenW-ima11.frame.origin.x-15, 40);
    CGSize expectSize = [artName sizeThatFits:maximumLabelSize];
    artName.frame = CGRectMake(15,(ima11.frame.size.height-expectSize.height)/2 ,kScreenW-artName.frame.origin.x-15, expectSize.height);
    artName.lineBreakMode = NSLineBreakByCharWrapping;
    artName.textAlignment = NSTextAlignmentCenter;
    artName.font = [UIFont boldSystemFontOfSize:21];
    
    //阴影透明度
    artName.layer.shadowOpacity = 0.75;
    //阴影宽度
    artName.layer.shadowRadius = 0.5;
    //阴影颜色
    artName.layer.shadowColor = [UIColor blackColor].CGColor;
    //映影偏移
    artName.layer.shadowOffset = CGSizeMake(1, 1);




}
/**
 编辑按钮点击
 
 @param sender <#sender description#>
 */
-(void)edit:(UIButton *)sender
{
    
    TLAccount *account = [TLAccountSave account];
    if (account.uuid!=nil) {
        TLCommodityTopicShareViewController * view = [[TLCommodityTopicShareViewController alloc] init];
        view.productID = _productId;
        view.title = _shareTitleLabel;
        [self.navigationController pushViewController:view animated:YES];
    }else
    {
        [self login];
        
    }
    
    
}

#pragma mark--购物车点击事件
-(void)carClick:(UIButton *)sender
{
    //友盟统计
    [MobClick event:@"94"];
    TLAccount *account = [TLAccountSave account];
    if (account.uuid!=nil) {
        shopCartViewController *shopCartVC = [[shopCartViewController alloc]init];
        [self.navigationController pushViewController:shopCartVC animated:YES];
    }else
    {
        [self login];
        
    }
    
    
    
}

#pragma mark--收藏点击事件
-(void)shoucangClick:(UIButton *)sender
{
    TLAccount *account = [TLAccountSave account];
    if (account.uuid!=nil) {
        if (collect==1) {
            collect=2;
            [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"shoucang3"] forState:UIControlStateNormal];
            [self requestAlert:kNewCANCEL_COLLECT_LIKE message:@""];
            
        }else
        {
            collect=1;
            if (alpha2==1) {
                [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"shoucang2"] forState:UIControlStateNormal];
            }else
            {
                [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"shoucang1"] forState:UIControlStateNormal];
            }
            [self requestAlert:kNewCANCEL_COLLECT_LIKE message:@""];
            
        }
    }else
    {
        [self login] ;
        
    }
    
    
}
-(void)login
{
    
    normalLoginVC *mainVc = [[normalLoginVC alloc]init];
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:mainVc];
    [self presentViewController:nv animated:YES completion:nil];
    
    
}
-(void)backClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)moreClick:(UIButton *)sender
{
    
    CGPoint point1 = CGPointMake(sender.frame.origin.x-sender.frame.size.width-50,sender.frame.origin.y+sender.frame.size.height+3+10);
    [self showDownList:&point1];
}
-(void)shareClick:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    [self shareRequest];
    
    
    
//    popupMenuView *shareView =[[popupMenuView alloc]initWithFrame:CGRectMake(0, kScreenH-64, kScreenW, kScreenH)];
//    [shareView sharecontrol:self title:_shareTitleLabel urlString:_shareUrlLabel  titleImage:_imaShare.image ];
}

-(void)btnClickShareRule
{
    shareRuleVC *vc = [[shareRuleVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)shareRequest
{
    MJWeakSelf;
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid != nil) {
        params = @{@"uuid":account.uuid,@"producesId":_productId};
        [NetAccess getJSONDataWithUrl:kProShare parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
            int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
            if (code==0) {
                
                zhuanShareDic =[responseObject objectForKey:@"date"] ;
                shareStr =[[responseObject objectForKey:@"date"] objectForKey:@"msg"];
                
                ShareApperView *vc =[[ShareApperView alloc]initWithFrame:CGRectMake(0, kScreenH-64, kScreenW, kScreenH)];
                vc.delegate = self;
                [vc sharecontrol:weakSelf dic:zhuanShareDic ];
                
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!shareBtn.userInteractionEnabled)
                    shareBtn.userInteractionEnabled = YES;
            });
            
        } fail:^{
            [MBProgressHUD showError:@"请求失败"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!shareBtn.userInteractionEnabled)
                    shareBtn.userInteractionEnabled = YES;
            });
        }];
    }else
    {

        [self login];
        if (!shareBtn.userInteractionEnabled)
            shareBtn.userInteractionEnabled = YES;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    alpha2=0;
    isNews=0;
    [self requestData1];
    self.navigationController.navigationBar.hidden = YES;

}
-(void)viewWillDisappear:(BOOL)animated
{


    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    [self.playerView resetPlayer];
    
}
- (void)setNav {
    _topView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view bringSubviewToFront:_topView];
    [self.view addSubview:_topView];
    
    
    changeLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5, WIDTH, 0.5)];
    changeLine.backgroundColor = [UIColor clearColor];
    [_topView addSubview:changeLine];
    
    backBtn = [LXTControl createButtonWithFrame:CGRectMake(15, 32, 22, 22) ImageName:@"back1" Target:self Action:@selector(backClick) Title:@""];
    [_topView addSubview:backBtn];
    
    
    
    moreBtn = [LXTControl createButtonWithFrame:CGRectMake(kScreenW-9.5-30, 28, 30, 30) ImageName:@"more1" Target:self Action:@selector(moreClick:) Title:@""];
    [_topView addSubview:moreBtn];
    
    shareBtn = [LXTControl createButtonWithFrame:CGRectMake(moreBtn.frame.origin.x-30-10, moreBtn.frame.origin.y,30,30) ImageName:@"share1" Target:self Action:@selector(shareClick:) Title:@""];
    [_topView addSubview:shareBtn];
    
    myzhuanLab =[[UILabel alloc]init];
    myzhuanLab.text = @"赚";
    CGFloat a=[NSString singeWidthForString:myzhuanLab.text fontSize:11 Height:20]+5;
    myzhuanLab.frame = CGRectMake(moreBtn.frame.origin.x-9.5-30-2, 25, a, a);
    myzhuanLab.font =[UIFont systemFontOfSize:11];
    myzhuanLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    myzhuanLab.layer.masksToBounds=YES;
    myzhuanLab.layer.cornerRadius=myzhuanLab.frame.size.width/2;
    myzhuanLab.textAlignment = NSTextAlignmentCenter;
    myzhuanLab.backgroundColor = [UIColor colorWithHexString:@"#FF5C36"];
    myzhuanLab.hidden=NO;
    [_topView addSubview:myzhuanLab];
    
    shoucangBtn = [LXTControl createButtonWithFrame:CGRectMake(shareBtn.frame.origin.x-30-10, moreBtn.frame.origin.y, 30,30) ImageName:@"shoucang1" Target:self Action:@selector(shoucangClick:) Title:@""];
    [_topView addSubview:shoucangBtn];
    
    carButton = [LXTControl createButtonWithFrame:CGRectMake(shoucangBtn.frame.origin.x-30-10, moreBtn.frame.origin.y, 30,30) ImageName:@"car1" Target:self Action:@selector(carClick:) Title:@""];
    [_topView addSubview:carButton];
    
    
    cornerMark = [[UILabel alloc]init];
    
    
    BrandView =[[BrandStoryView alloc]initWithFrame:CGRectMake(0, kScreenH-64, kScreenW, kScreenH)];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0) {
        // CGFloat alpha = MIN(1, (offsetY)/HEIGHT*2.5);
        CGFloat alpha = MIN(1, (offsetY)/[UIScreen mainScreen].bounds.size.width*9/16*5);
        alpha2=alpha;
        NSLog(@"%f",alpha);
        [_topView setBackgroundColor:RGBACOLOR(255, 255, 255, alpha)];
        [changeLine setBackgroundColor:RGBACOLOR(198, 198, 198, alpha)];
        if (alpha==1) {
            [backBtn setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
            [moreBtn setBackgroundImage:[UIImage imageNamed:@"more2"] forState:UIControlStateNormal];
            [shareBtn setBackgroundImage:[UIImage imageNamed:@"share2"] forState:UIControlStateNormal];
            [carButton setBackgroundImage:[UIImage imageNamed:@"car2"] forState:UIControlStateNormal];
            
            if (collect==1) {
                [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"shoucang2"] forState:UIControlStateNormal];
            }
            else
            {
                
                [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"shoucang3"] forState:UIControlStateNormal];
                
                
            }
            
            
        }else
        {
            [backBtn setBackgroundImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
            [moreBtn setBackgroundImage:[UIImage imageNamed:@"more1"] forState:UIControlStateNormal];
            [shareBtn setBackgroundImage:[UIImage imageNamed:@"share1"] forState:UIControlStateNormal];
            [carButton setBackgroundImage:[UIImage imageNamed:@"car1"] forState:UIControlStateNormal];
            if (collect==1) {
                [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"shoucang1"] forState:UIControlStateNormal];
            }
            else
            {
                [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"shoucang3"] forState:UIControlStateNormal];
                
                
            }
            
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark--网络请求(列表)
- (void)requestData
{
    __weak __typeof(self)weakSelf = self;
    
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid!=nil) {
        params = @{@"shopping_product_id":_productId,@"uuid":account.uuid};
    }else
    {
        params = @{@"shopping_product_id":_productId,@"uuid":@""};
        
    }
    // params = @{@"scenicId":_artic};
    _categoryArr =[[NSMutableArray alloc]init];
    _subjectsArr = [[NSMutableArray alloc]init];
    [NetAccess getJSONDataWithUrl:kNewArticDetail parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        
        int code = [[responseObject objectForKey:@"code"] intValue];
        if (code==0) {
            NSMutableArray *Arr = [[NSMutableArray alloc]init];
            weakSelf.dataSourceDic =[responseObject objectForKey:@"data"];
            weakSelf.productArr = _dataSourceDic[@"product"];
            weakSelf.evaluateArr =_dataSourceDic[@"evaluate"];
            weakSelf.recommendArr =_dataSourceDic[@"recommend"];
            
            weakSelf.invalidProduct = [NSString stringWithFormat:@"%@",_dataSourceDic[@"onSale"]];
            
            if ([weakSelf.invalidProduct isEqualToString:@"0"]){
                //下架
            
            }else if ([weakSelf.invalidProduct isEqualToString:@"1"]){
            //在售
                [weakSelf.view addSubview:_editButton];
            }else if ([weakSelf.invalidProduct isEqualToString:@"2"]){
            //预售
                [weakSelf.view addSubview:_editButton];
            }
            
            [weakSelf payView];
            evaluate=[[NSString stringWithFormat:@"%@",_dataSourceDic[@"evaluate_count"]] intValue];
            for (NSDictionary *tmpDic in _dataSourceDic[@"productDetail"]) {
                categoryModel *model1 = [[categoryModel alloc]initWithDictionary:tmpDic error:nil];
                [weakSelf.categoryArr addObject:model1];
            }
            
            for (NSDictionary *tmpDic in _dataSourceDic[@"subjects"]) {
                userTopicModel *model1 = [[userTopicModel alloc]initWithDictionary:tmpDic error:nil];
                model1.topicId=tmpDic[@"id"];
                [weakSelf.subjectsArr addObject:model1];
            }
            _shareUrlLabel = _dataSourceDic[@"shareUrl"];
            
            _shareTitleLabel =weakSelf.productArr[0][@"product_name"];
            if ([NSString isBlankString:weakSelf.productArr[0][@"head_image"]]) {
               _shareImageLabel =weakSelf.productArr[0][@"head_image"] ;
                _imaShare= [[UIImageView alloc]init];
                [_imaShare sd_setImageWithURL:[NSURL URLWithString:_shareImageLabel]];
            }


            //轮播图相关
            NSMutableArray *ima3 ;
            ima3 =weakSelf.productArr[0][@"images"];
            if (ima3.count!=0) {
                //self.carousel.images =_dataSourceArr[0][@"images"];
                for (NSDictionary *dic in weakSelf.productArr[0][@"images"]) {
                    if ([NSString isBlankString:dic[@"image_url"]]) {
                        NSString *newStr= [dic[@"image_url"] stringByReplacingOccurrencesOfString:@" " withString:@""];
                        [Arr addObject:[NSURL URLWithString:newStr]];
                    }
                    
                }
            }else
            {
                [Arr addObject:[UIImage imageNamed:@"169.png"]];
            }
            weakSelf.carousel.images =Arr;
            
            
            
            if (_productArr.count!=0) {
                bool isLike =  [_productArr[0][@"like_status"] boolValue];
                if (isLike==0 ) {
                    collect=1;
                    [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"shoucang1"] forState:UIControlStateNormal];
                }else
                {
                    collect=2;
                    [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"shoucang3"] forState:UIControlStateNormal];
                    
                }
                
                
                
                      myName= weakSelf.productArr[0][@"recommend_reason"];
                    [self myNamefuntion];
                
            }
            
            
        }
        
        [self.TableView reloadData];
    } fail:^{
        [MBProgressHUD showError:@"请求失败"];
    }];
}





#pragma mark--tableview相关
-(void)setTableview
{
    self.TableView= [[UITableView alloc]initWithFrame: CGRectMake(0, 0, WIDTH, HEIGHT-48) style:UITableViewStyleGrouped];
    self.TableView.alwaysBounceHorizontal = NO;
    self.TableView.alwaysBounceVertical = NO;
    self.TableView.showsHorizontalScrollIndicator = NO;
    self.TableView.showsVerticalScrollIndicator = NO;
    self.TableView.dataSource =self;
    self.TableView.delegate = self;
    self.TableView.bounces=NO;
    self.TableView.tableFooterView=[[UIView alloc]init];
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.TableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.1f)];
    self.TableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:self.TableView];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
    
     if (section== _categoryArr.count+3) {
         return 0.01;
     }
         return 10;
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_subjectsArr.count!=0||evaluate!=0) {
        if (section==_categoryArr.count+1&section!=0) {
            return 50;
        }
    }
   
    if (_recommendArr.count!=0) {
        
        if (section== _categoryArr.count+3) {
 return 60;
        }
    }
    
    return 0.01;
    
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
//    UIView *BackView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 5)];
//    BackView1.backgroundColor = RGBCOLOR(238, 238, 238);
    UIView *BackView1;
    BackView1 = [[UIView alloc]init];
    BackView1.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapg2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap)];
    tapg2.numberOfTapsRequired = 1;
    [BackView1 addGestureRecognizer:tapg2];
    if (_subjectsArr.count!=0||evaluate!=0) {
        if (section==_categoryArr.count+1&section!=0) {
            BackView1.userInteractionEnabled = YES;
            BackView1.frame = CGRectMake(0, 0, WIDTH, 50);
            
            
            
            UIImageView *myImage = [[UIImageView alloc]init];
            myImage.frame = CGRectMake(15, 13, 15, 17);
            myImage.image = [UIImage imageNamed:@"myImage8.png"];
            [BackView1 addSubview:myImage];
            
            UILabel *myLabel = [[UILabel alloc]init];
            myLabel.frame = CGRectMake(CGRectGetMaxX(myImage.frame)+3, 12.5, 120, 20);
            
            myLabel.font = [UIFont systemFontOfSize:17];
            myLabel.textColor =[UIColor colorWithHexString:@"#434343"];
            
            [BackView1 addSubview:myLabel];
            
            
            UIImageView *image1 = [[UIImageView alloc]init];
            image1.image = [UIImage imageNamed:@"right2.png"];
            image1.frame = CGRectMake(WIDTH-15-8, 15, 8, 16);
            [BackView1 addSubview:image1];
            
            
            UILabel *lin1 =[createControl createLineWithFrame:CGRectMake(15, 45, WIDTH-30, 0.5) labelLineColor:[UIColor colorWithHexString:@"#017E44"]];
           [BackView1 addSubview:lin1];
            
            if (_subjectsArr.count!=0) {
                myLabel.text =[NSString stringWithFormat:@"用户评价(%lu)",(unsigned long)_subjectsArr.count];
                UILabel *lin2 =[createControl createLineWithFrame:CGRectMake(15, 49, WIDTH-30, 0.5) labelLineColor:nil];
                [BackView1 addSubview:lin2];
            }else
            {
                myLabel.text =@"用户评价";
            }
            
            
            
            
            
            
            
            
        }
    }
    
    
    if (_recommendArr.count!=0) {
        
        if (section== _categoryArr.count+3) {
            BackView1.userInteractionEnabled = NO;
            
             BackView1.frame = CGRectMake(0, 0, WIDTH, 60);
            
            UILabel *myLabel = [[UILabel alloc]init];
            myLabel.frame = CGRectMake(15, 25, 120, 20);
            
            myLabel.font = [UIFont systemFontOfSize:15];
            myLabel.textColor =[UIColor colorWithHexString:@"#919191"];
            
            myLabel.text =@"为你推荐";
            [BackView1 addSubview:myLabel];
            
            
            UILabel *lin1 =[createControl createLineWithFrame:CGRectMake(15, 59, WIDTH-30, 0.5) labelLineColor:nil];
            [BackView1 addSubview:lin1];
            
            
        }
    }
    
    
   
    
    
            if (section!=_categoryArr.count+1&&section!=_categoryArr.count+3) {
                BackView1.frame = CGRectMake(0, 0, WIDTH, 0);
                
            }
    
    
    return BackView1;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *BackView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 5)];
    BackView1.backgroundColor = RGBCOLOR(238, 238, 238);
    
    return BackView1;
}
#pragma mark  返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _categoryArr.count+4;
    
    //return 1;
}
#pragma mark  每个分区多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return  2;
    }
    if (section<_categoryArr.count+1&section!=0) {
        
        return 1;
        
    }
    
    if (section==_categoryArr.count+1&section!=0) {
        
        return _subjectsArr.count;
        
    }
    
    if (section==_categoryArr.count+2&section!=0) {
        
        return 1;
        
    }
    

    return 1;
}


#pragma mark 改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return [UIScreen mainScreen].bounds.size.width*9/16;
        }
        if (indexPath.row==1) {
            
            if([_invalidProduct isEqualToString:@"2"]){
            
                return 305;
            }
            
            return 205;
        }
    }
    
    if (indexPath.section<_categoryArr.count+1&indexPath.section!=0) {
        Class currentClass = [categoryArticCell class];
        if (_categoryArr.count!=0) {
            model =_categoryArr[indexPath.section-1];
            // 推荐使用此普通简化版方法（一步设置搞定高度自适应，性能好，易用性好）
            return [self.TableView cellHeightForIndexPath:indexPath model:_categoryArr[indexPath.section-1] keyPath:@"categoryModel1" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
            
        }else
        {
            return 20;
        }
        
    }
    
    
    
    if (indexPath.section==_categoryArr.count+1&indexPath.section!=0) {
        Class currentClass = [userTopicCell class];
        if (_subjectsArr.count!=0) {
            userModel =_subjectsArr[indexPath.row];
            // 推荐使用此普通简化版方法（一步设置搞定高度自适应，性能好，易用性好）
            return [self.TableView cellHeightForIndexPath:indexPath model:_subjectsArr[indexPath.row] keyPath:@"userTopicModel1" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
            
        }else
        {
            return 20;
        }
        
    }
    
    if (indexPath.section==_categoryArr.count+2&indexPath.section!=0) {
        
        return 44;
        
    }
    if (_recommendArr.count!=0) {
        NSInteger line=_recommendArr.count/2;
        if (_recommendArr.count%2!=0) {
            line++;
        }
        
        
        
         return 10+160*line+70 +15*(line-1);
        
      //  return 10+160+70;
        
    }else{
        return 0;
    }
    
    
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark 代理数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            static NSString *identifier = @"lunbotu3sdd";
            // 1.缓存中取
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            // 2.创建
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            //设置cell被点击选择时的背景色为无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:self.carousel];
            [cell addSubview:ima11];
            [cell addSubview:artName];
            self.carousel.foucsDelegate = self;
            return cell;
        }
    
        if (indexPath.row==1) {
            newArticDetailCell *cell1 = [newArticDetailCell cellWithTableView:tableView];
            [cell1 setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
            
            if (_productArr.count!=0) {
                [cell1  addValue:_productArr[0] saleType:_invalidProduct];
            }
            
            cell1.delegate=self;
            return cell1;
        }
    }
    
    
    
    
    if (indexPath.section<_categoryArr.count+1&indexPath.section!=0) {
        categoryArticCell *cell = [categoryArticCell cellWithTableView:tableView];
    if (_categoryArr.count!=0) {
        cell.categoryModel1 = _categoryArr[indexPath.section-1];
         __block NSIndexPath *weakIndexPath = indexPath;
        __block categoryArticCell *weakCell     = cell;
        __weak typeof(self)  weakSelf      = self;
        // 点击播放的回调
        cell.playBlock = ^(UIButton *btn){
            model=weakSelf.categoryArr[indexPath.section-1];
            NSMutableArray *arr =model.list;
//            // 分辨率字典（key:分辨率名称，value：分辨率url)
//            NSMutableDictionary *dic = @{}.mutableCopy;
//            for (ZFVideoResolution * resolution in model.playInfo) {
//                [dic setValue:resolution.url forKey:resolution.name];
//            }
            
            // 取出字典中的第一视频URL
            NSURL *videoURL = [NSURL URLWithString:arr[btn.tag-3000][@"content"]];
            
            ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
            playerModel.title            = @"视频";
            playerModel.videoURL         = videoURL;
            playerModel.placeholderImageURLString = arr[btn.tag-3000][@"bigcategoryName"];
            playerModel.scrollView       = weakSelf.TableView;
            playerModel.indexPath        = weakIndexPath;
            // 赋值分辨率字典
            //playerModel.resolutionDic    = dic;
            // player的父视图tag
            UIImageView *myview = (UIImageView *)[weakCell viewWithTag:btn.tag-3000+50000];
            playerModel.fatherView = myview;
            
            // 设置播放控制层和model
            [weakSelf.playerView playerControlView:nil playerModel:playerModel];
            
            // 下载功能
            weakSelf.playerView.hasDownload = NO;
            // 自动播放
            [weakSelf.playerView autoPlayTheVideo];
        };
        
    }
        
    
    return cell;
        
    }
    if (indexPath.section==_categoryArr.count+1&indexPath.section!=0) {
    userTopicCell *cell = [userTopicCell cellWithTableView:tableView];
    if (_subjectsArr.count!=0) {
        cell.userTopicModel1 = _subjectsArr[indexPath.row];
    }
    cell.collectBtn.tag =indexPath.row+2000;
    cell.delegate=self;
    return cell;
        
    }
    
    if (indexPath.section==_categoryArr.count+2&indexPath.section!=0) {
        shopCell *cell = [shopCell cellWithTableView:tableView];
        
        
        return cell;
        
    }
    
    
    
    
    RecommendCell *cell5 = [RecommendCell cellWithTableView:tableView];
    [cell5 setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    if (_recommendArr.count!=0) {
        [cell5 addValue:_recommendArr];
    }
    cell5.myClick = ^(NSString *proID) {
        
        
        //友盟统计
        [MobClick event:@"82"];
        commodityDetailViewController *vc =[[commodityDetailViewController alloc]init];
        vc.commodityID=[NSString stringWithFormat:@"%@",proID];
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    return cell5;
    
//    goodDetailsTableViewCell *cell2 = [goodDetailsTableViewCell cellWithTableView:tableView];
//    [cell2 setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
//    if (_recommendArr.count!=0) {
//        [cell2 addValue:_recommendArr];
//    }
//    cell2.delegate=self;
//    return cell2;

    
    
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        //_playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = YES;
        
        // 当cell划出屏幕的时候停止播放
         _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==_categoryArr.count+1&indexPath.section!=0) {
        TLCommodityTopicDetailsViewController *VC = [[TLCommodityTopicDetailsViewController alloc]init];
         
        if (_subjectsArr.count!=0) {
            userTopicModel *model1 =_subjectsArr[indexPath.row];
            NSString *str=[NSString stringWithFormat:@"%@",model1.topicId];
            VC.topicID=str;
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }

    if (indexPath.section==_categoryArr.count+2&indexPath.section!=0) {
        
        NSDictionary *dic= _productArr[0][@"shops"];
        NSString *shop = [NSString stringWithFormat:@"%@",dic[@"shop_id"]];
        shopsViewController *shopVC = [[shopsViewController alloc]init];
        shopVC.title =dic[@"shop_name"];
        shopVC.shop_ID =shop;
        [self.navigationController pushViewController:shopVC animated:YES];

    }
    
}

#pragma mark--轮播图相关
- (LZBInifiteScrollView *)carousel
{
    if(_carousel == nil)
    {
        _carousel = [[LZBInifiteScrollView alloc]init];
        _carousel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16);
        [_carousel setPageControlCurrentImage:[UIImage imageNamed:@"page2.png"] OtherImage:[UIImage imageNamed:@"page1.png"] ];
        
        ima11 =[LXTControl createImageViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width*9/16) ImageName:@"detail3"];
        
    }
    return _carousel;
}

- (void)lzbInifiteScrollView:(LZBInifiteScrollView *)foucsScrollView didSelectScrollViewIndex:(NSInteger)index
{
    NSLog(@"----%@,点击了第几张图片%ld",foucsScrollView,index);
}


//商品属性跳转
-(void)jumpPro
{
    productAttributeViewController *vc =[[productAttributeViewController alloc]init];
    vc.productID=_productId;
    vc.dataSource=_productArr;
    if ([NSString isBlankString:_invalidProduct]) {
        vc.invalidProduct=_invalidProduct;
    }
    [self.navigationController pushViewController:vc animated:YES];


}


-(void)imageSelect:(NSInteger)index cell:(userTopicCell *)cell{

    

    if (index < cell.userTopicModel1.images.count){
    
        TLImageBrowseViewController * vc = [[TLImageBrowseViewController alloc] init];
        
        vc.currentIndex = index;
        vc.dataArray = cell.userTopicModel1.images;
       
        [self.navigationController pushViewController:vc animated:YES];

    }
}


#pragma mark--点击推荐商品代理事件
-(void)IsseceltView:(NSInteger )proID
{
//    //友盟统计
    [MobClick event:@"82"];
    
    commodityDetailViewController *vc =[[commodityDetailViewController alloc]init];
    vc.commodityID=[NSString stringWithFormat:@"%ld",proID];
    [self.navigationController pushViewController:vc animated:YES];
    

    
}

-(void)IsseceltView1:(NSInteger )proID
{
//    //友盟统计
    [MobClick event:@"82"];
   
    commodityDetailViewController *vc =[[commodityDetailViewController alloc]init];
    vc.commodityID=[NSString stringWithFormat:@"%ld",proID];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}





#pragma 查看品牌故事代理事件
-(void)btnClick2:(UIButton *)sender  ID:(NSString *)brandID
{
    
    sender.userInteractionEnabled=NO;
    //友盟统计
    [MobClick event:@"78"];
    NSDictionary *params;
    params = @{@"brand_id":brandID};
    
    [NetAccess getJSONDataWithUrl:kBrandStory parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        NSLog(@"成功");
        
        NSMutableDictionary *dic1 ;
        dic1 = [responseObject objectForKey:@"brand"];
        
        BrandView.delegate = self;
        
        
        if (dic1) {
            [BrandView popBrandView:dic1 control:self];
        }        sender.userInteractionEnabled=YES;
        
    } fail:^{
        [MBProgressHUD showError:@"失败"];
        
    }];
    
    
}
#pragma 查看品牌店铺代理事件
-(void)BrandStorySelect2:(NSString *)BrandID name:(NSString *)string;
{
    //友盟统计
    [MobClick event:@"77"];
    NSLog(@"dsfsdf");
    brandShopViewController *vc =[[brandShopViewController alloc]init];
    vc.brand_ID =BrandID;
    vc.brand_name =string;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--跳转话题列表页
-(void)commentTap
{
    TLCommodityTopicAndCommentViewController *vc = [[TLCommodityTopicAndCommentViewController alloc]init];
    vc.commodityID =_productId;
    vc.commodityTitle = _shareTitleLabel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--跳转分享列表页
-(void)shareJupm:(NSMutableDictionary *)dic
{
    //分享数据获取
   NSString*  shareUrlLabel = dic[@"shareUrl"];
    NSString *shareImageLabel =dic[@"image"];
    NSString *shareTitleLabel =dic[@"title"];
    
    
      UIImageView * imaShare= [[UIImageView alloc]init];
    [imaShare sd_setImageWithURL:[NSURL URLWithString:shareImageLabel]];
    
    popupMenuView *shareView =[[popupMenuView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    [shareView sharecontrol:self title:shareTitleLabel urlString:shareUrlLabel  titleImage:imaShare.image dic:dic ];



}


//收藏kCANCEL_COLLECT_LIKE
- (void)requestAlert:(NSString *)URL message:(NSString *)message
{
    
    
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params = @{@"product_id":_productId,@"uuid":account.uuid};
    [NetAccess getJSONDataWithUrl:URL parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id json) {
        NSString *str = [NSString stringWithFormat:@"%@",[json objectForKey:@"status"]];
        if ([str isEqualToString:@"200"]) {
            NSString *str1 = [NSString stringWithFormat:@"%@",[json objectForKey:@"message"]];
            [MBProgressHUD showSuccess:str1];
        }
        // NSLog(@"sadasndl");
    } fail:^{
        NSLog(@"shibaodsa");
    }];
}



#pragma mark--更多菜单管理
-(void)showDownList:(CGPoint *)point{
    
    NSArray *Arr = @[@"消息",@"最近浏览",@"返回首页",@"个人中心"];
    NSArray *imageArr = @[@"menu1.png",@"recent.png",@"menu3.png",@"TL_personCenterIcon",@"menu4.png"];
    __weak typeof(self)weakSelf=self;
    if (!_menu) {
        _menu=[[sanjiao alloc]initWithNameArray:Arr andMenuOrigin:*point andMenuWidth:100 andHeight:44 andLayer:4 andTableViewBackGroundColor:[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:1.0f] andIsSharp:YES andType:ksortPop imageArr:imageArr isNews:isNews];
        //_menu.delegate=self;
        _menu.tableViewDelegate=self;
        _menu.dismiss=^(){
            
            [weakSelf.menu removeFromSuperview];
            _menu=nil;
        };
        [ [ [ UIApplication  sharedApplication ]  keyWindow ] addSubview : _menu] ;
        
        
        // [self.view addSubview:_menu];
    }else
    {
        [_menu dismissWithCompletion:^(sanjiao *create) {
            [weakSelf.menu removeFromSuperview];
            weakSelf.menu=nil;
        }];
        
    }
}

#pragma mark--自定义下拉菜单代理方法,点击下拉菜单某一行时候对应的响应时间，点击完成后试图要消失，用一个block通知；
-(void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath andPopType:(popType)popViewType{
    //改变导航栏文字
    if (popViewType==kNavigationPop) {
        // [labelBUtton setTitle:_titleNameArray[indexPath.row] forState:UIControlStateNormal];
    }
    if (popViewType==ksortPop) {
        if (indexPath.row==0) {
            NSLog(@"点击排序后要做的事情000000");
            TLAccount *account = [TLAccountSave account];
            
            if (account.uuid!=nil) {
                myMessageViewController *vc = [[myMessageViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else
            {
                normalLoginVC *mainVc = [[normalLoginVC alloc]init];
                UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:mainVc];
                [self presentViewController:nv animated:YES completion:nil];
                
            }
        }
        
        if (indexPath.row==1) {
            NSLog(@"点击排序后要做的事情1111111");
            TLAccount *account = [TLAccountSave account];
            NSDictionary *params;
            if (account.uuid!=nil) {
                params =  @{@"uuid":account.uuid};
                
                
                [NetAccess getJSONDataWithUrl:kArticleHis parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id json) {
                    int code = [[[json objectForKey:@"header"]objectForKey:@"code"] intValue];
                    
                    if (code==0) {
                        NSMutableArray *arr =[[NSMutableArray alloc]init];
                        
                        arr=[json objectForKey:@"date"];
                        if (arr.count==0) {
                            [MBProgressHUD showSuccess:@"暂时没有浏览记录"];
                            return ;
                        }
                        newRecentPopView *Recent =[[newRecentPopView  alloc]initWithFrame:CGRectMake(0, kScreenH-64, kScreenW, kScreenH)];
                        Recent.delegate =self;
                        [Recent productPopView:arr control:self];
                    }else
                    {
                        [MBProgressHUD showSuccess:@"暂时没有浏览记录"];
                    }
                    
                } fail:^{
                    NSLog(@"失败");
                }];
            }else
            {
                normalLoginVC *mainVc = [[normalLoginVC alloc]init];
                UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:mainVc];
                [self presentViewController:nv animated:YES completion:nil];
            }

        }
        
        if (indexPath.row==2) {
            NSLog(@"点击排序后要做的事情1111111");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
        if (indexPath.row == 3){
        
            [self.navigationController popToRootViewControllerAnimated:YES];
            AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [app.tab showLeftView];
        }
    }
    [_menu dismissWithCompletion:nil];//点击完成后视图消失;
}


#pragma mark--网络请求(角标)
- (void)requestData1
{
    
    
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid != nil) {
        params = @{@"uuid":account.uuid};
        [NetAccess getJSONDataWithUrl:kPDetail parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
            int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
            if (code==0) {
                NSString *a=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"date"] ];
                MarkCount =[a intValue];
                NSLog(@"%d  %@",MarkCount,a);
                if (MarkCount>0) {
                    cornerMark.font=[UIFont systemFontOfSize:11];
                    if (MarkCount>9) {
                        cornerMark.text = @"...";
                    }else
                    {
                        cornerMark.text = [NSString stringWithFormat:@"%d",MarkCount];
                        
                    }
                    cornerMark.frame = CGRectMake(carButton.frame.origin.x+16, carButton.frame.origin.y+5, [NSString singeWidthForString:cornerMark.text fontSize:11 Height:20]+5, [NSString singeWidthForString:cornerMark.text fontSize:11 Height:20]+5);
                    cornerMark.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                    cornerMark.layer.masksToBounds=YES;
                    cornerMark.layer.cornerRadius=cornerMark.frame.size.width/2;
                    cornerMark.textAlignment = NSTextAlignmentCenter;
                    cornerMark.backgroundColor = [UIColor colorWithHexString:@"#FF5C36"];
                    cornerMark.hidden=NO;
                    [_topView addSubview:cornerMark];
                }else
                {
                    cornerMark.hidden=YES;
                }
                
                
            }
            
            
        } fail:^{
            // [MBProgressHUD showError:@"请求失败"];
            
        }];
    }
    
}





#pragma mark--底部视图
-(void)payView
{
    if ([_invalidProduct isEqualToString:@"0"]) {
        
        UILabel *backView = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenH-48, kScreenW, 48)];
        backView.backgroundColor = RGBCOLOR(198, 198, 198);
        backView.text=@"已下架";
        backView.textColor = [UIColor colorWithHexString:@"#ffffff"];
        backView.textAlignment = NSTextAlignmentCenter;
        backView.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:backView];
    }else {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-48, kScreenW, 48)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];
        
        UILabel *linAb= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
        linAb.backgroundColor = RGBCOLOR(198, 198, 198);
        [backView addSubview:linAb];
        
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake((73-20)/2, 6, 20, 24)];
        [image1 setImage:[UIImage imageNamed:@"kefu.png"]];
        [backView addSubview:image1];

        UILabel *shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 73, 18)];
        shopLabel.textColor = [UIColor colorWithHexString:@"#B2B2B2"];
        shopLabel.text = @"客服";
        shopLabel.textAlignment = NSTextAlignmentCenter;
        shopLabel.font = [UIFont systemFontOfSize:12.0];
        [backView addSubview:shopLabel];
        if ([_invalidProduct isEqualToString:@"1"]){
    
            UIButton *shopbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 73, 48)];
            //[btn setBackgroundColor:[UIColor colorWithHexString:@"#F0C01F"]];
            [shopbtn addTarget:self action:@selector(shopbtn:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:shopbtn];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(shopLabel.frame.size.width, 0, (kScreenW-shopLabel.frame.size.width)/2, 48)];
            [btn setTitle:@"加入购物车" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
            btn.tag =5009;
            [btn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
            [btn addTarget:self action:@selector(shopCartBtn:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];
            
            
            UIButton *payBtn = [[UIButton alloc]initWithFrame:CGRectMake( kScreenW-(kScreenW-shopLabel.frame.size.width)/2, 0, (kScreenW-shopLabel.frame.size.width)/2, 48)];
            [payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            [payBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
            payBtn.tag =5001;
            [payBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            [payBtn setBackgroundColor:[UIColor colorWithHexString:@"#017e44"]];
            [payBtn addTarget:self action:@selector(payBtn:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:payBtn];
        
     }else if ([_invalidProduct isEqualToString:@"2"] ){
         UIButton *payBtn = [[UIButton alloc]initWithFrame:CGRectMake( shopLabel.frame.size.width + shopLabel.frame.origin.x, 0, kScreenW-shopLabel.frame.size.width , 48)];
         [payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
         [payBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
         [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         payBtn.tag =5001;
         [payBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5C36"]];
         [payBtn addTarget:self action:@selector(payBtn:) forControlEvents:UIControlEventTouchUpInside];
         [backView addSubview:payBtn];

        
     }
    }
}
#pragma mark--加入购物车
-(void)shopCartBtn:(UIButton *)sender
{    chooseType=0;
    NSMutableArray *arr11=_productArr[0][@"product_spec"];;
    NSString *photo1 =_shareImageLabel ;
    parameterPopView *VC = [[parameterPopView alloc]init];
    VC.delegate = self;
    [VC popParameterView:arr11 control:self photo:photo1 actionX:carButton.frame];
    
    
}
-(void)payBtn:(UIButton *)sender
{
    //友盟统计
    [MobClick event:@"86"];
    chooseType=1;
    NSMutableArray *arr11=_productArr[0][@"product_spec"];;
    NSString *photo1 =_shareImageLabel ;
    parameterPopView *VC = [[parameterPopView alloc]init];
    VC.delegate = self;
    [VC popParameterView:arr11 control:self photo:photo1 ];
    
}

#pragma mark--添加购物车代理事件
-(void)addShopCart:(NSString *)count1 valueStr:(NSString *)valueStr
{
    //友盟统计
    [MobClick event:@"85"];
    TLAccount *account = [TLAccountSave account];
    
    if (account.uuid!=nil) {
        
        if (![NSString isBlankString:valueStr]) {
            valueStr=@"0";
        }
        if (_productArr.count!=0) {
            NSString *product_ID = _productId;
            
            NSDictionary *params1;
            if (account.uuid != nil) {
                params1 = @{@"productId":product_ID,@"uuid":account.uuid,@"count":count1,@"specId":valueStr};
            }else
            {
                [MBProgressHUD showSuccess:@"请先登录"];
            }
            
            [NetAccess getJSONDataWithUrl:kShopCount parameters:params1 WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
                int code1 = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
                if (code1==0) {
                    
                    if (chooseType==0) {
                        
                        NSDictionary *params;
                        if (account != nil) {
                            params = @{@"productId":product_ID,@"uuid":account.uuid,@"count":count1,@"specId":valueStr};
                        }else
                        {
                            [MBProgressHUD showSuccess:@"请先登录"];
                            
                        }
                        [NetAccess getJSONDataWithUrl:kShopCartAdd parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
                            int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
                            if (code==0) {
                                // [MBProgressHUD showSuccess:@"加入购物车成功"];
                                [self requestData1];
                            }else
                            {
                                [MBProgressHUD showError:@"加入购物车失败"];
                            }
                            
                        } fail:^{
                            [MBProgressHUD showError:@"加入购物车失败"];
                            
                        }];
                        
                    }else
                    {
                        
                        TLAccount *account = [TLAccountSave account];
                        //                        NSDictionary *params;
                        if (account.uuid != nil) {
                            //params = @{@"product_id":product_ID,@"uuid":account.uuid,@"product_count":count1,@"value_id":valueStr};
                            
                            
                            //立即购买跳转
                            nowBuyOrderViewController *vc = [[nowBuyOrderViewController alloc]init];
                            
                            vc.productID =[NSString stringWithFormat:@"%@",product_ID];
                            vc.productCount = count1;
                            vc.spec_id = valueStr;
                            [self.navigationController pushViewController:vc animated:YES];
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                if (code1==70004) {
                    [MBProgressHUD showError:@"商品库存不足"];
                }
                
            } fail:^{
                [MBProgressHUD showError:@"加入购物车失败"];
                
            }];
            
            
            
            
            
            
            
            
            
        }
        
        
    }else
    {
        
        [self login];
        
        
    }
    
}


#pragma mark--话题收藏代理事件
-(void)collectJupm:(UIButton *)myBtn
{
    userTopicModel *myModel =[[userTopicModel alloc]init];
    myModel=_subjectsArr[myBtn.tag-2000];
    
    if (myModel.isCollect) {
        myModel.isCollect=NO;
        myModel.collectNum =[NSString stringWithFormat:@"%d",[myModel.collectNum intValue]-1];
        
    }else
    {
    
      myModel.isCollect=YES;
    myModel.collectNum =[NSString stringWithFormat:@"%d",[myModel.collectNum intValue]+1];
    }
    [self collectData:[NSString stringWithFormat:@"%@",myModel.topicId] isCollect:myModel.isCollect];
    [self.TableView reloadData];
}


#pragma mark--话题收藏接口
- (void)collectData:(NSString *)topicId isCollect:(BOOL)Collect
{
    
    
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid != nil) {
        params = @{@"uuid":account.uuid,@"topicId":topicId};
        [NetAccess getJSONDataWithUrl:kTopicCollect parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
            int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
            if (code==0) {
                if (Collect) {
                    [MBProgressHUD showSuccess:@"收藏成功"];
                }else
                {
                [MBProgressHUD showSuccess:@"取消收藏成功"];
                }
                
            }
            
            
        } fail:^{
             [MBProgressHUD showError:@"请求失败"];
            
        }];
    }    
}

#pragma mark--客服功能
-(void)shopbtn:(UIButton *)sender
{
    //友盟统计
    [MobClick event:@"84"];
    TLAccount *account = [TLAccountSave account];
    if (account.uuid!=0){
        
        chatViewController *vc = [[chatViewController alloc]initWithConversationChatter:@"tuling" conversationType: EMConversationTypeChat];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        
        [self login];
    }
    
    
}

/**
 点击头像跳转
 
 @param userId <#userId description#>
 */
-(void)selectMy:(NSString *)userId
{
    TLAccount *account = [TLAccountSave account];
    if (account.uuid.length==0) {
        [self login];
        return;
    }
    MyAttentionDetailVC *detailVC = [[MyAttentionDetailVC alloc]init];
    detailVC.userId = [NSString stringWithFormat:@"%@",userId];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


#pragma mark--最近浏览点击跳转

-(void)DidSelectRowAtIndexPath:(NSString *)productID jumpType:(NSString*)myType
{
    NSString *latitude;
    NSString *longtitude;
    NSDictionary *dic = [StaticTools GetMapinformation];
    if (dic!=nil) {

        latitude = [dic objectForKey:@"latitude"];
        longtitude = [dic objectForKey:@"longtitude"];
    
    }
   //0好吃 1好玩 2 可淘 3商品
    
    if ([myType isEqualToString:@"0"]) {
        //好吃
        chiWanDetailViewController *vc=[[chiWanDetailViewController alloc]init];
        vc.artic =productID;
        vc.mold=myType;
        vc.longitude=longtitude;
        vc.latitude=latitude;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if ([myType isEqualToString:@"1"])
    {
        //好玩
        chiWanDetailViewController *vc=[[chiWanDetailViewController alloc]init];
        vc.artic =productID;
        vc.mold=myType;
        vc.longitude=longtitude;
        vc.latitude=latitude;
        [self.navigationController pushViewController:vc animated:YES];

    }else if ([myType isEqualToString:@"2"])
    {
        //可淘
        
        articleDetailViewController *vc=[[articleDetailViewController alloc]init];
        vc.artic =productID;
        [self.navigationController pushViewController:vc animated:YES];
    
    
    }else
    {
        //商品
        commodityDetailViewController *vc = [[commodityDetailViewController alloc]init];
        vc.commodityID=productID;
        [self.navigationController pushViewController:vc animated:YES];
    
    
    
    }




}


- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

@end
