//
//  SRNewFeaturesViewController.h
//  SRNewFeaturesDemo
//
//  Created by  on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//

/**
 *  If you have any question, please issue or contact me.
 *  QQ: 396658379
 *  Email: guowilling@qq.com
 *
 *  If you like it, please star it, thanks a lot.
 *  Github: https://github.com/guowilling/SRNewFeatures
 *
 *  Have Fun.
 */

#import <UIKit/UIKit.h>

@interface SRNewFeaturesViewController : UIViewController

#pragma mark - Properties

/**
 Whether to hide pageControl, default is NO which means show pageControl.
 */
@property (nonatomic, assign) BOOL hidePageControl;

/**
 Whether to hide skip Button, default is YES which means hide skip Button.
 */
@property (nonatomic, assign) BOOL hideSkipButton;

/**
 Current page indicator tint color, default is [UIColor whiteColor].
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 Other page indicator tint color, default is [UIColor lightGrayColor].
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

#pragma mark - Class methods

/**
 Only the first start app need show new features.

 @return YES to show, NO not to show.
 */
+ (BOOL)sr_shouldShowNewFeature;

/**
 Create new features view controller with images.

 @param imageNames The image's name array.
 @param rootVC     The key window's true root view controller.

 @return SRNewFeatureViewController
 */
+ (instancetype)sr_newFeatureWithImageNames:(NSArray *)imageNames rootViewController:(UIViewController *)rootVC;

/**
 The same as class method sr_newFeatureWithImageNames:rootViewController:
 */
- (instancetype)initWithImageNames:(NSArray *)imageNames rootViewController:(UIViewController *)rootVC;

@end
