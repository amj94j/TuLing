//
//  ShopOrderSendVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/21.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ShopOrderSendVC.h"
#import "LogisticsCompanyModel.h"
#import "LogisticsChoosePopView.h"

@interface ShopOrderSendVC ()
{
    UILabel *_comLab;
    UIButton *_companyBtn;
    UITextField *_numField;
}
@property (nonatomic, strong) NSMutableArray *logisComData;
@property (nonatomic, strong) LogisticsCompanyModel *logModel;

@end

@implementation ShopOrderSendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.title = @"待发货";
    [self createSubviews];
    [self getLogisCompanyDate];
}

- (void) createSubviews
{
    NSArray *titles = @[@"选择快递公司", @"请输入快递单号"];
    NSArray *placeholds = @[@"请选择快递公司", @"请输入单号"];
    
    for (int i=0; i<2; i++) {
        
        UILabel *titleLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 30*kHeightScale + 100*kHeightScale*i, WIDTH-30*kWidthScale, 20*kHeightScale) Font:15 Text:titles[i] LabTextColor:kColorFontBlack1];
        [self.view addSubview:titleLab];
        
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15*kWidthScale, 60*kHeightScale+ 100*kHeightScale*i, WIDTH-30*kWidthScale, 44*kHeightScale)];
        bgView.backgroundColor = kColorWhite;
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 2.5;
        [self.view addSubview:bgView];
        
        
        if (i == 0) {
            
            _comLab = [createControl labelWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-60*kWidthScale, 44*kHeightScale) Font:13 Text:placeholds[i] LabTextColor:kColorFontBlack3];
            [bgView addSubview:_comLab];
            
            
            UIButton *btn = [LXTControl createBtnWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height) titleName:@"" imgName:nil selImgName:nil target:self action:@selector(onChooseCompanyBtnClick:)];
            [bgView addSubview:btn];
        } else {
            
            _numField = [LXTControl createTextFieldWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-60*kWidthScale, 44*kHeightScale) placeholder:placeholds[i] passWord:NO leftImageView:nil rightImageView:nil Font:13];
            [bgView addSubview:_numField];
        }
    }
    
    
    UIButton *sendProductBtn = [LXTControl createBtnWithFrame:CGRectMake(0, HEIGHT-64-50*kHeightScale, WIDTH, 50*kHeightScale) titleName:@"发货" imgName:nil selImgName:nil target:self action:@selector(onSendBtnClick)];
    sendProductBtn.backgroundColor = kColorAppGreen;
    [sendProductBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [self.view addSubview:sendProductBtn];
}

// 获取退款快递公司
- (void) getLogisCompanyDate
{
   
}


- (void) onChooseCompanyBtnClick:(UIButton *)sender
{
    
    if(_logisComData.count <= 0 || !_logisComData){
        return;
    }
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [sender convertRect:sender.bounds toView:window];
    
    LogisticsChoosePopView *logisPopView = [[LogisticsChoosePopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [logisPopView storyBoardPopViewWithFrame:CGRectMake(0, rect.origin.y + rect.size.height+5*kHeightScale, WIDTH, 200) dataSource:_logisComData];
    
    
    if (_logModel == nil) {
        if (_logisComData.count != 0) {
            _logModel = _logisComData[0];
            _comLab.text = _logModel.logisticsName;
            _comLab.textColor = kColorFontBlack1;
        }
    }
    
    logisPopView.logisClick = ^(LogisticsCompanyModel *logModel) {
        _logModel = logModel;
        
        _comLab.text = _logModel.logisticsName;
        _comLab.textColor = kColorFontBlack1;
    };
}


- (void) onSendBtnClick
{
 
}


@end
