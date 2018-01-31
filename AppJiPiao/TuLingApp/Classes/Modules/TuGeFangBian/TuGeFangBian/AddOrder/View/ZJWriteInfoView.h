//
//  ZJWriteInfoView.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/14.
//  Copyright © 2017年 Abnerzj. All rights reserved.
//  填写信息视图

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZJWriteInfoViewTipTypeNot,   // 不需要
    ZJWriteInfoViewTipTypeInfo,  // 感叹号
    ZJWriteInfoViewTipTypeHelp,  // 问号
} ZJWriteInfoViewTipType;    // 提示类型

typedef enum : NSUInteger {
    ZJWriteInfoViewActionTypeWrite,  // 输入
    ZJWriteInfoViewActionTypeSelect, // 选择
} ZJWriteInfoViewActionType;         // 填写信息方式

@interface ZJWriteInfoView : UIView

/** 输入方式时键盘类型 */
@property(nonatomic) UIKeyboardType keyboardType;
/** 输入方式时文字 */
@property(nonatomic, copy) NSString *text;

// 获取实例
+ (instancetype)zj_WriteInfoView;

/**
 更新信息视图

 @param name 标题
 @param tipType 提示类型
 @param actionType 填写信息方式：输入、选择
 @param data 如果是输入填占位文字。如果是选择则是ZJWriteInfoViewSelectModel
 @param actionCallBack 操作完成回调。
 1> 选择方式时：isSelectAction YES为选择操作，否则为点击提示操作。
 1> 输入方式时：isSelectAction YES为结束输入后回调，否则为点击提示操作。
 */
- (void)zj_updateInfoWithName:(NSString *)name
                      tipType:(ZJWriteInfoViewTipType)tipType
                   actionType:(ZJWriteInfoViewActionType)actionType
                         data:(id)data
               actionCallBack:(void(^)(BOOL isSelectAction))actionCallBack;

// 获取填写或选择的内容
- (NSString *)zj_getWriteContent;
// 输入类型时，判断获取的内容是否为空
- (BOOL)zj_contentIsNotNilAndValid;
@end

@interface ZJWriteInfoViewSelectModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *dataList;

/**
 NSArray *dataList = @[@{@"湖南" : @[@{@"长沙" : @[@"雨花区", @"芙蓉区", @"天心区"]}, @{@"衡阳" : @[@"蒸湘区", @"芙蓉区1", @"天心区1"]}]}, @{@"湖南2" : @[@{@"长沙2" : @[@"雨花区2", @"芙蓉区2", @"天心区2"]}, @{@"衡阳2" : @[@"蒸湘区2", @"芙蓉区2", @"天心区2"]}]}, @{@"湖南3" : @[@{@"长沙3" : @[@"雨花区3", @"芙蓉区3", @"天心区3"]}, @{@"衡阳3" : @[@"蒸湘区3", @"芙蓉区3", @"天心区3"]}]}];
 */

+ (instancetype)initWithTitle:(NSString *)title dataList:(NSArray *)dataList;

@end
