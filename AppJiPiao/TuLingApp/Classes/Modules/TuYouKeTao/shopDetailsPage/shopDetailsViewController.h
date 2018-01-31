//
//  shopDetailsViewController.h
//  TuLingApp
//
//  Created by hua on 16/11/8.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shopDetailsViewController : UIViewController
@property(nonatomic,strong)NSString *productID;


/**
 商品是否失效判断 0代表代表不失效，1代表失效，为空代表不失效（非必填）
 */
@property(nonatomic,strong)NSString *invalidProduct;
@end
