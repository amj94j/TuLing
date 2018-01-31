//
//  BadgeView.m
//  EoopenEIM
//
//  Created by mac on 15-5-12.
//  Copyright (c) 2015年 James. All rights reserved.
//

#import "BadgeView.h"

@interface BadgeView ()

{
    UILabel *badgeLable;
}

@end

@implementation BadgeView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
        
        _oneFrame = frame;
        
        CGPoint origin = frame.origin;
        CGSize size = frame.size;
        
        _otherFrame = CGRectMake(origin.x-4, origin.y, size.width+8, size.height);

        _oneImage = [UIImage imageNamed:@"badgeVBGImgA.png"];
        _otherImage = [UIImage imageNamed:@"badgeVBGImgB.png"];
        
    }
    return self;
    
}

- (void)initSubView
{
    badgeLable = [[UILabel alloc] init];
    //[self badgeLableSetFrame];
    badgeLable.backgroundColor = [UIColor whiteColor];
    badgeLable.textColor = [UIColor whiteColor];
    badgeLable.textAlignment = NSTextAlignmentCenter;
    badgeLable.font = [UIFont systemFontOfSize:14];
    [self insertSubview:badgeLable aboveSubview:self]; // 在self上面

}

#define mark --- SET方法 ---
- (void)badgeLableSetFrame
{
    CGSize size = self.frame.size;
    badgeLable.frame = CGRectMake(0, 0, size.width, size.height);
}

-(void)setTextColor:(UIColor *)textColor {
    
    badgeLable.textColor = textColor;
    
}

-(void)setFont:(UIFont *)font {
    
    badgeLable.font = font;
    
}


-(void)setText:(NSString *)text {
    
    if (text.intValue>99)
    {
        text = @"99+";
    }
    
    badgeLable.text = text;

    if (text.length == 1)
    {
        
        self.image = _oneImage;
        self.frame = _oneFrame;
        
        
    }
    else
    {
        self.image = _otherImage;
        self.frame = _otherFrame;
    }
    
    [self badgeLableSetFrame];
    
    // 此处添加抖动效果
    if (_quake)
    {
//        [GlobalFunction badgeViewEarthquake:self];
    }
    
}



@end
