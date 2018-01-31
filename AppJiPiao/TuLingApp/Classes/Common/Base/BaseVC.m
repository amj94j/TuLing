//
//  BaseVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseVC.h"
#import "UIButton+Extensions.h"
@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    
    
    if (self.navigationItem.leftBarButtonItem == nil && [self.navigationController.viewControllers count] > 1) {
        
        // 返回按钮
        UIButton *btn = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(onBackBarBtnClick) Title:@""];
        [btn setHitTestEdgeInsets:UIEdgeInsetsMake(-20, -20, -20, -20)];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
    }
}


#pragma mark -- 重写返回按钮（支持右滑返回）
- (void) onBackBarBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    } else {
        return YES;
    }
}

-(void)exit{
    if (self.navigationController.viewControllers.count > 1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.view.userInteractionEnabled = YES;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(int)requetsResutlCode:(NSDictionary *)responseDic{

    if ([responseDic objectForKey:@"header"]){
        NSDictionary * headerDic = [responseDic objectForKey:@"header"];
        if (!headerDic){
            return -1;
        }
        int code = [headerDic[@"code"] intValue];
        
        return code;
    }
    
    return -1;
}

-(void)showProgressError:(NSString*)messageString{

    if ([NSString isBlankString:messageString]){
        [MBProgressHUD showError:messageString];
    }else{
        [MBProgressHUD showError:@"网络出错啦"];
    }
    
}

-(void)showProgress:(NSString *)messageString{

    [MBProgressHUD showSuccess:messageString];
}


-(NSString*)accountUUID{
    TLAccount *account = [TLAccountSave account];
    return account.uuid;
}

/**
 *  注销通知
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewAdjustmentTop:(UIScrollView*)sView{

        if (@available(iOS 11.0, *)) {
            if ([sView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)])
                sView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            [self viewAdjustment];
        }
}

-(void)viewAdjustment{
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
        self.automaticallyAdjustsScrollViewInsets = NO;
}

@end
