/**
 *  tableview的section个数
 */
#define SECTION_NUM 2
/**
 *  section1里cell的个数
 */
#define ROW_OF_SECTION_ONE 4
/**
 *  section2里cell的个数
 */
#define ROW_OF_SECTION_TWO 4
/**
 *  section header height
 */
#define SECTION_HEADER_HEIGHT 64
/**
 *  分类名
 */
#define DURATION 0.1


#define ORIGINAL_MAX_WIDTH 640.0f

#import "Tuling_user_setting_ViewController.h"
#import "Tuling_user_setting_frame_model.h"
#import "Tuling_user_setting_cell.h"
#import "Input_user_setting.h"
#import "TL_post_formdata.h"
#import "VPImageCropperViewController.h"
#import "UIImage+fixOrientation.h"
#import "MyPickerView.h"
#import "perTableViewCell.h"

#import "UIImage+Addition.h"
#import "GTMBase64.h"
@interface Tuling_user_setting_ViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate,UITextFieldDelegate>
{

    NSString *food;
    NSString *hangyeStr;
    NSString *sexStr;
    NSString *yearStr;
    NSString *educationStr;
    

}

@property (nonatomic, strong) Tuling_user_setting_frame_model * user_frame_model;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) Input_user_setting * input_user_name;
@property (nonatomic, strong) UIView * forbidden_view;
@property(nonatomic,strong)NSDictionary *userDic;
@property(nonatomic,strong)NSMutableArray *yearArr;
@property(nonatomic,strong)NSMutableArray *yearNameArr;
@property(nonatomic,strong)NSMutableArray *yearIDArr;
@property(nonatomic,strong)NSMutableArray *educationNameArr;
@property(nonatomic,strong)NSMutableArray *educationIDArr;
@end
/**
 *  SCLAlertView
 */
//NSString *kInfoTitle = @"修改个人信息";
NSString *kSubtitle = @"请将要修改的内容填在下面";
NSString *kButtonTitle = @"取消";

@implementation Tuling_user_setting_ViewController
/**
 添加图片的方式，照相机和图库
 */
typedef enum {
    add_picture_type_with_camera = 1,
    add_picture_type_with_storage
    
} add_picture_type;
/**
 个人信息一一对应
 */
typedef enum {
    
    user_information_to_icon,
    user_information_to_user_name,
    //user_information_to_name,
    user_information_to_sex,
    //user_information_to_phone,
    //user_information_to_wechat,
    // user_information_to_qq
    
} user_information;

-(Input_user_setting*)input_user_name
{
    if (_input_user_name == nil) {
        _input_user_name = [[Input_user_setting alloc]init];
    }

    return _input_user_name;
}
- (UIView * )forbidden_view
{

    if (_forbidden_view == nil) {
        _forbidden_view = [[UIView alloc]initWithFrame:self.view.frame];
        _forbidden_view.hidden = YES;
        _forbidden_view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_forbidden_view];
        [self.view bringSubviewToFront:_forbidden_view];
    }
    return _forbidden_view;
}
- (void) setForbidden_view_hidden_and_backgroundcolorclear_and_input_user_name_hidden
{
    [UIView animateWithDuration:DURATION animations:^{
        self.forbidden_view.backgroundColor = RGBACOLOR(255, 255, 255, 0);
        self.input_user_name.hidden = YES;
    } completion:^(BOOL finished) {
        self.forbidden_view.hidden = YES;
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    self.title = @"个人中心";
    UIButton * backBtn = [LXTControl createButtonWithFrame:CGRectMake(15, 32, 22, 20) ImageName:@"back2" Target:self Action:@selector(backClick) Title:@""];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    //self.view.backgroundColor = [UIColor blackColor];
    _userDic =[[NSDictionary alloc]init];
    _yearArr = [[NSMutableArray alloc]init];
    _yearNameArr = [[NSMutableArray alloc]init];
    _yearIDArr = [[NSMutableArray alloc]init];
    _educationNameArr=[[NSMutableArray alloc]init];
    _educationIDArr = [[NSMutableArray alloc]init];
    //注册通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi1:) name:@"tongzhi1" object:nil];
    [self request];
    [self request1];
    [self request2];
    [self init_tableview];
    
}
-(void)backClick
{
    
     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
   // [self.navigationController popViewControllerAnimated:YES];
    
}
/**
 *  初始化tableview
 */
- (void)init_tableview
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped ];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

#pragma mark tableview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
/**
 *  使用的时候先判断section,再用switch判断row来为每一个静态单元格赋值。
 *
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    perTableViewCell  *cell = [perTableViewCell  cellWithTableView:tableView];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    cell.textField.delegate = self;
    if (indexPath.section == 0)
    {
        cell.textField.tag = indexPath.row;
        switch (indexPath.row) {
                //头像
            case 0:
            {
                
                cell.leftLabel.text = @"头像";
                cell.leftLabel.frame =CGRectMake(15, 30, 120, 20);
                cell.rightArrowImageView.hidden = NO; //显示最右边的箭头
                UIImageView *imageView1 ;
                if (imageView1==nil) {
                    imageView1 = [LXTControl createImageViewWithFrame:CGRectMake(WIDTH-30 - 20 -60, 10, 60, 60) ImageName:@""];
                    if ([self isBlankString:_userDic[@"icon"]]) {
                        [imageView1 sd_setImageWithURL:[NSURL URLWithString:_userDic[@"icon"]]];
                    }else
                    {
                    [imageView1 setImage:[UIImage imageNamed:@"person0"]];
                    }
                    imageView1.layer.masksToBounds = YES;
                    imageView1.layer.cornerRadius = imageView1.frame.size.width/2;
                    [cell addSubview:imageView1];
                }
            }
                break;
                //昵称
            case 1:
            {
                cell.leftLabel.text = @"昵称";
                if (![NSString isBlankString:cell.textField.text]) {
                    
                
                if ([NSString isBlankString:_userDic[@"name"]]) {
                    cell.textField.text = _userDic[@"name"];
                }else
                {
                cell.textField.text = _userDic[@"user_name"];
                
                }
                }else
                {
                
                }
                
                cell.textField.frame =CGRectMake(WIDTH-30-[NSString singeWidthForString:cell.textField.text fontSize:13 Height:12] , 20, [NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20);
                cell.textField.tag=1;
                [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                cell.rightArrowImageView.hidden = YES;
                
            }
                
                break;
                
            case 2:
            {
                cell.leftLabel.text = @"性别";
                if ( [self isBlankString:_userDic[@"sex"]]||[self isBlankString:sexStr]) {
                    if (sexStr.length!=0) {
                        cell.textField.text  =sexStr;
                    }else
                    {
                     cell.textField.text = _userDic[@"sex"];
                    }
                    
                }else
                {
                 cell.textField.text = @"还不知道你的性别";
                }
                cell.textField.frame =CGRectMake(WIDTH-30-[NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20, [NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20);
               cell.rightArrowImageView.hidden = YES;
            }
                
                break;
            case 3:
            {
                cell.leftLabel.text = @"年龄";
                if ( [self isBlankString:_userDic[@"age"]]||[self isBlankString:yearStr]) {
                    if (yearStr.length!=0) {
                        cell.textField.text= yearStr;
                    }else
                    {
                        cell.textField.text = _userDic[@"age"];
                    }
                    
                }else
                {
                      cell.textField.text = @"还不知道你的年龄";
                }
                cell.textField.frame =CGRectMake(WIDTH-30-[NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20, [NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20);
                cell.rightArrowImageView.hidden = YES;
            }
                
                break;
            default:
                break;
        }
    }
    else
    {
         cell.textField.tag = indexPath.row+30;
        switch (indexPath.row) {
            case 0:
            {
                cell.leftLabel.text = @"行业";
                if ( [self isBlankString:_userDic[@"career"]]||[self isBlankString:hangyeStr]) {
                    if (hangyeStr.length!=0) {
                        cell.textField.text = hangyeStr;
                    }else
                    {
                        cell.textField.text = _userDic[@"career"];
                    }
                }else
                {
                    cell.textField.text = @"请选择你的行业";
                }
                cell.textField.frame =CGRectMake(WIDTH-30-[NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20, [NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20);
                    cell.rightArrowImageView.hidden = NO;

            }
                break;
            case 1:
            {
                cell.leftLabel.text = @"饮食偏好";
                if ( [self isBlankString:food]) {
                    if (food.length!=0) {
                        cell.textField.text = food;
                    }else
                    {
                        cell.textField.text = @"添加饮食偏好设置";
                    }

                }else
                {
                    cell.textField.text = @"添加饮食偏好设置";
                }
                cell.textField.frame =CGRectMake(WIDTH-30-[NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20, [NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20);
                cell.rightArrowImageView.hidden = NO;
                
            }
                break;
            case 2:
            {
               cell.leftLabel.text = @"学历";
               NSString *str =_userDic[@"education"];
                if ([self isBlankString:str]||[self isBlankString:educationStr]) {
                    if (educationStr.length!=0) {
                        cell.textField.text= educationStr;
                    }else
                    {
                        cell.textField.text = _userDic[@"education"];
                    }
                    
                }else
                {
                    cell.textField.text = @"请添加你的学历";
                }
                cell.textField.frame =CGRectMake(WIDTH-30-[NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20, [NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20);
                cell.rightArrowImageView.hidden = YES;
            }
                break;
            case 3:
            {
                cell.leftLabel.text = @"手机号";
                NSString *str =_userDic[@"phone"];
                if ([self isBlankString:str]) {
                   
                cell.textField.text = _userDic[@"phone"];
                    
                    
                }else
                {
                    cell.textField.text = @"还不知道你的手机号";
                }
                cell.textField.frame =CGRectMake(WIDTH-30-[NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20, [NSString singeWidthForString:cell.textField.text fontSize:13 Height:12], 20);
                cell.rightArrowImageView.hidden = YES;
                
            }
                break;
            default:
                break;
        }
    }
    return cell;
}
/**
 *  点击单元格触发事件
 *
 *  @param indexPath.row 点击的行数
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if(indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                //选择是打开相机还是打开相册
                UIActionSheet * choose_picture = [[UIActionSheet alloc]initWithTitle:@"请选择图像" delegate:self cancelButtonTitle:nil
                                                              destructiveButtonTitle:@"返回"
                                                                   otherButtonTitles:@"拍照", @"从相册里选择",nil];
                [choose_picture showInView:self.view];
                
            }
                break;
            case 1:
            {
                //弹出窗口输入内容，确定就提交，提交完要刷新tableview的内容
               
                    UITextField *textFid = (UITextField *)[self.view viewWithTag:1];
                
                    textFid.userInteractionEnabled =YES;
                   [textFid becomeFirstResponder];
                    
              
            }
                break;
                
            case 2:
            {
                //同1 跳转到pickerView
                [self sex_picker_with_key:@"sex"];
                
            }
                break;
            case 3:
            {
                //同1 跳转到pickerView
                [self year_picker_with_key:nil];
                
            }
                break;
            default:
                break;
        }
        
    }else
    {
    
        if (indexPath.row==0) {
//            UITextField *textFid = (UITextField *)[self.view viewWithTag:30];
//            textFid.userInteractionEnabled =YES;
        
          
            
        }
        if (indexPath.row==1) {
           
        }
        if (indexPath.row==2) {
            [self education_picker_with_key:nil];
        }
    
    }
    
}
#pragma mark actionsheet delegate
/**
 *  actionsheet代理方法
 *
 *  @param actionSheet
 *  @param buttonIndex 按钮的index
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case add_picture_type_with_camera:
        {
            //打开相机
            UIImagePickerController *icon_picture = [[UIImagePickerController alloc] init];
            icon_picture.sourceType = UIImagePickerControllerSourceTypeCamera;
            icon_picture.delegate = self;
            [self presentViewController:icon_picture animated:YES completion:nil];
        }
            break;
        case add_picture_type_with_storage:
        {
            //打开图库
            UIImagePickerController *icon_picture = [[UIImagePickerController alloc] init];
            icon_picture.title = @"";
            icon_picture.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            icon_picture.delegate = self;
            [self presentViewController:icon_picture animated:YES completion:nil];
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
    // 1. 销毁picker控制器
    [picker dismissViewControllerAnimated:YES completion:^{
        // 2. 获取图片
        UIImage *portraitImg = info[UIImagePickerControllerOriginalImage];
        // 3. 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:[portraitImg fixOrientation] cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
        }];
        
//        if (isCamera) {
//            [picker dismissModalViewControllerAnimated:NO];
//            
//            // 把拍摄的照片保存到本地
//            
//            UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
//            if (photo) {
//                UIImageWriteToSavedPhotosAlbum(photo, self,
//                                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //发送选择的图片到服务器
//    //压缩图片
    UIImage *resizedImage = [UIImage scaleToSize:editedImage size:CGSizeMake(200, 200)];
    [self send_image_to_server_with_params:resizedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark tableview datasource

/**
 *  设置section中view的代理方法
 *
 */
  


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            return ICON_CELL_HEIGHT;
        }
        else
        {
            return  60;
        }
        
    }
    else
    {
        return  60;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_NUM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return ROW_OF_SECTION_ONE;
            break;
        case 1:
            return ROW_OF_SECTION_TWO;
            break;
            
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
# pragma mark TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:_userDic[@"user_name"]]||[textField.text isEqualToString:_userDic[@"name"]]) {
        
        
        
    }else{
        NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:textField.text,@"name", nil];
        
        [self send_data_to_server_with_params:params];
    }
    
    

     [textField resignFirstResponder];
     textField.userInteractionEnabled=NO;
   
    return YES;
}
-(void)textFieldDidChange :(UITextField *)theTextField{
   
    if (theTextField.tag==1) {
        
            if (theTextField.text.length > 20) {
                theTextField.text = [theTextField.text substringToIndex:20];
                 [MBProgressHUD showError:@"不能超过20个汉字"];
            }
        
        theTextField.frame =CGRectMake(WIDTH-30-[NSString singeWidthForString:theTextField.text fontSize:13 Height:12], 12, [NSString singeWidthForString:theTextField.text fontSize:13 Height:12], 20);
    }
    

}
#pragma mark AFNetworking



/**
 *  向服务器发送更新数据的方法
 */
- (void)send_data_to_server_with_params:(NSDictionary*)dictionary
{
    
}

/**
 *  向服务器发送更新头像图片数据的方法
 */
- (void)send_image_to_server_with_params: (UIImage*)image
{


}
- (void) education_picker_with_key:(NSString*)key
{   NSArray *arr = _educationNameArr;
    MyPickerView * my_pick = [[MyPickerView alloc]initWithTitle:@"请选择学历" array:arr andCurIndex:0];
    my_pick.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:my_pick];
    [my_pick showInView:self.view selectBlock:^(int selectIndex) {
        
        NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
        [dicParams setObject:_educationNameArr[selectIndex] forKey:@"education"];
        educationStr =_educationNameArr[selectIndex];
        [self send_data_to_server_with_params:dicParams];
        [self.tableView reloadData];
    } cancel:^{
        nil;
    }];
    
}



- (void) year_picker_with_key:(NSString*)key
{   NSArray *arr = _yearNameArr;
    MyPickerView * my_pick = [[MyPickerView alloc]initWithTitle:@"请选择年代" array:arr andCurIndex:0];
    my_pick.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:my_pick];
    [my_pick showInView:self.view selectBlock:^(int selectIndex) {
        
        NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
        
        [dicParams setObject:_yearNameArr[selectIndex] forKey:@"age"];
        yearStr =_yearNameArr[selectIndex];
        [self send_data_to_server_with_params:dicParams];
        [self.tableView reloadData];
        } cancel:^{
        nil;
    }];
    
}


- (void) sex_picker_with_key:(NSString*)key
{
    MyPickerView * my_pick = [[MyPickerView alloc]initWithTitle:@"请选择性别" array:@[@"男",@"女"]andCurIndex:0];
    my_pick.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:my_pick];
    [my_pick showInView:self.view selectBlock:^(int selectIndex) {
        switch (selectIndex) {
            case 0:
            {
                //男
                NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"男",key, nil];
                sexStr =@"男";
                [self send_data_to_server_with_params:params];
                [self.tableView reloadData];
            }
                break;
            case 1:
            {
                //女
                sexStr =@"女";
                NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"女",key, nil];
                [self send_data_to_server_with_params:params];
                [self.tableView reloadData];
            }
                break;
            default:
                break;
            
                
        }
    } cancel:^{
        nil;
    }];
    
}
#pragma mark--网络请求
- (void)request
{
  
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];

    [self setForbidden_view_hidden_and_backgroundcolorclear_and_input_user_name_hidden];
  
    
}

- (void)tongzhi:(NSNotification *)text{
    
    
    
    NSLog(@"－－－－－接收到通知------");
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhi" object:nil];
    food =[[NSString alloc]init];
     NSArray *arr11= [text.userInfo allValues];
    for (NSString *str1 in arr11) {
        if (food.length!=0) {
            food = [NSString stringWithFormat:@"%@ %@ ",food, str1];
        }else
        {
        food = [NSString stringWithFormat:@"%@", str1];
        
        }
        
    }
    NSString *send = [[NSString alloc]init];
    for (NSString *str1 in arr11) {
        if (send.length!=0) {
            send = [NSString stringWithFormat:@"%@,%@ ",send, str1];
        }else
        {
            send = [NSString stringWithFormat:@"%@", str1];
            
        }
        
    }

    NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
    [dicParams setObject:send forKey:@"foods"];
    [self send_data_to_server_with_params:dicParams];
    
    [self.tableView reloadData];
}


- (void)tongzhi1:(NSNotification *)text{
    
   
    

//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhi1" object:nil];
    

    hangyeStr = text.userInfo[@"value_name"];
    
    NSMutableDictionary *dicParams =[[NSMutableDictionary alloc]init];
    [dicParams setObject:hangyeStr forKey:@"career"];
    [self send_data_to_server_with_params:dicParams];

    [self.tableView reloadData];
}



#pragma mark--年龄
- (void)request1
{
    NSDictionary *params = @{@"type": @"NIAN_DAI"};
  
}


#pragma mark--年龄
- (void)request2
{

    
   
}
-  (BOOL) isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return NO;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return NO;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return NO;
        
    }
    
    return YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
