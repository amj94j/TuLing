//
//  TicketBaseModel.h
//  TuLingApp
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "JSONModel.h"

@interface TicketBaseModel : JSONModel
- (NSArray *)getAllProperties;
- (void)printMothList;
/*!
 @brief 返回的字典处理下空的值(为了存储)，并返回可变的对象，递归解析完所有的字典
 */
+(NSMutableDictionary*)getDataDictionary:(NSDictionary*)dictionary;

//2、/* 获取对象的所有属性 以及属性值 */
- (NSDictionary *)properties_aps;

@end
