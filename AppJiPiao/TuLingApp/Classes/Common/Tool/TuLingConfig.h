//
//  TuLingConfig.h
//  TuLingApp
//
//  Created by hua on 2017/7/19.
//  Copyright © 2017年 shensiwei. All rights reserved.
//


#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define FONT_MEDIUM    (IOS9?@"PingFangSC-Medium":@"Helvetica")  //苹方中黑
#define FONT_REGULAR   (IOS9?@"PingFangSC-Regular":@"Helvetica")  // 苹方常规
#define FONT_SEMIBOLD   (IOS9?@"PingFangSC-Semibold":@"Helvetica")  //苹方中粗
#define SINGLE_LINE_WIDTH   (1 / [UIScreen mainScreen].scale) //绘制一个像素的宽度


#define TLFontSize(size,diff)  (320?size - diff:size)  //如果不是375以上宽度，字号大小相应减小

//#define TLFont_Regular_Size(size,diff) (IOS9 ? [UIFont fontWithName:@"PingFangSC-Regular" size:TLFontSize(23, 2)]:[UIFont systemFontOfSize:TLFontSize(23, 2)])

//#define TLFont_Semibold_Size(size,diff) (IOS9?[UIFont fontWithName:@"PingFangSC-Semibold" size:TLFontSize(size, diff)] : [UIFont boldSystemFontOfSize:TLFontSize(size, diff)])


static inline UIFont * TLFont_Regular_Size(int size , int diff) {
    return IOS9 ? [UIFont fontWithName:@"PingFangSC-Regular" size:TLFontSize(size, diff)] : [UIFont systemFontOfSize:TLFontSize(size, diff)];
}

static inline UIFont * TLFont_Semibold_Size(int size , int diff) {
    return IOS9 ? [UIFont fontWithName:@"PingFangSC-Semibold" size:TLFontSize(size, diff)] : [UIFont boldSystemFontOfSize:TLFontSize(size, diff)];
}

#define SCALEPhoneHEIGHT [UIScreen mainScreen].bounds.size.height/667
#define SCALEPhoneWIDTH  [UIScreen mainScreen].bounds.size.width/375
