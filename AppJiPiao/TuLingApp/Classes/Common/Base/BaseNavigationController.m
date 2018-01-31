#import "BaseNavigationController.h"
#import "MainSliderViewController.h"
#import "AppDelegate.h"
#import "UIButton+Extensions.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        //[UIApplication sharedApplication].statusBarHidden = NO;
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#434343"],NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
        [button setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -30, -10, -30)];
        [button setBackgroundImage:[UIImage imageNamed:@"mine"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        rootViewController.navigationItem.leftBarButtonItem = item;
        self.navigationBar.translucent = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavBarTheme];
}

- (void)setupNavBarTheme
{
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 设置背景
    //navBar.barTintColor =  RGBCOLOR(0, 102, 32);
    navBar.barTintColor =  [UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)ButtonClick
{
    AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.tab showLeftView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
