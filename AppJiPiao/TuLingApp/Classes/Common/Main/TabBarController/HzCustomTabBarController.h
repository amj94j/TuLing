//
//  HzCustomTabBarController.h
//  HzCustomViewController
//
//  Created by Beyond on 15/9/22.
//  Copyright © 2015年 Huozong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HzCustomTabBarController : UITabBarController

/**
 *  自定义的tabbarView
 */
@property (nonatomic,strong)UIImageView *tabBarView;

/**
 *  创建tabbarViewcontrollers
 *
 *  @param tabbarsCount      共几个controller
 *  @param vcArray           controller数组
 *  @param normalArr         tabbar的正常图片
 *  @param TabbarSelectedArr tabbar的选中图片
 *  @param titlesArr         tabbar的文字
 */
- (void)creatTabbarVCWithControllersArray:(NSArray *)vcArray andTabbarNormalImageArr:(NSArray *)normalArr andTabbarSelectedImageArr:(NSArray *)TabbarSelectedArr andTabbarsTitlesArr:(NSArray *)titlesArr;
/**切换tabbar*/
- (void)tabBarBtnClick:(id)sender;
/**
 *  右滑操作
 */
- (void)showLeftView;


-(void)selectBar:(NSUInteger )sele;

- (void)showMainView;


@end
