//
//  TLMainLeftResultView.h
//  TuLingApp
//
//  Created by 最印象 on 2017/10/11.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TLMainLeftResultViewEventBlock)(void);

@interface TLMainLeftResultView : UIView

-(instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary*)dic;

-(void)resultEvent:(TLMainLeftResultViewEventBlock)block;
-(void)updateInfomation:(NSDictionary*)dictionary;
@end
