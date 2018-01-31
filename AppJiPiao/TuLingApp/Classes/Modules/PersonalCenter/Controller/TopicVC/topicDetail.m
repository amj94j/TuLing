//
//  topicDetail.m
//  TuLingApp
//
//  Created by hua on 17/4/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "topicDetail.h"
#import "topicDetailcell.h"
#import "topicCell1.h"

#import "topicCell2.h"
//#import "topicCell3.h"
#import "IQKeyboardManager.h"
#import "topicCell4.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "VPImageCropperViewController.h"
#import "topicModel.h"
#import "ZLPhotoActionSheet.h"
#import "GTMBase64.h"
#import "UIImage+Addition.h"

#import "TLPromptInformationView.h"

@interface topicDetail ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,topicCell4Delegate>

{


  topicModel *model;
    UIButton *settingBtn;
    UIButton *informationCardBtn;
    int edit;
    int statue;
    NSString *fellStr;
    
    
    NSString *backReason;
    CGFloat _keyboardTopSpace;
}
@property(nonatomic,strong)UITableView *TableView;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)NSMutableArray *dataModelArr;

@property (nonatomic,strong) topicCell2 * textViewCell;
/**
 图片数组
 */
@property (nonatomic, strong) NSMutableArray *arrDataSources;


@property (nonatomic, strong)NSMutableArray *networkImage;

@end

@implementation topicDetail

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _keyboardTopSpace = [[IQKeyboardManager sharedManager] keyboardDistanceFromTextField];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:17];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:_keyboardTopSpace];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    edit=0;
    statue=0;
    
    fellStr =@"";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataDic = [[NSMutableDictionary alloc]init];
    self.arrDataSources = [[NSMutableArray alloc]init];
    model = [[topicModel alloc]init];
    _dataModelArr =[[NSMutableArray alloc]init];
    _networkImage =[[NSMutableArray alloc]init];
    
    [self creatTableView];
    if (_productID.length!=0) {
        [self requestData];
    }else
    {
    
    
    }
    
    if (!_isModel) {
        informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [informationCardBtn addTarget:self action:@selector(enterehzFilesVC:) forControlEvents:UIControlEventTouchUpInside];
        
            [informationCardBtn setTitle:@"删除 |" forState:UIControlStateNormal];
            
        [informationCardBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        informationCardBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        informationCardBtn.frame =CGRectMake(0, 0, [NSString singeWidthForString:informationCardBtn.titleLabel.text fontSize:16 Height:20], 20);
        
        UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:informationCardBtn];
        
        
        
        
        
        settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingBtn addTarget:self action:@selector(enterTeamCard:) forControlEvents:UIControlEventTouchUpInside];
        [settingBtn setTitle:@"暂存" forState:UIControlStateNormal];
        [settingBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        settingBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        settingBtn.frame =CGRectMake(0, 0, [NSString singeWidthForString:settingBtn.titleLabel.text fontSize:16 Height:20], 20);
        UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
        
        
        self.navigationItem.rightBarButtonItems  = @[settingBtnItem,informationCardItem];
        
    }else
    {
        
        
        informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [informationCardBtn addTarget:self action:@selector(enterehzFilesVC:) forControlEvents:UIControlEventTouchUpInside];
        [informationCardBtn setTitle:@"暂存" forState:UIControlStateNormal];
        [informationCardBtn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        informationCardBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        informationCardBtn.frame =CGRectMake(0, 0, [NSString singeWidthForString:informationCardBtn.titleLabel.text fontSize:16 Height:20], 20);
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:informationCardBtn];
        self.navigationItem.rightBarButtonItem = rightItem;

        
       
    }
    
    
    [self commitFunction];
    
}


//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//    UITextView *mytext = (UITextView*)[self.view viewWithTag:666];
//    [mytext becomeFirstResponder];
//}

-(void)enterehzFilesVC:(UIButton *)sender
{
    if (!_isModel) {
        //删除
        //删除操作
        [self deleteRequest:_ID];

    }else
    {
        //暂存
        statue=3;
         [self submitRequest];

    }

}

-(void)enterTeamCard:(UIButton *)sender
{
    if (!_isModel) {

        //暂存
        statue=3;
        [self submitRequest];

    }else
    {

        
    }
}
#pragma mark--网络请求(列表)
- (void)requestData
{
    __weak __typeof(self)weakSelf = self;
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    _networkImage = [[NSMutableArray alloc]init];
    params = @{@"uuid":account.uuid,@"id":_ID};
    [NetAccess getJSONDataWithUrl:kTopicLook parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        NSLog(@"%@",kTopicLook);
        NSLog(@"%@",params);
        int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
        if (code==0) {
            weakSelf.dataDic =[responseObject objectForKey:@"date"];
            topicModel *model1 =[[topicModel alloc]initWithDictionary:weakSelf.dataDic error:nil];
           [weakSelf.dataModelArr addObject:model1];
        
            NSArray * array = [[responseObject objectForKey:@"date"] objectForKey:@"images"];
            if (array.count > 0)
                [_networkImage  addObjectsFromArray:array];
            if (weakSelf.dataModelArr.count!=0) {
                model=weakSelf.dataModelArr[0];
                backReason =[NSString stringWithFormat:@"%@",model.auditStatus];
            }
            
            
        }
        [weakSelf.TableView reloadData];
    } fail:^{
        [MBProgressHUD showError:@"请求失败"];
        
    }];
}


/**
 tableView相关
 */
- (void)creatTableView
{
    self.TableView= [[UITableView alloc]initWithFrame: CGRectMake(0, 0, WIDTH, HEIGHT-64-50) style:UITableViewStyleGrouped];
    self.TableView.alwaysBounceHorizontal = NO;
    self.TableView.alwaysBounceVertical = YES;
    self.TableView.showsHorizontalScrollIndicator = NO;
    self.TableView.showsVerticalScrollIndicator = NO;
    self.TableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.TableView.dataSource =self;
    self.TableView.delegate = self;
    //self.TableView.scrollEnabled=NO;
    self.TableView.backgroundColor = RGBCOLOR(238, 238, 238);
    self.TableView.bounces=NO;
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.TableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    

    return 0.01;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
    return 5;
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *BackView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 5)];
    BackView1.backgroundColor = RGBCOLOR(238, 238, 238);
    
    return BackView1;
}

#pragma mark  返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([backReason isEqualToString:@"2"]) {
         return 4;
    }
     return 3;
   
    
   
}
#pragma mark  每个分区多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
    
    
}

#pragma mark 改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return WIDTH*9/16;
    }
    
    
   if ([backReason isEqualToString:@"2"]) {
        if (indexPath.section==1||indexPath.section==2) {
            Class currentClass = [topicCell1 class];
            if (_dataModelArr.count!=0) {
                
                if (indexPath.section==1) {
                    model =_dataModelArr[0];
                    if ([NSString isBlankString:model.auditCause]) {
                        // 推荐使用此普通简化版方法（一步设置搞定高度自适应，性能好，易用性好）
                        return [self.TableView cellHeightForIndexPath:indexPath model:_dataModelArr[0] keyPath:@"topicModel1" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
                    }else
                    {
                        return 90;
                    }
                    
                }else
                {
                
                
                    return 185;
                }
               
                
            }else
            {
                if (indexPath.section==1) {
                    return 50;
                }else
                {
                    return 160;
                }
                
            }
            
        }

    }else
    {
    
        if (indexPath.section==1) {
            Class currentClass = [topicCell1 class];
            if (_dataModelArr.count!=0) {
                model =_dataModelArr[0];
                // 推荐使用此普通简化版方法（一步设置搞定高度自适应，性能好，易用性好）
                return [self.TableView cellHeightForIndexPath:indexPath model:_dataModelArr[0] keyPath:@"topicModel1" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
                
            }else
            {
                
                    return 185;
               
                
            }
            
        }

    

    }
    
    int imageWidth =97;
    int space =11;
    
    
    if ((imageWidth+space)*(_arrDataSources.count+_networkImage.count+1)%((int)WIDTH-30)!=0) {
       
        
        CGFloat a=   ((int)((imageWidth+space)*(_arrDataSources.count+_networkImage.count+1)/((int)WIDTH-30)+1))*(imageWidth+space)+65;
       
      return  a;
    }else
    {
        
        CGFloat b= ((int)((imageWidth+space)*(_arrDataSources.count+_networkImage.count+1)/((int)WIDTH-30)+0))*(imageWidth+space)+65;
        
        return b;
    
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
        topicDetailcell *cell = [topicDetailcell cellWithTableView:tableView];
        if (!_isModel) {
            if ([NSString isBlankString:_dataDic[@"goodsName"]]||[NSString isBlankString:_dataDic[@"shoppingImage"]]) {
            [cell addValue:_dataDic];
            }
        }else
        {
            
            if ([NSString isBlankString:_myModel.headImage]) {
                [cell.myImage sd_setImageWithURL:[NSURL URLWithString:_myModel.headImage]];
            }
            
            if ([NSString isBlankString:_myModel.name]) {
                cell.name.text = _myModel.name;
                CGSize maximumLabelSize = CGSizeMake(WIDTH-30, 40);
                CGSize expectSize = [cell.name sizeThatFits:maximumLabelSize];
                cell.name.frame = CGRectMake(15,(cell.myImage.frame.size.height-expectSize.height)/2 ,WIDTH-30, expectSize.height);
            }

        }
        return cell;
    }
    
    
    if ([backReason isEqualToString:@"2"]) {
        
        //查看话题
        if (indexPath.section==1) {
            topicCell1 *cell = [topicCell1 cellWithTableView:tableView];
            //判断是否是二，是的话显示，不是隐藏,  _dataDic[@"auditStatus"
            if (_dataModelArr.count!=0) {
                
                cell.topicModel1 =_dataModelArr[0];
            }
            return cell;
        }
        if (indexPath.section==2) {
            self.textViewCell = [topicCell2 cellWithTableView:tableView];
//            self.textViewCell.textView.delegate =self;
            if (_dataModelArr.count!=0) {
                
                self.textViewCell.topicModel1 =_dataModelArr[0];
//                model =_dataModelArr[0];
//                
//                self.textViewCell.textView.text =model.goodsComment;
            }
            

            return self.textViewCell;
        }
    }else
    {
        //发表话题
        if (indexPath.section==1) {
            self.textViewCell = [topicCell2 cellWithTableView:tableView];
//            self.textViewCell.textView.delegate =self;
            
            if (_dataModelArr.count!=0) {
                
                self.textViewCell.topicModel1 =_dataModelArr[0];
//                model =_dataModelArr[0];
//                self.textViewCell.textView.text =model.goodsComment;
                
            }
            self.textViewCell.textView.editable = YES;
            return self.textViewCell;
        }
    
    }

      topicCell4 *cell = [topicCell4 cellWithTableView:tableView];
    
       [cell addValueNetWork:_networkImage local:_arrDataSources];
       cell.delegate=self;
       return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//删除图片
-(void)deleteImage:(NSInteger) imageTag
{
    
    if (imageTag>=_arrDataSources.count) {
        //网络图片
        
        TLPromptInformationView * promview = [[TLPromptInformationView alloc] initWithRootView:self.navigationController.view titleString:nil contentString:@"要删除这张图片吗" cancelString:@"删除" confirmString:@"取消"];
        [promview showView];
        
        MJWeakSelf;
        [promview viewEvnet:^(TLPromptInformationViewEventType type) {
            
            if(type == TLPromptInformationViewEventTypeCancel){
                
                
                
                 [weakSelf.networkImage removeObjectAtIndex:imageTag-_arrDataSources.count];
                
                [weakSelf.TableView reloadData];
            }
        }];

        
    }else
    {
    //本地图片
        
        TLPromptInformationView * promview = [[TLPromptInformationView alloc] initWithRootView:self.navigationController.view titleString:nil contentString:@"要删除这张图片吗" cancelString:@"删除" confirmString:@"取消"];
        [promview showView];
        
        MJWeakSelf;
        [promview viewEvnet:^(TLPromptInformationViewEventType type) {
            
            if(type == TLPromptInformationViewEventTypeCancel){
                
                
                [weakSelf.arrDataSources removeObjectAtIndex:imageTag];
                 [weakSelf.TableView reloadData];
            }
        }];

    
    
    }
    
    
    
}



//添加图片
-(void)addImage
{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择图像" preferredStyle: UIAlertControllerStyleActionSheet];
    // 使用富文本来改变alert的title字体大小和颜色
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(0, 2)];
    [alertController setValue:titleText forKey:@"attributedTitle"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //打开相机
        UIImagePickerController *icon_picture = [[UIImagePickerController alloc] init];
        icon_picture.sourceType = UIImagePickerControllerSourceTypeCamera;
        icon_picture.delegate = self;
        [self presentViewController:icon_picture animated:YES completion:nil];
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"从相册里选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        __weak __typeof(self)weakSelf = self;
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        if (weakSelf.arrDataSources.count!=0) {
            //设置最大选择数量
            actionSheet.maxSelectCount=5-weakSelf.arrDataSources.count;
        }else
        {
            //设置最大选择数量
            actionSheet.maxSelectCount = 5;
        }
        //设置预览图最大数目
        actionSheet.maxPreviewCount = 20;
        [actionSheet showPhotoLibraryWithSender:self lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
            
            NSArray *imageDataArray = [NSArray array];
            imageDataArray = selectPhotos;
            for (int i=0; i<imageDataArray.count; i++) {
                UIImage *resizedImage=imageDataArray[i];
                //UIImage *resizedImage = [UIImage scaleToSize:ima  size:CGSizeMake(200, 200)];
                NSData *data =UIImageJPEGRepresentation(resizedImage,kScaleImage);
                [weakSelf.arrDataSources insertObject:data atIndex:0];
               // [weakSelf.arrDataSources addObject:data];
            }
            
            //            //weakSelf.arrDataSources=[NSMutableArray arrayWithCapacity:_dataArr.count];
            
            [self.TableView reloadData];
        }];
        
        
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - UIImagePickerViewControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    //压缩图片
    //UIImage *resizedImage = [UIImage scaleToSize:image size:CGSizeMake(70, 70)];
    //重命名图片
    NSString *fileName = [NSString stringWithFormat:@"%@_myicon.png",@"1"];
    //保存在cache
    [UIImage savePNGImage:image toCachesWithName:fileName];
    
    //NSData *imageData = [NSData dataWithContentsOfFile: [UIImage getPNGImageFilePathFromCache:fileName]];
    //  销毁picker控制器
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //发送选择的图片到服务器
    //[self send_image_to_server_with_params:editedImage];
    //    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        
        //先把图片转成NSData
        UIImage* resizedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //UIImage *resizedImage = [UIImage scaleToSize:image  size:CGSizeMake(300, 300)];
        NSData *data;
        if (UIImagePNGRepresentation(resizedImage) == nil)
        {
            data = UIImageJPEGRepresentation(resizedImage, kScaleImage);
        }
        else
        {
            data = UIImagePNGRepresentation(resizedImage);
        }
        //        UIImage *ima =[UIImage imageWithData:data];
        
        NSArray *imageDataArray = [NSArray array];
        imageDataArray = @[data] ;
         [_arrDataSources insertObject:data atIndex:0];
       // [_arrDataSources addObject:data];
        //        //weakSelf.arrDataSources=[NSMutableArray arrayWithCapacity:_dataArr.count];
        //        [_arrDataSources insertObject:imageDataArray atIndex:selectCreame];
        
        [self.TableView reloadData];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
}


#pragma mark--网络请求(列表)
- (void)deleteRequest:(NSString *)topicID
{
    __weak __typeof(self)weakSelf = self;
    TLAccount *account = [TLAccountSave account];
   
    NSDictionary *params;
    params = @{@"uuid":account.uuid,@"id":topicID};
    [NetAccess getJSONDataWithUrl:kTopicLDelete parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
        if (code==0) {
            
            
            
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"删除成功"];
            
        }
       
    } fail:^{
        [MBProgressHUD showError:@"请求失败"];
        
    }];
}




-(void)submitRequest
{
    
    __weak __typeof(self)weakSelf = self;
    TLAccount *account = [TLAccountSave account];
    
    NSMutableDictionary *params =[[NSMutableDictionary alloc]init];
    NSString *MyProductId;
    if (!_isModel) {
        MyProductId=_productID;
    }else
    {
            MyProductId = _myModel.product_id;
    }
    
    UITextView *mytextView =(UITextView *)[self.view viewWithTag:666];
  
    if (mytextView.text.length==0) {
        [MBProgressHUD showError:@"请输入你的评价!"];
        return;
    }
    
    
    //_arrDataSources
    NSString *str;
    if (_networkImage.count!=0) {
        str = [_networkImage componentsJoinedByString:@","];
    }else
    {
    str=@"";
    }
    
    if (_arrDataSources.count!=0) {
        for (int i=0; i<_arrDataSources.count; i++) {
            UIImage *resizedImage=[UIImage imageWithData:_arrDataSources[i]];
            //压缩图片
//            UIImage *resizedImage = [UIImage scaleToSize:ima  size:CGSizeMake(300, 300)];
            
            NSString *imaKey = [NSString stringWithFormat:@"feedbackImgs[%d].imgUrl",i];
            NSData *data =UIImageJPEGRepresentation(resizedImage,kScaleImage);
            NSString *pictureDataString=[GTMBase64 stringByEncodingData:data];
            [params addEntriesFromDictionary:@{imaKey:pictureDataString}];
            
        }
        
    }

    NSString *MyId;
    NSString *MyUrl;
    if (_productID.length!=0) {
        MyId = _ID;
        MyUrl = [NSString stringWithFormat:@"%@myTopicsGoods/updateTopicsGoods",yangChuanHostV2];
    }else
    {
    MyId = @"";
    MyUrl = kTopicAdd;
    }
  [params addEntriesFromDictionary:@{@"uuid":account.uuid,@"productsId":MyProductId,@"auditStatus":[NSString stringWithFormat:@"%d",statue],@"goodsComment":mytextView.text,@"images":str,@"id":MyId}];
    
    [NetAccess postJSONWithUrl:MyUrl parameters:params WithLoadingView:YES andLoadingViewStr:nil success:^(id responseObject) {
        int code = [[[responseObject objectForKey:@"header"] objectForKey:@"code"] intValue];
        if (code==0) {
            
            
            //[weakSelf.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"提交成功"];
        }
        
        if ([_backInt isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            int index = (int)[[weakSelf.navigationController viewControllers]indexOfObject:weakSelf];
            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:(index -3)] animated:YES];
        }

        
    } fail:^{
        
        if ([_backInt isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            int index = (int)[[weakSelf.navigationController viewControllers]indexOfObject:weakSelf];
            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:(index -3)] animated:YES];
        }

        [MBProgressHUD showError:@"请求失败"];
        
    }];








}



#pragma mark--话题提交
-(void)commitFunction
{
    UIButton *commitBtn = [[UIButton alloc]init];
    commitBtn.frame = CGRectMake(0, HEIGHT-50-64, WIDTH, 50);
    [commitBtn setTitle:@"发表" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font =[UIFont systemFontOfSize:16];
    [commitBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5C36"]];
    [commitBtn addTarget:self action:@selector(comClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    

}

-(void)comClick:(UIButton *)sender
{

    //提交话题
    statue=0;
    [self submitRequest];

}

@end
