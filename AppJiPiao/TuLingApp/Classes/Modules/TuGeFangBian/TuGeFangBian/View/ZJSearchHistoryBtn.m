//
//  ZJSearchHistoryBtn.m
//  TuLingApp
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 shensiwei. All rights reserved.
//

#import "ZJSearchHistoryBtn.h"

@implementation ZJSearchHistoryBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconImageView.contentMode = UIViewContentModeCenter;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"ZJSearchHistoryBtn" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
