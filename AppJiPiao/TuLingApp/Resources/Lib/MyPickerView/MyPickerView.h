#import <UIKit/UIKit.h>

typedef void (^MyPickerSelectBlock)(int selectIndex);
typedef void (^MyPickerCancelBlock)(void);

@interface MyPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
{
    int selectIndex;
    NSArray *pickerArr;
    
    UIView *dimView;
    UIView *pickerBgView;
    UIPickerView *picker;
    MyPickerSelectBlock selectBlock;
    MyPickerCancelBlock cancelBlock;
}

- (id)initWithTitle:(NSString *)title array:(NSArray *)array andCurIndex:(NSInteger)curIndex;
- (void)showInView:(UIView *)view selectBlock:(MyPickerSelectBlock)block cancel:(MyPickerCancelBlock)cancelB;

@end
