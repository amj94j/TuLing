//
//  NameSuggestsViewController.m
//  TuLingApp
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 shensiwei. All rights reserved.
//

#import "NameSuggestsViewController.h"

@interface NameSuggestsViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation NameSuggestsViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismiss)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapDismiss {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
