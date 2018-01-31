//
//  UIView+Common.h
//  MusicSample
//
//  Created by JackWong on 13-8-21.
//  Copyright (c) 2013年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)

/**
 *	@brief	获取左上角横坐标
 *
 *	@return	坐标值
 */
- (CGFloat)left;


/**
 *	@brief	获取左上角纵坐标
 *
 *	@return	坐标值
 */
- (CGFloat)top;

/**
 *	@brief	获取视图右下角横坐标
 *
 *	@return	坐标值
 */
- (CGFloat)right;

/**
 *	@brief	获取视图右下角纵坐标
 *
 *	@return	坐标值
 */
- (CGFloat)bottom;


/**
 *	@brief	获取视图宽度
 *
 *	@return	宽度值（像素）
 */
- (CGFloat)width;

/**
 *	@brief	获取视图高度
 *
 *	@return	高度值（像素）
 */
- (CGFloat)height;

/**
 *	@brief	获取视图所在控制器
 *
 *	@return	控制器
 */
- (UIViewController *)viewController;

/**
 *  快速移除所有子视图
 */
- (void)removeAllSubViews;

/**
 *  添加单击手势
 *
 *  @param selector 单击手势执行方法
 */
- (UITapGestureRecognizer *)addTapGestureWithTarget:(id)target action:(SEL)selector;

/**
 *  增大 view 半径
 *
 *  @param extendValue 增大量
 */
- (void)extendBounds:(CGFloat)extendValue;

@end
