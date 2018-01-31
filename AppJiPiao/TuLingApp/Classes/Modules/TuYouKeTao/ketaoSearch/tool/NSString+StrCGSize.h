//
//  NSString+StrCGSize.h
//  search
//
//  Created by hua on 16/11/1.
//  Copyright © 2016年 huazhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
@interface NSString (StrCGSize)
//计算单行字符串宽度
+(CGFloat)singeWidthForString:(NSString *)value fontSize:(CGFloat)fontSize Height:(CGFloat)height;


+(CGFloat)heightWithString:(NSString *)value andFont:(CGFloat)font  Width:(CGFloat)width;


+(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font;
+(void)setLabelSpace1:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font;

+(CGFloat)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font Width:(CGFloat)width;
/**
 计算带有行间距和字间距的字符串的高度
 
 @param str       传入的字符串
 @param font      字体
 @param width     文本宽度
 @param lineSpace 行间距，建议 6
 @param fontSpace 字间距，建议 1.5f
 
 @return 返回字符串的高度
 */
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace fontSpace:(NSNumber *)fontSpace;
@end
