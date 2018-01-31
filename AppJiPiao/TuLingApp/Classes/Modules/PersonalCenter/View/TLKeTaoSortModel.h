//
//  TLKeTaoSortModel.h
//  TuLingApp
//
//  Created by gyc on 2017/7/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "JSONModel.h"

@interface TLKeTaoSortModel : JSONModel
@property (nonatomic) int id;
@property (nonatomic,copy) NSString * name;//名字

@property (nonatomic) BOOL isSelected;//已被选中

@property (nonatomic) BOOL isNeedSort;//需要显示排序箭头

@property (nonatomic) BOOL isUp;//排序箭头指向

@property (nonatomic) BOOL isNeedChoose;//需要选择分类


@end
