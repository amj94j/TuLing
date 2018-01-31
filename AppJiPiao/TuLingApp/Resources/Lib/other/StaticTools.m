//
//  StaticTools.m
//  TuLingApp
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "StaticTools.h"
#import "MainViewController.h"
#import "NewFeatureViewController.h"
#import "BaseNavigationController.h"
#import "MainSliderViewController.h"
#import "UIImage+DX.h"
#import "AppDelegate.h"
#import "SRNewFeaturesViewController.h"

@implementation StaticTools
+ (void)chooseRootController
{
    NSString *key = @"CFBundleVersion";
    
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
   
    if ([currentVersion isEqualToString:lastVersion]) {
        // 显示状态栏
        [UIApplication sharedApplication].statusBarHidden = NO;
        MainSliderViewController * mvc = [[MainSliderViewController alloc] init];
        
        AppDelegate * app = (AppDelegate*)[UIApplication sharedApplication].delegate;;
        app.nav = [[BaseNavigationController alloc] initWithRootViewController:mvc];
        
        
//        BaseNavigationController * nvc = [[BaseNavigationController alloc] initWithRootViewController:mvc];
        [UIApplication sharedApplication].keyWindow.rootViewController =app.nav;
    } else { // 新版本
        MainSliderViewController * mvc = [[MainSliderViewController alloc] init];
        BaseNavigationController * nvc = [[BaseNavigationController alloc] initWithRootViewController:mvc];
        NSArray *imageNames = @[@"lan1.jpg", @"lan2.jpg", @"lan3.jpg", @"lan4.jpg", @"lan5.jpg"];
        SRNewFeaturesViewController *newFeaturesVC = [SRNewFeaturesViewController sr_newFeatureWithImageNames:imageNames
                                                                                           rootViewController:nvc];
        newFeaturesVC.hideSkipButton = NO; // show skip Button
        [UIApplication sharedApplication].keyWindow.rootViewController = newFeaturesVC;
        //        [UIApplication sharedApplication].keyWindow.rootViewController = [self setupNewFeature];
        // 存储新版本
        
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];

    }
}

//获取当前语言环境
+ (NSString*)deviceLanguages
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
}

//获取当前设备ID
/*
 *  IMEI、UDID(IOS5)、MAC地址(IOS7)苹果都禁用了。
 *  目前苹果推荐的方案是使用UUID(通用唯一识别码)，或者IDFA(广告标示符)，但重新安装之后就变了。
 *  或者程序首次启动时，生成一个时间戳+随机码的字符串(基本可以保证唯一)，保存到本地。同样删除后就变了。
 *  解决方法，是把标识符存储到keychain中，删除应用不会删除keychain中的数据。
 *  此项目没有要求。
 */
+ (NSString*)deviceID
{
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uuid;
}

//获取当前设备类型值 (0- iPod touch  1- iPhone 3GS以前版本  2- iPhone 4  9 - iPad)
+ (int)deviceType
{
    NSString *machineType = [[UIDevice currentDevice] model];
    
    if ([machineType compare:@"iPod touch"] == NSOrderedSame)
        return 0;
    else if ([machineType compare:@"iPhone"] == NSOrderedSame)
        return 1;
    else if ([machineType compare:@"iPad"] == NSOrderedSame)
        return 2;
    
    //模拟器
    else if ([machineType compare:@"iPhone Simulator"] == NSOrderedSame)
        return 3;
    else if ([machineType compare:@"iPad Simulator"] == NSOrderedSame)
        return 4;
    
    return -1;
}

/**
 *  获取版本号
 */
+ (NSString *)projectVerson
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
#pragma mark get Date
//获得当天的日期加上星期
+(NSString *)getCurrentDate:(NSDate *)date :(BOOL)ISCurrent
{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //设置时区
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ZH_cn"];
    NSDateComponents *comps;
    //NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    //获取当前日期
    if (ISCurrent) {
        NSDate *date0 = [NSDate date];
        NSString *sstr = [dateFormatter stringFromDate:date0];
        comps = [calendar components:unitFlags fromDate:date0];
        NSInteger week0 = [comps weekday];
        return [sstr stringByAppendingString:[NSString stringWithFormat:@"    %@",[arrWeek objectAtIndex:(week0 - 1)]]];
    }else{
        NSString *sstr = [dateFormatter stringFromDate:date];
        comps = [calendar components:unitFlags fromDate:date];
        NSInteger week0 = [comps weekday];
        return [sstr stringByAppendingString:[NSString stringWithFormat:@"    %@",[arrWeek objectAtIndex:(week0 - 1)]]];
    }
}
+(NSString *)getCurrentDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return  [dateFormatter stringFromDate:date];
}
#pragma mark - 给view加圆角和边框及颜色
+ (void)setRoundView:(UIView *)view radius:(CGFloat)radius borderWidth:(CGFloat)width color:(UIColor *)color
{
    if (view) {
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = radius;
        view.layer.borderWidth = width;
        if (color) {
            view.layer.borderColor = [color CGColor];
        }
        else {
            view.layer.borderColor = [[UIColor blackColor] CGColor];
        }
    }
}

+ (void)showAlert:(NSString *)alertString
{
    if([alertString isBlankString])
    {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:alertString
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
    }
}
//“确定”和“取消”按钮，并实现代理
+ (void)showAlertWithCancelWithTag:(NSString *)alertString tag:(int)tag delegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString
                                                    message:nil
                                                   delegate:delegate
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", @"取消",nil];
    alert.tag = tag;
    [alert show];
}
+ (void)showAlertWithTag:(int)tag title:(NSString *)titleString message:(NSString *)messageString AlertType:(CAlertStyle)AlertType SuperView:(UIViewController *)SuperViewController
{
    UIAlertView *alert;
    switch (AlertType) {
        case CAlertTypeDefault:
            alert = [[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            if (SuperViewController) {
                alert.delegate = SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            break;
        case CAlertTypeCacel:
            alert = [[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            if (SuperViewController) {
                alert.delegate = SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            
            break;
        case CAlertTypeUpDate:
            alert = [[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:nil cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新", nil];
            if (SuperViewController) {
                alert.delegate = SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            break;
        case CAlertTypeRelogin:
            alert = [[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
            if (SuperViewController) {
                alert.delegate = SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            break;
        case CalertTypeOther:
            alert = [[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:@"重试", nil];
            if (SuperViewController) {
                alert.delegate = SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            break;
        default:
            break;
    }
}
//增加日历事件
+(void)addEventNotify:(NSDate *)date title:(NSString *)title
{
    //生成事件数据库对象
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    //申请事件类型权限
    [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) { //授权是否成功
            EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB]; //创建一个日历事件
            myEvent.title     = title;  //标题
            myEvent.startDate = date; //开始date   required
            myEvent.endDate   = date;  //结束date    required
            [myEvent addAlarm:[EKAlarm alarmWithAbsoluteDate:date]]; //添加一个闹钟  optional
            [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]]; //添加calendar  required
             NSError *err;
            [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err]; //保存
        }
    }];
}
//增加提醒事件
+(void)addReminderNotify:(NSDate *)date title:(NSString *)title
{
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    //申请提醒权限
    [eventDB requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //创建一个提醒功能
            EKReminder *reminder = [EKReminder reminderWithEventStore:eventDB];
            //标题
            reminder.title = title;
            //添加日历
            [reminder setCalendar:[eventDB defaultCalendarForNewReminders]];
            NSCalendar *cal = [NSCalendar currentCalendar];
            [cal setTimeZone:[NSTimeZone systemTimeZone]];
            NSInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth |
            NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute |
            NSCalendarUnitSecond;
            NSDateComponents* dateComp = [cal components:flags fromDate:date];
            dateComp.timeZone = [NSTimeZone systemTimeZone];
            reminder.startDateComponents = dateComp; //开始时间
            reminder.dueDateComponents = dateComp; //到期时间
            reminder.priority = 1; //优先级
            EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date]; //添加一个车闹钟
            [reminder addAlarm:alarm];
            NSError *err;
            [eventDB saveReminder:reminder commit:YES error:&err];
            if (err) {
                
            }
        }
    }];
}

+ (NSString *)GetLastAndFirstString:(NSString *)string
{
    //NSInteger lg = [string length];
    NSRange range = {0,1};
    NSRange range1 = {[string length]-1,1};
    NSString *firstString= [string substringWithRange:range];
    NSString *lastString = [string substringWithRange:range1];
    NSString *allString = [[firstString stringByAppendingString:@".."] stringByAppendingString:lastString];
    return allString;
}
//存储商品订单号
+ (void)SaveOrderId:(NSString *)str url:(NSString *)url
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:str forKey:@"name"];
    //[defaults setObject:url forKey:@"url"];
}
+ (NSString *)GetOrderId:(NSString *)str
{
    if ([str isEqualToString:@"orderid"]) {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *name = [defaults objectForKey:@"name"];//根据键值取出name
        return name;
    }else{
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *name = [defaults objectForKey:@"url"];//根据键值取出name
        return name;
    }
}
+ (NSDictionary *)SaveMapInformation:(NSString *)city longtitude:(NSString *)longtitude latitude:(NSString *)latitude cityid:(NSString *)city_id
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"infomation.plist"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:city forKey:@"city"];
    [dic setValue:longtitude forKey:@"longtitude"];
    [dic setValue:latitude forKey:@"latitude"];
    [dic setValue:city_id forKey:@"city_id"];
    [dic writeToFile:fileName atomically:YES];
//     NSSet *twoSet=[[NSSet alloc] initWithArray:@[@"1"]];
    
    return dic;
}
+ (NSDictionary *)GetMapinformation
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"infomation.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fileName];
    return dic;
}
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (NewFeatureViewController *)setupNewFeature
{
    NewFeatureViewController *newFeatureVC = [[NewFeatureViewController alloc] init];
    // 设置本地视频路径数组
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<4; i++) {
        @try{
          [array addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide%d",i] ofType:@"mp4"]];  
        }
        @catch(NSException *exception) {
            NSLog(@"exception:%@", exception);
        }
        @finally {
            
        }
    }
    newFeatureVC.guideMoviePathArr = array;
    // 设置封面图片数组
    newFeatureVC.guideImagesArr = @[@"guide0", @"guide1", @"guide2", @"guide3"];
    // 设置最后一个视频播放完成之后的block
    [newFeatureVC setLastOnePlayFinished:^{
//        UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:[[NewBackViewController alloc] init]];
//        [UIApplication sharedApplication].keyWindow.rootViewController = rootNav;
        MainSliderViewController * mvc = [[MainSliderViewController alloc] init];
        BaseNavigationController * nvc = [[BaseNavigationController alloc] initWithRootViewController:mvc];
        [UIApplication sharedApplication].keyWindow.rootViewController =nvc;
    }];
    return newFeatureVC;
}

@end
