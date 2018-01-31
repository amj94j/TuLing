//
//  ShopOrderSearchVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/4/19.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ShopOrderSearchVC.h"
//#import "MyOrderFormListModel.h"
#import "TLChooseDateView.h"
@interface ShopOrderSearchVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *_orderNumField;
    
    UIButton *_startBtn;
    UIButton *_endBtn;
    
    NSInteger _currBtn;
}

@property (nonatomic, strong) UIView *dateBgView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) BOOL isChooseDate;
@end

@implementation ShopOrderSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isChooseDate = NO;
    self.title = @"搜索";
    
    [self createSubViews];
}

- (void) createSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kColorClear;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30*kHeightScale)];
    headerView.backgroundColor = kColorClear;
    _tableView.tableHeaderView = headerView;
    
    
    UILabel *titleLab = [createControl createLabelWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-30*kWidthScale, 30*kHeightScale) Font:12 Text:@"可任选一项或两项进行查询" LabTextColor:kColorFontBlack3];
    [headerView addSubview:titleLab];
    

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 110*kHeightScale)];
    footerView.backgroundColor = kColorClear;
    _tableView.tableFooterView = footerView;
    
    
    UIButton *searchBtn = [LXTControl createBtnWithFrame:CGRectMake(15*kWidthScale, 60*kHeightScale, WIDTH-30*kWidthScale, 50*kHeightScale) titleName:@"搜索" imgName:nil selImgName:nil target:self action:@selector(onSearchBtnClick)];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 2.5;
    searchBtn.backgroundColor = kColorAppGreen;
    [searchBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [footerView addSubview:searchBtn];
}


/**
 开始搜索
 */
- (void) onSearchBtnClick
{
    if (_orderNumField.text.length == 0) {
        _orderNumField.text = @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年 MM月 dd号"];
    NSDate *startDate = [formatter dateFromString:_startBtn.titleLabel.text];
    NSDate *endDate = [formatter dateFromString:_endBtn.titleLabel.text];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startStr = [formatter stringFromDate:startDate];
    NSString *endStr = [formatter stringFromDate:endDate];
    
    if (!_isChooseDate){
        startStr = @"";
        endStr = @"";
    }
    
   
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50*kHeightScale;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10*kHeightScale;
    }
    return 0.01;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50*kHeightScale)];
    bgView.backgroundColor = kColorWhite;
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*kHeightScale, 3*kWidthScale, 20*kHeightScale)];
    line.backgroundColor = kColorAppGreen;
    [bgView addSubview:line];
    
    
    UILabel *title = [LXTControl createLabelWithFrame:CGRectMake(15*kWidthScale, 0, WIDTH-15*kWidthScale, 50*kHeightScale) Font:16 Text:nil];
    title.textColor = kColorFontBlack1;
    [bgView addSubview:title];
    
    if (section == 0) {
        title.text = @"按订单号查询";
    } else {
        title.text = @"按时间查询";
    }
    
    
    UILabel *line1 = [createControl createLineWithFrame:CGRectMake(15*kWidthScale, 49*kHeightScale, WIDTH-30*kWidthScale, 1*kHeightScale) labelLineColor:kColorLine];
    [bgView addSubview:line1];
    
    return bgView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 104*kHeightScale;
    }
    return 90*kHeightScale;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellStyleDefault;
    }
    
    if (indexPath.section == 0) {
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(15*kWidthScale, 20*kHeightScale, WIDTH-30*kWidthScale, 44*kHeightScale)];
        bgView.backgroundColor = kColorLine;
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 2.5;
        [cell.contentView addSubview:bgView];
        
        
        _orderNumField = [[UITextField alloc]initWithFrame:CGRectMake(10*kWidthScale, 0, WIDTH-50*kWidthScale, 44*kHeightScale)];
        _orderNumField.placeholder = @"输入订单编号/商品名称";
        _orderNumField.returnKeyType = UIReturnKeyDone;
        _orderNumField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _orderNumField.font = kFontNol13;
        _orderNumField.delegate = self;
        [bgView addSubview:_orderNumField];
    } else if (indexPath.section == 1) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年 MM月 dd号"];
        NSDate *date = [NSDate date];
        NSString *dateStr = [formatter stringFromDate:date];
        
        
        _startBtn = [LXTControl createBtnWithFrame:CGRectMake(15*kWidthScale, 20*kHeightScale, (WIDTH-50*kWidthScale)/2, 40*kHeightScale) titleName:dateStr imgName:nil selImgName:nil target:self action:@selector(onChooseStartBtnClick:)];
        [cell.contentView addSubview:_startBtn];
        _startBtn.tag = 101;
        
        UILabel *line = [createControl createLineWithFrame:CGRectMake(WIDTH/2-10, 39*kHeightScale, 20*kWidthScale, 1*kHeightScale) labelLineColor:kColorAppGreen];
        [cell.contentView addSubview:line];
        
        
        _endBtn = [LXTControl createBtnWithFrame:CGRectMake(WIDTH/2+10*kWidthScale, 20*kHeightScale, (WIDTH-50*kWidthScale)/2, 40*kHeightScale) titleName:dateStr imgName:nil selImgName:nil target:self action:@selector(onChooseEndBtnClick:)];
        [cell.contentView addSubview:_endBtn];
        _endBtn.tag = 201;
    }
    
    return cell;
}


-(void)chooseDate:(UIButton*)sender isMinDate:(BOOL)isMin date:(NSDate*)date {
    [_orderNumField resignFirstResponder];
    TLChooseDateView * chooseDateVew = [[TLChooseDateView alloc] initWithRootView:self.navigationController.view start:nil end:nil];
    MJWeakSelf;
    [chooseDateVew finishChooseDate:^(NSDate *date, NSString *stringDate) {
        if (stringDate){
            if (sender.tag == 101) {
                [sender setTitle:stringDate forState:UIControlStateNormal];
            } else if (sender.tag == 201) {
                [sender setTitle:stringDate forState:UIControlStateNormal];
            }
            weakSelf.isChooseDate = YES;
        }
    }];
    [chooseDateVew showView];
}


- (void) onChooseStartBtnClick:(UIButton *)sender
{
    [self chooseDate:sender isMinDate:NO date:nil];
//    if (_dateBgView == nil) {
//        
//        [self initDateBgView];
//    }
//    _dateBgView.hidden = !_dateBgView.hidden;
//    if (_dateBgView.hidden == NO) {
//        
//        UIWindow *window = [[[UIApplication sharedApplication] delegate]window];
//        CGRect rect = [sender convertRect:sender.bounds toView:window];
//        CGFloat popViewY = rect.origin.y;
//        
//        _dateBgView.frame = CGRectMake(0, popViewY, WIDTH, 200);
//        
//        _currBtn = 1;
//    } else
//        _currBtn = 0;
}

- (void) onChooseEndBtnClick:(UIButton *)sender
{
    [self chooseDate:sender isMinDate:NO date:nil];
//    if (_dateBgView == nil) {
//        
//        [self initDateBgView];
//    }
//    _dateBgView.hidden = !_dateBgView.hidden;
//    if (_dateBgView.hidden == NO) {
//        
//        UIWindow *window = [[[UIApplication sharedApplication] delegate]window];
//        CGRect rect = [sender convertRect:sender.bounds toView:window];
//        CGFloat popViewY = rect.origin.y;
//        
//        _dateBgView.frame = CGRectMake(0, popViewY, WIDTH, 200);
//        
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yyyy年 MM月 dd号"];
//        NSDate *startDate = [formatter dateFromString:_startBtn.titleLabel.text];
////        [_datePicker setMinimumDate:startDate];
//        
//        _currBtn = 2;
//    } else
//        _currBtn = 0;
}


//- (void) initDateBgView
//{
//    _dateBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
//    _dateBgView.backgroundColor = kColorWhite;
//    [self.view addSubview:_dateBgView];
//    
//    _datePicker = [[UIDatePicker alloc]initWithFrame:_dateBgView.bounds];
//    _datePicker.backgroundColor = kColorClear;
//    [_datePicker setDatePickerMode:UIDatePickerModeDate];
//    _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
//    [_datePicker addTarget:self action:@selector(onDateChange:) forControlEvents:UIControlEventValueChanged];
//    [_dateBgView addSubview:_datePicker];
//    
//    
////    [_datePicker setMaximumDate:[NSDate date]];
//    
//    _dateBgView.hidden = YES;
//}
//
//- (void) onDateChange:(UIDatePicker *)sender
//{
//    NSDate *date = sender.date;
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy年 MM月 dd号"];
//    NSString *dateStr = [formatter stringFromDate:date];
//    DLog(@"%@", dateStr);
//    
//    
//    if (_currBtn == 1) {
//        [_startBtn setTitle:dateStr forState:UIControlStateNormal];
//    } else if (_currBtn == 2) {
//        [_endBtn setTitle:dateStr forState:UIControlStateNormal];
//    }
//}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    _dateBgView.hidden = YES;
    _currBtn = 0;
}
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self.view endEditing:YES];
}

#pragma mark ---- textField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

@end
