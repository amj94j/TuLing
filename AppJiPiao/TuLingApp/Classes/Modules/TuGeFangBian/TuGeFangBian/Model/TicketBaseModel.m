//
//  TicketBaseModel.m
//  TuLingApp
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseModel.h"
#import <objc/runtime.h>

@implementation TicketBaseModel
//1、/* 获取对象的所有属性，不包括属性值 */
- (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

//2、/* 获取对象的所有属性 以及属性值 */
- (NSDictionary *)properties_aps {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

//3、/* 获取对象的所有方法 */
- (void)printMothList
{
    
    unsigned int mothCout_f =0;
    
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    
    for(int i=0;i<mothCout_f;i++)
        
    {
        
        Method temp_f = mothList_f[i];
        
        //        IMP imp_f = method_getImplementation(temp_f);
        
        //        SEL name_f = method_getName(temp_f);
        
        const char* name_s =sel_getName(method_getName(temp_f));
        
        int arguments = method_getNumberOfArguments(temp_f);
        
        const char* encoding =method_getTypeEncoding(temp_f);
        
        //        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s], arguments,[NSString stringWithUTF8String:encoding]);
        
    }
    
    free(mothList_f);
    
}


/*!
 @brief 返回的字典处理下空的值(为了存储)，并返回可变的对象，递归解析完所有的字典
 */
+(NSMutableDictionary*)getDataDictionary:(NSDictionary*)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSMutableDictionary* mutDic = [NSMutableDictionary dictionary];
    
    for (id key in dictionary.allKeys) {
        id obj = [self getObject:dictionary[key]];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = [self getDataDictionary:obj];//本身再调用本身接着处理
        }
        
        [mutDic setObject:obj forKey:key];
    }
    return mutDic;
}
+ (id) getObject:(id)obj{
    if (obj == nil || obj == NULL) {
        return @"";
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    //    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
    //        return @"";
    //    }
    return obj;
}


@end
