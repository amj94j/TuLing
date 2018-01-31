//
//  BaseTicketViewController.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseTicketViewController.h"

@interface BaseTicketViewController ()

@end

@implementation BaseTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 定制标题
- (void)addCustomTitleWithTitle:(NSString *)titleName {
    UIFont *font = [UIFont fontWithName:@"PingFang SC" size:18];
    CGSize size = [titleName sizeWithFont:font constrainedToSize:CGSizeMake(ScreenWidth, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
    titleLabel.textAlignment = NSTextAlignmentCenter;
#else
    titleLabel.textAlignment = NSTextAlignmentCenter;
#endif
    
    titleLabel.textColor = [UIColor  colorWithHexString:@"#434343"];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.text = titleName;
    [titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size:18]];
    [self.navigationItem setTitleView:titleLabel];
}

- (void)layoutNavigationItemViewGo:(NSString *)go back:(NSString *)back
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.width, self.navigationItem.titleView.height)];
    self.navigationItem.titleView = titleView;
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"selectflight_arrow_c"];
    arrowImageView.contentMode = UIViewContentModeCenter;
    [titleView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView);
        make.centerY.equalTo(titleView);
    }];
    
    UILabel *goLabel = [[UILabel alloc] init];
    goLabel.font = [UIFont fontWithName:kFont_PingFangSCSemibold size:18];
    goLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    goLabel.textAlignment = NSTextAlignmentRight;
    goLabel.text = go;
    [titleView addSubview:goLabel];
    
    [goLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageView.mas_left).offset(-5);
        make.centerY.equalTo(titleView);
    }];
    
    UILabel *backLabel = [[UILabel alloc] init];
    backLabel.font = [UIFont fontWithName:kFont_PingFangSCSemibold size:18];
    backLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    [titleView addSubview:backLabel];
    backLabel.text = back;
    backLabel.textAlignment = NSTextAlignmentLeft;
    [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(arrowImageView.mas_right).offset(5);
        make.centerY.equalTo(titleView);
    }];
}

- (void)layoutNavigationItemViewGo:(NSString *)go back:(NSString *)back image:(NSString *)image
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.width, self.navigationItem.titleView.height)];
    self.navigationItem.titleView = titleView;
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:image];
    arrowImageView.contentMode = UIViewContentModeCenter;
    [titleView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView);
        make.centerY.equalTo(titleView);
    }];
    
    UILabel *goLabel = [[UILabel alloc] init];
    goLabel.font = [UIFont fontWithName:kFont_PingFangSCSemibold size:18];
    goLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    goLabel.textAlignment = NSTextAlignmentRight;
    goLabel.text = go;
    [titleView addSubview:goLabel];
    
    [goLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageView.mas_left).offset(-5);
        make.centerY.equalTo(titleView);
    }];
    
    UILabel *backLabel = [[UILabel alloc] init];
    backLabel.font = [UIFont fontWithName:kFont_PingFangSCSemibold size:18];
    backLabel.textColor = [UIColor colorWithHexString:@"#434343"];
    [titleView addSubview:backLabel];
    backLabel.text = back;
    backLabel.textAlignment = NSTextAlignmentLeft;
    [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(arrowImageView.mas_right).offset(5);
        make.centerY.equalTo(titleView);
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
