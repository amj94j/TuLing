#define FontSize 15
#define THE_FIRST_NORMAL_TITLELABEL @"获取验证码"
#define LATER_NORMAL_TITLELABEL @"再次获取"


#import "verification_button.h"

@interface verification_button ()
/**
 * 倒计时的总秒数
 */
@property (nonatomic, assign) int total_seconds;

/**
 * 再次发送验证码秒数(变化的)
 */

@property (nonatomic,assign) int second;

/**
 * 验证码计时器
 */
@property (nonatomic,strong) NSTimer * timer;

@end

@implementation verification_button

- (instancetype)initWithTotal_seconds : (int)total_seconds
{
    self = [super init];
    if (self) {
        
        self.total_seconds = total_seconds;
        self.second = total_seconds;
        self.titleLabel.font = [UIFont systemFontOfSize:FontSize];
        [self setTitleColor:RGBCOLOR(35, 160, 90) forState:UIControlStateNormal];
        [self setTitle:THE_FIRST_NORMAL_TITLELABEL forState:UIControlStateNormal];
        [self setTitle:[NSString stringWithFormat:@"剩余%d秒",total_seconds ] forState:UIControlStateDisabled];
        //[self setBackgroundColor:[UIColor colorWithRed:230/255.0 green:106/255.0 blue:116/255.0 alpha:1.0]];
        [self addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (instancetype)buttonWithTotal_seconds:(int)total_seconds
{
    return [[self alloc]initWithTotal_seconds:total_seconds];
}

- (void) sendMessage
{
    //重新赋值
    self.second = self.total_seconds;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(seconds)
                                                userInfo:nil
                                                 repeats:YES];
    self.enabled = NO;
    
    //代理对象向服务器发送请求验证码的方法
    if ([self.delegate respondsToSelector:@selector(send_mobile_number_to_server:)]) {
        [self.delegate send_mobile_number_to_server:self];
    }
    
}
/**
 *  倒计时事件
 */
- (void) seconds
{
    if (self.second > 1) {
        self.second -- ;
        [self setTitle:[NSString stringWithFormat:@"剩余%d秒",self.second]
              forState:UIControlStateDisabled];
    }
    else
    {
        self.enabled = YES;
        [self.timer invalidate];
        [self setTitle: LATER_NORMAL_TITLELABEL forState:UIControlStateNormal];
        [self setTitle:[NSString stringWithFormat:@"剩余%d秒",self.total_seconds ] forState:UIControlStateDisabled];
    }
}
@end
