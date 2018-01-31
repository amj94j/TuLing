//
//  AppDelegate.m
//  TuLingApp
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+XHLaunchAd.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMMobClick/MobClick.h"
#import "TLAccountSave.h"
#import "StaticTools.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "IQKeyboardManager.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "MyOrderDetailVC.h"
#import "OrderReturnDetailVC.h"

@interface AppDelegate ()<UIAlertViewDelegate>
{
    NSDictionary *myDic1;
    NSDictionary *myDic2;
    
    UIAlertView *_needUpAlert;
    UIAlertView *_upAlert;
    
    BOOL _otherDeviceLogin;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if (launchOptions !=nil) {
        
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        myDic1=remoteNotification;
        if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
     
            [self performSelector:@selector(skipToMessageCenter) withObject:nil afterDelay:1];
           
        }else{
            
            [self performSelector:@selector(skipToMessageCenter) withObject:nil afterDelay:1];
        }
    }
 
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
   
    [[SDWebImageManager sharedManager].imageDownloader setValue: nil forHTTPHeaderField:@"Accept"];
 
    [self.window makeKeyAndVisible];
    
    //控制显示个人中心显示商户还是个人，-1未登录，0个人，1商户
    [[NSUserDefaults standardUserDefaults] setObject:@"-1" forKey:kShopStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //显示状态栏
    application.statusBarHidden = NO;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    [StaticTools chooseRootController];

    return YES;
  
}



//当前登录账号在其它设备登录时会接收到此回调
-(void)userAccountDidLoginFromOtherDevice{
    _otherDeviceLogin = YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    

   
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
           
            NSString *resultStatus=resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {

                NSString *allString=resultDic[@"result"];
               // NSMutableDictionary *Mydic =[resultDic[@"result"] objectForKey:@"alipay_trade_app_pay_response"];
                
               // [self request:Mydic];

                [MBProgressHUD showSuccess:@"支付成功"];
                NSDictionary *resDic = @{@"result":@"0"};
                NSNotification *notification =[NSNotification notificationWithName:@"resultName" object:nil userInfo:resDic];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];

                NSDictionary *dic = [self dictionaryWithJsonString:allString];

                NSMutableDictionary *Mydic = [[NSMutableDictionary alloc]init];
                Mydic =dic[@"alipay_trade_app_pay_response"];
                
                
                
                
                [self request:Mydic];
                
                
            }
            else
            {
                NSDictionary *resDic = @{@"result":@"1"};
                NSNotification *notification =[NSNotification notificationWithName:@"resultName" object:nil userInfo:resDic];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                //NSLog(@"支付失败");
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
          
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
          
        }];
        return YES;
    }else if (([[url absoluteString] rangeOfString:@"TuLingApp://"]).location!=NSNotFound)
    {
        
        
       
        
        NSRange range = [[url absoluteString] rangeOfString:@"://"];//匹配得到的下标
        NSString *str = [[url absoluteString] substringWithRange:NSMakeRange(range.location+range.length, [url absoluteString].length-range.length-range.location)];//截取范围类的字符串
        
        NSString *unicodeStr1 = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic=[self dictionaryWithJsonString:unicodeStr1];
        myDic2=dic;
         [self performSelector:@selector(skipToMessageCenter1) withObject:nil afterDelay:1];
        
        
        return YES;
    }
    
    else
    {
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
        
        if (result) {
            return  [[UMSocialManager defaultManager] handleOpenURL:url];
        }else
        {
     return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
        
        
        
    }
//    //return YES;
//
//    BOOL result = [UMSocialSnsService handleOpenURL:url];
//    //int a =[WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//    NSLog(@"%d === result",result);
//    if (result == FALSE) {
//        //调用其他SDK，例如支付宝SDK等
//      return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];;
//    }
//    return result;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    

    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
          
            NSString *resultStatus=resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {

                //NSMutableDictionary *Mydic =[resultDic[@"result"] objectForKey:@"alipay_trade_app_pay_response"];
                //[self request:Mydic];

                NSString *allString=resultDic[@"result"];
                
                
                NSDictionary *dic = [self dictionaryWithJsonString:allString];

                
               // NSLog(@"ali=%@",dic);
                
//                if ([dic[@"success"]isEqualToString:@"true"]) {
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:dic];
//                    
//                }
                
                
                NSMutableDictionary *Mydic = [[NSMutableDictionary alloc]init];
                Mydic =dic[@"alipay_trade_app_pay_response"];
                
                [MBProgressHUD showSuccess:@"支付成功"];
                NSDictionary *resDic = @{@"result":@"0"};
                NSNotification *notification =[NSNotification notificationWithName:@"resultName" object:nil userInfo:resDic];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
               // NSLog(@"%@",Mydic);

//                [self request:Mydic];
                

               //  [MBProgressHUD showSuccess:@"支付成功"];
                
            }
            else
            {
                NSDictionary *resDic = @{@"result":@"1"};
                NSNotification *notification =[NSNotification notificationWithName:@"resultName" object:nil userInfo:resDic];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
            }

        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            
         
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
        
        }];
        
         return YES;
    }
    else if (([[url absoluteString] rangeOfString:@"TuLingApp://"]).location!=NSNotFound)
    {
        NSRange range = [[url absoluteString] rangeOfString:@"://"];//匹配得到的下标
        NSString *str = [[url absoluteString] substringWithRange:NSMakeRange(range.location+range.length, [url absoluteString].length-range.length-range.location)];//截取范围类的字符串
        
        NSString *unicodeStr1 = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          NSDictionary *dic=[self dictionaryWithJsonString:unicodeStr1];
        myDic2=dic;
        [self performSelector:@selector(skipToMessageCenter1) withObject:nil afterDelay:1];
     
        
        return YES;
    }else{
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
        if (result) {
            return [[UMSocialManager defaultManager] handleOpenURL:url];
        }else
        {
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
    }
   
}
-(BOOL)application:(UIApplication* )application handleOpenURL:(NSURL* )url{
  
    if ([url.host isEqualToString:@"test"])
    {
        
    }
    return YES;
}
-(void)request:(NSMutableDictionary *)dic
{
    
    TLAccount *account = [TLAccountSave account];
    NSDictionary *params;
    if (account.uuid!=nil) {
        params = @{@"out_trade_no":dic[@"out_trade_no"],@"uuid":account.uuid,@"total_amount":dic[@"total_amount" ],@"seller_id":dic[@"seller_id"],@"app_id":dic[@"app_id"],};
        
    }
    [NetAccess postJSONWithUrl:kalipayResult parameters:params WithLoadingView:NO andLoadingViewStr:nil success:^(id responseObject) {
        
 
        int code = [[[responseObject objectForKey:@"header"]objectForKey:@"code"] intValue];
     
        if (code==0) {

            [MBProgressHUD showSuccess:@"支付成功"];
            NSDictionary *resDic = @{@"result":@"0"};
                NSNotification *notification =[NSNotification notificationWithName:@"resultName" object:nil userInfo:resDic];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    } fail:^{
        [MBProgressHUD showError:@"网络错误"];
        NSLog(@"dv");
    }];
    
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [application setApplicationIconBadgeNumber:0];
     
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   
     
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
 
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[application setApplicationIconBadgeNumber:0];
     
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   // [application setApplicationIconBadgeNumber:0];
    

}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
 
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
   
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
 
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
     
}

/**
 
 *  支付宝返回字段解析
 
 
 
 *  @return 返回字典
 
 */

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
       
        
        return nil;
        
    }
    
    return dic;
    
}



- (void)resultPush:(NSDictionary *)text{
 
    NSString *str= text[@"type0"];
    NSString *str1= text[@"type1"];
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    switch ([str intValue]) {
        
        case 1:
        {
            //订单详情
            
            MyOrderDetailVC *VC = [[MyOrderDetailVC alloc]init];
            VC.orderId =[str1 integerValue];
            [app.tab.viewControllers[app.tab.selectedIndex] pushViewController:VC animated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            //退款详情
            OrderReturnDetailVC *VC = [[OrderReturnDetailVC alloc]init];
            VC.orderId =[str1 integerValue];
           [app.tab.viewControllers[app.tab.selectedIndex] pushViewController:VC animated:YES];
            
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
           
        }
            break;
        case 6:
        {
            //两地城市7天天气预报
            
        }
            break;
        case 7:
        {
          
        }
            break;
        case 8:
        {
           
        }
            break;
        case 9:
        {
           
        }
            break;
        case 10:
        {
            // 目的地好吃
            // TasteWorldViewController
            
            AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            // 设置默认选中的视图
            [app.tab selectBar:1];
            [app.tab.viewControllers[app.tab.selectedIndex] popViewControllerAnimated:YES];
        }
            break;
        case 11:
        {
            //目的地好玩
            
            AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            // 设置默认选中的视图
            [app.tab selectBar:2];
            [app.tab.viewControllers[app.tab.selectedIndex] popViewControllerAnimated:YES];
            
            
        }
            break;
        case 12:
        {


           
        }
            break;
        case 13:
        {
         
        }
            break;
        case 14:
        {
            
        }
        case 17:
        {
            
        }
            break;
            
        default:
            break;
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView == _upAlert) {

            
        } else if (alertView == _needUpAlert) {

            exit(1);
            
        }
    } else if (buttonIndex == 1) {

    }
}

#pragma mark--唤醒app跳转
-(void)jumpApp:(NSDictionary *)dic
{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSInteger valueTag = [dic[@"tag"] integerValue];
    
    switch (valueTag) {
            
        case 0:
        {
           
        }
            break;
        case 1:
        {
        
        }
            break;
        case 2:
        {
            
            
            
        }
            break;
        case 3:
        {
       
            
            
        }
            break;
        case 4:
        {

        }
            break;
        case 6:
        {
     
        }
            break;
        case 10:
        {
      
            
        }
            break;

        default:
            break;
            
    }

}


-(void)skipToMessageCenter {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
       [self resultPush:myDic1];
    });
}

-(void)skipToMessageCenter1 {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self jumpApp:myDic2];
    });
}


 @end
