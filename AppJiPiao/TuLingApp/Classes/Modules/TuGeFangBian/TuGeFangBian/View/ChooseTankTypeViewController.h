//
//  ChooseTankTypeViewController.h
//  TuLingApp
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChooseTankTypeViewControllerBlock)(NSString *type, NSInteger typeID);
@interface ChooseTankTypeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *jingjiImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (nonatomic, copy) ChooseTankTypeViewControllerBlock block;
@property (nonatomic, copy) NSString *positionType;
@end
