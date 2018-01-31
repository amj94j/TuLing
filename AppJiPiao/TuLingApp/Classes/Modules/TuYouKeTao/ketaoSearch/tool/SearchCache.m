//
//  SearchCache.m
//  search
//
//  Created by hua on 16/10/31.
//  Copyright © 2016年 huazhuo. All rights reserved.
//

#import "SearchCache.h"

@implementation SearchCache
//缓存搜索数组
+(void)SearchText :(NSString *)seaTxt
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSMutableArray *myArray =[[NSMutableArray alloc]init];
    [myArray addObjectsFromArray:[userDefaultes arrayForKey:@"myArray"]];
    
    
    if (myArray.count > 0) {//先取出数组，判断是否有值，有值继续添加，无值创建数组
        [myArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:seaTxt]) {
               
                [myArray removeObjectAtIndex:idx];
            }
        }];

    }

    NSMutableArray *searTXT = [myArray mutableCopy];
 
    
    [searTXT addObject:seaTxt];
    if(searTXT.count > 5)
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
    [userDefaultes setObject:searTXT forKey:@"myArray"];
    [userDefaultes synchronize];
}
+(void)removeAllArray{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"myArray"];
    [userDefaults synchronize];
}


@end
