//
//  UIImage+DX.h
//  新浪微博
//
//  Created by Ibokan on 15/9/18.
//  Copyright (c) 2015年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DX)
+ (UIImage *) imageWithName : (NSString *) string;
+ (UIImage *) stretchImageWith : (NSString *) string;
+ (UIImage *) stretchImageWith : (NSString *) string andLeft:(CGFloat)left andTop : (CGFloat)top;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 画一个虚线的边框
 
 @param size 需要虚线边框视图的大小
 @param color 边框颜色
 @param borderWidth 边框粗细
 @return 虚线边框的image
 */
+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
@end
