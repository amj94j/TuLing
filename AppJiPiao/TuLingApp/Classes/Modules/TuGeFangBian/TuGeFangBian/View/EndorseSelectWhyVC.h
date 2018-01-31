//
//  EndorseSelectWhyVC.h
//  TuLingApp
//
//  Created by apple on 2017/12/23.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndorseSelectWhyVC : UIViewController
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) void (^endorseSelectWhy)(NSDictionary *dic);
@property (nonatomic, copy) NSDictionary *selectedReasonResult;
@end
