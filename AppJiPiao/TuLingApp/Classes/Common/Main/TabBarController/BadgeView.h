//
//  BadgeView.h
//  EoopenEIM
//
//  Created by mac on 15-5-12.
//  Copyright (c) 2015年 James. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 角标
 */
@interface BadgeView : UIImageView

@property (nonatomic, copy)   NSString           *text;            // default is nil

@property (nonatomic, retain) UIFont             *font;            // default is nil (system font 12 plain)

@property (nonatomic, retain) UIColor            *textColor;       // default is nil (text draws white)

@property (nonatomic, retain) UIImage            *oneImage;

@property (nonatomic, retain) UIImage            *otherImage;

@property(nonatomic)          CGRect             oneFrame;

@property(nonatomic)          CGRect             otherFrame;

@property (nonatomic, assign) BOOL               quake; // Yes有抖动效果 默认NO

@end
