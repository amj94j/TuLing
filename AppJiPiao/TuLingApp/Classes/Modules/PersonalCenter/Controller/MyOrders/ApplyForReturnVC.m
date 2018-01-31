//
//  MyOrderApplyForReturnVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/1.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ApplyForReturnVC.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Addition.h"
#import "VPImageCropperViewController.h"
#import "GTMBase64.h"

#import "MyOrderFormListModel.h"

#define imgWidth (WIDTH-45)/4

@interface ApplyForReturnVC () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSArray *_titles;
    UILabel *_reason;
    UITextView *_textView;
    UILabel *_placeholder;
    
    UIView *_reasonView;
    
    UIView *_tableFooterView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imgData;
@property (nonatomic, strong) NSMutableArray *reasonArr;

@end

@implementation ApplyForReturnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _titles = @[@"退款原因", @"退款金额", @"退款说明"];
    _reasonArr = [[NSMutableArray alloc]init];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#EDEEEF"];
    
    [self requestReasonData];
}

// 退款原因数据
- (void) requestReasonData
{
    TLAccount * account = [TLAccountSave account];
    NSInteger time = [[NSDate date]timeIntervalSince1970]*1000;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"orderId=%@",@(_orderId)]];
    [array addObject:[NSString stringWithFormat:@"uuid=%@",account.uuid]];
    [array addObject:[NSString stringWithFormat:@"time=5%@",@(time)]];
    [NetAccess getForEncryptJSONDataWithUrl:kOrderFormRetrunReason parameters:array  WithLoadingView:NO andLoadingViewStr:nil success:^(id reswponse){
        
        if ([reswponse[@"header"][@"code"] intValue] != 0) {
            return ;
        }
        
        NSMutableDictionary *dataDic = [reswponse objectForKey:@"date"];
        for (NSDictionary *dict in dataDic[@"rasons"]) {
            CancelOrderReasonModel *model = [[CancelOrderReasonModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            model.reasonId = [dict[@"id"] integerValue];
            [_reasonArr addObject:model];
        }
        self.title = dataDic[@"title"];
        _returnPrice = [dataDic[@"totle"] doubleValue];
        
        [self createSubviews];

    } fail:^{
    }];
}

- (void) createSubviews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
    
    UIButton *putIn = [UIButton buttonWithType:UIButtonTypeCustom];
    putIn.frame = CGRectMake(0, HEIGHT-64-50, WIDTH, 50);
    putIn.backgroundColor = [UIColor colorWithHexString:@"#FF4861"];
    [putIn setTitle:@"提交申请" forState:UIControlStateNormal];
    [putIn addTarget:self action:@selector(onPutInBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:putIn];
    
    
    _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    _tableView.tableFooterView = _tableFooterView;
    
//    if (![self.title isEqualToString:@"申请退款"]) {
//        [self buildTabelFooterView];
//    }
    
}

// 提交申请
- (void) onPutInBtnClick:(UIButton *) sender
{
    __weak __typeof(self)weakSelf = self;

    if([_reason.text isEqualToString:@"请选择退款原因"])
    {
        [MBProgressHUD showError:@"请选择退款原因"];
        return;
    }
    
    TLAccount *account = [TLAccountSave account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (account.uuid != 0) {
        [params addEntriesFromDictionary:@{@"uuid":account.uuid}];
    }
    if (_textView.text.length != 0) {
        [params addEntriesFromDictionary:@{@"content":_textView.text}];
    }
    [params setObject:@(_orderId) forKey:@"orderId"];
    [params setObject:_reason.text forKey:@"shopOrderReturnReason"];
    
    NSInteger time = [[NSDate date]timeIntervalSince1970]*1000;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"orderId=%@",@(_orderId)]];
    [array addObject:[NSString stringWithFormat:@"shopOrderReturnReason=%@",_reason]];
    [array addObject:[NSString stringWithFormat:@"uuid=%@",account.uuid]];
    [array addObject:[NSString stringWithFormat:@"time=5%@",@(time)]];
    
    if (weakSelf.imgData.count != 0) {
        for (int i=0; i<weakSelf.imgData.count; i++) {
            UIImage *ima = weakSelf.imgData[i];
            //压缩图片
            UIImage *resizedImage = [UIImage scaleToSize:ima  size:CGSizeMake(300, 300)];
            NSString *imaKey = [NSString stringWithFormat:@"shopOrderRetrunImgs[%d].imgUrl",i];
            NSData *data = UIImageJPEGRepresentation(resizedImage,1.0);
            NSString *pictureDataString = [GTMBase64 stringByEncodingData:data];
            [params setObject:pictureDataString forKey:imaKey];
            
        }
    }
    
    [NetAccess postJSONWithUrl:kOrderFormRetrunCreate parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        
        self.view.userInteractionEnabled = YES;
        
       
        
        if ([responseObject[@"header"][@"code"] intValue] != 0) {
            [MBProgressHUD showSuccess:@"提交失败"];
            return ;
        }
        
        [MBProgressHUD showSuccess:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^{
        
        self.view.userInteractionEnabled = YES;
        [MBProgressHUD showSuccess:@"网络出错了"];
    }];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
//    if ([self.title isEqualToString:@"申请退款"]) {
//        return 2;
//    }
    return 2;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = _titles[section];
    title.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:title];
    
    if (section == 0 || section == 1) {
        
        UILabel *dian = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 15, 20)];
        dian.text = @"*";
        dian.textColor = [UIColor colorWithHexString:@"#F9516A"];
        [bgView addSubview:dian];
        
        title.frame = CGRectMake(30, 20, WIDTH-45, 20);
    } else {
        title.frame = CGRectMake(15, 20, WIDTH-30, 20);
    }
    
    return bgView;
}
- (void) buildTabelFooterView
{
    for (UIView * view in _tableFooterView.subviews) {
        [view removeFromSuperview];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 20, imgWidth, imgWidth);
    [btn setBackgroundImage:[UIImage imageNamed:@"img_upDateImg"] forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7"];
//    [btn setTitle:@"(不超过3张)" forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:13];
//    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//    [btn setTitleColor:[UIColor colorWithHexString:@"919191"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onChoosePhotosBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_tableFooterView addSubview:btn];
    
    if (_imgData.count != 0) {
        
        for (int i=0; i<_imgData.count; i++) {
            UIImageView *imagePhoto1 = [LXTControl createImageViewWithFrame:CGRectMake(15+(imgWidth+5)*(i+1), 20, imgWidth, imgWidth) ImageName:@""];
            [imagePhoto1 setImage:_imgData[i]];
            [_tableFooterView addSubview:imagePhoto1];
        }
    }
}


// 选择图片按钮
- (void) onChoosePhotosBtnClick:(UIButton *)sender
{
    //选择是打开相机还是打开相册
    UIActionSheet * choose_picture = [[UIActionSheet alloc]initWithTitle:@"请选择图像" delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册里选择", nil];
    [choose_picture showInView:self.view];
}
// 选择图片的方式
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) { // 判断是否有相机
                // 打开相机
                UIImagePickerController *icon_picture = [[UIImagePickerController alloc] init];
                icon_picture.sourceType = UIImagePickerControllerSourceTypeCamera;
                icon_picture.delegate = self;
                [self presentViewController:icon_picture animated:YES completion:nil];
            } else {
                
                if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) { // 用户明确地拒绝授权，或者相机设备无法访问
                    
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的手机没有开通相机权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                    return ;
                    
                } else {
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的手机不支持相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                }
            }
        
        }
            break;
        case 1:
        {
           
        }
            break;
            
        default:
            break;
    }
}
#pragma mark imagepicker delegate
/**
 *  图库代理方法
 *
 *  @param picker 要销毁picker
 *  @param info   传回的图片
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *resizedImage = [UIImage scaleToSize:image  size:CGSizeMake(300, 300)];
        NSData *data;
        if (UIImagePNGRepresentation(resizedImage) == nil)
        {
            data = UIImageJPEGRepresentation(resizedImage, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(resizedImage);
        }
        UIImage *ima =[UIImage imageWithData:data];
        
        
        _imgData = [[NSMutableArray alloc]init];
        _imgData = @[ima];

        [self buildTabelFooterView];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 100;
    } else
        return 50;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:bgView];
    
    if (indexPath.section == 2) {
        bgView.frame = CGRectMake(15, 0, WIDTH-30, 100);
        _placeholder = [LXTControl createLabelWithFrame:CGRectMake(15, 15, WIDTH-60, 20) Font:15 Text:@"请输入退款说明，最多不超过200字"];
        _placeholder.textColor = [UIColor colorWithHexString:@"#919191"];
        [bgView addSubview:_placeholder];
        
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH-60, 70)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.tintColor = [UIColor colorWithHexString:@"#434343"];
        [bgView addSubview:_textView];
    } else {
        bgView.frame = CGRectMake(15, 0, WIDTH-30, 50);
        if (indexPath.section == 0) {
            _reason = [LXTControl createLabelWithFrame:CGRectMake(15, 0, WIDTH-50, 50) Font:15 Text:@"请选择退款原因"];
            _reason.textColor = [UIColor colorWithHexString:@"#919191"];
            [bgView addSubview:_reason];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, WIDTH-30, 50);
            [btn setImage:[UIImage imageNamed:@"bt_arrowDown"] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
            [btn addTarget:self action:@selector(onChooseReasonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
        } else {
            UILabel *pirce = [LXTControl createLabelWithFrame:CGRectMake(10, 0, WIDTH-50, 50) Font:17 Text:[NSString stringWithFormat:@"¥%0.2f", _returnPrice]];
            [bgView addSubview:pirce];
        }
    }
    
    return cell;
}

// 选择原因
- (void) onChooseReasonBtnClick:(UIButton *) sender
{
    if (_reasonView == nil) {
        _reasonView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, WIDTH, 190)];
        _reasonView.backgroundColor = [UIColor whiteColor];
        [_tableView addSubview:_reasonView];
        
        UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, WIDTH-30, 190)];
        picker.dataSource = self;
        picker.delegate = self;
        picker.backgroundColor = [UIColor whiteColor];
        [_reasonView addSubview:picker];
        CancelOrderReasonModel *model = _reasonArr[0];
        _reason.text = model.dicName;
        _reason.textColor = [UIColor colorWithHexString:@"#434343"];
        _reasonView.hidden = YES;
    }
    _reasonView.hidden = !_reasonView.hidden;
    
}
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_reasonArr.count > 4) {
        return 5;
    } else
        return _reasonArr.count;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CancelOrderReasonModel *model = _reasonArr[row];
    return model.dicName;
}
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 哪一行被选中
    CancelOrderReasonModel *model = _reasonArr[row];
    _reason.text = model.dicName;
    _reasonView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _reasonView.hidden = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeholder.hidden = YES;
}
- (void) textViewDidEndEditing:(UITextView *)textView
{
    if (_textView.text.length == 0) {
        _placeholder.hidden = NO;
    }
}

@end
