//
//  ZJXibSubView.m
//  TuLingApp
//
//  Created by abner on 2017/12/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ZJXibSubView.h"

@implementation ZJXibSubView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject];
    }
    return self;
}

@end
