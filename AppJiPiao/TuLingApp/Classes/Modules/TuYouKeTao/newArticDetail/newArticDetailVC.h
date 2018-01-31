//
//  newArticDetailVC.h
//  TuLingApp
//
//  Created by hua on 17/5/3.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newArticDetailVC : UIViewController
@property(nonatomic,strong)NSString *productId;

/**
 商品是否失效判断 0代表代表不失效，1代表失效，为空代表不失效（非必填）
 */
@property(nonatomic,strong)NSString *invalidProduct;



@end
