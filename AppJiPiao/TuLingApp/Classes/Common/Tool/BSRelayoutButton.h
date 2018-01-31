//
//  BSRelayoutButton.h
//  MusicSample
//
//  Created by LonlyCat on 2016/12/21.
//  Copyright © 2016年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BSRelayoutButtonAlignment) {
    
    BSRelayoutButtonAlignmentNormal = 0,        // 系统默认
    BSRelayoutButtonAlignmentImageRight = 1,    // 图片在右侧
    BSRelayoutButtonAlignmentImageTop = 2       // 图片在上侧
};

@interface BSRelayoutButton : UIButton

/**
 image 与 title 的间距
 */
@property (assign, nonatomic) CGFloat  offset;

/**
 image 与 title 的对齐方式
 */
@property (assign, nonatomic) BSRelayoutButtonAlignment  type;

@end
