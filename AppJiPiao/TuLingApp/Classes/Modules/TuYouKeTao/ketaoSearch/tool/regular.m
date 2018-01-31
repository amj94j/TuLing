//
//  regular.m
//  yun
//
//  Created by dangyongxing on 16/1/7.
//  Copyright © 2016年 yunzu. All rights reserved.
//

#import "regular.h"
//#import "NSPredicate.h"
#import <Foundation/Foundation.h>
@implementation regular
/**
 *  正则表达式(只能由中文、字母或数字组成)
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)checkRegular:(NSString *)str
{
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject: str])
    {

        return  NO;
    }
   return  YES;
}

/**
 *  正则表达式(只能由字母或数字组成)
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)checkRegular2:(NSString *)str
{
    NSString *regex =@"^[A-Za-z0-9\u4e00-\u9fa5]+";;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:str])
    {
        return  NO;
    }
    return  YES;
}
/**
 *  正则表达式(ip地址)
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)checkRegular3:(NSString *)str
{
    NSString *regex = @"\\b(?:\\d{1,3}\\.){3}\\d{1,3}\\b";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject: @""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"只能由字母和数字组成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return  NO;
    }
    return  YES;
}
/**
 *  正则表达式(中文字符)
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)checkRegular4:(NSString *)str
{
    NSString *regex = @"[\u4e00-\u9fa5]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject: @""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"只能由中文字符组成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return  NO;
    }
    return  YES;
}
/**
 *  匹配Email地址的正则表达式
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)checkRegular5:(NSString *)str
{
     NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject: @""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"只能由中文字符组成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return  NO;
    }
    return  YES;
}
/**
 *  匹配网址URL的正则表达式
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)checkRegular6:(NSString *)str
{
    NSString *regex = @"[a-zA-z]+://[^\\s]* ";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject: @""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"只能由中文字符组成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return  NO;
    }
    return  YES;
}
+(BOOL)checkRegular7:(NSString *)str
{
    NSString *regex =@"^[0-9]{11}+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:str])
    {
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"只能由字母和数字组成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //        [alertView show];
        return  NO;
    }
    return  YES;
}
+(BOOL)checkRegular8:(NSString *)str
{
    NSString *regex =@"^[A-Za-z0-9]{6,16}+$";;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred evaluateWithObject:str])
    {
        return  NO;
    }
    return  YES;
}


#pragma 正则匹配用户密码6-9位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

#pragma 正则匹配数字或者字母
+ (BOOL)checkPassword1:(NSString *) password
{
    NSString *pattern = @"^[a-z0－9A-Z]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}





//判断手机号码格式是否正确

+ (BOOL)checkMobile:(NSString *)mobile

{
    
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (mobile.length != 11)
        
    {
        
        return NO;
        
    }else{
        
        /**
         
         * 移动号段正则表达式
         
         */
        
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        
        /**
         
         * 联通号段正则表达式
         
         */
        
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        /**
         
         * 电信号段正则表达式
         
         */
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        
        
        if (isMatch1 || isMatch2 || isMatch3) {
            
            return YES;
            
        }else{
            
            return NO;
            
        }
        
    }
    
}

//只能为中文

+(BOOL)onlyInputChineseCharacters:(NSString*)string{
    NSString *zhString = @"[\u4e00-\u9fa5]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",zhString];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//只能为数字

+(BOOL)onlyInputTheNumber:(NSString*)string{
    NSString *numString =@"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numString];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//只能为小写
+(BOOL)onlyInputLowercaseLetter:(NSString*)string{
    NSString *regex =@"[a-z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//*只能为大写

+(BOOL)onlyInputACapital:(NSString*)string{
    NSString *regex =@"[A-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//允许大小写

+(BOOL)InputCapitalAndLowercaseLetter:(NSString*)string{
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//允许含大小写或数字(不限字数)

+(BOOL)inputLettersOrNumbers:(NSString*)string{
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//允许含大小写或数字(限字数)

+(BOOL)inputNumberOrLetters:(NSString*)name {
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL inputString = [userNamePredicate evaluateWithObject:name];
    return inputString;
}

//允许汉字或数字(不限字数)

+(BOOL)inputChineseOrNumbers:(NSString*)string{
    NSString *regex =@"[\u4e00-\u9fa5]+[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//允许汉字或数字(限字数)
+(BOOL)inputChineseOrNumbersLimit:(NSString*)string{
    NSString *regex =@"[\u4e00-\u9fa5][0-9]{6,20}+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//允许汉字，大小写或数字(不限字数)

+(BOOL)inputChineseOrLettersAndNumbersNum:(NSString*)string{
    NSString *regex =@"[\u4e00-\u9fa5]+[A-Za-z0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//允许汉字，大小写或数字(限字数)

+(BOOL)inputChineseOrLettersNumberslimit:(NSString*)string{
    NSString *regex =@"[\u4e00-\u9fa5]+[A-Za-z0-9]{6,20}+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}


@end
