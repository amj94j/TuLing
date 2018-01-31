#import <UIKit/UIKit.h>
#import "HzCustomTabBarController.h"
#import "BaseNavigationController.h"

#import "MainLeftBackgroundVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)HzCustomTabBarController *tab;
@property (strong, nonatomic)BaseNavigationController *nav;

@property (strong, nonatomic) MainLeftBackgroundVC *lvc;
@property (strong, nonatomic) UIImageView *splashView;

@end
