/* 使用注意: 1、要使用构造器的方法创建button,后面是总的秒数,之后要记得把frame设置上.

               verification_button* button = [verification_button buttonWithTotal_seconds:5];

            2、向服务器发送的请求要写在代理方法里面.
*/

#import <UIKit/UIKit.h>
@class verification_button;

//在这里写向服务器发送请求验证码的具体方法
@protocol verification_buttonDelegate <NSObject>
- (void) send_mobile_number_to_server: (verification_button *) maleAndFemale;
@end


@interface verification_button : UIButton

@property (nonatomic, weak) id <verification_buttonDelegate> delegate;

+ (instancetype)buttonWithTotal_seconds : (int) total_seconds;

@end
