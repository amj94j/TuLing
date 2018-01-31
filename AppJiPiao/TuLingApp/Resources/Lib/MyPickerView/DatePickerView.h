#import <UIKit/UIKit.h>

#define AnimateDuration 0.3
#define PickerHeight    216
#define ToolbarHeight   44

typedef void (^DateSelectBlock)(NSString *dateStr);
typedef void (^DateCancelBlock)(void);

@interface DatePickerView : UIView
{
    UIView *dimView;
    UIView *pickerBgView;
    UIDatePicker *picker;
    DateSelectBlock selectBlock;
    DateCancelBlock cancelBlock;
}

- (id)initWithMode:(UIDatePickerMode)mode date:(NSDate *)curDate maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate showAllBtn:(BOOL)showAll;
- (void)showDatePickerInView:(UIView *)view select:(DateSelectBlock)block cancel:(DateCancelBlock)cancel;

@end
