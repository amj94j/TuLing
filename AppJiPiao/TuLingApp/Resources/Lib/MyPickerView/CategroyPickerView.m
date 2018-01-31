//
//  CategroyPickerView.m
//  TuLingApp
//
//  Created by hua on 17/4/14.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "CategroyPickerView.h"

#define AnimateDuration 0.3
#define PickerHeight    216
#define ToolbarHeight   44

@interface CategroyPickerView ()
@property (nonatomic,strong) NSMutableDictionary * dicData;

@end

@implementation CategroyPickerView

- (id)initWithTitle:(NSString *)title array:(NSArray *)array andCurIndex:(NSInteger)curIndex
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        _proIndex=0;
         self.pickerArr = array;
        _dicData = [NSMutableDictionary dictionary];
        dimView = [[UIView alloc] initWithFrame:self.bounds];
        [dimView setBackgroundColor:[UIColor blackColor]];
        dimView.alpha = 0;
        [self addSubview:dimView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [dimView addGestureRecognizer:tap];
        
        //滑轮内容view
        pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, PickerHeight+ToolbarHeight)];
        [pickerBgView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:pickerBgView];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pickerBgView.frame.size.width, ToolbarHeight)];
        //[toolbar setBackgroundColor:[UIColor redColor]];
        [toolbar setTranslucent:YES];
        [toolbar setBarStyle:UIBarStyleDefault];
        
        UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(hideView)];
        UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(onDone)];
        UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        itemCancel.tintColor = [UIColor grayColor];
        itemDone.tintColor = [UIColor grayColor];
        
        
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
        
        
        [_dicData setValue:_pickerArr[0][@"name"] forKey:@"name"];
        
        [_dicData setValue:_pickerArr[0][@"id"] forKey:@"id"];
        
        NSArray * arr = _pickerArr[0][@"categories"];
        if (arr.count > 0){
            NSDictionary * dicA = arr[0];
            [_dicData setValue:dicA[@"name"] forKey:@"name"];
            [_dicData setValue:dicA[@"id"] forKey:@"id"];
        }
    
        //滑轮创建
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ToolbarHeight, pickerBgView.frame.size.width, PickerHeight)];
        [picker setBackgroundColor:[UIColor whiteColor]];
        picker.dataSource = self;
        picker.delegate = self;
        picker.showsSelectionIndicator = YES;
        [picker reloadAllComponents];
        if (curIndex > _pickerArr.count-1) {
            curIndex = 0;
        }
        [picker selectRow:curIndex inComponent:0 animated:NO];
        [pickerBgView addSubview:picker];
        
        
    }
    return self;
}
#pragma mark - show
- (void)showInView:(UIView *)view
{
   
    [self setFrame:view.bounds];
    [view addSubview:self];
    [UIView animateWithDuration:AnimateDuration animations:^{
        [dimView setAlpha:0.4];
        [pickerBgView setFrame:CGRectMake(0, self.frame.size.height-pickerBgView.frame.size.height, self.frame.size.width, pickerBgView.frame.size.height)];
    } completion:^(BOOL finished) {
    }];
    
}

-(void)selectBlock:(MyPickerSelectBlock)block{

    self.selectBlock = block;
}

#pragma mark - hide
- (void)hideView
{
    [UIView animateWithDuration:AnimateDuration animations:^{
        [dimView setAlpha:0];
        [pickerBgView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, pickerBgView.frame.size.height)];
    } completion:^(BOOL finished) {
  
        [self removeFromSuperview];
    }];
}

-(void)dealloc{
    _selectBlock = nil;
}

- (void)onDone
{
    
    [self hideView];
    if (!_pickerArr.count) {
        return;
    }
    if (_selectBlock) {
        self.selectBlock(_dicData);
    }
}

- (void)selectBtnAll:(id)sender
{
    [self hideView];
    if (_selectBlock) {
    
    }
}


#pragma mark - Picker DataSource/Delegat
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return _pickerArr.count;
    }
    
   
    NSArray *arr= _pickerArr[_proIndex][@"categories"];
    
    return arr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * string = nil;
    //判断当前是第几列
    if (component == 0) {
        string = _pickerArr[row][@"name"];

        return string;
    }else{
        string = _pickerArr[_proIndex][@"categories"][row][@"name"];
      
        return string;
    }
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
if (component == 0) {
    
    [_dicData setValue:_pickerArr[row][@"name"] forKey:@"name"];
   
    [_dicData setValue:_pickerArr[row][@"id"] forKey:@"id"];
    _proIndex = row;
//    _proIndex = [pickerView selectedRowInComponent:0];
    [pickerView reloadComponent:1];
    return;
}

    if (_pickerArr[_proIndex][@"categories"][row][@"name"]){
        [_dicData setValue:_pickerArr[_proIndex][@"categories"][row][@"name"] forKey:@"name"];
    }
    
    
    if (_pickerArr[_proIndex][@"categories"][row][@"id"]){
        [_dicData setValue:_pickerArr[_proIndex][@"categories"][row][@"id"] forKey:@"id"];
    }
//   NSString *cityName = pickerArr[_proIndex][@"categories"][row][@"name"];
//    selectIndex = (int)row;

}

@end
