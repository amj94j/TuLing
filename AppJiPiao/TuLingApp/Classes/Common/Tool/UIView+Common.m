//
//  UIView+Common.m
//  MusicSample
//
//  Created by JackWong on 13-8-21.
//  Copyright (c) 2013年 JackWong. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)
- (CGFloat)left{
    return CGRectGetMinX(self.frame);
}
/**
 *	@brief	获取左上角纵坐标
 *
 *	@return	坐标值
 */
- (CGFloat)top{
    return CGRectGetMinY(self.frame);
}
/**
 *	@brief	获取视图右下角横坐标
 *
 *	@return	坐标值
 */
- (CGFloat)right{
    return CGRectGetMaxX(self.frame);
}

/**
 *	@brief	获取视图右下角纵坐标
 *
 *	@return	坐标值
 */
- (CGFloat)bottom{
    return CGRectGetMaxY(self.frame);
}

/**
 *	@brief	获取视图宽度
 *
 *	@return	宽度值（像素）
 */
- (CGFloat)width{
    return CGRectGetWidth(self.frame);
}

/**
 *	@brief	获取视图高度
 *
 *	@return	高度值（像素）
 */
- (CGFloat)height{
    return CGRectGetHeight(self.frame);
}

-(UIViewController *)viewController{
    for (UIView* next = [self superview];next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)removeAllSubViews{
    for (UIView *sub in self.subviews) {
        [sub removeFromSuperview];
    }
}

- (UITapGestureRecognizer *)addTapGestureWithTarget:(id)target action:(SEL)selector {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:tap];
    
    return tap;
}

- (void)extendBounds:(CGFloat)extendValue{
    self.bounds = CGRectMake(0, 0, self.width + extendValue, self.height + extendValue);
}

@end
