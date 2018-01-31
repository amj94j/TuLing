#import "HzTools.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <sys/utsname.h>

@implementation HzTools
/**
 *  异常提示语
 *
 *  @param msg                    自定义提示语
 *  @param time                   显示的时间
 *  @param userInteractionEnabled 是否允许交互
 */
+ (void)showHudWithOnlySting:(NSString *)msg withTime:(NSTimeInterval)time 
{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    MBProgressHUD * msgHUD = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    msgHUD.mode = MBProgressHUDModeText;
    msgHUD.margin = 20.f;
    msgHUD.yOffset = 0.f;
    msgHUD.removeFromSuperViewOnHide = YES;
//    msgHUD.delegate = self;
    msgHUD.labelFont = [UIFont systemFontOfSize:18];
    msgHUD.labelText = msg;
    [msgHUD hide:YES afterDelay:time];
}


// 显示loadingView
+ (void)showLoadingViewWithString:(NSString*)string
{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    MBProgressHUD *loadHud = [[MBProgressHUD alloc] initWithWindow:app.window];
    //    loadHud.delegate  = self;
    // y 的偏移量
    loadHud.yOffset = 0;
    // 黑色背景区域的大小
    loadHud.margin = 10;
    loadHud.labelText = string;
    loadHud.tag = 990;
    [app.window addSubview:loadHud];
    [loadHud show:YES];
}

+ (void)hiddenLoadingView
{
    AppDelegate * app =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    MBProgressHUD * hud = [app.window viewWithTag:990];
    [hud removeFromSuperview];
    hud = nil;
}

/**
 *  正则判断手机号码地址格式
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|4[1-9]|5[017-9]|8[1-478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestphs evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *  判断身份证号码
 *
 *  @param identityCard 身份证号码
 *
 *  @return Boll值
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

/**
 *  正则判断邮箱
 *
 *  @param email <#email description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *  确定手机类型
 *
 *  @return 手机类型编码
 */
- (NSString *)phoneModel
{
    // 根据编码可以确定手机型号
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    return code;
}
+ (NSString*)timeIntervalWithDateFormat:(NSString*)dateFormat timeString:(NSString*)timeString
//时间转时间戳
{
    NSDateFormatter *dF = [[NSDateFormatter alloc] init];
    [dF setDateFormat:dateFormat];
    //类型
    
    NSDate *date = [dF dateFromString:timeString];
    //获得时间戳时间
    
    return [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
}

/**
 *  获取当前时间－－－－自定义格式
 *
 *  @param format <#format description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getCurrentTimeWithFormat:(NSString *)format
{

    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:format];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    
    return locationString;

}


/**
 *  两个时间的时间差
 *
 *  @param oneTime   <#oneTime description#>
 *  @param otherTime <#otherTime description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getIntervalOneTime:(NSString *)oneTime SinceOtherTime:(NSString *)otherTime WithTimeFormate:(NSString *)formate
{
    // 首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    
    // 然后创建日期对象
    NSDate *date1 = [dateFormatter dateFromString:oneTime];
    
    NSDate *date = [dateFormatter dateFromString:otherTime];
    
    //计算时间间隔（单位是秒）
    
    NSTimeInterval time = [date timeIntervalSinceDate:date1];
    
    //计算天数、时、分、秒、毫秒
    
    int days = ((int)time)/(3600*24);
    
    int hours = ((int)time)%(3600*24)/3600;
    
    int minutes = ((int)time)%(3600*24)%3600/60;
    
    int seconds = ((int)time)%(3600*24)%3600%60;
    
    
    // 此处可以根据项目需要返回需要的格式
    NSString *dateContent = [[NSString alloc] initWithFormat:@"仅剩%i天%i小时%i分%i秒",days,hours,minutes,seconds];
    
    //（%i可以自动将输入转换为十进制,而%d则不会进行转换）
    
    //赋值显示
    
    return dateContent;
}


/**
 * 获取文本的动态高度
 */
+ (CGFloat)getHeightFromString:(NSString *)str WithFont:(UIFont*)strFont AndWithLabelWidht:(CGFloat)width
{
    // 获取文本的动态高度
    UIFont *font = strFont;
    CGSize size = CGSizeMake(width, 29999);
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        
    size =[str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size.height;
    
}


@end
