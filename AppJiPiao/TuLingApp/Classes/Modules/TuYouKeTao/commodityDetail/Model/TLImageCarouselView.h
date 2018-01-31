//
//  TLImageCarouselView.h
//  TuLingApp
//
//  Created by gyc on 2017/8/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TYCyclePagerView.h"
#import "TYPageControl.h"

@interface TLImageCarouselView : UIView

@property (nonatomic,strong) NSArray * imagesArray;

-(instancetype)initWithFrame:(CGRect)frame;

@end
