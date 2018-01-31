//
//  StaticTools.h
//  TuLingApp
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface StaticTools : NSObject

typedef enum
{
    CAlertTypeDefault = 0,  //默认只有一个确定按钮
    CAlertTypeCacel,        //确定和取消
    CAlertTypeUpDate,       //更新
    CAlertTypeRelogin,      //重新登录
    CalertTypeOther         //关闭/重试
    
} CAlertStyle;

//数据存储枚举
typedef enum {
    /** pList */
    DataModePlist,
    /** UserDefault */
    DataModeUserDefault,
    /** DB */
    DataModeDB
} DataMode;
/**
 *  选择根控制器
 */
+ (void)chooseRootController;

#pragma mark - 设备相关
//获取当前语言环境
+ (NSString*)deviceLanguages;

//获取当前设备ID//这个目前没有好方法取固定值
+ (NSString*)deviceID;

//获取当前设备类型值 (0- iPod touch  1- iPhone 3GS以前版本  2- iPhone 4  9 - iPad)
+ (int)deviceType;

//获取app版本号
+ (NSString *)projectVerson;
//获取当天的星期加上日期
+(NSString *)getCurrentDate:(NSDate *)date :(BOOL)ISCurrent;
//获取当前的时间
+(NSString *)getCurrentDate:(NSDate *)date;

#pragma mark - 给view加圆角和边框及颜色
+ (void)setRoundView:(UIView *)view radius:(CGFloat)radius borderWidth:(CGFloat)width color:(UIColor *)color;

#pragma mark - 显示警告
+ (void)showAlert:(NSString *)alertString;
+ (void)showAlertWithCancelWithTag:(NSString *)alertString tag:(int)tag delegate:(id)delegate;
+ (void)showAlertWithTag:(int)tag title:(NSString *)titleString message:(NSString *)messageString AlertType:(CAlertStyle)AlertType SuperView:(UIViewController *)SuperViewController;
//增加日历事件
+(void)addEventNotify:(NSDate *)date title:(NSString *)title;
//增加提醒事件
+(void)addReminderNotify:(NSDate *)date title:(NSString *)title;
//截取第一位和最后一位
+ (NSString *)GetLastAndFirstString:(NSString *)string;
//存储订单号
+ (void)SaveOrderId:(NSString *)str url:(NSString *)url;
//获取订单号
+ (NSString *)GetOrderId:(NSString *)str;
+ (NSDictionary *)SaveMapInformation:(NSString *)city longtitude:(NSString *)longtitude latitude:(NSString *)latitude cityid:(NSString *)city_id;
+ (NSDictionary *)GetMapinformation;
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
@end
