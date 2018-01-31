//
//  TLBaseShareView.h
//  TuLingApp
//
//  Created by 李立达 on 2017/8/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLBaseShareView : UIView
@property(nonatomic,strong)  NSString *title;
@property(nonatomic,strong)  NSString *content;
@property(nonatomic,copy  )  NSString *urlString;
@property(nonatomic,strong)  NSString *titleImage;
@property(nonatomic,strong)  UIView   *allShareView;


@property(nonatomic,copy) NSString *msgString;

@property(nonatomic,strong)UILabel *contentLabel;

@property(nonatomic,strong)UILabel *titleLable;

- (void)appear;
- (void)disappear;
@end
