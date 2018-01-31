//
//  MyOrderDetailVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/2/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "MyOrderDetailVC.h"
#import "CheckLogisticsModel.h"
#import "MyOrderDetailModel.h"
#import "MyOrderFormListModel.h"
#import "MyOrderAddressCell.h"
#import "MyOrderDetailPayTypeCell.h"
#import "LogisticsRecomCell.h"
#import "MyOrderFormListCell.h"

#import "WXApiRequestHandler.h"
#import "AlipayRequestConfig.h"
#import "ApplyForReturnVC.h"
#import "OrderReturnDetailVC.h"
#import "ApplyReturnViewController.h"

#import "MyOrderFormVC.h" //

#import "payTypeVC.h"

#import "MyOrderProductTableViewCell.h"


@interface MyOrderDetailVC () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>
{
    NSString *_reason;
    UIView *_cancelBgView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *pojoData;
@property (nonatomic, strong) NSMutableArray *buttonsData;
@property (nonatomic, strong) NSMutableArray *productData;
@property (nonatomic, strong) MyOrderDetailModel *detailModel;
@property (nonatomic, strong) AddressModel *addressModel;
@property (nonatomic, strong) NSMutableArray *cancelReasonData;

@property (nonatomic, strong) UILabel        *timerLable;
@property (nonatomic, assign) BOOL isfirstCreatTableview;
@end
#define kColor(r , g ,b) [UIColor colorWithRed:(r)/255.0  green:(g)/255.0  blue:(b)/255.0 alpha:1]
@implementation MyOrderDetailVC
{
    CGFloat PayTypeHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isfirstCreatTableview = YES;
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
 
    _pojoData = [[NSMutableArray alloc]init];
    _buttonsData = [[NSMutableArray alloc]init];
    _productData = [[NSMutableArray alloc]init];
    _cancelReasonData = [[NSMutableArray alloc]init];
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(ButtonClick) Title:@""];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;

    [self buildSubviews];
}

-(void)ButtonClick
{
    
    
   if ([_ispayLogin isEqualToString:@"0"]) {
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    }else
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}



- (void) requestData
{
    TLAccount * account = [TLAccountSave account];
    NSDictionary *params = nil;
    if([NSString isBlankString:account.uuid]){
     params = @{@"uuid":account.uuid, @"orderId":[NSString stringWithFormat:@"%ld",_orderId]};
    }
    NSInteger time = [[NSDate date]timeIntervalSince1970]*1000;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"orderId=%@",@(_orderId)]];
    [array addObject:[NSString stringWithFormat:@"uuid=%@",account.uuid]];
    [array addObject:[NSString stringWithFormat:@"time=5%@",@(time)]];
    MJWeakSelf;

    
    [NetAccess getForEncryptJSONDataWithUrl:kOrderFormDetail parameters:array WithLoadingView:YES andLoadingViewStr:nil success:^(id reswponse) {

        if ([reswponse[@"header"][@"code"] intValue] != 0) {
            [weakSelf showProgressError:@"订单信息出错啦"];
            return ;
        }
        [weakSelf.pojoData removeAllObjects];
        [weakSelf.buttonsData removeAllObjects];
        [weakSelf.productData removeAllObjects];
        
        NSDictionary *dict = reswponse[@"date"];
        if (weakSelf.detailModel == nil) {
            weakSelf.detailModel = [[MyOrderDetailModel alloc]init];
        }
        if (weakSelf.addressModel == nil) {
            weakSelf.addressModel = [[AddressModel alloc]init];
        }
        
        [weakSelf.detailModel setValuesForKeysWithDictionary:dict];
        [weakSelf.addressModel setValuesForKeysWithDictionary:weakSelf.detailModel.address];
        
        
        for (NSDictionary *dic in dict[@"brandProductPojo"]) {
            BrandProductPojoModel *pojoModel = [[BrandProductPojoModel alloc]init];
            [pojoModel setValuesForKeysWithDictionary:dic];
            pojoModel.pojoId = [dic[@"id"] integerValue];
            [weakSelf.pojoData addObject:pojoModel];
        }
        for (NSDictionary *dic in dict[@"buttons"]) {
            OrderFormButtonsModel *buttonModel = [[OrderFormButtonsModel alloc]init];
            [buttonModel setValuesForKeysWithDictionary:dic];
            [weakSelf.buttonsData addObject:buttonModel];
        }
        for (NSDictionary *dic in dict[@"products"]) {
            OrderFormProductsModel *productModel = [[OrderFormProductsModel alloc]init];
            [productModel setValuesForKeysWithDictionary:dic];
            [weakSelf.productData addObject:productModel];
        }
        MyOrderDetailPayTypeCell *cell = [[MyOrderDetailPayTypeCell alloc]init];
        cell.model = _detailModel;
        PayTypeHeight = cell.lastHeight;
        [weakSelf createTableHeaderView];
        [weakSelf.tableView reloadData];
    } fail:^{
        [weakSelf showProgressError:@""];
    }];
    
}

- (void) buildSubviews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tableViewGesture];
}

- (void) commentTableViewTouchInSide
{
//    [_cancelBgView removeFromSuperview];
}

- (void) createTableHeaderView
{
    UILabel *statusLab = [[UILabel alloc]init];
    statusLab.text = _detailModel.status;
    statusLab.textColor = [UIColor whiteColor];
    statusLab.textAlignment = NSTextAlignmentCenter;
    statusLab.backgroundColor = [UIColor colorWithHexString:@"#6dcb99"];
    if([_detailModel.status isEqualToString:@"待付款"]&&_isfirstCreatTableview==YES)
    {
        CGFloat headViewHeight = 125;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, headViewHeight)];
        statusLab.frame = CGRectMake(0, 0, WIDTH, 70);
        headView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:statusLab];
        
        self.timerLable = [[UILabel alloc]init];
        _timerLable.frame = CGRectMake(0, 70, WIDTH, 55);
        _timerLable.textColor = [UIColor colorWithHexString:@"#6dcb99"];
        _timerLable.textAlignment = NSTextAlignmentCenter;
        CGFloat fontsize = isIPHONE5?13:15;
        _timerLable.font = [UIFont fontWithName:FONT_REGULAR size:fontsize];
        _timerLable.backgroundColor = [UIColor whiteColor];
         [headView addSubview:_timerLable];
       
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headView.height-SINGLE_LINE_WIDTH, mainScreenWidth, SINGLE_LINE_WIDTH)];
        line.backgroundColor =[UIColor colorWithHexString:@"#e7e7e7"];
        [headView addSubview:line];
        _tableView.tableHeaderView = headView;
    
    }else
    {
         statusLab.frame = CGRectMake(0, 0, WIDTH, 70);
         _tableView.tableHeaderView = statusLab;
    }
    NSInteger count = _buttonsData.count;
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-64-50, WIDTH, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#939393"];
    [footView addSubview:line];
    

    UIButton *kefu = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 60, 50) ImageName:nil Target:self Action:@selector(onKeFuBtnClick:) Title:@"客服"];
    [kefu setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    kefu.titleLabel.font = [UIFont systemFontOfSize:12];
    [kefu setImage:[UIImage imageNamed:@"img_kefu"] forState:UIControlStateNormal];
    kefu.titleEdgeInsets = UIEdgeInsetsMake(13, -10, -13, 10);
    kefu.imageEdgeInsets = UIEdgeInsetsMake(-7, 12, 7, -12);
    [footView addSubview:kefu];
    
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 0.5, 50)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
    [footView addSubview:line2];
    CGFloat width = WIDTH -60 - 15;
    CGFloat widthButton = width / count - 15;
    for (int i=1; i<=count; i++) {
        
        OrderFormButtonsModel *buttonsModel = _buttonsData[count-i];
        
        UIButton *btn = [LXTControl createButtonWithFrame:CGRectMake(WIDTH  -15-widthButton*i-15*(i-1) , 10, widthButton, 30) ImageName:nil Target:self Action:@selector(onFootStatusBtnClick:) Title:buttonsModel.buttonName];
        btn.titleLabel.font = TLFont_Regular_Size(15, 1);
        btn.tag = 10000+(count-i);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        btn.layer.borderWidth = 0.5;
        
        
        if ([buttonsModel.buttonName isEqualToString:@"取消订单"] || [buttonsModel.buttonName isEqualToString:@"删除订单"] || [buttonsModel.buttonName isEqualToString:@"查看物流"]) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor colorWithHexString:@"#C6C6C6"].CGColor;
        } else {
            [btn setTitleColor:[UIColor colorWithHexString:@"#FF5C36"] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor colorWithHexString:@"#FF5C36"].CGColor;
        }
        
        [footView addSubview:btn];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_detailModel == nil) {
        return 0;
    }
    return 4;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _productData.count;
    } else {
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 115;
    } else if (indexPath.section == 2) {
        return PayTypeHeight;
    } else if (indexPath.section == 3) {
        NSInteger row = 0;
        if (_pojoData.count%2 == 0) {
            row = _pojoData.count/2;
        } else {
            row = _pojoData.count/2+1;
        }
        return 10+190*row;
    } else {
        return 115;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3 || section == 1) {
        return 55;
    } else {
        return 0.1;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (_detailModel.remarks.length > 0) {
            
            CGFloat space = 15;
            if (_detailModel.expect){
                space += 50;
            }
            CGSize size = [_detailModel.remarks sizeWithFont:15 andMaxSize:CGSizeMake(WIDTH-115, 200)];
            
            
            if ([_detailModel.status isEqualToString:@"待付款"]) {
                space += 150+size.height+20;
                return space;
            } else {
                space += 100+size.height+20;
                return space;
            }
        } else {
            CGFloat space = 15;
            if (_detailModel.expect){
                space += 50;
            }
            
            
            if ([_detailModel.status isEqualToString:@"待付款"]) {
                space += 150;
                return space;
            } else {
                space += 100;
                return space;
            }
        }
    }
    
    return 10;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 3) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 55)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab = [LXTControl createLabelWithFrame:CGRectMake(15, 0, WIDTH, 55) Font:15 Text:nil];
        lab.textColor = [UIColor colorWithHexString:@"#919191"];
        [bgView addSubview:lab];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, 54, WIDTH-30, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        [bgView addSubview:line];
        
        if (section == 1) {
            lab.text = _detailModel.shopName;
            
            UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            returnBtn.frame = CGRectMake(WIDTH-95, 15, 80, 30);
            returnBtn.layer.masksToBounds = YES;
            returnBtn.layer.cornerRadius = 3;
            returnBtn.layer.borderWidth = 0.5;
            returnBtn.layer.borderColor = [UIColor colorWithHexString:@"#919191"].CGColor;
            returnBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [returnBtn setTitle:_detailModel.returnStatus forState:UIControlStateNormal];
            [returnBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
            [returnBtn addTarget:self action:@selector(onReturnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:returnBtn];

            if (_detailModel.isReturn) {
                returnBtn.hidden = NO;
            } else {
                returnBtn.hidden = YES;
            }
            
            return bgView;
        } else if (section == 3) {
            lab.text = @"猜你喜欢";
            return bgView;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerView = [[UIView alloc]init];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:bgView];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, WIDTH-30, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        [bgView addSubview:line];
        
        // 商品总价
        UILabel *productTotalLab = [LXTControl createLabelWithFrame:CGRectMake(15, 15, 100, 15) Font:13 Text:@"商品总价"];
        productTotalLab.textColor = [UIColor colorWithHexString:@"#919191"];
        [bgView addSubview:productTotalLab];
        
        UILabel *productTotal = [LXTControl createLabelWithFrame:CGRectMake(15, 15, WIDTH-30, 15) Font:13 Text:[NSString stringWithFormat:@"¥%.2f",_detailModel.productsTotle]];
        productTotal.textAlignment = NSTextAlignmentRight;
        productTotal.textColor = [UIColor colorWithHexString:@"#919191"];
        [bgView addSubview:productTotal];
        
        // 运费（快递）
        UILabel *yunfeiLab = [LXTControl createLabelWithFrame:CGRectMake(15, 40, 100, 15) Font:13 Text:@"运费（快递）"];
        yunfeiLab.textColor = [UIColor colorWithHexString:@"#919191"];
        [bgView addSubview:yunfeiLab];
        
        UILabel *yunfei = [LXTControl createLabelWithFrame:CGRectMake(15, 40, WIDTH-30, 15) Font:13 Text:[NSString stringWithFormat:@"¥%.2f",_detailModel.cost]];
        yunfei.textAlignment = NSTextAlignmentRight;
        yunfei.textColor = [UIColor colorWithHexString:@"#919191"];
        [bgView addSubview:yunfei];
        CGFloat topSpace = yunfei.frame.size.height + yunfei.frame.origin.y + 10;
        if(_detailModel.expect){
            UILabel *lineexpect = [[UILabel alloc]initWithFrame:CGRectMake(15, topSpace, WIDTH-30, 0.5)];
            lineexpect.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
            [bgView addSubview:lineexpect];
            
            
            UILabel *sendTimeTitleLabel = [LXTControl createLabelWithFrame:CGRectMake(15, lineexpect.frame.size.height + lineexpect.frame.origin.y + 5, 100, 35) Font:15 Text:@"发货日期"];
            sendTimeTitleLabel.textAlignment = NSTextAlignmentLeft;
            sendTimeTitleLabel.textColor = [UIColor colorWithHexString:@"#434343"];
            [bgView addSubview:sendTimeTitleLabel];
            
            UILabel *sendTimeLabel = [LXTControl createLabelWithFrame:CGRectMake(sendTimeTitleLabel.frame.origin.x + sendTimeTitleLabel.frame.size.width + 10, lineexpect.frame.size.height + lineexpect.frame.origin.y + 5, WIDTH-sendTimeTitleLabel.frame.size.width - sendTimeTitleLabel.frame.origin.x - 10 - 15, 35) Font:15 Text:[NSString stringWithFormat:@"%@",_detailModel.sendDate]];
            if (![NSString isBlankString:_detailModel.sendDate]){
                sendTimeLabel.text = @"";
            }
            sendTimeLabel.textAlignment = NSTextAlignmentRight;
            sendTimeLabel.textColor = [UIColor colorWithHexString:@"#434343"];
            [bgView addSubview:sendTimeLabel];
            
            UILabel *lineexpectBottom = [[UILabel alloc]initWithFrame:CGRectMake(15, sendTimeLabel.frame.size.height + sendTimeLabel.frame.origin.y + 5, WIDTH-30, 0.5)];
            lineexpectBottom.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
            [bgView addSubview:lineexpectBottom];
            
            topSpace = lineexpectBottom.frame.origin.y + lineexpectBottom.frame.size.height + 5;
        }
        
     
        
        
        // 订单总价
        UILabel *orderTotalLab = [LXTControl createLabelWithFrame:CGRectMake(15, topSpace, 100, 35) Font:15 Text:@"订单总价"];
        orderTotalLab.textColor = [UIColor colorWithHexString:@"#434343"];
        [bgView addSubview:orderTotalLab];
        
        UILabel *orderTotal = [LXTControl createLabelWithFrame:CGRectMake(15, topSpace, WIDTH-30, 35) Font:15 Text:[NSString stringWithFormat:@"¥%.2f",_detailModel.totle]];
        orderTotal.textAlignment = NSTextAlignmentRight;
        orderTotal.textColor = [UIColor colorWithHexString:@"#434343"];
        [bgView addSubview:orderTotal];
        
        
        UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(15, orderTotal.frame.size.height + orderTotal.frame.origin.y + 5, WIDTH-30, 0.5)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        [bgView addSubview:line1];
        
        CGFloat line1Y = CGRectGetMaxY(line1.frame);
        if (_detailModel.remarks.length > 0) {
            // 买家留言
            UILabel *contentLab = [LXTControl createLabelWithFrame:CGRectMake(15, line1Y+10, 100, 15) Font:15 Text:@"买家留言"];
            contentLab.textColor = [UIColor colorWithHexString:@"#434343"];
            [bgView addSubview:contentLab];
            
            
            UILabel *content = [LXTControl createLabelWithFrame:CGRectZero Font:15 Text:[NSString stringWithFormat:@"%@",_detailModel.remarks]];
            content.numberOfLines = 0;
            CGSize size = [_detailModel.remarks sizeWithFont:15 andMaxSize:CGSizeMake(WIDTH-115, 200)];
            content.frame = CGRectMake(100, line1Y+9, size.width, size.height);
            content.textColor = [UIColor colorWithHexString:@"#919191"];
            [bgView addSubview:content];
            
            
            CGFloat contentY = CGRectGetMaxY(content.frame);
            UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(15, contentY+10, WIDTH-30, 0.5)];
            line2.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
            [bgView addSubview:line2];
            
            line1Y = CGRectGetMaxY(line2.frame);
        }
        
        if ([_detailModel.status isEqualToString:@"待付款"]) {
            // 需要付款
            UILabel *needMoneyLab = [LXTControl createLabelWithFrame:CGRectMake(15, line1Y, 100, 50) Font:15 Text:@"需要付款"];
            needMoneyLab.textColor = [UIColor colorWithHexString:@"#434343"];
            [bgView addSubview:needMoneyLab];
            
            UILabel *needMoney = [LXTControl createLabelWithFrame:CGRectMake(15, line1Y, WIDTH-30, 50) Font:15 Text:[NSString stringWithFormat:@"¥%.2f",_detailModel.totle]];
            needMoney.textAlignment = NSTextAlignmentRight;
            needMoney.textColor = [UIColor colorWithHexString:@"#F96500"];
            [bgView addSubview:needMoney];
            
            line1Y = CGRectGetMaxY(needMoneyLab.frame);
        }
        

        bgView.frame = CGRectMake(0, 0, WIDTH, line1Y);
        footerView.frame = CGRectMake(0, 0, WIDTH, line1Y+10);


//        bgView.frame = CGRectMake(0, 0, WIDTH, line1Y);
//        footerView.frame = CGRectMake(0, 0, WIDTH, line1Y+10);
        

        return footerView;
    } else
        return nil;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"addressCellIdentifier";
        MyOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyOrderAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _addressModel;
        return cell;
    } else if (indexPath.section == 2) {
        static NSString *cellId = @"payTypeCellIdentifier";
        MyOrderDetailPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyOrderDetailPayTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _detailModel;
        return cell;
    } else if (indexPath.section == 3) {
        static NSString *cellId = @"pojoCellIdentifier";
        LogisticsRecomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[LogisticsRecomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dataSource = _pojoData;

        cell.likeProductBtn = ^(NSInteger index) { // 跳转到商品详情页
         
            
        };
        return cell;
    } else {
        static NSString *cellId = @"productCellIdentifier";
        MyOrderProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyOrderProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        MJWeakSelf
         OrderFormProductsModel *model =  _productData[indexPath.row];
        cell.model =model;
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = kColor(238, 238, 238);
        line.frame = CGRectMake(15, 115, mainScreenWidth-30, SINGLE_LINE_WIDTH);
        [cell.contentView addSubview:line];
        [cell setButtonClick:^{
            [weakSelf shareBuyWith:[NSString stringWithFormat:@"%ld",model.productId]];
        }];
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cancelBgView != nil) {
        [_cancelBgView removeFromSuperview];
        _cancelBgView = nil;
        return;
    }
    
    if (indexPath.section == 1) {
        
    }
    
}


// 下部状态按钮
- (void) onFootStatusBtnClick:(UIButton *) sender
{
    if (_cancelBgView != nil) {
        [_cancelBgView removeFromSuperview];
        _cancelBgView = nil;
        return;
    }
    
    NSInteger row = sender.tag - 10000;
    
    OrderFormButtonsModel *buttomsModel = _buttonsData[row];
    
    if (buttomsModel.buttonId == 1) { // 取消订单
        
        // 友盟统计
       [MobClick event:@"TC221"];
        [self cancelOrder];
        
    } else if (buttomsModel.buttonId == 2) { // 付款
        
        [MobClick event:@"TC222"];
        //[self payType];
        payTypeVC *vc = [[payTypeVC alloc]init];
        vc.orderID =[NSString stringWithFormat:@"%ld",(long)_orderId];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (buttomsModel.buttonId == 3) { // 查看物流
        
      
        
    } else if (buttomsModel.buttonId == 4) { // 确认收货
        
    } else if (buttomsModel.buttonId == 5) { // 删除订单
        [MobClick event:@"TC224"];
        [self deleteOrderRequest:_orderId];
        
    } else if (buttomsModel.buttonId == 6) { // 评价
        
        
    } else if (buttomsModel.buttonId == 7) { // 重新购买
      
    }
}


#pragma mark pickViewDelegate 

- (void) cancelOrder
{
    _cancelBgView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-64-250, WIDTH, 250)];
    _cancelBgView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.view addSubview:_cancelBgView];
 
    if (_cancelReasonData.count != 0) {
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.frame = CGRectMake(WIDTH-60, 0, 60, 30);
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [finishBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(onCancelFinishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBgView addSubview:finishBtn];
        UIButton *cacenl = [UIButton buttonWithType:UIButtonTypeCustom];
        cacenl.frame = CGRectMake(15, 0, 60, 30);
        cacenl.titleLabel.font = [UIFont systemFontOfSize:12];
        [cacenl setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        [cacenl setTitle:@"取消" forState:UIControlStateNormal];
        [cacenl addTarget:self action:@selector(onCancelClickWith:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBgView addSubview:cacenl];
        UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, WIDTH, 220)];
        picker.dataSource = self;
        picker.delegate = self;
        picker.backgroundColor = [UIColor whiteColor];
        [_cancelBgView addSubview:picker];
        CancelOrderReasonModel *model = _cancelReasonData[0];
        _reason = model.dicName;
        
        return;
    } else {
        TLAccount * account = [TLAccountSave account];
        NSDictionary *params = @{@"uuid":account.uuid};
        
        [NetAccess getJSONDataWithUrl:kOrderFormCancelReason parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
            
            
            
            if ([reswponse[@"header"][@"code"] intValue] != 0) {
                return ;
            }
            
            [_cancelReasonData removeAllObjects];
            for (NSDictionary *dict in reswponse[@"date"]) {
                CancelOrderReasonModel *cancelReasonModel = [[CancelOrderReasonModel alloc]init];
                [cancelReasonModel setValuesForKeysWithDictionary:dict];
                cancelReasonModel.reasonId = [dict[@"id"] integerValue];
                [_cancelReasonData addObject:cancelReasonModel];
            }
            
            UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            finishBtn.frame = CGRectMake(WIDTH-60, 0, 60, 30);
            finishBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [finishBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
            [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
            [finishBtn addTarget:self action:@selector(onCancelFinishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_cancelBgView addSubview:finishBtn];
            UIButton *cacenl = [UIButton buttonWithType:UIButtonTypeCustom];
            cacenl.frame = CGRectMake(15, 0, 60, 30);
            cacenl.titleLabel.font = [UIFont systemFontOfSize:12];
            [cacenl setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
            [cacenl setTitle:@"取消" forState:UIControlStateNormal];
            [cacenl addTarget:self action:@selector(onCancelClickWith:) forControlEvents:UIControlEventTouchUpInside];
            [_cancelBgView addSubview:cacenl];
            UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, WIDTH, 220)];
            picker.dataSource = self;
            picker.delegate = self;
            picker.backgroundColor = [UIColor whiteColor];
            [_cancelBgView addSubview:picker];
            CancelOrderReasonModel *model = _cancelReasonData[0];
            _reason = model.dicName;
        } fail:^{
            [MBProgressHUD showSuccess:@"网络出错了"];
        }];
    }
}
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_cancelReasonData.count < 5) {
        return _cancelReasonData.count;
    } else
        return 5;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CancelOrderReasonModel *model = _cancelReasonData[row];
    return model.dicName;
}
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_cancelBgView removeFromSuperview];
    _cancelBgView = nil;
}
// 哪一行被选中
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CancelOrderReasonModel *model = _cancelReasonData[row];
    _reason = model.dicName;
}
-(void)onCancelClickWith:(UIButton *)sender
{
    if(_cancelBgView!=nil)
    {
        [_cancelBgView removeFromSuperview];
        _cancelBgView = nil;
    }
}

-(void)btnClickShareRule
{

}

-(void)shareBuyWith:(NSString *)productId;
{
    
}


// 取消订单完成按钮
- (void) onCancelFinishBtnClick:(UIButton *)sender
{
    _cancelBgView.hidden = YES;
    
   
}

// 删除订单
- (void) deleteOrderRequest:(NSInteger)orderId
{
   
}

- (void) payType
{
    UIActionSheet *alert = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信支付", @"支付宝支付", nil];
    [alert showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger payType;
    if (buttonIndex == 0) { // 微信支付
        payType = 2;
    } else if (buttonIndex == 1) { // 支付宝支付
        payType = 1;
    } else {
        return;
    }
    
    TLAccount * account = [TLAccountSave account];
    NSDictionary *params = @{@"uuid":account.uuid, @"orderId":@(_orderId), @"payType":@(payType)};
    
    [NetAccess getJSONDataWithUrl:kOrderFormOrderPay parameters:params  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
       
        
        int code = [[[reswponse objectForKey:@"header"] objectForKey:@"code"] intValue];
        if (code==0) {
            
            // 支付宝回调通知
            NSMutableDictionary *dataDic = [reswponse objectForKey:@"date"];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultName:) name:@"resultName" object:nil];
            [StaticTools SaveOrderId:[NSString stringWithFormat:@"%@",dataDic[@"orderNumber"]] url:@""];
            

            if (payType == 2) {
                [WXApiRequestHandler wxPayWithPartnerId:dataDic[@"partnerid"] prepayId:dataDic[@"prepayid"] nonceStr:dataDic[@"noncestr"] timeStamp:[dataDic[@"timestamp"] intValue] sign:dataDic[@"sign"]];
            } else {
                [AlipayRequestConfig payServerWithAppScheme:@"123" signedString:dataDic[@"aliPayOrder"] orderInfoEncoded:dataDic[@"aliPayOrder"] payBlock:^(NSString *resultCode)
                 {
                     [self requestData];
                     
                 }];
            }
        }
        
    } fail:^{
    }];
}

- (void)resultName:(NSNotification *)text{
    
    NSString *str= text.userInfo[@"result"];
    if ([str isEqualToString:@"0"]) {
       
    }else
    {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *str1= [defaults objectForKey:@"orderId1"];
        if ([str1 isEqualToString:@"0"]) {
            //列表页
            MyOrderFormVC *fail = [[MyOrderFormVC alloc]init];
            [self.navigationController pushViewController:fail animated:YES];
        }else
        {
            
        
            
        }
        
    }
    
    
    //    [MBProgressHUD showSuccess:@"支付成功"];
}

- (void)WxResult:(NSNotification *)text{
    
    NSString *str= text.userInfo[@"result"];
    if ([str isEqualToString:@"0"]) {
      
        
    }else
    {
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *str1= [defaults objectForKey:@"orderId1"];
        if ([str1 isEqualToString:@"0"]) {
            //列表页
            MyOrderFormVC *fail = [[MyOrderFormVC alloc]init];
            [self.navigationController pushViewController:fail animated:YES];
        }else
        {
            
            
            
            
        }
        
    }
}

// 退款状态 1、申请退款  2、退款中 3、退款完成
- (void) onReturnBtnClick:(UIButton *) sender
{
    if (_cancelBgView != nil) {
        [_cancelBgView removeFromSuperview];
        _cancelBgView = nil;
        return;
    }
    
    if (_detailModel.returnType == 1) {
        if( [_detailModel.status isEqualToString:@"待发货"])
        {
            
            ApplyForReturnVC *returnVc = [[ApplyForReturnVC alloc]init];
            returnVc.orderId = _orderId;
            [self.navigationController pushViewController:returnVc animated:YES];
        }else
        {
            ApplyReturnViewController *returnVC = [[ApplyReturnViewController alloc]init];
            returnVC.orderID = _orderId;
            [self.navigationController pushViewController:returnVC animated:YES];
        }
    } else  {
    
        OrderReturnDetailVC *returnDetailVC = [[OrderReturnDetailVC alloc]init];
        returnDetailVC.orderId = _orderId;
        [self.navigationController pushViewController:returnDetailVC animated:YES];
    }
}

/**
 客服
 */
- (void) onKeFuBtnClick:(UIButton *) sender
{
    if (_cancelBgView != nil) {
        [_cancelBgView removeFromSuperview];
        _cancelBgView = nil;
        return;
    }
    
  
}

@end
