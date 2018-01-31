

#import <Foundation/Foundation.h>
#import "TLAccount.h"
@interface TLAccountSave : NSObject
/**
 * 保存account
 */
+ (void) saveAccountWithAccount : (TLAccount*) account;
/**
 * 取出保存的account
 */
+ (TLAccount*) account;

+ (void)removeAccount;
@end
