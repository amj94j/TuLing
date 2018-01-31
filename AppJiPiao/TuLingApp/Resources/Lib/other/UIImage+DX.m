//
//  UIImage+DX.m
//  新浪微博
//
//  Created by Ibokan on 15/9/18.
//  Copyright (c) 2015年 Ibokan. All rights reserved.
//

#import "UIImage+DX.h"

@implementation UIImage (DX)
+ (UIImage *)imageWithName:(NSString *)string
{
    double a = [[UIDevice currentDevice].systemVersion doubleValue];
    if (a >= 7.0)
    {
        //NSLog(@"当前机器的型号是%f",a);
        NSString *appendingstring = [string stringByAppendingString:@"_os7"];
        UIImage * image = [UIImage imageNamed:appendingstring];
        if (image == nil) {
            return [UIImage imageNamed:string];
        }
    
    }
    return [UIImage imageNamed:string];
}
+ (UIImage *) stretchImageWith : (NSString *) string
{
    return [UIImage stretchImageWith:string andLeft:0.5 andTop:0.5];
}
+ (UIImage *) stretchImageWith : (NSString *) string andLeft:(CGFloat)left andTop : (CGFloat)top
{
    UIImage * image = [self imageWithName:string];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


/**
 画一个虚线的边框
 
 @param size 需要虚线边框视图的大小
 @param color 边框颜色
 @param borderWidth 边框粗细
 @return 虚线边框的image
 */
+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
