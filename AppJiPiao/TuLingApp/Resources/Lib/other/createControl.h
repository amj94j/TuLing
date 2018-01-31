//
//  crateControl.h
//  TuLingApp
//
//  Created by hua on 17/4/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface createControl : NSObject


/**
 快速创建label
 
 @param frame frame
 @param font 字体大小
 @param text 文本
 @param LabTextColor 文字颜色
 @return 返回label
 */
+(UILabel*) labelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text LabTextColor:(UIColor *)LabTextColor;

/**
 快速创建label
 
 @param frame        frame
 @param font         字体大小
 @param text         文本
 @param LabTextColor 文字颜色
 
 @return 返回label
 */
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text LabTextColor:(UIColor *)LabTextColor;

/**
 创建单行宽度自适应UIlabel
 
 @param frame              label的frame，宽度随意   (必传)
 @param font               字体大小    (必传)
 @param text               内容    (必传)
 @param TextAlignment      对齐方式 @"0"代表左边，@"1"代表中间，@"2"代表右边  不设置传nil   (非必传)
 @param LabBackgroundColor 背景颜色，不设置传nil                     (非必传)
 @param LabTextColor       文字颜色，不设置传nil  默认文字颜色434343   (非必传)
 @param LabCornerRadius    label圆角大小，不设置传0                  (必传)
 @param labBorderColor     label边框颜色，不设置传nil                (非必传)
 
 @return 返回UIlabel
 */
+(UILabel*)createOneLineLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text  TextAlignment:(NSString *)TextAlignmentType LabBackgroundColor:(UIColor *)LabBackgroundColor LabTextColor:(UIColor *)LabTextColor cornerRadius:(CGFloat)LabCornerRadius labBorderColor:(UIColor *)labBorderColor;




/**
 创建多行高度自适应UIlabel(不带行间距和字间距)
 
 @param frame              label的frame，高度随意   (必传)
 @param font               字体大小    (必传)
 @param text               内容    (必传)
 @param TextAlignment      对齐方式 @"0"代表左边，@"1"代表中间，@"2"代表右边  不设置传nil   (非必传)
 @param LabBackgroundColor 背景颜色，不设置传nil                     (非必传)
 @param LabTextColor       文字颜色，不设置传nil  默认文字颜色434343   (非必传)
 @param LabCornerRadius    label圆角大小，不设置传0                  (必传)
 @param labBorderColor     label边框颜色，不设置传nil                (非必传)
 
 @return 返回UIlabel
 */

+(UILabel*)createMultiLineLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text  TextAlignment:(NSString *)TextAlignmentType LabBackgroundColor:(UIColor *)LabBackgroundColor LabTextColor:(UIColor *)LabTextColor cornerRadius:(CGFloat)LabCornerRadius labBorderColor:(UIColor *)labBorderColor;


/**
 创建多行高度自适应UIlabel(带行间距和字间距)
 
 @param frame              label的frame，高度随意   (必传)
 @param font               字体大小    (必传)
 @param text               内容    (必传)
 @param TextAlignment      对齐方式 @"0"代表左边，@"1"代表中间，@"2"代表右边  不设置传nil   (非必传)
 @param LabBackgroundColor 背景颜色，不设置传nil                     (非必传)
 @param LabTextColor       文字颜色，不设置传nil  默认文字颜色434343   (非必传)
 @param LabCornerRadius    label圆角大小，不设置传0                  (必传)
 @param labBorderColor     label边框颜色，不设置传nil                (非必传)
 @param lineSpace      label行间距                 (必传)
 @param wordSpace     label字体间距 1.5             (必传)
 
 @return 返回UIlabel
 */
+(UILabel*)createHaveSpaceLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text  TextAlignment:(NSString *)TextAlignmentType LabBackgroundColor:(UIColor *)LabBackgroundColor LabTextColor:(UIColor *)LabTextColor cornerRadius:(CGFloat)LabCornerRadius labBorderColor:(UIColor *)labBorderColor lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace;

+(UILabel*)createSpaceLabelWithFrame:(CGRect)frame Font:(UIFont*)font Text:(NSString*)text  TextAlignment:(NSString *)TextAlignmentType LabBackgroundColor:(UIColor *)LabBackgroundColor LabTextColor:(UIColor *)LabTextColor cornerRadius:(CGFloat)LabCornerRadius labBorderColor:(UIColor *)labBorderColor lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace;

/**
 创建线条
 
 @param frame          frame
 @param labelLineColor 线条颜色
 
 @return 返回label
 */
+(UILabel *)createLineWithFrame:(CGRect)frame labelLineColor:(UIColor *)labelLineColor;
@end
