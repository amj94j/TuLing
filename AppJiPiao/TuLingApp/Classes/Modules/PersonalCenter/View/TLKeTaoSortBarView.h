//
//  TLKeTaoSortBarView.h
//  TuLingApp
//
//  Created by gyc on 2017/7/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLKeTaoSortModel.h"

typedef void(^KeTaoSortBarSelectBlock)(int index,BOOL isNeedSort,BOOL isUp ,TLKeTaoSortModel * model);

@interface TLKeTaoSortBarView : UIView

@property (nonatomic,strong) UIColor * selectTextColor;

@property (nonatomic,strong) UIColor * defaultTextColor;

@property (nonatomic,strong) UIFont * textFont;

@property (nonatomic,strong) UIColor * barViewBackgroundColor;

//下部选中条颜色
@property (nonatomic,strong) UIColor * bottomMarkViewColor;

/*
 *  初始化信息，array 存 TLKeTaoSortModel 类型
 */
-(instancetype)initWithTitles:(NSArray*)array;

/*
 *  button title 改变文字
 *  index 第几个需要改变 (排序从0开始)
 */
-(void)titleChangeText:(NSString*)string index:(int)index;

-(void)chooseEvent:(KeTaoSortBarSelectBlock)block;

//更新
-(void)reloadTitleState;
@end
