#import "TLAccountSave.h"

/**
 判断用户是否已经登录 将首次登陆的信息保存到一个模型对象存储在account.data中 AppDelegate需要判断
 */
#define WBAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]
@implementation TLAccountSave

+ (void) saveAccountWithAccount : (TLAccount*) account
{
    
 
}


+ (TLAccount*) account
{
    NSString *str=  [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid" ];
    TLAccount *str1 = [[TLAccount alloc]init];
    str1.uuid =str;
    
    
    return str1;
}

+ (void)removeAccount{
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uuid"];

}
@end
