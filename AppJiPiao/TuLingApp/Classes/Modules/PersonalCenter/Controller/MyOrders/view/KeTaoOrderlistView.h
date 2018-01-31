//
//  KeTaoOrderlistView.h
//  TuLingApp
//
//  Created by 李立达 on 2017/8/25.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeTaoOrderlistView : UIView
- (void) requestGetData;
@property (nonatomic, assign) NSInteger currentPage;
@end
