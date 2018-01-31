//
//  NSString+StrCGSize.m
//  search
//
//  Created by hua on 16/11/1.
//  Copyright © 2016年 huazhuo. All rights reserved.
//

#import "NSString+StrCGSize.h"
#define UILABEL_LINE_SPACE 7

//#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height
@implementation NSString (StrCGSize)


#pragma mark--自动计算字符串宽度
//在iOS 8下，需要占用的宽度为40.f
//但在iOS9下，就可能需要45.f;  adjustsFontSizeToFitWidth
+(CGFloat) singeWidthForString:(NSString *)value fontSize:(CGFloat)fontSize Height:(CGFloat)height
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],};
    //最新自动计算宽度方法
    CGSize textSize = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size;
    return ceil(textSize.width) ;
}
/**
 *  计算字符串高度 （多行）
 *
 *  @param width 字符串的宽度
 *  @param font  字体大小
 *
 *  @return 字符串的尺寸
 */
+ (CGFloat)heightWithString:(NSString *)value andFont:(CGFloat)font  Width:(CGFloat)width{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize  size = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)  attributes:attribute context:nil].size;
    return size.height;
}
//NSStringDrawingTruncatesLastVisibleLine：

//如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。如果没有指定//NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略。
//    typedef NS_ENUM(NSInteger, NSLineBreakMode) {

//        NSLineBreakByWordWrapping = 0,    // //以空格为边界，保留单词。

//        NSLineBreakByCharWrapping, // 截取到范围内(字符串)

//        NSLineBreakByClipping, //简单剪裁，到边界为止

//        NSLineBreakByTruncatingHead, // 从前面开始裁剪字符串: "...wxyz"

//        NSLineBreakByTruncatingTail, // 从后面开始裁剪字符串: "abcd..."

//        NSLineBreakByTruncatingMiddle  // 从中间裁剪字符串:  "ab...yz"

//    }

//给UILabel设置行间距和字间距

+(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    
    paraStyle.hyphenationFactor = 0.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle,                           };
    
    
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    
    label.attributedText = attributeStr;

    
}

+(CGFloat)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font Width:(CGFloat)width{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    
    paraStyle.hyphenationFactor = 0.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle,                           };
    
    
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    
    label.attributedText = attributeStr;
    
    
    CGSize  size = [label.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)  attributes:dic context:nil].size;
    return size.height;
    
}


//计算UILabel的高度(带有行间距的情况)

/**
 计算带有行间距和字间距的字符串的高度

 @param str       传入的字符串
 @param font      字体
 @param width     文本宽度
 @param lineSpace 行间距，建议 6
 @param fontSpace 字间距，建议 1.5f

 @return 返回字符串的高度
 */
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace fontSpace:(NSNumber *)fontSpace{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    //paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
//    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = lineSpace;
    
//    paraStyle.hyphenationFactor = 0.0;
//    
//    paraStyle.firstLineHeadIndent = 0.0;
//    
//    paraStyle.paragraphSpacingBefore = 0.0;
//    
//    paraStyle.headIndent = 0;
//    
//    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:fontSpace
                          };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    return ceil(size.height);
    
}

//给UILabel设置行间距和字间距（商品详情页使用）

+(void)setLabelSpace1:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    //paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = 6; //设置行间距
    
    paraStyle.hyphenationFactor = 0.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    
    NSDictionary *dic = @{NSFontAttributeName:font,NSKernAttributeName:@1.5f, NSParagraphStyleAttributeName:paraStyle,                           };
    
    
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    
    label.attributedText = attributeStr;
    
    
}

@end
