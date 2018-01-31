//
//  TicketAddPassengerViewController.m
//  TuLingApp
//
//  Created by abner on 2017/12/15.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketAddPassengerViewController.h"
#import "ZJWriteInfoView.h"
#import "TicketPassengerModel.h"
#import "Masonry.h"

@interface TicketAddPassengerViewController ()
{
    BOOL _isEdit; // 是否编辑乘机人
}

@property (nonatomic, strong) ZJWriteInfoView *nameInfoView;
@property (nonatomic, strong) ZJWriteInfoView *typeInfoView;
@property (nonatomic, strong) ZJWriteInfoView *idInfoView;
@property (nonatomic, strong) ZJWriteInfoView *phoneInfoView;
@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation TicketAddPassengerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WS(ws)
    
    _isEdit = self.model;
    
    [self addCustomTitleWithTitle:@"新增乘机人"];
    
    // 姓名
    _nameInfoView = [ZJWriteInfoView zj_WriteInfoView];
    [_nameInfoView zj_updateInfoWithName:@"姓名" tipType:ZJWriteInfoViewTipTypeInfo actionType:ZJWriteInfoViewActionTypeWrite data:@"与乘客证件一致" actionCallBack:nil];
    if (_model) _nameInfoView.text = _model.personName;
    [self.baseScrollView addSubview:_nameInfoView];
    
    // 证件类型
    _typeInfoView = [ZJWriteInfoView zj_WriteInfoView];
    NSString *defaultTitle = (_model) ? _model.personIdentityName : @"身份证";
    [_typeInfoView zj_updateInfoWithName:@"证件类型" tipType:ZJWriteInfoViewTipTypeNot actionType:ZJWriteInfoViewActionTypeSelect data:[ZJWriteInfoViewSelectModel initWithTitle:defaultTitle dataList:@[@"身份证"]] actionCallBack:^(BOOL isSelectAction) {
        [ws.view endEditing:YES];
    }];
    [self.baseScrollView addSubview:_typeInfoView];
    
    // 证件号码
    _idInfoView = [ZJWriteInfoView zj_WriteInfoView];
    [_idInfoView zj_updateInfoWithName:@"证件号码" tipType:ZJWriteInfoViewTipTypeNot actionType:ZJWriteInfoViewActionTypeWrite data:@"请输入证件号码" actionCallBack:nil];
    if (_model) _idInfoView.text = _model.personIdentityCode;
    [self.baseScrollView addSubview:_idInfoView];
    
    // 手机号
    _phoneInfoView = [ZJWriteInfoView zj_WriteInfoView];
    _phoneInfoView.keyboardType = UIKeyboardTypePhonePad;
    [_phoneInfoView zj_updateInfoWithName:@"手机号" tipType:ZJWriteInfoViewTipTypeNot actionType:ZJWriteInfoViewActionTypeWrite data:@"便于接收航班重要通知" actionCallBack:nil];
    if (_model) _phoneInfoView.text = _model.linkPhone;
    [self.baseScrollView addSubview:_phoneInfoView];
    
    // 保存
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#008C4E"]];
    [_saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [_saveBtn.layer setCornerRadius:4.0f];
    [_saveBtn.layer setMasksToBounds:YES];
    
    [self.baseScrollView addSubview:_saveBtn];
    
    // 布局视图
    [self layoutWriteInfoViews];
}

- (void)layoutWriteInfoViews
{
    CGFloat height = _nameInfoView.height;
    
    WS(ws)
    [_nameInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.baseScrollView).mas_offset(5.0f);
        make.left.equalTo(ws.baseScrollView);
        make.width.equalTo(ws.baseScrollView);
        make.height.mas_offset(height);
    }];
    
    [_typeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.nameInfoView.mas_bottom);
        make.left.equalTo(ws.baseScrollView);
        make.width.equalTo(ws.baseScrollView);
        make.height.mas_offset(height);
    }];
    
    [_idInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.typeInfoView.mas_bottom);
        make.left.equalTo(ws.baseScrollView);
        make.width.equalTo(ws.baseScrollView);
        make.height.mas_offset(height);
    }];
    
    [_phoneInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.idInfoView.mas_bottom);
        make.left.equalTo(ws.baseScrollView);
        make.width.equalTo(ws.baseScrollView);
        make.height.mas_offset(height);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.phoneInfoView.mas_bottom).mas_offset(40.0f);
        make.left.equalTo(ws.baseScrollView).mas_offset(15.0f);
        make.width.equalTo(ws.baseScrollView).mas_offset(-30.0f);
        make.height.mas_offset(44.0f);
    }];
}

#pragma 保存乘机人
- (void)saveAction
{
    // 判断数据
    if (![_nameInfoView zj_contentIsNotNilAndValid]) {
        [self showProgress:@"请输入您的姓名"];
        return;
    } else if (![_idInfoView zj_contentIsNotNilAndValid]) {
        [self showProgress:@"请输入您的证件号码"];
        return;
    } else if (![_phoneInfoView zj_contentIsNotNilAndValid]) {
        [self showProgress:@"请输入您的手机号"];
        return;
    } else if ([_phoneInfoView zj_getWriteContent].length!=11) {
        [self showProgress:@"请输入正确的手机号"];
        return;
    } else if ([_idInfoView zj_getWriteContent].length!=18) {
        [self showProgress:@"请输入正确的证件号码"];
        return;
    }
    
    // 新增乘机人
    if (!_isEdit) self.model = [[TicketPassengerModel alloc] init];
    self.model.personName = [_nameInfoView zj_getWriteContent];
    self.model.personIdentityName = [_typeInfoView zj_getWriteContent];
    self.model.personIdentityType = ([self.model.personIdentityName isEqualToString:@"身份证"] ? 1 : ([self.model.personIdentityName isEqualToString:@"护照"] ? 3 : 8));
    self.model.personIdentityCode = [_idInfoView zj_getWriteContent];
    self.model.linkPhone = [_phoneInfoView zj_getWriteContent];
    
    // 先判断是否是成年人
    WS(ws)
    [TicketPassengerModel asyncCheckPersonIsAdultWithPersonIdentityCode:self.model.personIdentityCode successBlock:^(NSInteger passengerType) {
        // 成员类型
        if (passengerType == 0) {
            ws.model.isBaby = YES;
        } else if (passengerType == 1) {
            ws.model.isChild = YES;
        } else if (passengerType == 2) {
            ws.model.isAudlt = YES;
        }
        
        // 添加新乘客或修改乘客信息
        [ws addPassenger];
    } errorBlock:^(NSError *errorResult) {
        [ws showProgressError:errorResult.localizedDescription];
    }];
}

#pragma mark 添加新乘客或修改乘客信息
- (void)addPassenger
{
    WS(ws)
    [TicketPassengerModel asyncPassengerActionWithActionType:_isEdit ? PassengerActionEdit : PassengerActionAdd passengerModel:self.model successBlock:^(NSArray *dataArray) {
        if (ws.addComplete) {
            [dataArray enumerateObjectsUsingBlock:^(TicketPassengerModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([model.personIdentityCode isEqualToString:ws.model.personIdentityCode]) {
                    ws.addComplete(model);
                    *stop = YES;
                }
            }];
        }
        [ws.navigationController popViewControllerAnimated:YES];
    } errorBlock:^(NSError *errorResult) {
        [ws showProgressError:errorResult.localizedDescription];
    }];
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
