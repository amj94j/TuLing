//
//  HzCustomTabBarController.m
//  HzCustomViewController
//
//  Created by Beyond on 15/9/22.
//  Copyright © 2015年 Huozong. All rights reserved.
//

#import "HzCustomTabBarController.h"
#import "BaseNavigationController.h"
#import "HzTabarBtn.h"
#import "AppDelegate.h"

#import "UIButton+LXMImagePosition.h"

#define kColor(r , g ,b) [UIColor colorWithRed:(r)/255.0  green:(g)/255.0  blue:(b)/255.0 alpha:1]
@interface HzCustomTabBarController ()

@end

@implementation HzCustomTabBarController
{
    UITapGestureRecognizer * _tapRgr;
    UIImageView * bgView;
}


#define tabBarItemsTag 2015
#define offSet  200  // 抽屉效果的偏移

-(instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[TLUploadSystemInfo shareIntens]uploadSystemBaseDatatoServer];
    
    /*
     * 关闭自定义崩溃收集日志，继续使用友盟
     */
//    [self sendException];
    
}


-(void)sendException{
    
    MJWeakSelf;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       
        // 发送崩溃日志
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];
        NSData *data = [NSData dataWithContentsOfFile:dataPath];
        if (data != nil) {
            [weakSelf sendExceptionLogWithData:data path:dataPath];
        }
    });
}



#pragma mark -- 发送崩溃日志
- (void)sendExceptionLogWithData:(NSData *)data path:(NSString *)path {
    

}



- (void)creatTabbarVCWithControllersArray:(NSArray *)vcArray andTabbarNormalImageArr:(NSArray *)normalArr andTabbarSelectedImageArr:(NSArray *)TabbarSelectedArr andTabbarsTitlesArr:(NSArray *)titlesArr
{
    // 创建tabbarItems
    self.tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, tabbarHeight)];
    self.tabBarView.backgroundColor = [UIColor whiteColor];
    self.tabBarView.userInteractionEnabled = YES;
    [self.tabBar addSubview:self.tabBarView];
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (int i=0; i<vcArray.count; i++)
    {
        HzTabarBtn * btn = [[HzTabarBtn alloc] initWithFrame:CGRectMake(i*mainScreenWidth/vcArray.count, 0, mainScreenWidth/vcArray.count, tabbarHeight)];
        // UIViewContentModeScaleAspectFill也会证图片比例不变，但是是填充整个ImageView的
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.tag = i+tabBarItemsTag;
        [btn addTarget:self action:@selector(tabBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(0, 102, 32) forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:normalArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:TabbarSelectedArr[i]] forState:UIControlStateSelected];
        
        [self.tabBarView addSubview:btn];
        [btn setImagePosition:LXMImagePositionTop spacing:2];
//        if (i == vcArray.count - 1){
//        
//            UIEdgeInsets def = btn.imageEdgeInsets;
//            def.left = def.left + ;
//            btn.imageEdgeInsets = def;
//            
//        }
        
        
        UIViewController * vc = [[NSClassFromString(vcArray[i]) alloc] init];
        BaseNavigationController * cvc = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [array addObject:cvc];
        
        // 添加拖拽手势实现抽屉效果
        UISwipeGestureRecognizer *swipeGtr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [vc.view addGestureRecognizer:swipeGtr];
        
        
        
    }
    self.viewControllers = array;
    
    
}
- (UIImage*)getImage
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return img;
}
// 切换tabbar
- (void)tabBarBtnClick:(id)sender
{
    HzTabarBtn * btn = (HzTabarBtn *)sender;
    
    for (int i =0;i<self.viewControllers.count;i++)
    {
        HzTabarBtn * button = (HzTabarBtn *)[self.tabBarView viewWithTag:tabBarItemsTag+i];
        button.selected = NO;
    }
    btn.selected = YES;
    NSInteger indexx = btn.tag-tabBarItemsTag;
    self.selectedIndex = indexx;
}


-(void)selectBar:(NSUInteger )sele
{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 设置默认选中的视图
    app.tab.selectedIndex = sele;
    
    // 设置默认选中的tabbar按钮
    for (int i=0; i<4; i++) {
        if (i==sele) {
            ((HzTabarBtn *)[app.tab.tabBarView.subviews objectAtIndex:i]).selected = YES;
        }else
        {
            ((HzTabarBtn *)[app.tab.tabBarView.subviews objectAtIndex:i]).selected = NO;
        }
    }

}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSString *str;
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex==0) {
        str=@"51";
    }
    if (tabIndex==1) {
        str=@"CY300";
    }
    if (tabIndex==2) {
        str=@"60";
    }
    if (tabIndex==3) {
        str=@"TC200";
    }
    //友盟统计
    [MobClick event:str];
    if (tabIndex != self.selectedIndex)
    {
        HzTabarBtn *btn = (HzTabarBtn*)[self.tabBarView viewWithTag: tabIndex+tabBarItemsTag];
        [self tabBarBtnClick:btn];
    }
}
- (void)showLeftView{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CGAffineTransform transT = CGAffineTransformMakeTranslation(kLeftVCWidth, 0);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(1, 1);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
   
    [UIView animateWithDuration:0.3 animations:^{
        //        app.tab.view.frame = CGRectMake(offSet, 0, mainScreenWidth, mainScreenHeight);
        app.tab.view.transform= conT;
    } completion:^(BOOL finished){
        if (bgView) {
            [bgView removeFromSuperview];
        }
        bgView = [[UIImageView alloc] init];
        bgView.frame = CGRectMake(0, 0, mainScreenWidth, mainScreenHeight);
        bgView.backgroundColor =RGBACOLOR(0, 0, 0, 0.5);
        bgView.userInteractionEnabled = YES;
        bgView.tag = 1321;
        //bgView.image = [self getImage];
        
        [self performSelector:@selector(bringBgViewToFront) withObject:nil afterDelay:0.25];
//        [self.view bringSubviewToFront:bgView];
        // 添加点击手势实现反回
        
        _tapRgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabAction)];
        [app.tab.view addGestureRecognizer:_tapRgr];
       
        _tapRgr.enabled = YES;
        
       
    }];
    AppDelegate * app1 = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app1.lvc geticon:[TLAccountSave account].uuid];
}

- (void) bringBgViewToFront
{
    [self.view addSubview:bgView];
    [self.view bringSubviewToFront:bgView];
}

- (void)panAction:(UISwipeGestureRecognizer *)swipeRgr
{
    [self showLeftView];
}
- (void)showMainView
{
    [self tabAction];
}
- (void)tabAction
{
    [UIView animateWithDuration:0.3 animations:^{
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.tab.view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
         bgView.backgroundColor =RGBACOLOR(0, 0, 0, 0.0);
    } completion:^(BOOL finished){
        
        _tapRgr.enabled = NO;
        UIImageView * view = [self.view viewWithTag:1321];
        [view removeFromSuperview];
        [self.view removeGestureRecognizer:_tapRgr];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
