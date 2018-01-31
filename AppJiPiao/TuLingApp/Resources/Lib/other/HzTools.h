#import <Foundation/Foundation.h>

/*
 * 通用工具类
 */
@interface HzTools : NSObject

/**
 *  HUD的文字提示
 *
 *  @param msg                    提示的文字
 *  @param time                   显示的时间
 *  @param userInteractionEnabled 是否允许交互
 */
+ (void)showHudWithOnlySting:(NSString *)msg withTime:(NSTimeInterval)time;

/**
 *  加载等待框
 *
 *  @param hzString 显示的字符串
 */
+ (void)showLoadingViewWithString:(NSString*)hzString;

/**
 *  隐藏等待框
 */
+ (void)hiddenLoadingView;

/**
 *  正则判断是否是手机号
 *
 *  @param mobileNum 传入的字符串
 *
 *  @return bool值
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  判断身份证号码
 *
 *  @param identityCard 身份证号码String
 *
 *  @return 返回的Bool值
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

/**
 *  正则判断邮箱
 *
 *  @param email 邮箱字符串
 *
 *  @return 是否成功
 */
+ (BOOL)isEmail:(NSString *)email;

/**
 *  时间转时间戳
 *
 *  @param dateFormat 格式
 *  @param timeString 时间字符串
 *
 *  @return 时间戳
 */
+ (NSString*)timeIntervalWithDateFormat:(NSString*)dateFormat timeString:(NSString*)timeString;

/**
 *  获取当前时间－－－－
 *
 *  @param format 时间格式
 *
 *  @return 当前时间字符串
 */
+ (NSString *)getCurrentTimeWithFormat:(NSString *)format;

/**
 *  获取两个时间的时间差
 *
 *  @param oneTime   oneTime
 *  @param otherTime otherTime
 *  @param formate  时间的格式
 *  @return 时间差字符串
 */
+ (NSString *)getIntervalOneTime:(NSString *)oneTime SinceOtherTime:(NSString *)otherTime WithTimeFormate:(NSString *)formate;

/**
 *  获取文本的动态高度
 *
 *  @param str     文本
 *  @param strFont 文本的font
 *  @param width   文本所在Label的宽度
 *
 *  @return 动态高度
 */
//+ (CGFloat)getHeightFromString:(NSString *)str WithFont:(UIFont*)strFont AndWithLabelWidht:(CGFloat)width;

/**
 *  抖动动画
 *
 *  @param itemView 需要抖动的view
 */

@end
