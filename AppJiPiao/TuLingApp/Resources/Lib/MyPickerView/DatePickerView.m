#import "DatePickerView.h"

@implementation DatePickerView

- (id)initWithMode:(UIDatePickerMode)mode date:(NSDate *)curDate maxDate:(NSDate *)maxDate minDate:(NSDate *)minDate showAllBtn:(BOOL)showAll
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        //半透明黑色背景
        dimView = [[UIView alloc] initWithFrame:self.bounds];
        [dimView setBackgroundColor:[UIColor blackColor]];
        dimView.alpha = 0;
        [self addSubview:dimView];
        
        //Picker背景view
        pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, PickerHeight+ToolbarHeight)];
        [pickerBgView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:pickerBgView];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pickerBgView.frame.size.width, ToolbarHeight)];
        [toolbar setBackgroundColor:[UIColor clearColor]];
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        
        //ToolBar导航条
        //取消/确定
        UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(hideView)];
        UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(onDone)];
        UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        //全部
        UIButton *btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAll setFrame:CGRectMake(0, 0, 70, 30)];
        [btnAll setBackgroundImage:[UIImage imageNamed:@"bg_blue"] forState:UIControlStateNormal];
        [StaticTools setRoundView:btnAll radius:2 borderWidth:1 color:[UIColor whiteColor]];
        [btnAll setTitle:@"全部" forState:UIControlStateNormal];
        [btnAll addTarget:self action:@selector(selectBtnAll:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *itemTitle = [[UIBarButtonItem alloc] initWithCustomView:btnAll];
        if (showAll) {
            btnAll.hidden = NO;
        }
        else {
            btnAll.hidden = YES;
        }
        [toolbar setItems:[NSArray arrayWithObjects:itemCancel,itemSpace,itemTitle,itemSpace,itemDone, nil]];
        [pickerBgView addSubview:toolbar];
        
        //DatePicker
        picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, ToolbarHeight, pickerBgView.frame.size.width, PickerHeight)];
        [picker setBackgroundColor:[UIColor whiteColor]];
        [picker setDatePickerMode:mode];
        if (minDate) {
            [picker setMinimumDate:minDate];
        }
        if (maxDate) {
            [picker setMaximumDate:maxDate];
        }
        if (curDate) {
            [picker setDate:curDate];
        }
        else {
            [picker setDate:[NSDate date]];
        }
        [pickerBgView addSubview:picker];
    }
    return self;
}

#pragma mark - show
- (void)showDatePickerInView:(UIView *)view select:(DateSelectBlock)block cancel:(DateCancelBlock)cancel
{
    [self setFrame:view.bounds];
    [view addSubview:self];
    [UIView animateWithDuration:AnimateDuration animations:^{
        [dimView setAlpha:0.4];
        [pickerBgView setFrame:CGRectMake(0, self.frame.size.height-pickerBgView.frame.size.height, self.frame.size.width, pickerBgView.frame.size.height)];
    } completion:^(BOOL finished) {
    }];
    
    selectBlock = block;
    cancelBlock = cancel;
}

#pragma mark - hide
- (void)hideView
{
    [UIView animateWithDuration:AnimateDuration animations:^{
        [dimView setAlpha:0];
        [pickerBgView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, pickerBgView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (cancelBlock) {
            cancelBlock ();
        }
        [self removeFromSuperview];
    }];
}

- (void)onDone
{
    [self hideView];
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (picker.datePickerMode == UIDatePickerModeTime) {
        [df setDateFormat:@"HH:mm"];
    }
    else if (picker.datePickerMode == UIDatePickerModeDateAndTime) {
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else {
        [df setDateFormat:@"yyyy-MM-dd"];
    }
    NSString *string = [df stringFromDate:picker.date];
    if (selectBlock) {
        selectBlock(string);
    }
}

- (void)selectBtnAll:(id)sender
{
    [self hideView];
    if (selectBlock) {
        selectBlock(@"");
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(pickerBgView.frame, point)) {
        [self hideView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
