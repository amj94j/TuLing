#import "MyPickerView.h"

#define AnimateDuration 0.3
#define PickerHeight    216
#define ToolbarHeight   44

@implementation MyPickerView

- (id)initWithTitle:(NSString *)title array:(NSArray *)array andCurIndex:(NSInteger)curIndex
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        pickerArr = [NSArray arrayWithArray:array];
        
        dimView = [[UIView alloc] initWithFrame:self.bounds];
        [dimView setBackgroundColor:[UIColor blackColor]];
        dimView.alpha = 0;
        [self addSubview:dimView];
        
        pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, PickerHeight+ToolbarHeight)];
        [pickerBgView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:pickerBgView];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pickerBgView.frame.size.width, ToolbarHeight)];
        //[toolbar setBackgroundColor:[UIColor redColor]];
        [toolbar setTranslucent:YES];
        [toolbar setBarStyle:UIBarStyleDefault];
        
        //取消/确定
        
        UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(hideView)];
        UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(onDone)];
        UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        itemCancel.tintColor = [UIColor grayColor];
        itemDone.tintColor = [UIColor grayColor];
        
        //TitleView：label或者button
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:16]];
        titleLabel.minimumScaleFactor = 0.8;
        [titleLabel setText:title];
        [titleLabel setTextColor:[UIColor lightGrayColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        
        UIButton *btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAll setFrame:CGRectMake(0, 0, 70, 30)];
        [btnAll setBackgroundImage:[UIImage imageNamed:@"bg_blue"] forState:UIControlStateNormal];
        [StaticTools setRoundView:btnAll radius:2 borderWidth:1 color:[UIColor whiteColor]];
        [btnAll setTitle:@"全部" forState:UIControlStateNormal];
        [btnAll addTarget:self action:@selector(selectBtnAll:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *itemTitle;
        if ([title isEqualToString:@"请选择分行"]) {//单独判断吧，是否显示“全部”按钮
            itemTitle = [[UIBarButtonItem alloc] initWithCustomView:btnAll];
        }
        else {
            itemTitle = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
        }
        
        
        [toolbar setItems:[NSArray arrayWithObjects:itemCancel,itemSpace,itemTitle,itemSpace,itemDone, nil]];
        [pickerBgView addSubview:toolbar];
        
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ToolbarHeight, pickerBgView.frame.size.width, PickerHeight)];
        [picker setBackgroundColor:[UIColor whiteColor]];
        picker.dataSource = self;
        picker.delegate = self;
        picker.showsSelectionIndicator = YES;
        [picker reloadAllComponents];
        if (curIndex > pickerArr.count-1) {
            curIndex = 0;
        }
        [picker selectRow:curIndex inComponent:0 animated:NO];
        [pickerBgView addSubview:picker];
    }
    return self;
}

#pragma mark - show
- (void)showInView:(UIView *)view selectBlock:(MyPickerSelectBlock)block cancel:(MyPickerCancelBlock)cancelB
{
    [self setFrame:view.bounds];
    [view addSubview:self];
    [UIView animateWithDuration:AnimateDuration animations:^{
        [dimView setAlpha:0.4];
        [pickerBgView setFrame:CGRectMake(0, self.frame.size.height-pickerBgView.frame.size.height, self.frame.size.width, pickerBgView.frame.size.height)];
    } completion:^(BOOL finished) {
    }];
    selectBlock = block;
    cancelBlock = cancelB;
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
    if (!pickerArr.count) {
        return;
    }
    if (selectBlock) {
        selectBlock(selectIndex);
    }
}

- (void)selectBtnAll:(id)sender
{
    [self hideView];
    if (selectBlock) {
        selectBlock(-1);
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

#pragma mark - Picker DataSource/Delegat
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArr objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectIndex = (int)row;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
