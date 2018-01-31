//
//  TLMainLeftEnterResultView.h
//  TuLingApp
//
//  Created by 最印象 on 2017/10/11.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

/*
 * 文字提示图
 */

#import <UIKit/UIKit.h>

@interface TLMainLeftEnterResultView : UIView
/*
 * result : 1 审核未通过 ，2 成功
 **/
-(instancetype)initWithFrame:(CGRect)frame result:(int)result title:(NSString*)title;
@end
