#import "Input_user_setting.h"

@implementation Input_user_setting

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;
        UIView * view = [[UIView alloc]init];
        self.backgroundColor = [UIColor whiteColor];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, WIDTH*0.03, 1);
        self.rightView = view;
        self.rightViewMode = UITextFieldViewModeAlways;
        self.returnKeyType = UIReturnKeyDone;
        self.textAlignment = NSTextAlignmentRight;
        
        
    }
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if(hidden == NO)
    {
        [self becomeFirstResponder];
    }

}
- (void)drawTextInRect:(CGRect)rect
{
    rect.origin.y +=5;
    [super drawTextInRect:rect];

}
@end
