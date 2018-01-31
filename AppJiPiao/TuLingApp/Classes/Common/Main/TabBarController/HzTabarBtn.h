//
//  HzTabarBtn.h
//  HzCustomViewController
//
//  Created by Beyond on 15/9/23.
//  Copyright © 2015年 Huozong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeView.h"

/**
 *  自定义tabbarItems
 */
@interface HzTabarBtn : UIButton
@property (nonatomic,strong)NSString * normalImageNames;
@property (nonatomic,strong)NSString * selectedImages;
@property (nonatomic,strong)NSString * highLightImages;
@property (nonatomic, strong) BadgeView *badgeView;


/**
 *  设置角标未读数
 *
 *  @param num 角标数量
 */
- (void)showBadgeWithNum:(NSString *)num;

@end
