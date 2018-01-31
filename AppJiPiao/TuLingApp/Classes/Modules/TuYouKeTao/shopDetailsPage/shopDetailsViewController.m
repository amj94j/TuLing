//
//  shopDetailsViewController.m
//  TuLingApp
//
//  Created by hua on 16/11/8.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "shopDetailsViewController.h"
#import "productCommentViewController.h"
#import "DetailTableViewCell.h"
#import "LZBInifiteScrollView.h"
#import "UIColor+ColorChange.h"
#import "goodDetailsTableViewCell.h"
#import "NSString+StrCGSize.h"
#import "comment1TableViewCell.h"
#import "FMLStarView.h"
#import "sanjiao.h"
#import "popupMenuView.h"
#import "TripServiceViewController.h"
#import "shopCartViewController.h"
#import "shopsViewController.h"
#import "confirmOrdersViewController.h"
#import "RecentPopView.h"
#import "BrandStoryView.h"
#import "productsPopView.h"
#import "parameterPopView.h"
#import "BrandStoryView.h"
#import "nowBuyOrderViewController.h"
#import "brandShopViewController.h"
#import "productAttributeViewController.h"

#import "confirmOrdersViewController.h"

#import "submitCommentViewController.h"
#import "payResultViewController.h"
#import "chatViewController.h"
#import "myMessageViewController.h"
#import "newArticDetailVC.h"
#define kColor(r , g ,b) [UIColor colorWithRed:(r)/255.0  green:(g)/255.0  blue:(b)/255.0 alpha:1]
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
@interface shopDetailsViewController ()<LZBInifiteScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,FMLStarViewDelegate,SCXCreatePopViewDelegate,goodDetailsTableViewCellDelegate,parameterPopViewDelegate,DetailTableViewCellDelegate,BrandStoryViewDelegate>
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
    NSString *evaluate_count;
    UILabel *labelCon;
    int chooseType;
    UIImageView *ima11;
    UIImageView *imaShare;
    UILabel *changeLine;
    UILabel *cornerMark;
    int MarkCount;
    BrandStoryView *BrandView;
    

}

@property(nonatomic,strong)sanjiao *menu;
@property (nonatomic, strong) LZBInifiteScrollView *carousel;
@property(nonatomic,strong)UITableView *TableView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,copy)NSMutableArray *dataSourceArr;
@property(nonatomic,copy)NSMutableArray *evaluateArr;
@property(nonatomic,copy)NSMutableArray *recommendArr;
@property(nonatomic,copy)NSMutableArray *SpecificationArr;
@property (nonatomic, strong) FMLStarView *starView;

@property(nonatomic,strong)NSString *shareTitleLabel;
@property(nonatomic,strong)NSString *shareImageLabel;
@property(nonatomic,strong)NSString *shareUrlLabel;


@end

@implementation shopDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    collect=1;
    MarkCount=0;
    chooseType=0;
     labelCon = [[UILabel alloc]init];
    contentstr = [[NSString alloc]init];
    _SpecificationArr= [[NSMutableArray alloc]init];
    evaluate_count=0;
    contentstrHeight=0;
    _recommendArr = [[NSMutableArray alloc]init];
    _evaluateArr = [[NSMutableArray alloc]init];
    _dataSourceArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setTableview];
    
    [self requestData];
    
   
    
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
    
    shoucangBtn = [LXTControl createButtonWithFrame:CGRectMake(shareBtn.frame.origin.x-30-10, moreBtn.frame.origin.y, 30,30) ImageName:@"shoucang1" Target:self Action:@selector(shoucangClick:) Title:@""];
    [_topView addSubview:shoucangBtn];
    
    carButton = [LXTControl createButtonWithFrame:CGRectMake(shoucangBtn.frame.origin.x-30-10, moreBtn.frame.origin.y, 30,30) ImageName:@"car1" Target:self Action:@selector(carClick:) Title:@""];
    [_topView addSubview:carButton];
    
    
    cornerMark = [[UILabel alloc]init];
    
    
    
    BrandView =[[BrandStoryView alloc]initWithFrame:CGRectMake(0, kScreenH-64, kScreenW, kScreenH)];
    [self payView];
    
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
    popupMenuView *shareView =[[popupMenuView alloc]initWithFrame:CGRectMake(0, kScreenH-64, kScreenW, kScreenH)];
     [shareView sharecontrol:self title:_shareTitleLabel urlString:_shareUrlLabel  titleImage:imaShare.image];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
     self.navigationController.navigationBar.hidden = YES;
    
    alpha2=0;
    isNews=0;
    [self requestData1];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
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
-(void)setTableview
{
    self.TableView= [[UITableView alloc]initWithFrame: CGRectMake(0, 0, kScreenW, kScreenH-48) style:UITableViewStyleGrouped];
    self.TableView.alwaysBounceHorizontal = NO;
    self.TableView.alwaysBounceVertical = NO;
    self.TableView.showsHorizontalScrollIndicator = NO;
    self.TableView.showsVerticalScrollIndicator = NO;
    self.TableView.dataSource =self;
    self.TableView.delegate = self;
    //self.TableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.TableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.1f)];
    //self.TableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.TableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([evaluate_count intValue]!=0) {
        if (section==5)
        {
            return 0.1;
        }
        return 10;
    }else
    {
    
        if (section==4)
        {
            return 0.1;
        }
        return 10;
    }
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     if ([evaluate_count intValue]!=0) {
    if (section==0){
        return 0.01;
    }
    if (section==3){
        return 0.01;
    }
    
        return 60;
     }else
     {
         if (section==0){
             return 0.01;
         }
         if (section==2){
             return 0.01;
         }
         
         return 60;
     
     }
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section

{
    
    view.tintColor = kColor(238, 238, 238);
    
}
#pragma mark头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if ([evaluate_count intValue]!=0) {
    if (section==1||section==2||section==4||section==5) {
        
        NSMutableArray *leftArr = [[NSMutableArray alloc]initWithObjects:@"推荐理由",@"商家介绍",@"为你推荐",nil];
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.userInteractionEnabled = YES;

        UILabel *shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, kScreenW-100, 20)];
        shopLabel.textColor = [UIColor colorWithHexString:@"#919191"];
        shopLabel.textAlignment = NSTextAlignmentLeft;
        shopLabel.font = [UIFont systemFontOfSize:15.0];
        [headerView addSubview:shopLabel];
        if (section==1) {
            shopLabel.text = leftArr[0];
        }
        if (section==2) {
            if (_dataSourceArr.count!=0) {
                     shopLabel.text = [NSString stringWithFormat:@"商品评价(%@)",evaluate_count];
                shopLabel.textColor = [UIColor colorWithHexString:@"#434343"];
                 
            }
            
            UITapGestureRecognizer *tapg2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap)];
            tapg2.numberOfTapsRequired = 1;
            [headerView addGestureRecognizer:tapg2];
            
        }
        if (section==4) {
            shopLabel.text = leftArr[1];
            UITapGestureRecognizer *tapg1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shoptap)];
            tapg1.numberOfTapsRequired = 1;
            [headerView addGestureRecognizer:tapg1];
            shopLabel.textColor = [UIColor colorWithHexString:@"#434343"];
        }
        if (section==5) {
            shopLabel.text = leftArr[2];
        }
        
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(15, 59.5, kScreenW-30, 0.4)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"C6C6C6"];
        [headerView addSubview:lineView];
        
    if (section==2||section==4) {
            
       UIImageView *photoView2 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-25, 27.5, 8, 16)];
        [photoView2 setImage:[UIImage imageNamed:@"right2.png"]];
        [headerView addSubview:photoView2];
        

        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(photoView2.frame.origin.x-5- 120, 25, 120, 20)];
        rightLabel.textColor = [UIColor colorWithHexString:@"#919191"];
        //rightLabel.text = rightArr[section-2];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:13.0];
        if (section==2) {
           rightLabel.text = @"查看全部";
        }
        if (section==4) {
            rightLabel.text = @"进入商家店铺";
        }
        [headerView addSubview:rightLabel];
        }
        
        return  headerView;
    }
        
    }else
    {
        if (section==1||section==3||section==4) {
            
            NSMutableArray *leftArr = [[NSMutableArray alloc]initWithObjects:@"推荐理由",@"商家介绍",@"为你推荐",nil];
            UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
            headerView.backgroundColor = [UIColor whiteColor];
            headerView.userInteractionEnabled = YES;
            
            UILabel *shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, kScreenW-100, 20)];
            shopLabel.textColor = [UIColor colorWithHexString:@"#919191"];
            shopLabel.textAlignment = NSTextAlignmentLeft;
            shopLabel.font = [UIFont systemFontOfSize:15.0];
            [headerView addSubview:shopLabel];
            if (section==1) {
                shopLabel.text = leftArr[0];
            }
                       if (section==3) {
                shopLabel.text = leftArr[1];
                shopLabel.textColor = [UIColor colorWithHexString:@"#434343"];
                UITapGestureRecognizer *tapg1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shoptap)];
                tapg1.numberOfTapsRequired = 1;
                [headerView addGestureRecognizer:tapg1];
            }
            if (section==4) {
                shopLabel.text = leftArr[2];
            }
            
            UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(15, 59.5, kScreenW-30, 0.4)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"C6C6C6"];
            [headerView addSubview:lineView];
            
            if (section==3) {
                
                UIImageView *photoView2 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-25, 27.5, 8, 16)];
                [photoView2 setImage:[UIImage imageNamed:@"right2.png"]];
                [headerView addSubview:photoView2];
                shopLabel.textColor = [UIColor colorWithHexString:@"#434343"];
                
                UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(photoView2.frame.origin.x-5- 120, 25, 120, 20)];
                rightLabel.textColor = [UIColor colorWithHexString:@"#919191"];
                //rightLabel.text = rightArr[section-2];
                rightLabel.textAlignment = NSTextAlignmentRight;
                rightLabel.font = [UIFont systemFontOfSize:13.0];
                if (section==3) {
                    rightLabel.text = @"进入商家店铺";
                }
                [headerView addSubview:rightLabel];
            }
            
            return  headerView;
        }

    
    }
    return nil;
    
}

#pragma mark  返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   if ([evaluate_count intValue]!=0) {
    return 6;
   }else
   {
   return 5;
   }
}

#pragma mark  每个分区多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return  2;
    }
    return  1;
}
#pragma mark 改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([evaluate_count intValue]!=0) {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return [UIScreen mainScreen].bounds.size.width*9/16;
        }
        if (indexPath.row==1) {
            return 195;
        }
    }
    if (indexPath.section==1) {
         return 44;
    }
    if (indexPath.section==2) {
        return 100;
    }
    if (indexPath.section==3) {
        return 44;
    }
    if (indexPath.section==4) {
        return contentstrHeight+24;
    }
          return 240;
   
    }else
    {
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                return [UIScreen mainScreen].bounds.size.width*9/16;
            }
            if (indexPath.row==1) {
                return 195;
            }
        }
        if (indexPath.section==1) {
            return 44;
        }
       
        if (indexPath.section==2) {
            return 44;
        }
        if (indexPath.section==3) {
            return contentstrHeight+24;
        }
        return 240;

    
    }
}
#pragma mark 代理数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSAttributedString *string;
    if (contentstr.length!=0) {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    //style.lineSpacing = 6;
    //string = [[NSAttributedString alloc]initWithString:contentstr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:style,NSKernAttributeName:@1.5}];
      string = [[NSAttributedString alloc]initWithString:contentstr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:style}];
    }

    [self.TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (indexPath.section==0) {
    if (indexPath.row==0) {
        static NSString *identifier = @"lunbotusdd";
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
        self.carousel.foucsDelegate = self;
        return cell;
    }
    if (indexPath.row==1) {
        DetailTableViewCell *cell1 = [DetailTableViewCell cellWithTableView:tableView];
        [cell1 setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        
        if (_dataSourceArr.count!=0) {
             [cell1  addValue:_dataSourceArr[0]];
        }
        cell1.delegate=self;
        return cell1;
    }
    }
    if (indexPath.section==1) {
        static NSString *identifier = @"lunbotu1";
        // 1.缓存中取
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        // 2.创建
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        //设置cell被点击选择时的背景色为无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *contentLabel;
        if (contentLabel==nil) {
             contentLabel = [[UILabel alloc]init];
        }
       
        contentLabel.frame = CGRectMake(15, 12, kScreenW-30, 20);
        contentLabel.textColor = [UIColor colorWithHexString:@"#6DCB99"];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont systemFontOfSize:15.0];
        contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        if (_dataSourceArr.count!=0) {
            NSString *a = _dataSourceArr[0][@"recommend_reason"];
            if ([NSString isBlankString:a]) {
                 contentLabel.text = _dataSourceArr[0][@"recommend_reason"];
            }
        }
        [cell addSubview:contentLabel];
        return cell;

    }
    if ([evaluate_count intValue]!=0) {
    if (indexPath.section==3) {
        static NSString *identifier = @"lunbotu2";
        // 1.缓存中取
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        // 2.创建
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        //设置cell被点击选择时的背景色为无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"商品详情";
        cell.textLabel.textColor =[UIColor colorWithHexString:@"#434343"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        UIImageView *photoView2;
        if (photoView2==nil) {
            photoView2 = [[UIImageView alloc]init];
        }
        photoView2.frame =CGRectMake(kScreenW-23, 14, 8, 16);
        [photoView2 setImage:[UIImage imageNamed:@"right2.png"]];
        [cell addSubview:photoView2];
        return cell;

    }
    if (indexPath.section==4) {
        static NSString *identifier = @"lunbotu3";
        // 1.缓存中取
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        // 2.创建
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        //设置cell被点击选择时的背景色为无色
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UILabel *labelCon;
//        if (labelCon==nil) {
//            labelCon = [[UILabel alloc]init];
//            
//        }
        
        labelCon.frame =CGRectMake(15, 12, WIDTH-30, contentstrHeight);
       // [NSString setLabelSpace1:labelCon withValue:contentstr withFont:[UIFont systemFontOfSize:15]];
        labelCon.textColor = [UIColor colorWithHexString:@"#919191"];
        //labelCon.textAlignment = NSTextAlignmentLeft;
        labelCon.numberOfLines =0;
        
//        labelCon.font = [UIFont systemFontOfSize:15.0];
//        labelCon.lineBreakMode = NSLineBreakByTruncatingTail;
        //labelCon.backgroundColor = [UIColor redColor];
        if (string.length!=0) {
           labelCon.attributedText = string;
            labelCon.text = contentstr;
        }
        
        [cell addSubview:labelCon];
        
        return cell;

        
    }
    if (indexPath.section==5) {
        goodDetailsTableViewCell *cell2 = [goodDetailsTableViewCell cellWithTableView:tableView];
        [cell2 setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        if (_recommendArr.count!=0) {
            [cell2 addValue:_recommendArr];
        }
        cell2.delegate=self;
        return cell2;
    }
    comment1TableViewCell *cell2 = [comment1TableViewCell cellWithTableView:tableView];
    [cell2 setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    if (_starView==nil&&_evaluateArr.count!=0) {
        
    _starView = [[FMLStarView alloc] initWithFrame:CGRectMake(15, cell2.content.frame.size.height+cell2.content.frame.origin.y+5, 16*[_evaluateArr[0][@"grade"] intValue], 15)
                                     numberOfStars:[_evaluateArr[0][@"grade"] intValue]
                                       isTouchable:NO
                                           index:1];
    }
    if (_evaluateArr.count!=0) {
         if ([NSString isBlankString:[NSString stringWithFormat:@"%@",_evaluateArr[0][@"grade"]]]) {
        _starView.currentScore = [_evaluateArr[0][@"grade"] intValue];
        _starView.totalScore =  [_evaluateArr[0][@"grade"] intValue];
         }else
      {
    _starView.currentScore = 5;
     }
    }
     
    _starView.isFullStarLimited = YES;
    _starView.delegate = self;
    [cell2 addSubview:_starView];
    if (_evaluateArr.count!=0) {
        [cell2 addValue:_evaluateArr];
    }
    return cell2;
    }else
    {
    
        if (indexPath.section==2) {
            static NSString *identifier = @"lunbotu2";
            // 1.缓存中取
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            // 2.创建
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            //设置cell被点击选择时的背景色为无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"商品详情";
            cell.textLabel.textColor =[UIColor colorWithHexString:@"#434343"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            
            UIImageView *photoView2;
            if (photoView2==nil) {
                photoView2 = [[UIImageView alloc]init];
            }
            photoView2.frame =CGRectMake(kScreenW-23, 14, 8, 16);
            [photoView2 setImage:[UIImage imageNamed:@"right2.png"]];
            [cell addSubview:photoView2];
            return cell;
            
        }
        if (indexPath.section==3) {
            static NSString *identifier = @"lunbotu3";
            // 1.缓存中取
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            // 2.创建
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            //设置cell被点击选择时的背景色为无色
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        UILabel *labelCon;
            //        if (labelCon==nil) {
            //            labelCon = [[UILabel alloc]init];
            //
            //        }
            
            labelCon.frame =CGRectMake(15, 12, kScreenW-30, contentstrHeight);
            //[NSString setLabelSpace1:labelCon withValue:contentstr withFont:[UIFont systemFontOfSize:15]];
            labelCon.textColor = [UIColor colorWithHexString:@"#919191"];
            //labelCon.textAlignment = NSTextAlignmentLeft;
            labelCon.numberOfLines =0;
//            labelCon.font = [UIFont systemFontOfSize:15.0];
           // labelCon.lineBreakMode = NSLineBreakByTruncatingTail;
            labelCon.text = contentstr;
            labelCon.attributedText = string;
            [cell addSubview:labelCon];
            
            return cell;
            
            
        }
        
            goodDetailsTableViewCell *cell2 = [goodDetailsTableViewCell cellWithTableView:tableView];
            [cell2 setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
            if (_recommendArr.count!=0) {
                [cell2 addValue:_recommendArr];
            }
            cell2.delegate=self;
            return cell2;
        

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if ([evaluate_count intValue]!=0) {
    if (indexPath.section==3) {
        //友盟统计
        [MobClick event:@"79"];
        productAttributeViewController *vc =[[productAttributeViewController alloc]init];
        vc.productID=_productID;
        vc.dataSource=_dataSourceArr;
        if ([NSString isBlankString:_invalidProduct]) {
            vc.invalidProduct=_invalidProduct;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
        }else
        {
            if (indexPath.section==2) {
                //友盟统计
                [MobClick event:@"79"];
                productAttributeViewController *vc =[[productAttributeViewController alloc]init];
                vc.productID=_productID;
                vc.dataSource=_dataSourceArr;
                [self.navigationController pushViewController:vc animated:YES];
            }
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


#pragma mark - 评论星星点击代理事件

- (void)fml_didClickStarViewByScore:(CGFloat)score atIndex:(NSInteger)index  uiView:(UIView *)myView{
    NSLog(@"score: %f  index：%zd", score, index);
}

#pragma mark--底部视图
-(void)payView
{
    if ([_invalidProduct isEqualToString:@"1"]) {
        
        UILabel *backView = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenH-48, kScreenW, 48)];
        backView.backgroundColor = RGBCOLOR(198, 198, 198);
        backView.text=@"已下架";
        backView.textColor = [UIColor colorWithHexString:@"#ffffff"];
        backView.textAlignment = NSTextAlignmentCenter;
        backView.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:backView];
    }else
    {
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
    
    UIButton *shopbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 73, 48)];
       //[btn setBackgroundColor:[UIColor colorWithHexString:@"#F0C01F"]];
    [shopbtn addTarget:self action:@selector(shopbtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:shopbtn];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(shopLabel.frame.size.width, 0, (kScreenW-shopLabel.frame.size.width)/2, 48)];
    [btn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.tag =5009;
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#F0C01F"]];
    [btn addTarget:self action:@selector(shopCartBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    
    
    UIButton *payBtn = [[UIButton alloc]initWithFrame:CGRectMake( kScreenW-(kScreenW-shopLabel.frame.size.width)/2, 0, (kScreenW-shopLabel.frame.size.width)/2, 48)];
    [payBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [payBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.tag =5001;
    [payBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5C36"]];
    [payBtn addTarget:self action:@selector(payBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:payBtn];
 
    }
}
#pragma mark--加入购物车
-(void)shopCartBtn:(UIButton *)sender
{    chooseType=0;
     NSMutableArray *arr11= _dataSourceArr[0][@"product_spec"];
    NSString *photo1 =_dataSourceArr[0][@"head_image"] ;
    parameterPopView *VC = [[parameterPopView alloc]init];
    VC.delegate = self;
    [VC popParameterView:arr11 control:self photo:photo1 actionX:carButton.frame];
    

}
-(void)payBtn:(UIButton *)sender
{
    //友盟统计
    [MobClick event:@"86"];
    chooseType=1;
    NSMutableArray *arr11= _dataSourceArr[0][@"product_spec"];
    NSString *photo1 =_dataSourceArr[0][@"head_image"] ;
    parameterPopView *VC = [[parameterPopView alloc]init];
    VC.delegate = self;
    [VC popParameterView:arr11 control:self photo:photo1 ];
    
}
#pragma mark--headerview点击跳转事件
//店铺跳转
-(void)shoptap
{
    //友盟统计
    [MobClick event:@"81"];
    if (_dataSourceArr.count!=0&&_dataSourceArr[0][@"shops"]!=[NSNull null]) {
        NSString *shop = [NSString stringWithFormat:@"%@",_dataSourceArr[0][@"shops"][@"shop_id"]];
        shopsViewController *shopVC = [[shopsViewController alloc]init];
        shopVC.title =_dataSourceArr[0][@"shops"][@"shop_name"];
        shopVC.shop_ID =shop;
        [self.navigationController pushViewController:shopVC animated:YES];
    }
    
}
//评论跳转
-(void)commentTap
{
    //友盟统计
    [MobClick event:@"80"];
    productCommentViewController *vc = [[productCommentViewController alloc]init];
    vc.productID =_productID;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark--客服功能
-(void)shopbtn:(UIButton *)sender
{
    //友盟统计
    [MobClick event:@"84"];
    
//    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",_dataSourceArr[0][@"phone"]]]) {
//        NSString *str1=[NSString stringWithFormat:@"tel://%@",_dataSourceArr[0][@"phone"]];
//        UIWebView*callWebview =[[UIWebView alloc] init];
//        NSURL *telURL =[NSURL URLWithString:str1];// 貌似tel:// 或者 tel: 都行
//        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//        //记得添加到view上
//        [self.view addSubview:callWebview];
//     
//    }
//    TLAccount *account = [TLAccountSave account];
//    if (account.uuid!=0) {
//    NSString *name=  [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
//    EMOptions *options = [EMOptions optionsWithAppkey:@"13911416463#touring"];
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = [[EMClient sharedClient] registerWithUsername:name password:@"0"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if (!error) {
//                
//                [[EMClient sharedClient].options setIsAutoLogin:YES];
//            }
//               int code=[[NSString stringWithFormat:@"%u",error.code] intValue];
//            if (code==203) {
//                EMError *error2 = [[EMClient sharedClient] loginWithUsername:name password:@"0"];
//                
//                if (!error2) {
//                    
//                    NSLog(@"登陆成功");
//                    
//                }
//            }
//            
//           
//        });
//    });
//    }else
//    {
//    
//        [self login];
//    }
    
    TLAccount *account = [TLAccountSave account];
    if (account.uuid!=0){
        
        chatViewController *vc = [[chatViewController alloc]initWithConversationChatter:@"tuling" conversationType: EMConversationTypeChat];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        
        [self login];
    }
    
    
}

#pragma mark--更多菜单管理
-(void)showDownList:(CGPoint *)point{
    
    NSArray *Arr = @[@"消息",@"返回首页"];
    NSArray *imageArr = @[@"menu1.png",@"menu3.png",@"menu4.png"];
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
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
    [_menu dismissWithCompletion:nil];//点击完成后视图消失;
}
#pragma mark--网络请求(列表)
- (void)requestData
{
    __weak __typeof(self)weakSelf = self;

    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid != nil) {
        params = @{@"shopping_product_id":_productID,@"uuid":account.uuid};
    }else
    {
        params = @{@"shopping_product_id":_productID};
        
    }
    [NetAccess getJSONDataWithUrl:kProductDetail parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        NSLog(@"成功");
        _recommendArr = [[NSMutableArray alloc]init];
        _evaluateArr = [[NSMutableArray alloc]init];
        _dataSourceArr = [[NSMutableArray alloc]init];
        NSMutableArray *Arr = [[NSMutableArray alloc]init];
        [weakSelf.dataSourceArr addObjectsFromArray:[responseObject objectForKey:@"product"]];
        if (_dataSourceArr[0][@"shops"]!=[NSNull null]) {
          if ([NSString isBlankString:_dataSourceArr[0][@"shops"][@"content"]]) {
            //contentstr = sa;
             contentstr =_dataSourceArr[0][@"shops"][@"content"];
            contentstrHeight=[self getHeight:contentstr];
            contentstrHeight= [NSString getSpaceLabelHeight:contentstr withFont:[UIFont systemFontOfSize:15] withWidth:kScreenW-30 lineSpace:6.0 fontSpace:@1.5f];
            NSLog(@"%f",contentstrHeight);
          }
        }else
        {
        contentstr=@"";
        }
       
        _shareUrlLabel =[responseObject objectForKey:@"shareUrl"];
        
        _shareTitleLabel =_dataSourceArr[0][@"product_name"];
        
        if ([NSString isBlankString:_dataSourceArr[0][@"head_image"]]) {
            _shareImageLabel =_dataSourceArr[0][@"head_image"];
            imaShare= [[UIImageView alloc]init];
            [imaShare sd_setImageWithURL:[NSURL URLWithString:_shareImageLabel]];
        }else
        {
            _shareImageLabel =@"www.touring.com";
            imaShare= [[UIImageView alloc]init];
            [imaShare sd_setImageWithURL:[NSURL URLWithString:_shareImageLabel]];
        
        }
        
        NSMutableArray *ima3 ;
        ima3 =_dataSourceArr[0][@"images"];
        if (ima3.count!=0) {
            //self.carousel.images =_dataSourceArr[0][@"images"];
            for (NSDictionary *dic in _dataSourceArr[0][@"images"]) {
                if ([NSString isBlankString:dic[@"image_url"]]) {
                    NSString *newStr= [dic[@"image_url"] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [Arr addObject:[NSURL URLWithString:newStr]];
                }
                
            }
        }else
        {
            [Arr addObject:[UIImage imageNamed:@"169.png"]];
        }
   //[Arr addObject:[NSURL URLWithString:_dataSourceArr[0][@"images"][0][@"image_url"]]];
        weakSelf.carousel.images =Arr;
        
        weakSelf.evaluateArr =[responseObject objectForKey:@"evaluate"];
        
        weakSelf.recommendArr =[responseObject objectForKey:@"recommend"];
        evaluate_count =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"evaluate_count"]];
        
        
        if (_dataSourceArr.count!=0) {
            bool isLike =  [_dataSourceArr[0][@"like_status"] boolValue];
            if (isLike==0 ) {
                collect=1;
                [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"shoucang1"] forState:UIControlStateNormal];
            }else
            {
                collect=2;
                [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"shoucang3"] forState:UIControlStateNormal];
            
            }
        }
        [self.TableView reloadData];
    } fail:^{
        [MBProgressHUD showError:@"请求失败"];
        
    }];
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


//收藏kCANCEL_COLLECT_LIKE
- (void)requestAlert:(NSString *)URL message:(NSString *)message
{
    NSString *product_ID;
    if (_dataSourceArr.count!=0) {
        product_ID = [NSString stringWithFormat:@"%@",_dataSourceArr[0][@"product_id"]];
    }
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params = @{@"product_id":_productID,@"uuid":account.uuid};
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
#pragma mark--点击推荐商品代理事件
-(void)IsseceltView:(NSInteger )proID
{
    //友盟统计
   [MobClick event:@"82"];
    shopDetailsViewController *vc =[[shopDetailsViewController alloc]init];
    vc.productID=[NSString stringWithFormat:@"%ld",proID];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)IsseceltView1:(NSInteger )proID
{
    //友盟统计
    [MobClick event:@"82"];

    shopDetailsViewController *vc =[[shopDetailsViewController alloc]init];
    vc.productID=[NSString stringWithFormat:@"%ld",proID];
    [self.navigationController pushViewController:vc animated:YES];

    
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
        if (_dataSourceArr.count!=0) {
            NSString *product_ID = _dataSourceArr[0][@"product_id"];
            
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



#pragma 查看品牌故事代理事件
-(void)btnClick2:(UIButton *)sender  ID:(NSString *)brandID;
{
   
    sender.userInteractionEnabled=NO;
    //友盟统计
    [MobClick event:@"78"];
    NSDictionary *params;
    params = @{@"brand_id":brandID};

[NetAccess getJSONDataWithUrl:kBrandStory parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
    NSLog(@"成功");
    
    NSMutableDictionary *dic1 ;
    dic1 = [responseObject objectForKey:@"brand"];

    BrandView.delegate = self;
    
    [BrandView popBrandView:dic1 control:self];
    sender.userInteractionEnabled=YES;
    
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


-(CGFloat)getHeight:(NSString *)str
{
    NSString *text = str;
    // 方法1：
    // 段落设置与实际显示的 Label 属性一致 采用 NSMutableParagraphStyle 设置Nib 中 Label 的相关属性传入到 NSAttributeString 中计算；
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    //style.lineSpacing = 6;
    //,NSKernAttributeName:@1.5}
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:style}];
    
    CGSize size =  [string boundingRectWithSize:CGSizeMake(WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    //NSLog(@" size =  %@", NSStringFromCGSize(size));
    
    
    // 并不是高度计算不对，我估计是计算出来的数据是 小数，在应用到布局的时候稍微差一点点就不能保证按照计算时那样排列，所以为了确保布局按照我们计算的数据来，就在原来计算的基础上 取ceil值，再加1，测试 OK；
    CGFloat height = ceil(size.height) + 1;
    return height;
}
@end
