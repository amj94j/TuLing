//
//  ZJBaseViewController.h
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseVC.h"

#define NavigationBarHeight             (IOS7_OR_LATER ? 64 : 44) //导航栏高度
#define BaseY                           (IOS7_OR_LATER ? 20 : 0)

@interface ZJBaseViewController : BaseVC

@property (nonatomic, strong) UINavigationBar *navigationBar;        //导航栏

- (void)setNavBarLeftButtonTitle:(NSString *)title;
- (void)setNavBarLeftButtonIcon:(UIImage *)image;
- (void)setNavBarLeftButtonTarget:(id)target action:(SEL)selector;
- (void)enableNavBarLeftButton:(BOOL)fEnable;
- (void)hideLeftButton:(BOOL)hide;

- (void)setNavBarCenterTitle:(NSString *)title;
- (void)setCenterTitleFont:(UIFont *)font;
- (void)setCenterLabelTarget:(id)target action:(SEL)selector;
- (void)setCenterTextColor:(UIColor *)color;
- (NSString *)centerTitle;

- (void)setNavBarRightButtonTitle:(NSString *)title;
- (void)setNavBarRightButtonIcon:(UIImage *)icon;
- (void)setNavBarRightButtonTarget:(id)target action:(SEL)selector;
- (void)enableNavBarRightButton:(BOOL)fEnable;
- (void)hideRightButton:(BOOL)hide;

@end
