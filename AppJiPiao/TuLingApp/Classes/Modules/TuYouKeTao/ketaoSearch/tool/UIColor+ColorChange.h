//
//  UIColor+ColorChange.h
//  search
//
//  Created by hua on 16/10/31.
//  Copyright © 2016年 huazhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)
// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
