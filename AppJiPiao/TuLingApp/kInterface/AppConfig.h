//
//  AppConfig.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h


#define TESTVERSION @"testVersion"



// =====================    打印控制    ====================
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif




#ifdef DEBUG
//#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLog(format, ...) do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#else
#define NSLog(...)
#endif


// =====================    Colors     ====================
#define kColorWhite         [UIColor whiteColor]
#define kColorClear         [UIColor clearColor]
#define kColorBlack         [UIColor blackColor]

#define kColorLine          [UIColor colorWithHexString:@"#EEEEEE"]

// 字体黑
#define kColorFontBlack1    [UIColor colorWithHexString:@"#434343"]
#define kColorFontBlack2    [UIColor colorWithHexString:@"#6A6A6A"]
#define kColorFontBlack3    [UIColor colorWithHexString:@"#919191"]

// 主题绿
#define kColorAppGreen      [UIColor colorWithHexString:@"#6DCB99"]
// 主题红
#define kColorAppRed        [UIColor colorWithHexString:@"#FF5C36"]


// =====================      Font     ====================
#define kFontNol10  [UIFont systemFontOfSize:10]
#define kFontNol12  [UIFont systemFontOfSize:12]
#define kFontNol13  [UIFont systemFontOfSize:13]
#define kFontNol15  [UIFont systemFontOfSize:15]
#define kFontNol16  [UIFont systemFontOfSize:16]
#define kFontNol17  [UIFont systemFontOfSize:17]
#define kFontNol18  [UIFont systemFontOfSize:18]


// 屏幕比例（设计稿按照750*1334设计）
#define kWidthScale WIDTH/375
#define kHeightScale HEIGHT/667
#define kLeftVCWidth 300*kWidthScale



#endif /* AppConfig_h */
