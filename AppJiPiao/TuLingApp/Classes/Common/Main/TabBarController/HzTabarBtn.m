//
//  HzTabarBtn.m
//  HzCustomViewController
//
//  Created by Beyond on 15/9/23.
//  Copyright © 2015年 Huozong. All rights reserved.
//

#import "HzTabarBtn.h"

@implementation HzTabarBtn
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        if(isIPHONE6P){
            self.titleLabel.font = [UIFont systemFontOfSize:14];
        }else{
            self.titleLabel.font = [UIFont systemFontOfSize:10];
        }
        _badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(frame.size.width/2+8, 1, 20, 20)];
        _badgeView.quake = YES;
//        _badgeView.backgroundColor = [UIColor redColor];
        [self addSubview:_badgeView];
        
    }
    return self;
}

/**
 *  设置角标
 *
 */
- (void)showBadgeWithNum:(NSString *)num
{
    int text = [num intValue];
    if (text == 0) {
        _badgeView.hidden = YES;
    } else {
        
        _badgeView.hidden = NO;
        _badgeView.text = num;
    }
}

#pragma mark - 设置按钮内部图片和文字的frame
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    if (!self.titleLabel.text.length)
//    {
//        return CGRectMake(13, 5, 45, 45);
//    }
//    if(isIPHONE6P){
//        return CGRectMake(38, 6, 24, 24);
//    }else if (isIPHONE6){
//        return CGRectMake(33, 6, 24, 24);
//    }else{
//        return CGRectMake(27, 6, 24, 24);
//    }
//}
//
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    if(isIPHONE6P){
//        return CGRectMake(19, 29, 64, 20);
//    } else if (isIPHONE6) {
//        return CGRectMake(14, 29, 64, 20);
//    }else{
//        return CGRectMake(8, 29, 64, 20);
//    }
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
