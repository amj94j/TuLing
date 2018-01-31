//
//  Untils.h
//  TuLingApp
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Untils : NSObject
+ (NSString*)accountUUID;

//将字符串转成NSDate类型
+ (NSDate *)dateYYMMDDFromString:(NSString *)dateString;

//传入今天的时间，返回明天的时间
- (NSString *)GetTomorrowDay:(NSDate *)aDate;

// 获取当前是星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

// 获取当前时间并拼接星期几
+ (NSString *)daraWeekdatStringFromDate:(NSDate*)date;

// 判断当前字符串是否存在
+ (BOOL)isStringAre:(NSString *)str;

+ (NSString *)calendarDateString:(NSDate*)date;

- (NSInteger)checkDateBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;
// 将一个View转换成图片
+ (UIImage*)imageWithUIView:(UIView *)view;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
+ (NSDictionary*)getObjectData:(id)obj;

//将getObjectData方法返回的NSDictionary转化成JSON
+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;

//直接通过NSLog输出getObjectData方法返回的NSDictionary
+ (void)print:(id)obj;

/*!
 @brief 将NSDate为单位的时间戳转化为固定格式的时间字符串 2015-08-08 08:08:08
 */
+(NSString *)getFormatDateByDate:(NSDate*)date;
/*!
 @brief 2015-12-14 11:45:03  转换为date
 */
+(NSDate*)dateFormString:(NSString*)string;

// 计算时间差 1h29m
+(NSString *)getCountDownStringWithBeginTime:(NSString *)beginTime EndTime:(NSString *)endTime;

// 11-10 12:11 周日
+ (NSString *)getMMDDWeekFormatDate:(NSDate*)date;
/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
// 设置label的行间距
+ (void)labelLineSpacingWith:(UILabel *)label
                labelSpacing:(int)labelSpacing;

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;

+ (NSString *)convertToJsonData:(NSDictionary *)dict;
// 时间戳转换为时间
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
+ (NSString *)arrayToJSONString:(NSArray *)array;

/**
 获取时间差

 @param createTime 订单创建时间
 @param currentTime 当前时间
 @return 秒
 */
+ (NSInteger )getCountDownRemainingTimeWithCreateTime:(NSString *)createTime currentTime:(NSString *)currentTime;
@end
