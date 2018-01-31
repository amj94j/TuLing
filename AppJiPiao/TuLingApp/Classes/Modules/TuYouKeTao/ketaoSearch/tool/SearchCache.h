//
//  SearchCache.h
//  search
//
//  Created by hua on 16/10/31.
//  Copyright © 2016年 huazhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchCache : NSObject
//缓存搜索的数组
+(void)SearchText :(NSString *)seaTxt;
//清除缓存数组
+(void)removeAllArray;
@end
