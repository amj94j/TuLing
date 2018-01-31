//
//  crateControl.m
//  TuLingApp
//
//  Created by hua on 17/4/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "createControl.h"
//label默认字体颜色
#define LabDefaultLabTextColor [UIColor colorWithHexString:@"#434343"];

//线条默认颜色
#define labelDefaultLineColor [UIColor colorWithHexString:@"#E2E2E2"];

@implementation createControl

/**
 快速创建label
 @param frame frame
 @param font 字体大小
 @param text 文本
 @param LabTextColor 文字颜色
 @return 返回label
 */
+(UILabel*) labelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text LabTextColor:(UIColor *)LabTextColor
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];

    //限制行数
    label.numberOfLines=1;
    //字体
    label.font=[UIFont systemFontOfSize:font];
    
    //字体颜色
    if (LabTextColor) {
        label.textColor=LabTextColor;
    }else
    {
        //默认字体颜色
        label.textColor=LabDefaultLabTextColor;
    }
    label.text=text;
    return label;
}

/**
 快速创建宽度自适应label

 @param frame        frame
 @param font         字体大小
 @param text         文本
 @param LabTextColor 文字颜色

 @return 返回label
 */
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text LabTextColor:(UIColor *)LabTextColor
{
    UILabel*label=[[UILabel alloc]init];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font],};
    if (text.length == 0 || [text isEqualToString:@""] || text == nil){
        label.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
        return label;
    }

    //最新自动计算宽度方法
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, frame.size.height) options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size;
    
    label.frame =CGRectMake(frame.origin.x, frame.origin.y, textSize.width, frame.size.height);
    
    //限制行数
    label.numberOfLines=1;
    //字体
    label.font=[UIFont systemFontOfSize:font];
    
    //字体颜色
    if (LabTextColor) {
        label.textColor=LabTextColor;
    }else
    {
        //默认字体颜色
        label.textColor=LabDefaultLabTextColor;
    }
    label.text=text;
  return label;
}


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
{
    
    UILabel*label=[[UILabel alloc]init];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font],};
    
    if (text.length == 0 || [text isEqualToString:@""] || text == nil){
        label.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
        return label;
    }

    //最新自动计算宽度方法
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, frame.size.height) options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size;
    
    label.frame =CGRectMake(frame.origin.x, frame.origin.y, textSize.width, frame.size.height);
    
    //限制行数
    label.numberOfLines=1;
    
    
    //对齐方式
    if ([TextAlignmentType isEqualToString:@"0"]) {
        label.textAlignment=NSTextAlignmentLeft;
    }else if ([TextAlignmentType isEqualToString:@"1"])
    {
        label.textAlignment=NSTextAlignmentCenter;
    }else
    {
    label.textAlignment=NSTextAlignmentRight;
    }
    
    //背景颜色
    if (LabBackgroundColor) {
        label.backgroundColor=LabBackgroundColor;
    }
    
    //字体
    label.font=[UIFont systemFontOfSize:font];
    
    
    //单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    
    //字体颜色
    if (LabTextColor) {
        label.textColor=LabTextColor;
    }else
    {
        //默认字体颜色
        label.textColor=LabDefaultLabTextColor;
    }
    
    label.text=text;
    
    //圆角
    if (LabCornerRadius!=0) {
        label.layer.masksToBounds=YES;
        label.layer.cornerRadius = LabCornerRadius;
    }
    
    
    //边框
    if (labBorderColor) {
        label.layer.borderWidth =0.5;
        label.layer.borderColor = labBorderColor.CGColor;
    }
    
    return label;
}





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

+(UILabel*)createMultiLineLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text  TextAlignment:(NSString *)TextAlignmentType LabBackgroundColor:(UIColor *)LabBackgroundColor LabTextColor:(UIColor *)LabTextColor cornerRadius:(CGFloat)LabCornerRadius labBorderColor:(UIColor *)labBorderColor

{
    UILabel*label=[[UILabel alloc]init];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font],};
    
    if (text.length == 0 || [text isEqualToString:@""] || text == nil){
        label.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
        return label;
    }

    //最新自动计算宽度方法
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)  attributes:attributes context:nil].size;
    
    label.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, ceil(textSize.height));
    
    //限制行数
    label.numberOfLines=0;
    
    
    //对齐方式
    if ([TextAlignmentType isEqualToString:@"0"]) {
        label.textAlignment=NSTextAlignmentLeft;
    }else if ([TextAlignmentType isEqualToString:@"1"])
    {
        label.textAlignment=NSTextAlignmentCenter;
    }else
    {
        label.textAlignment=NSTextAlignmentRight;
    }
    
    //背景颜色
    if (LabBackgroundColor) {
        label.backgroundColor=LabBackgroundColor;
    }
    
    //字体
    label.font=[UIFont systemFontOfSize:font];
    
    
    //单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    
    //字体颜色
    if (LabTextColor) {
        label.textColor=LabTextColor;
    }else
    {
        //默认字体颜色
        label.textColor=LabDefaultLabTextColor;
    }
    
    label.text=text;
    
    //圆角
    if (LabCornerRadius!=0) {
        label.layer.masksToBounds=YES;
        label.layer.cornerRadius = LabCornerRadius;
    }
    
    
    //边框
    if (labBorderColor) {
        label.layer.borderWidth =0.5;
        label.layer.borderColor = labBorderColor.CGColor;
    }
 return label;
}


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
+(UILabel*)createHaveSpaceLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text  TextAlignment:(NSString *)TextAlignmentType LabBackgroundColor:(UIColor *)LabBackgroundColor LabTextColor:(UIColor *)LabTextColor cornerRadius:(CGFloat)LabCornerRadius labBorderColor:(UIColor *)labBorderColor lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace
{
     UILabel*label=[[UILabel alloc]init];
    
    //限制行数
    label.numberOfLines=0;
    //背景颜色
    if (LabBackgroundColor) {
        label.backgroundColor=LabBackgroundColor;
    }
    //字体
    label.font=[UIFont systemFontOfSize:font];
    
    //字体颜色
    if (LabTextColor) {
        label.textColor=LabTextColor;
    }else
    {
        //默认字体颜色
        label.textColor=LabDefaultLabTextColor;
    }
    
    label.text=text;
    
    //圆角
    if (LabCornerRadius!=0) {
        label.layer.masksToBounds=YES;
        label.layer.cornerRadius = LabCornerRadius;
    }
    
    
    //边框
    if (labBorderColor) {
        label.layer.borderWidth =0.5;
        label.layer.borderColor = labBorderColor.CGColor;
    }
  
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //对齐方式
    if ([TextAlignmentType isEqualToString:@"0"]) {
        paraStyle.alignment=NSTextAlignmentLeft;
    }else if ([TextAlignmentType isEqualToString:@"1"])
    {
        paraStyle.alignment=NSTextAlignmentCenter;
    }else
    {
        paraStyle.alignment=NSTextAlignmentRight;
    }

    paraStyle.lineSpacing = lineSpace; //设置行间距
    
    paraStyle.hyphenationFactor = 0.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font],NSKernAttributeName:[NSNumber numberWithFloat:wordSpace], NSParagraphStyleAttributeName:paraStyle,};
    
    if (text.length == 0 || [text isEqualToString:@""] || text == nil){
        label.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
        return label;
    }
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    
    label.attributedText = attributeStr;
    
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)  attributes:dic context:nil].size;
    
    label.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, ceil(textSize.height));
    
    return label;
}

+(UILabel*)createSpaceLabelWithFrame:(CGRect)frame Font:(UIFont*)font Text:(NSString*)text  TextAlignment:(NSString *)TextAlignmentType LabBackgroundColor:(UIColor *)LabBackgroundColor LabTextColor:(UIColor *)LabTextColor cornerRadius:(CGFloat)LabCornerRadius labBorderColor:(UIColor *)labBorderColor lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace
{
    UILabel*label=[[UILabel alloc]init];
    if (!font){
        font  = [UIFont systemFontOfSize:15];
    }
    //限制行数
    label.numberOfLines=0;
    //背景颜色
    if (LabBackgroundColor) {
        label.backgroundColor=LabBackgroundColor;
    }
    //字体
    label.font = font;
    
    //字体颜色
    if (LabTextColor) {
        label.textColor=LabTextColor;
    }else
    {
        //默认字体颜色
        label.textColor=LabDefaultLabTextColor;
    }
    
    label.text=text;
    
    //圆角
    if (LabCornerRadius!=0) {
        label.layer.masksToBounds=YES;
        label.layer.cornerRadius = LabCornerRadius;
    }
    
    
    //边框
    if (labBorderColor) {
        label.layer.borderWidth =0.5;
        label.layer.borderColor = labBorderColor.CGColor;
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //对齐方式
    if ([TextAlignmentType isEqualToString:@"0"]) {
        paraStyle.alignment=NSTextAlignmentLeft;
    }else if ([TextAlignmentType isEqualToString:@"1"])
    {
        paraStyle.alignment=NSTextAlignmentCenter;
    }else
    {
        paraStyle.alignment=NSTextAlignmentRight;
    }
    
    paraStyle.lineSpacing = lineSpace; //设置行间距
    
    paraStyle.hyphenationFactor = 0.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    
    NSDictionary *dic = @{NSFontAttributeName:font,NSKernAttributeName:[NSNumber numberWithFloat:wordSpace], NSParagraphStyleAttributeName:paraStyle,};
    
    if (text.length == 0 || [text isEqualToString:@""] || text == nil){
        label.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
        return label;
    }
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    
    label.attributedText = attributeStr;
    
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)  attributes:dic context:nil].size;
    
    label.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, ceil(textSize.height));
    
    return label;
}


/**
 创建线条

 @param frame          frame
 @param labelLineColor 线条颜色

 @return 返回label
 */
+(UILabel *)createLineWithFrame:(CGRect)frame labelLineColor:(UIColor *)labelLineColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    if (labelLineColor) {
        label.backgroundColor = labelLineColor;
    }else
    {
       label.backgroundColor =labelDefaultLineColor
    }
    

    return label;


}
@end
