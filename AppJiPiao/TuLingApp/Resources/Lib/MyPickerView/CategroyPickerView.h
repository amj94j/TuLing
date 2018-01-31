//
//  CategroyPickerView.h
//  TuLingApp
//
//  Created by hua on 17/4/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

/* {
 *  name
 *  id
 * }
 */
typedef void (^MyPickerSelectBlock)(NSDictionary*dic);

@interface CategroyPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    int selectIndex;
    
    
    
    
    UIView *dimView;
    //picker背景View
    UIView *pickerBgView;
    //滑轮
    UIPickerView *picker;

}
@property(nonatomic,assign) NSInteger proIndex;
//确认回调
@property (nonatomic,copy) MyPickerSelectBlock selectBlock;

//数据源
@property (nonatomic,strong) NSArray *pickerArr;

- (id)initWithTitle:(NSString *)title array:(NSArray *)array andCurIndex:(NSInteger)curIndex;
-(void)selectBlock:(MyPickerSelectBlock)block;
- (void)showInView:(UIView *)view;
@end
