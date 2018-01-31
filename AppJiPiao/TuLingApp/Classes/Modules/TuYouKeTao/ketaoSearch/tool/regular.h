//
//  regular.h
//  yun
//
//  Created by dangyongxing on 16/1/7.
//  Copyright © 2016年 yunzu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface regular : NSObject
/**
 *  正则表达式(只能由中文、字母或数字组成)
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)checkRegular:(NSString *)str;

/**
 *  正则表达式(只能由字母或数字组成)
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)checkRegular2:(NSString *)str;

+(BOOL)checkRegular7:(NSString *)str;
+(BOOL)checkRegular8:(NSString *)str;



+ (BOOL)checkPassword:(NSString *) password;

+ (BOOL)checkPassword1:(NSString *) password;

//允许汉字，大小写或数字(不限字数)

+(BOOL)inputChineseOrLettersAndNumbersNum:(NSString*)string;

//判断手机号码格式是否正确

+ (BOOL)checkMobile:(NSString *)mobile;
@end
