//
//  TempViewController.m
//  TuLingApp
//
//  Created by gyc on 2017/5/11.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TempViewController.h"
#import "TLLoadImageView.h"
#import "ZLPhotoActionSheet.h"

@interface TempViewController ()<TLLoadImageViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) TLLoadImageView * loadImageView;
@end

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _loadImageView = [[TLLoadImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 165)];
    _loadImageView.titleString = @"上传焦点图";
    _loadImageView.isHaveBitmap = YES;
    _loadImageView.delegate = self;
    MJWeakSelf;
    [_loadImageView viewSizeChanged:^(CGSize size) {
        NSLog(@"change siz - %@ , frame - %@" ,NSStringFromCGSize(size),NSStringFromCGRect(weakSelf.loadImageView.frame));
        
//        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
        
        //        [weakSelf.tableView reloadData];
    }];
    
    [self.view addSubview:_loadImageView];
}

//点击了占位图
-(void)selectBitmap:(TLLoadImageView *)view{
    [self creamtap];
}

//调用照片库方法
-(void)creamtap
{
    if(1 >= 5){
        
        MBProgressHUD * pro = [MBProgressHUD showMessage:@"图片已超过5张不能再添加" duration:1.3];
        pro.mode = MBProgressHUDModeText;
        return;
    }
    
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
        if (1!=0) {
            //设置最大选择数量
//            actionSheet.maxSelectCount=5-weakSelf.arrDataSources.count;
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
                UIImage *ima=imageDataArray[i];
//                UIImage *resizedImage = [UIImage scaleToSize:ima  size:CGSizeMake(kUpdateImageWidth, kUpdateImageWidth / 16 * 9)];
                NSData *data =UIImageJPEGRepresentation(ima,1.0);
//                [weakSelf.arrDataSources addObject:data];
                [weakSelf.loadImageView addImage:data];
            }
        }];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    //压缩图片
//    UIImage *resizedImage = [UIImage scaleToSize:image size:CGSizeMake(70, 70)];
    //重命名图片
    NSString *fileName = [NSString stringWithFormat:@"%@_myicon.png",@"1"];
    //保存在cache
//    [UIImage savePNGImage:resizedImage toCachesWithName:fileName];
    
    //NSData *imageData = [NSData dataWithContentsOfFile: [UIImage getPNGImageFilePathFromCache:fileName]];
    //  销毁picker控制器
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *resizedImage = image;
        NSData *data;
        if (UIImagePNGRepresentation(resizedImage) == nil)
        {
            data = UIImageJPEGRepresentation(resizedImage, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(resizedImage);
        }
        //        UIImage *ima =[UIImage imageWithData:data];
        
        NSArray *imageDataArray = [NSArray array];
        imageDataArray = @[data] ;
        
//        [_arrDataSources addObject:data];
        [_loadImageView addImage:data];
        //        //weakSelf.arrDataSources=[NSMutableArray arrayWithCapacity:_dataArr.count];
        //        [_arrDataSources insertObject:imageDataArray atIndex:selectCreame];
        
        
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
}


@end
