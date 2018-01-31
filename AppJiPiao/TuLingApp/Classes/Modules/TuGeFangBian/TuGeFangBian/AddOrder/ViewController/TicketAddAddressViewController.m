//
//  TicketAddAddressViewController.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/16.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketAddAddressViewController.h"
#import "ZJWriteInfoView.h"
#import "TicketAddressModel.h"
#import "Masonry.h"

@interface TicketAddAddressViewController ()

@property (nonatomic, strong) ZJWriteInfoView *nameInfoView;
@property (nonatomic, strong) ZJWriteInfoView *phoneInfoView;
@property (nonatomic, strong) ZJWriteInfoView *areaInfoView;
@property (nonatomic, strong) ZJWriteInfoView *detaileInfoView;
@property (nonatomic, strong) ZJWriteInfoView *zipCodeInfoView;
@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation TicketAddAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WS(ws)
    
    [self addCustomTitleWithTitle:@"新增常用地址"];
    
    // 姓名
    _nameInfoView = [ZJWriteInfoView zj_WriteInfoView];
    [_nameInfoView zj_updateInfoWithName:@"姓名" tipType:ZJWriteInfoViewTipTypeNot actionType:ZJWriteInfoViewActionTypeWrite data:@"请输入收件人姓名" actionCallBack:nil];
    [self.baseScrollView addSubview:_nameInfoView];
    
    // 手机号
    _phoneInfoView = [ZJWriteInfoView zj_WriteInfoView];
    _phoneInfoView.keyboardType = UIKeyboardTypePhonePad;
    [_phoneInfoView zj_updateInfoWithName:@"手机号" tipType:ZJWriteInfoViewTipTypeNot actionType:ZJWriteInfoViewActionTypeWrite data:@"请输入手机号" actionCallBack:nil];
    [self.baseScrollView addSubview:_phoneInfoView];
    
    // 所在地区
    _areaInfoView = [ZJWriteInfoView zj_WriteInfoView];
    [_areaInfoView zj_updateInfoWithName:@"所在地区" tipType:ZJWriteInfoViewTipTypeNot actionType:ZJWriteInfoViewActionTypeSelect data:[ZJWriteInfoViewSelectModel initWithTitle:@"请选择所在地区" dataList:[self getAreaData]] actionCallBack:^(BOOL isSelectAction) {
        [ws.view endEditing:YES];
    }];
    [self.baseScrollView addSubview:_areaInfoView];
    
    // 详细地址
    _detaileInfoView = [ZJWriteInfoView zj_WriteInfoView];
    [_detaileInfoView zj_updateInfoWithName:@"详细地址" tipType:ZJWriteInfoViewTipTypeNot actionType:ZJWriteInfoViewActionTypeWrite data:@"不需要重复填写省市区/县" actionCallBack:nil];
    [self.baseScrollView addSubview:_detaileInfoView];
    
    // 邮编 请输入邮编
    _zipCodeInfoView = [ZJWriteInfoView zj_WriteInfoView];
    [_zipCodeInfoView zj_updateInfoWithName:@"邮编" tipType:ZJWriteInfoViewTipTypeNot actionType:ZJWriteInfoViewActionTypeWrite data:@"选填" actionCallBack:nil];
    [self.baseScrollView addSubview:_zipCodeInfoView];
    
    // 保存
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#008C4E"]];
    [_saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
//    [_saveBtn.layer setCornerRadius:4.0f];
//    [_saveBtn.layer setMasksToBounds:YES];
    
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
    
    [_phoneInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.nameInfoView.mas_bottom);
        make.left.equalTo(ws.baseScrollView);
        make.width.equalTo(ws.baseScrollView);
        make.height.mas_offset(height);
    }];
    
    [_areaInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.phoneInfoView.mas_bottom);
        make.left.equalTo(ws.baseScrollView);
        make.width.equalTo(ws.baseScrollView);
        make.height.mas_offset(height);
    }];
    
    [_detaileInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.areaInfoView.mas_bottom);
        make.left.equalTo(ws.baseScrollView);
        make.width.equalTo(ws.baseScrollView);
        make.height.mas_offset(height);
    }];
    
    [_zipCodeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.detaileInfoView.mas_bottom);
        make.left.equalTo(ws.baseScrollView);
        make.width.equalTo(ws.baseScrollView);
        make.height.mas_offset(height);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view.mas_bottom);
        make.left.equalTo(ws.view.mas_left);
        make.width.equalTo(ws.view.mas_width);
        make.height.mas_offset(50);
    }];
}

#pragma 保存常用地址
- (void)saveAction
{
    // 判断数据
    if (![_nameInfoView zj_contentIsNotNilAndValid]) {
        [self showProgress:@"请输入您的姓名"];
        return;
    } else if (![_phoneInfoView zj_contentIsNotNilAndValid]) {
        [self showProgress:@"请输入您的手机号"];
        return;
    } else if (![_areaInfoView zj_contentIsNotNilAndValid]) {
        [self showProgress:@"请选择您所在地区"];
        return;
    } else if (![_detaileInfoView zj_contentIsNotNilAndValid]) {
        [self showProgress:@"请输入您的详细地址"];
        return;
    } else if ([_phoneInfoView zj_getWriteContent].length!=11) {
        [self showProgress:@"请输入正确手机号"];
        return;
    }
    
    // 新增常用地址
    TicketAddressModel *model = [[TicketAddressModel alloc] init];
    model.zipCode = [_zipCodeInfoView zj_getWriteContent];
    
    NSArray *addressArray = [[_areaInfoView zj_getWriteContent] componentsSeparatedByString:@"/"];
    model.province = addressArray[0];
    model.city = [addressArray[1] isEqualToString:@"市辖区"] ? addressArray[0] : addressArray[1];
    model.county = addressArray[2];
    
    model.detailedAddress = [_detaileInfoView zj_getWriteContent];
    model.linkPhone = [_phoneInfoView zj_getWriteContent];
    model.linkPhone = [_phoneInfoView zj_getWriteContent];
    model.userName = [_nameInfoView zj_getWriteContent];
    
    WS(ws)
    [TicketAddressModel asyncAddressActionWithActionType:AddressActionAdd addressModel:model successBlock:^(NSArray *dataArray) {
        if (ws.addComplete) {
            ws.addComplete(model);
        }
        [ws.navigationController popViewControllerAnimated:YES];
    } errorBlock:^(NSError *errorResult) {
        [ws showProgressError:errorResult.localizedDescription];
    }];
}

- (NSMutableArray *)getAreaData
{
    NSMutableArray *areaDataArray = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"];
    NSString *areaString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (areaString && ![areaString isEqualToString:@""]) {
        NSError *error = nil;
        NSArray *areaStringArray = [NSJSONSerialization JSONObjectWithData:[areaString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if (areaStringArray && areaStringArray.count) {
//            [areaDataArray addObjectsFromArray:areaStringArray];
            [areaStringArray enumerateObjectsUsingBlock:^(NSDictionary *currentProviceDict, NSUInteger idx, BOOL * _Nonnull stop) {
                // 省份
                NSMutableDictionary *proviceDict = [NSMutableDictionary dictionary];
                NSString *proviceName = currentProviceDict[@"name"];
                NSArray *cityArray = currentProviceDict[@"childs"];

                // 城市
                NSMutableArray *tempCityArray = [NSMutableArray arrayWithCapacity:cityArray.count];
                [cityArray enumerateObjectsUsingBlock:^(NSDictionary *currentCityDict, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
                    NSString *cityName = currentCityDict[@"name"];
                    NSArray *countryArray = currentCityDict[@"childs"];

                    // 县城
                    NSMutableArray *tempCountryArray = [NSMutableArray arrayWithCapacity:countryArray.count];
                    if (countryArray) {
                        [countryArray enumerateObjectsUsingBlock:^(NSDictionary *currentCountryDict, NSUInteger idx, BOOL * _Nonnull stop) {
                            [tempCountryArray addObject:currentCountryDict[@"name"]];
                        }];

                        if (cityName) {
                            [cityDict setObject:tempCountryArray forKey:cityName];
                            [tempCityArray addObject:cityDict];
                        }
                    } else {
                        [tempCityArray addObject:cityName];
                    }
                }];

                if (proviceName && cityArray) {
                    [proviceDict setObject:tempCityArray forKey:proviceName];
                    [areaDataArray addObject:proviceDict];
                }
            }];
        } else {
            NSLog(@"解析错误");
        }
    }
    return areaDataArray;
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
