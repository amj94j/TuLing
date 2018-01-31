//
//  NSString+Extension.m
//  WKMHS_IOS
//
//  Created by zyz on 15/11/17.
//  Copyright © 2015年 han. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

/**
 *  快速返回沙盒中，Documents文件的路径
 *
 *  @return Documents文件的路径
 */
+ (NSString *)pathForDocuments
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  快速返回Documents文件中某个子文件的路径
 *
 *  @param fileName 子文件名称
 *
 *  @return 快速返回Documents文件中某个子文件的路径
 */
+ (NSString *)filePathAtDocumentsWithFileName:(NSString *)fileName
{
    return  [[self pathForDocuments] stringByAppendingPathComponent:fileName];
}

/**
 *  快速返回沙盒中Library下Caches文件的路径
 *
 *  @return 快速返回沙盒中Library下Caches文件的路径
 */
+ (NSString *)pathForCaches
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)filePathAtCachesWithFileName:(NSString *)fileName
{
    return [[self pathForCaches] stringByAppendingPathComponent:fileName];
}

/**
 *  快速返回MainBundle(资源捆绑包的)的路径
 *
 *  @return 快速返回MainBundle(资源捆绑包的)的路径
 */
+ (NSString *)pathForMainBundle
{
    return [NSBundle mainBundle].bundlePath;
}

/**
 *  快速返回MainBundle(资源捆绑包的)下文件的路径
 *
 *  @param fileName MainBundle(资源捆绑包的)下的文件名
 *
 *  @return 快速返回MainBundle(资源捆绑包的)下文件的路径
 */
+ (NSString *)filePathAtMainBundleWithFileName:(NSString *)fileName
{
    return [[self pathForMainBundle] stringByAppendingPathComponent:fileName];
}

/**
 *  快速返回沙盒中tmp(临时文件)文件的路径
 *
 *  @return 快速返回沙盒中tmp文件的路径
 */
+ (NSString *)pathForTemp
{
    return NSTemporaryDirectory();
}

/**
 *  快速返回沙盒中，temp文件中某个子文件的路径
 *
 *  @param fileName 子文件名
 *
 *  @return 快速返回temp文件中某个子文件的路径
 */
+ (NSString *)filePathAtTempWithFileName:(NSString *)fileName
{
    return [[self pathForTemp] stringByAppendingPathComponent:fileName];
}

/**
 *  快速返回沙盒中，Library下Preferences文件的路径
 *
 *  @return 快速返回沙盒中Library下Caches文件的路径
 */
+ (NSString *)pathForPreferences
{
    return [NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  快速返回沙盒中，Library下Preferences文件中某个子文件的路径
 *
 *  @param fileName 子文件名称
 *
 *  @return 快速返回Preferences文件中某个子文件的路径
 */
+ (NSString *)filePathAtPreferencesWithFileName:(NSString *)fileName
{
    return [[self pathForPreferences] stringByAppendingPathComponent:fileName];
}

/**
 *  快速返回你指定的系统文件的路径
 *
 *  @param directory NSSearchPathDirectory枚举
 *
 *  @return 快速你指定的系统文件的路径
 */
+ (NSString *)pathForSystemFile:(NSSearchPathDirectory)directory
{
    return [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) lastObject];
}

/**
 *  快速返回沙盒中，你指定的系统文件的中某个子文件的路径。tmp文件除外，请使用filePathAtTempWithFileName
 *
 *  @param directory 你指的的系统文件
 *  @param fileName  子文件名
 *
 *  @return 快速返回沙盒中，你指定的系统文件的中某个子文件的路径
 */
+ (NSString *)filePathForSystemFile:(NSSearchPathDirectory)directory withFileName:(NSString *)fileName
{
    return [[self pathForSystemFile:directory] stringByAppendingPathComponent:fileName];
}


#pragma mark - 文本计算方法

/**
 *  快速计算出文本的真实尺寸
 *
 *  @param font    文字的字体
 *  @param maxSize 文本的最大尺寸
 *
 *  @return 快速计算出文本的真实尺寸
 */
- (CGSize)sizeWithFont:(NSInteger)font andMaxSize:(CGSize)maxSize
{
    NSDictionary *arrts = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:arrts context:nil].size;
}

/**
 设置字符串为具有行间距和字间距的富文本字符串

 @param lineSpace 行间距
 @param wordSpace 字间距
 @param font 字体大小
 @return 富文本字符串
 */
- (NSAttributedString *) setSpaceWithLineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace font:(UIFont*)font
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    paraStyle.hyphenationFactor = 0.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:font forKey:NSFontAttributeName];
    [dict setObject:paraStyle forKey:NSParagraphStyleAttributeName]; //
    if (wordSpace) {
        [dict setObject:@(wordSpace) forKey:NSKernAttributeName]; // 设置字间距
    }
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self attributes:dict];
    
    return attributeStr;
}

/**
 快速计算带有行间距和字间距的文本尺寸

 @param font 字体
 @param lineSpace 行间距
 @param wordSpace 字间距
 @param maxSize 最大尺寸
 @return 文本尺寸
 */
- (CGSize) sizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace maxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpace;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    paraStyle.hyphenationFactor = 0.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *dict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(wordSpace)};
    
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return size;
}


#pragma mark - 判断字符串
/**
 *  从一段文本中匹配出其中的超链接
 */
- (BOOL)checkURLStringFromText:(NSString *)string
{
    NSError *error;
    NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSString* substringForMatch;
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        substringForMatch = [string substringWithRange:match.range];
    }
    
    if (substringForMatch.length > 0)
        return YES;
    else
        return NO;
}

/**
 *  判断字符串中只含有汉字
 */
- (BOOL)checkStringOnlyChinese
{
    int s = 0;
    for (int i=0; i < [self length]; i++) {
        
        int a = [self characterAtIndex:i];
        if(a>0x4e00 && a<0x9fff) {
            s++;
        }
    }
    if (self.length == s) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *  判断字符串中只含有数字和字母
 */
- (BOOL)checkStringOnlyNumberAndLetter
{
    NSString *regex = @"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:self]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 判断是否是空字符串
 */
- (BOOL) isBlankString
{
    if (self == nil || self == NULL) {
        return NO;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}


#pragma mark - 字符串的常用简单操作
/**
 *  截取字符串
 *
 *  @param a 起始位置
 *  @param b 结束位置
 *
 *  @return 结果字符串
 */
- (NSString*)substringFrom:(NSInteger)a to:(NSInteger)b
{
    NSRange r;
    r.location = a;
    r.length = b - a;
    return [self substringWithRange:r];
}

/**
 *  快速返回字符串中所包含的字符数
 *
 *  @return 字符数
 */
- (int) numberOfCharacters
{
    int strlength = 0;
    char *p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}

/**
 *  去掉字符串 最前面 和 最后面 的空格
 *
 *  @return 结果字符串
 */
- (NSString *) removeTheSpacesBeforeAndAfter
{
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [[NSString alloc]initWithString:[self stringByTrimmingCharactersInSet:whiteSpace]];
}

@end
