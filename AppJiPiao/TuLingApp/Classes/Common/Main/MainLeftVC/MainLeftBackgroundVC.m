//
//  MainLeftBackgroundVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MainLeftBackgroundVC.h"
#import "MainLeftFirstCell.h"
#import "MainLeftSecondCell.h"
#import "MainLeftThridCell.h"
#import "MainLeftBusinessCell.h"
#import "MainLeftBusVerifyCell.h"
#import "MainUserInfoModel.h"
#import "AppDelegate.h"
#import "Tuling_user_setting_ViewController.h"
#import "MainSliderViewController.h"
#import "MyOrderFormVC.h" // 我的订单
#import "ShopOrderListVC.h" // 订单管理

#define kYaoQingHeight 100
#define systemHeight 18*kHeightScale
@interface MainLeftBackgroundVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel * _centerLineLabel;
    UIImageView *_headImg;
    UILabel *_nameLab;
    UILabel *_detailLab;
    
    /*
     * 用户信息状态变化
     * 0 未登录，1 用户 ， 2 商户状态
     */
    NSInteger _userStatusChange;
    BOOL _isYaoQing;
    UIView * _enterBottomView;
   
    
    BOOL _intoEnter;
}
@property (nonatomic, strong) UIButton *changeBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *uuidString;
@property (nonatomic, copy) NSString *reasonString;

@property (nonatomic) NSInteger role;

/*
 *   1、个人用户未入驻   2、商户入驻中或者失败   3、商户已入驻
 */
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) MainUserInfoModel *userInfoModel;
@property (nonatomic, strong) MainUserInfoModel *busInfoModel;
@property (nonatomic, strong) UIImageView  *codeButton;
@property (nonatomic, strong) UIView    *headerView;
@property (nonatomic, strong) NSString  *inviteImagestr;

@property (nonatomic,strong) NSDictionary * userDictionary;
@end

@implementation MainLeftBackgroundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _status = 1;
    _userStatusChange = 0;
    self.uuidString = [TLAccountSave account].uuid;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    [self createSubViews];
    [self requestGetUserInfo];
    [self getImageForinvite];
}


/**
 登录完成之后调用
 */
- (void)geticon:(NSString *)UUIDStr
{
    self.uuidString = UUIDStr;
    [self requestGetUserInfo];
    [self getImageForinvite];
}

-(void)getImageForinvite
{
   
}

#pragma mark - 获取用户信息接口

/**
 获取用户信息
 */
- (void) requestGetUserInfo
{
    
    TLAccount *account = [TLAccountSave account];
    if ([NSString isBlankString:account.uuid]) {
        self.uuidString = account.uuid;
    }else{
        self.uuidString = @"";
    }

    NSDictionary *params = @{@"uuid":self.uuidString};
    MJWeakSelf;
    [NetAccess getJSONDataWithUrl:kTLMobileUserInfo parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        if (responseObject[@"header"] == nil) {
            return;
        }
        if ([responseObject[@"header"][@"code"] intValue] != 0) {
            return ;
        }
        if (responseObject[@"date"] == nil) {
            return;
        }
        NSDictionary *date = [responseObject objectForKey:@"date"];
        if (date){
            weakSelf.userDictionary = [NSDictionary dictionaryWithDictionary:date];
        }
        weakSelf.userInfoModel = [[MainUserInfoModel alloc]init];
        weakSelf.busInfoModel = [[MainUserInfoModel alloc]init];
        weakSelf.status = [date[@"status"] integerValue];
        weakSelf.status = 1;
        [weakSelf.userInfoModel setValuesForKeysWithDictionary:date[@"personal"]];
        [weakSelf.busInfoModel setValuesForKeysWithDictionary:date[@"business"]];
        weakSelf.reasonString = date[@"reason"];
        weakSelf.role = [date[@"role"] integerValue];
        
        if([NSString isBlankString:weakSelf.userInfoModel.icon]){
            [_headImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.userInfoModel.icon] placeholderImage:[UIImage imageNamed:@"person0"]];
        }else{
            _headImg.image = [UIImage imageNamed:@"person0"];
        }
        BOOL unlogin = YES;
        if (![weakSelf.userInfoModel.userType isEqualToString:@"未登录"]){
            unlogin = NO;
        }
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * shopStatusType = nil;
        if (unlogin){
            _nameLab.text = weakSelf.userInfoModel.userType;
            _detailLab.text = nil;
            [userDefaults setObject:@"-1" forKey:kShopStatus];
            weakSelf.changeBtn.hidden = YES;
            _centerLineLabel.hidden = YES;
            shopStatusType = @"-1";
            weakSelf.tableView.tableFooterView = nil;
            _userStatusChange = 0;
        }else{
            shopStatusType = [userDefaults objectForKey:kShopStatus];
      
                //登录后个人用户
                _userStatusChange = 1;
                _nameLab.text = weakSelf.userInfoModel.name;
                _detailLab.text = weakSelf.userInfoModel.userType;
                weakSelf.changeBtn.hidden = YES;
                _centerLineLabel.hidden = YES;
                shopStatusType = @"0";
                [userDefaults setObject:@"0" forKey:kShopStatus];
                weakSelf.tableView.tableFooterView = nil;
            
        }
    
        [userDefaults synchronize];
        [weakSelf.tableView reloadData];
    } fail:^{
        
    }];
}

- (void) createSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kLeftVCWidth, HEIGHT) style:UITableViewStylePlain];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]){
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    } else {
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    
    [self createHeaderView];
}

#pragma mark - 头部信息UI设置
- (void) createHeaderView
{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kLeftVCWidth, floorf(337*kHeightScale/2))];
    self.headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = self.headerView;
    

    UIImageView *imgView = [LXTControl createImageViewWithFrame:self.headerView.bounds ImageName:@"img_mineHeader"];
    [self.headerView addSubview:imgView];
    
    // 切换身份
    _changeBtn = [LXTControl createBtnWithFrame:CGRectMake(kLeftVCWidth-110*kWidthScale, systemHeight, 50*kWidthScale, 50*kHeightScale) titleName:nil imgName:@"btn_mineChange" selImgName:nil target:self action:@selector(onChangeIdentifierBtnClick)];
    [self.headerView addSubview:_changeBtn];
    
    
    _centerLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeftVCWidth-55*kWidthScale, 18*kHeightScale+systemHeight, 0.5*kWidthScale, 15*kHeightScale)];
    _centerLineLabel.backgroundColor = kColorWhite;
    [self.headerView addSubview:_centerLineLabel];
    
    if (_status == 1) {
        _changeBtn.hidden = YES;
        _centerLineLabel.hidden = YES;
    }

    // 设置
    UIButton *settingBtn = [LXTControl createBtnWithFrame:CGRectMake(kLeftVCWidth-50*kWidthScale, systemHeight, 50+kWidthScale, 50*kHeightScale) titleName:@"退出" imgName:nil selImgName:nil target:self action:@selector(onSettingBtnClick)];
    [self.headerView addSubview:settingBtn];
    
    
    // 头像
    _headImg = [LXTControl createImageViewWithFrame:CGRectMake(15*kWidthScale, 65*kHeightScale, 73*kWidthScale, 73*kWidthScale) ImageName:@"person0"];
    _headImg.layer.masksToBounds = YES;
    _headImg.layer.cornerRadius = 73*kWidthScale/2;
    _headImg.layer.borderWidth = 1;
    _headImg.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.headerView addSubview:_headImg];
    
    UIImageView *ima = [LXTControl createImageViewWithFrame:CGRectMake(kLeftVCWidth-23*kWidthScale, 85*kHeightScale, 8*kWidthScale, 16*kWidthScale) ImageName:@"error2"];
    [self.headerView addSubview:ima];
    
    // 用户名
    _nameLab = [LXTControl createLabelWithFrame:CGRectMake(100*kWidthScale, 80*kHeightScale, WIDTH-100*kWidthScale, 18*kHeightScale) Font:18 Text:@"未登录"];
    _nameLab.textColor = [UIColor whiteColor];
    [self.headerView addSubview:_nameLab];
    
    
    // 描述
    CGFloat nameLabY = CGRectGetMaxY(_nameLab.frame);
    _detailLab = [LXTControl createLabelWithFrame:CGRectMake(100*kWidthScale, nameLabY+10*kHeightScale, WIDTH-100*kWidthScale, 15*kHeightScale) Font:13 Text:@""];
    _detailLab.textColor = [UIColor whiteColor];
    [self.headerView addSubview:_detailLab];
    
    
    UIButton *headBtn = [LXTControl createBtnWithFrame:CGRectMake(0, 60*kHeightScale, kLeftVCWidth, self.headerView.frame.size.height-60*kWidthScale) titleName:nil imgName:nil selImgName:nil target:self action:@selector(onUserInfoBtnClick)];
    [self.headerView addSubview:headBtn];
    
    self.codeButton = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kLeftVCWidth, WIDTH > 375? kYaoQingHeight:90)];
    
    [self.codeButton addTapGestureWithTarget:self action:@selector(codeButtonClick)];

}


#pragma mark - 商家已入驻底部信息
-(void)bottomViewUISet{
    if (_status != 3){
        return;
    }
    if (_enterBottomView){
        self.tableView.tableFooterView = _enterBottomView;
        return;
    }
    _enterBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLeftVCWidth, 49)];
    _enterBottomView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kLeftVCWidth, 49)];
    label.text = @"使用更多商家功能请使用电脑登录\nhttp://app.touring.com.cn/shop";
    label.textColor = [UIColor colorWithHexString:@"919191"];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.font = TLFont_Regular_Size(12, 0);
    [_enterBottomView addSubview:label];
    self.tableView.tableFooterView = _enterBottomView;
}

-(void)isShowinviteImage:(BOOL)isShow
{
    _isYaoQing = isShow;
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView reloadData];
}

-(void)codeButtonClick
{
   
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_changeBtn.selected) {
        // 用户
            //未入住
            if(_isYaoQing){
                if(_status == 1 && _role == 0){
                    return 4;
                }else{
                   return 3;
                }
            }else{
                if(_status == 1 && _role == 0){
                    return 3;
                }else{
                    return 2;
                }
            }
        
    } else {
        // 商户入驻中或失败
        if (_status == 2) {
            return 1;
        }
        //商户已入驻
        return 2;
    }
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        if (_changeBtn.selected == YES){
            return 10;
        }else{
            if (!_isYaoQing){
                return 10;
            }
        }
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1){
       
        if ((!_isYaoQing && !_changeBtn.selected) || _changeBtn.selected){
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
            view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            return view;
        }
    }
    return nil;
}

-(CGFloat)firstSectionHeight{
    CGFloat section0Height = 0;
    if (_changeBtn.selected && _status == 2) {
        //商户正在入驻或者失败
        section0Height = HEIGHT-floorf(337/2*kHeightScale);
    }else{
        //_status == 1 or 3 ,普通用户或者已入驻
        section0Height = 80*kHeightScale;
    }
    return section0Height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self firstSectionHeight];
    }
    
    if (_changeBtn.selected){
        //商户
        if(_status == 2){
            //入驻中
            CGFloat height = self.tableView.frame.size.height - self.headerView.frame.size.height - [self firstSectionHeight];
            return height;
        }else if (_status == 3){
            //已入驻
            CGFloat height = self.tableView.frame.size.height - self.headerView.frame.size.height - [self firstSectionHeight] - 59;
            return height;
        }
       
    }else{
        //用户
            //未入驻
            if (_isYaoQing && indexPath.section == 1){
                return WIDTH > 375? kYaoQingHeight:90;
            }else if (!_isYaoQing && indexPath.section == 1){
//                CGFloat height = self.tableView.frame.size.height - self.headerView.frame.size.height - 80 * kHeightScale - 55*kHeightScale - 10;
                return 240 * kHeightScale;
//                return height;
            }else if (_isYaoQing && indexPath.section == 2){
//                CGFloat height = self.tableView.frame.size.height - self.headerView.frame.size.height - 80 * kHeightScale - (WIDTH > 375? kYaoQingHeight:90) - 55*kHeightScale;
                return 240 * kHeightScale;
//                return height;
            }else{
                return 55*kHeightScale + 10;
            }
        
    }
    return 0;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJWeakSelf;
    
    if (indexPath.section == 0) {
        if (_changeBtn.selected) {
//           1、个人用户未入驻   2、商户入驻中或者失败   3、商户已入驻
            //显示入驻中信息
            if (_status == 2){
                static NSString *cellId = @"busVerifyCellId";
                MainLeftBusVerifyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[MainLeftBusVerifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
               
                }
              
            
                return cell;
            }
        }
        //用户、商家余额、积分信息展示
        static NSString *cellId = @"FirstCellId";
        MainLeftFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MainLeftFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.isBusiness = _changeBtn.selected;
        if (_changeBtn.selected) {
            cell.model = _busInfoModel;
        } else {
            cell.model = _userInfoModel;
        }
        cell.yueClick = ^{ // 余额明细
           
        };
        cell.jiFenClick = ^{ // 积分明细
           
            
        };
        return cell;
      
    }else if(_isYaoQing && indexPath.section == 1 ){
        
        if(_changeBtn.selected){
            //商家已入驻
            return [self bussinessCell:tableView];
        }
        //个人中心显示邀请码
        NSString * codeID = @"UITableViewCellID_yaoqingma";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:codeID];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:codeID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:self.codeButton];
            if ([NSString isBlankString:self.inviteImagestr])
                [self.codeButton sd_setImageWithURL:[NSURL URLWithString:self.inviteImagestr]];
        }
        
        return cell;
    }else if ((indexPath.section == 1 && !_isYaoQing)||(indexPath.section == 2 && _isYaoQing)){
        
        if (!_changeBtn.selected) { // 用户
            
            static NSString *cellId = @"secondCellId";
            MainLeftSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                
                cell = [[MainLeftSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
               
            }
           // if (_userInfoModel.messageNumber) {
                cell.isNews = [NSString stringWithFormat:@"%ld",(long)_userInfoModel.messageNumber];
            UIImageView *img = (UIImageView *)[self.view viewWithTag:5005];
            
            if (![[NSString stringWithFormat:@"%ld",(long)_userInfoModel.messageNumber] isEqualToString:@"0"]||![NSString stringWithFormat:@"%ld",(long)_userInfoModel.messageNumber]) {
                img.image = [UIImage imageNamed:@"btn_mineItem20"];
            }else{
                img.image = [UIImage imageNamed:@"btn_mineItem6"];
            }

           // }
            cell.itemsClick = ^(UIButton *sender) {
                [weakSelf onUserApplyWithIndex:sender.tag-100];
            };
            return cell;
            
        } else { // 商户
            return [self bussinessCell:tableView];
        }
        
    } else {
        
        static NSString *cellId = @"thridCellId";
        MainLeftThridCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MainLeftThridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.businessClick = ^{
            
 
        };
        return cell;
    }
}
//商家已入驻cell
-(MainLeftBusinessCell*)bussinessCell:(UITableView*)tableView{
    NSString *cellId = @"secondBusCellId";
    MainLeftBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MainLeftBusinessCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MJWeakSelf;
    cell.item2 = ^(UIButton *sender) {
        [weakSelf onBusinessApplyWithIndex:sender.tag];
    };
    return cell;
}

#pragma mark - header按钮点击
/**
 切换身份
 */
- (void) onChangeIdentifierBtnClick
{
    _changeBtn.selected = !_changeBtn.selected;
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    NSString *str=[userDef objectForKey:kShopStatus];
    if ([str isEqualToString:@"0"]) {
        [userDef setObject:@"1" forKey:kShopStatus];
        if ([NSString isBlankString:_busInfoModel.icon]){
            [_headImg sd_setImageWithURL:[NSURL URLWithString:_busInfoModel.icon] placeholderImage:[UIImage imageNamed:@"person0"]];
        }else{
            _headImg.image = [UIImage imageNamed:@"person0"];
        }
        
        _nameLab.text = _busInfoModel.name;
        _detailLab.text = _busInfoModel.userType;
        [self bottomViewUISet];
    }else if([str isEqualToString:@"1"]){
        [userDef setObject:@"0" forKey:kShopStatus];
        if ([NSString isBlankString:_userInfoModel.icon]){
            [_headImg sd_setImageWithURL:[NSURL URLWithString:_userInfoModel.icon] placeholderImage:[UIImage imageNamed:@"person0"]];
        }else{
            _headImg.image = [UIImage imageNamed:@"person0"];
        }
        _nameLab.text = _userInfoModel.name;
        _detailLab.text = _userInfoModel.userType;
        self.tableView.tableFooterView = nil;
    }
    [userDef synchronize];
    
    [_tableView reloadData];
}

/**
 设置
 */
- (void) onSettingBtnClick
{
    [[NSUserDefaults standardUserDefaults] setObject:@"-1" forKey:@"shopStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    MainSliderViewController * mvc = [[MainSliderViewController alloc] init];
    BaseNavigationController * nvc = [[BaseNavigationController alloc] initWithRootViewController:mvc];
    [UIApplication sharedApplication].keyWindow.rootViewController =nvc;
    [TLAccountSave removeAccount];
}

#pragma mark - 进入个人或商户店铺信息页面

/**
 用户信息（未登录）
 */
- (void) onUserInfoBtnClick{
   
    if (![NSString isBlankString:self.uuidString]) { // 登录
        [self toLoginClick];
        return;
    }

    Tuling_user_setting_ViewController *tvc = [[Tuling_user_setting_ViewController alloc]init];
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:tvc];
    [self  presentViewController:nv animated:YES completion:nil];
   
}

#pragma mark - 用户各模块
- (void) onUserApplyWithIndex:(NSInteger)index
{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (self.uuidString.length == 0) { // 登录
        [self toLoginClick];
        return;
    }
    
    switch (index) {
        case 0:
        {
     
            
        }
            break;
        case 1: // 全部订单
        {
            MyOrderFormVC *myOrderFormVC = [[MyOrderFormVC alloc]init];
            myOrderFormVC.isFromLeft = YES;
            [app.tab.viewControllers[app.tab.selectedIndex] pushViewController:myOrderFormVC animated:YES];
            [app.tab showMainView];
        }
            break;
        case 2:
        {

        }
            break;
        case 3:
        {

        }
            break;
        case 4:
        {
           
        }
            break;
        case 5:
        {

        }
            break;
        case 6:
        {       

        }
            break;
        case 7:
        {

        }
            break;
            
        default:
            break;
    }
    
}

- (void) onBusinessApplyWithIndex:(NSInteger)index
{
 
}

/**
 去登录
 */
- (void) toLoginClick
{
    normalLoginVC *mainVc = [[normalLoginVC alloc]init];
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:mainVc];
    [self presentViewController:nv animated:YES completion:nil];
}

#pragma mark - 入驻状态按钮点击
-(void)bussinessEnterEvent:(int)event{
    MJWeakSelf;
    UIViewController * viewVC = nil;
    if (event == 1 || event == 4 || event == 6){
        
    }else if (event == 2){
        
    }else if (event == 3){
        //返回个人中心
        //入驻中等待客服审核，点击返回个人中心
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kShopStatus];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([NSString isBlankString:weakSelf.userInfoModel.icon]){
            [_headImg sd_setImageWithURL:[NSURL URLWithString:weakSelf.userInfoModel.icon] placeholderImage:[UIImage imageNamed:@"person0"]];
        }else{
            _headImg.image = [UIImage imageNamed:@"person0"];
        }
        _nameLab.text = _userInfoModel.name;
        _detailLab.text = _userInfoModel.userType;
        
        weakSelf.changeBtn.selected = NO;
        [weakSelf.tableView reloadData];
    }else if (event == 5){
        //开始经营
        [self businessToRun];
        return;
    }
    if (viewVC){
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.tab.viewControllers[app.tab.selectedIndex] pushViewController:viewVC animated:YES];
        [app.tab showMainView];
    }
    
}

-(void)businessToRun{
  
}

@end
