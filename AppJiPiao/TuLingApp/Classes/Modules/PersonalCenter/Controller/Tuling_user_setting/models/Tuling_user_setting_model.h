#import <Foundation/Foundation.h>

@interface Tuling_user_setting_model : NSObject
/**
 *  用户名
 */
@property (nonatomic, strong) NSString * user_name;
/**
 *  用户头像url
 */
@property (nonatomic, strong) NSString * icon;
/**
 *  用户真实姓名
 */
@property (nonatomic, strong) NSString * name;
/**
 *  用户微信号
 */
@property (nonatomic, strong) NSString * wechat;
/**
 *  用户QQ号码
 */
@property (nonatomic, strong) NSString * qq;
/**
 *  用户手机号码
 */
@property (nonatomic, strong) NSString * phone;
/**
 *  用户性别
 */
@property (nonatomic, strong) NSString * sex;
/**
 *  
 */
@property (nonatomic, strong) NSString * travel_id;
/**
 *  用户性别
 */
@property (nonatomic, strong) NSString * travel_status;
/**
 *  创建model的构造方法
 *
 *  @param params 服务器返回的个人信息字典
 *
 *  @return model实例对象
 */
+ (instancetype) user_built_with_dictionary:(NSDictionary*)params;
@end
