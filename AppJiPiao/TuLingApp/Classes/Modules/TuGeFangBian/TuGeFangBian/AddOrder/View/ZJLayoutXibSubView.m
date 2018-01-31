//
//  ZJLayoutXibSubView.m
//  peipei
//
//  Created by abner on 2017/10/10.
//  Copyright © 2017年 Shenzhen Turen Technology Inc. All rights reserved.
//

#import "ZJLayoutXibSubView.h"
#import "Masonry.h"

@implementation ZJLayoutXibSubView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.equalTo(self);
        }];
    }
    return self;
}

@end
