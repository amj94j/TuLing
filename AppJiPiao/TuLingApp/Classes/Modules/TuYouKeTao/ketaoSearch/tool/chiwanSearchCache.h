//
//  chiwanSearchCache.h
//  TuLingApp
//
//  Created by hua on 2017/5/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chiwanSearchCache : NSObject

/**
 缓存数据

 @param seaTxt 缓存字段
 @param mytype 1美食，2美景，3可淘
 */
+(void)SearchText :(NSString *)seaTxt type:(NSString *)mytype;

//清除缓存数组
+(void)removeAllArray:(NSString *)mytype;

@end
