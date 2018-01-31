//
//  launchView.m
//  TuLingApp
//
//  Created by hua on 17/1/5.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "launchView.h"
#import "UIColor+ColorChange.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kColor(r , g ,b) [UIColor colorWithRed:(r)/255.0  green:(g)/255.0  blue:(b)/255.0 alpha:1]
@interface launchView ()
@property(nonatomic ,weak) UIWindow *windowes;
@end
@implementation launchView
- (instancetype)initWithWindow:(UIWindow *)window
{
    if(self = [super init]){
       
        self.windowes = window;
        [window makeKeyAndVisible];
        self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        
        self.backgroundColor = [UIColor redColor];
        [window addSubview:self];
        
    }
    return self;
}




-(void)launchView
{
//    _launchScroView = [[UIScrollView alloc]init];
//    _launchScroView.frame =self.frame;
//    _launchScroView.backgroundColor=[UIColor blackColor];
//    [self addSubview:_launchScroView];
    
    [self performSelector:@selector(scale_1) withObject:nil afterDelay:0.0f];
    [self performSelector:@selector(scale_2) withObject:nil afterDelay:0.2f];
    [self performSelector:@selector(scale_3) withObject:nil afterDelay:0.4f];
    [self performSelector:@selector(scale_4) withObject:nil afterDelay:0.6f];
    [self performSelector:@selector(scale_5) withObject:nil afterDelay:0.8f];
    
    


}
-(void)scale_1
{
    UIImageView *round_1 = [[UIImageView alloc]initWithFrame:self.frame];
    round_1.image = [UIImage imageNamed:@"round_"];
    [self addSubview:round_1];
    [self setAnimation:round_1];
}

-(void)scale_2
{
    UIImageView *round_2 = [[UIImageView alloc]initWithFrame:self.frame];
    round_2.image = [UIImage imageNamed:@"round_"];
    [self addSubview:round_2];
    [self setAnimation:round_2];
}

-(void)scale_3
{
    UIImageView *round_3 = [[UIImageView alloc]initWithFrame:self.frame];
    round_3.image = [UIImage imageNamed:@"round_"];
    [self addSubview:round_3];
    [self setAnimation:round_3];
}

-(void)scale_4
{
    UIImageView *round_4 = [[UIImageView alloc]initWithFrame:self.frame];
    round_4.image = [UIImage imageNamed:@"round_"];
    [self addSubview:round_4];
    [self setAnimation:round_4];
}

-(void)scale_5
{
    UIImageView *heart_1 = [[UIImageView alloc]initWithFrame:CGRectMake(130, 180, 100, 100)];
    heart_1.image = [UIImage imageNamed:@"heart_"];
    [self addSubview:heart_1];
    [self setAnimation:heart_1];
}
-(void)setAnimation:(UIImageView *)nowView
{
    
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         // 执行的动画code
         [nowView setFrame:CGRectMake(nowView.frame.origin.x- nowView.frame.size.width*0.1, nowView.frame.origin.y-nowView.frame.size.height*0.1, nowView.frame.size.width*1.2, nowView.frame.size.height*1.2)];
     }
                     completion:^(BOOL finished)
     {
         // 完成后执行code
         [nowView removeFromSuperview];
     }
     ];
    
    
}
@end
