//
//  ChooseTankTypeViewController.m
//  TuLingApp
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ChooseTankTypeViewController.h"

@interface ChooseTankTypeViewController ()

@end

@implementation ChooseTankTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    // Do any additional setup after loading the view from its nib.
    if ([self.positionType isEqualToString:@"0"]) {
        self.jingjiImageView.image = [UIImage imageNamed:@"selectflight_check_2"];
        self.headImageView.image = [UIImage imageNamed:@"selectflight_uncheck"];
    } else {
        self.jingjiImageView.image = [UIImage imageNamed:@"selectflight_uncheck"];
        self.headImageView.image = [UIImage imageNamed:@"selectflight_check_2"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseTankType:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 222) {
        self.jingjiImageView.image = [UIImage imageNamed:@"selectflight_check_2"];
        ChooseTankTypeViewControllerBlock block = self.block;
        if (block) {
            block(@"经济舱",0);
        }
    } else {
        self.headImageView.image = [UIImage imageNamed:@"selectflight_check_2"];
        ChooseTankTypeViewControllerBlock block = self.block;
        if (block) {
            block(@"头等舱/公务舱",1);
        }
    }
    [self dismissViewControllerAnimated:NO completion:^{
    }];
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
