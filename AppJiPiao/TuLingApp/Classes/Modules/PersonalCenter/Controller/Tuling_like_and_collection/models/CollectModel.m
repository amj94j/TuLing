//
//  CollectModel.m
//  TuLingApp
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "CollectModel.h"

@implementation CollectModel
- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"未赋值的key:%@", key);
}
@end
