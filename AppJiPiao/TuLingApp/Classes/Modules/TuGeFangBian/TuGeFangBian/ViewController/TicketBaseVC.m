//
//  TicketBaseVC.m
//  TuLingApp
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TicketBaseVC.h"

@interface TicketBaseVC ()

@end

@implementation TicketBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 定制标题
- (void)addCustomTitleWithTitle:(NSString *)titleName {
    UIFont *font = [UIFont fontWithName:kFont_PingFangSCSemibold size:18];
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
    [titleLabel setFont:[UIFont fontWithName:kFont_PingFangSCSemibold size:18]];
    [self.navigationItem setTitleView:titleLabel];
}

- (void)layoutNavigationItemViewGo:(NSString *)go back:(NSString *)back {
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
- (void)addRightBtnWithTitle:(NSString *)title iconName:(NSString *)iconName target:(id)target selector:(SEL)selector
{
    CGSize size = CGSizeZero;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title.length > 0) {
        [rightBtn setTitle:title forState:UIControlStateNormal];
        [rightBtn setTitle:title forState:UIControlStateHighlighted];
        size = [title sizeWithFont:rightBtn.titleLabel.font];
    }
    
    if (iconName.length > 0) {
        UIImage *image = [UIImage imageNamed:iconName];
        if (image) {
            CGFloat imageW = image.size.width;// / [UIScreen mainScreen].scale;
            CGFloat imageH = image.size.height;// / [UIScreen mainScreen].scale;
            if (size.width) {
                [rightBtn setImage:image forState:UIControlStateNormal];
                [rightBtn setImage:image forState:UIControlStateHighlighted];
                size = CGSizeMake(size.width + 10.0f, size.height);
            } else {
                [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
                [rightBtn setBackgroundImage:image forState:UIControlStateHighlighted];
                if (imageH < 18.0f) {
                    if (imageW == imageH) {
                        imageH = 18.0f;
                        imageW = 18.0f;
                    } else {
                        CGFloat scale = imageW / imageH;
                        imageH = 18.0f;
                        imageW = imageH * scale;
                    }
                }
            }
            size = CGSizeMake(size.width + imageW, size.height + imageH);
        }
    }
    [rightBtn setFrame:CGRectMake(0, 0, size.width, size.height)];
    [rightBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    rightBtn.selected = NO;
    [rightBtn setShowsTouchWhenHighlighted:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

//是否为今天
- (BOOL)isToday:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
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
