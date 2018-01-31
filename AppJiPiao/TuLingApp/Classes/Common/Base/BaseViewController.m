#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)addLoginedNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginedNotification:) name:kTLLoginedNotification object:nil];
}

-(void)loginedNotification:(NSNotification*)noti{

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTLLoginedNotification object:nil];
}

@end
