//
//  chiwanSearchCache.m
//  TuLingApp
//
//  Created by hua on 2017/5/24.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "chiwanSearchCache.h"

@implementation chiwanSearchCache
//缓存搜索数组

/**
 缓存数据
 
 @param seaTxt 缓存字段
 @param mytype 1美食，2美景，3可淘
 */
+(void)SearchText :(NSString *)seaTxt type:(NSString *)mytype
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSMutableArray *myArray =[[NSMutableArray alloc]init];
    //命名key
    NSString *str = [NSString stringWithFormat:@"myArray%@",mytype];
    
    
    [myArray addObjectsFromArray:[userDefaultes arrayForKey:str]];
    
    
    if (myArray.count > 0) {//先取出数组，判断是否有值，有值继续添加，无值创建数组
        [myArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:seaTxt]) {
               
                [myArray removeObjectAtIndex:idx];
            }
        }];
        
    }
    
    NSMutableArray *searTXT = [myArray mutableCopy];
    
    [searTXT addObject:seaTxt];
    if(searTXT.count > 10)
    {
        [searTXT removeObjectAtIndex:0];
    }
    //    NSMutableArray *searArr = [[NSMutableArray alloc]init];
    //    for (int i=0; i<searTXT.count; i++) {
    //        NSString *str =searTXT[searTXT.count-1-i];
    //        [searArr addObject:str];
    //    }
    //将上述数据全部存储到NSUserDefaults中
    //        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:searTXT forKey:str];
    [userDefaultes synchronize];
}
+(void)removeAllArray:(NSString *)mytype{
    
    
    //命名key
    NSString *str = [NSString stringWithFormat:@"myArray%@",mytype];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:str];
    [userDefaults synchronize];
    
}

@end
