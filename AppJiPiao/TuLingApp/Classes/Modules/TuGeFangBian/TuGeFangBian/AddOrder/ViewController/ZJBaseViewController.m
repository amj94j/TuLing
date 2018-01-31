//
//  ZJBaseViewController.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/12.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "ZJBaseViewController.h"
#import "BSRelayoutButton.h"

@interface ZJBaseViewController ()
{
    BSRelayoutButton *_leftButton;
    BSRelayoutButton *_additionButton;
    BSRelayoutButton *_rightButton;
    UIView *_rightView;    //右边
    UILabel *_titleLabel;  //中心标题文字label
    UINavigationItem *_item;
}
@end

@implementation ZJBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, NavigationBarHeight)];
    [self.view addSubview:_navigationBar];
    [self setNavBarLeftButtonTarget:self action:@selector(exit)];
    
    _item = [[UINavigationItem alloc] init];
    _navigationBar.items = @[_item];
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    if (IOS7_OR_LATER){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)layoutSubviews
{
    CGFloat origin = BaseY;
    CGFloat height = self.navigationBar.height - origin;
    CGFloat leftButtonMaxWidth = 65.0 / 320 * mainScreenWidth;
    CGFloat rightButtonMaxWidth = leftButtonMaxWidth;
    CGFloat titleViewMaxWidth = 180.0 / 320 * mainScreenWidth;
    
    // 左边按钮
    CGSize leftButtonTextSize = _leftButton.titleLabel.frame.size;
    if (leftButtonTextSize.width > leftButtonMaxWidth) {
        leftButtonTextSize.width = leftButtonMaxWidth;
    }
    
    CGFloat leftButtonWidth = 10.0f  * 2 + 5.0f + _leftButton.imageView.frame.size.width + leftButtonTextSize.width;
    if (leftButtonTextSize.width == 0) {
        leftButtonWidth = 10.0f  * 2 + _leftButton.imageView.frame.size.width;
    }
    _leftButton.frame = CGRectMake(15, origin, leftButtonWidth, height);
    
    // 右边按钮
    CGSize rightButtonTextSize = _rightButton.titleLabel.frame.size;
    if (rightButtonTextSize.width > rightButtonMaxWidth) {
        rightButtonTextSize.width = rightButtonMaxWidth;
    }
    
    if (_rightView)
    {
        _rightView.frame = CGRectMake(self.navigationBar.frame.size.width - 88, origin, 88, 44);
        _additionButton.frame = CGRectMake(0, 0, 44, height);
        _rightButton.frame = CGRectMake(44, 0, 44, height);
    }
    else
    {
        CGFloat rightButtonWidth = 10.0f * 2 + rightButtonTextSize.width + 5.0f + _rightButton.imageView.frame.size.width;
        if (rightButtonTextSize.width == 0) {
            rightButtonWidth = 10.0f  * 2 + _rightButton.imageView.frame.size.width;
        }
        _rightButton.frame = CGRectMake(self.navigationBar.frame.size.width - rightButtonWidth, origin, rightButtonWidth, height);
    }
    
    // title
    if (_titleLabel.text.length > 8) {
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 0.6;
    }
    CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(titleViewMaxWidth, height)];//约束中间标题的尺寸
    _titleLabel.frame = CGRectMake((self.navigationBar.frame.size.width - titleSize.width) / 2, origin + (height - titleSize.height) / 2, titleSize.width, titleSize.height) ;
}
#pragma mark 导航栏左边按钮
- (void)initLeftButton
{
    _leftButton = [[BSRelayoutButton alloc] initWithFrame:CGRectZero];
    [_leftButton setImage:[UIImage imageNamed:@"arrowback"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"arrowback"] forState:UIControlStateHighlighted];
    [_leftButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateHighlighted];
    _leftButton.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:15.0f];
    _leftButton.offset = 5.0f;
//    _leftButton.hidden = YES;
    
    [_navigationBar addSubview:_leftButton];
    
    [self layoutSubviews];
}
#pragma mark 导航栏右边按钮
- (void)initRightButton
{
    CGRect frame = CGRectMake(18.0f, 0.0f, 18.0f, 18.0f);
    _rightButton = [[BSRelayoutButton alloc] initWithFrame:frame];
    [_rightButton setImage:[UIImage imageNamed:@"arrowback"] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"arrowback"] forState:UIControlStateHighlighted];
    [_rightButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateHighlighted];
    _rightButton.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:15.0f];
    _rightButton.offset = 5.0f;
    _rightButton.hidden = YES;
    
    [_navigationBar addSubview:_rightButton];
    
    [self layoutSubviews];
}
#pragma mark 导航栏中心标题的文字
- (void)initTitleLabel
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:15.0f];;
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    
    [_navigationBar addSubview:_titleLabel];
    [self layoutSubviews];
}

#pragma mark 监听导航栏中心标题
- (void)setCenterLabelTarget:(id)target action:(SEL)selector
{
    if (_titleLabel){
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addGestureRecognizer:gesture];
    }
}
- (CGRect)titleLabelFrame
{
    return _titleLabel.frame;
}

- (void)hideLeftButton:(BOOL)hide
{
    if (!_leftButton)
    {
        [self initLeftButton];
    }
    
    _leftButton.hidden = hide;
}

- (void)setNavBarLeftButtonTitle:(NSString *)title
{
    if (!_leftButton)
    {
        [self initLeftButton];
    }
    
    [_leftButton setTitle:title forState:UIControlStateNormal];
    [_leftButton setTitle:title forState:UIControlStateHighlighted];
    if (title.length > 0)
    {
        _leftButton.hidden = NO;
    }
    
    [self layoutSubviews];
}

- (void)setNavBarLeftButtonIcon:(UIImage *)image
{
    if (!_leftButton)
    {
        [self initLeftButton];
    }
    
    _leftButton.hidden = NO;
    [_leftButton setImage:image forState:UIControlStateNormal];
    [_leftButton setImage:image forState:UIControlStateHighlighted];
}

- (void)setNavBarLeftButtonTarget:(id)target action:(SEL)selector
{
    if (!_leftButton)
    {
        [self initLeftButton];
    }
    
    [_leftButton removeTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [_leftButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNavBarCenterTitle:(NSString *)title
{
    if (!_titleLabel)
    {
        [self initTitleLabel];
    }
    
    _titleLabel.text = title;
    
    [self layoutSubviews];
}

- (void)setCenterTitleFont:(UIFont *)font
{
    if (!_titleLabel)
    {
        [self initTitleLabel];
    }
    
    _titleLabel.font = font;
    
    [self layoutSubviews];
}

- (NSString *)centerTitle
{
    return _titleLabel.text;
}

- (void)setCenterTextColor:(UIColor *)color
{
    _titleLabel.textColor = color;
}

- (void)setNavBarRightButtonTitle:(NSString *)title
{
    if (!_rightButton)
    {
        [self initRightButton];
    }
    
    [_rightButton setTitle:title forState:UIControlStateNormal];
    [_rightButton setTitle:title forState:UIControlStateHighlighted];
    
    [self layoutSubviews];
}

- (void)setNavBarRightButtonTarget:(id)target action:(SEL)selector
{
    if (!_rightButton)
    {
        [self initRightButton];
    }
    
    [_rightButton removeTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [_rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNavBarRightButtonIcon:(UIImage *)icon
{
    if (!_rightButton)
    {
        [self initRightButton];
    }
    
    [_rightButton setImage:icon forState:UIControlStateNormal];
    [_rightButton setImage:icon forState:UIControlStateHighlighted];
}

- (void)enableNavBarRightButton:(BOOL)fEnable
{
    _rightButton.userInteractionEnabled = fEnable;
}

- (void)enableNavBarLeftButton:(BOOL)fEnable
{
    _leftButton.userInteractionEnabled = fEnable;
}

- (void)hideRightButton:(BOOL)hide
{
    _rightButton.hidden = hide;
}

@end
