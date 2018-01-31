
#import "MBProgressHUD.h"

@interface MBProgressHUD (WJ)

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (void)showSuccess:(NSString *)success duration:(NSTimeInterval)duration;
+ (void)showError:(NSString *)error duration:(NSTimeInterval)duration;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message duration:(NSTimeInterval)seconds;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view duration:(NSTimeInterval)seconds;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
