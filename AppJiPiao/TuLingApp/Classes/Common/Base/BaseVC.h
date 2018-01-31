//
//  BaseVC.h
//  TuLingApp
//
//  Created by 韩宝国 on 2017/3/9.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "BaseViewController.h"
#import "HzTools.h"
#import "AppDelegate.h"

@interface BaseVC : BaseViewController <UIGestureRecognizerDelegate>
/*
 * viewController 返回上一级页面
 */
-(void)exit;


/*
 *  
 */
-(NSString*)accountUUID;

/**
 *  返回按钮的点击事件（可重写）
 */
- (void) onBackBarBtnClick;



/*
 *  return {
   -1 : 传入数据可能错误，外界自己再判断
    0 : 请求数据正确
  100 : 后台处理错误，前端提示 "网络出错"
  其他 : 后台出错，直接抛出 传入参数的 message
 
 }
 
 */
-(int)requetsResutlCode:(NSDictionary *)responseDic;

/*
 * 用于网络请求错误提示，如果 messageString 为空，提示网络出错啦
 */
-(void)showProgressError:(NSString*)messageString;

/*
 * 提示文字
 */
-(void)showProgress:(NSString*)messageString;
/*
 * 调整 UIViewController 顶部布局
 **/
-(void)viewAdjustment;
/*
 * 调整 UIScrollView 类顶部高度定位
 **/
-(void)viewAdjustmentTop:(UIScrollView*)sView;
@end
