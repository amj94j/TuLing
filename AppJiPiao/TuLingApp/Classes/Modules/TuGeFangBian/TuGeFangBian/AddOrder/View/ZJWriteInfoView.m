//
//  ZJWriteInfoView.m
//  TuLingApp
//
//  Created by Abnerzj on 2017/12/14.
//  Copyright © 2017年 Abnerzj. All rights reserved.
//

#import "ZJWriteInfoView.h"
#import "ZJPickerView.h"
#import "NameSuggestsViewController.h"

@interface ZJWriteInfoView ()<UITextFieldDelegate>
{
    ZJWriteInfoViewActionType _actionType;
    id _data;
    void(^_actionCallBack)(BOOL isSelectAction);
    CGFloat _detal;
    NSString *_selectContent;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *tipBtn;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UILabel *actionTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) ZJPickerView *pickerView;

@end

@implementation ZJWriteInfoView

- (ZJPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [ZJPickerView zj_PickerView];
        _pickerView.dataList = ((ZJWriteInfoViewSelectModel *)_data).dataList;
    }
    return _pickerView;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    
    self.textField.keyboardType = keyboardType;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    self.textField.text = text;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (instancetype)zj_WriteInfoView
{
    ZJWriteInfoView *writeInfoView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    writeInfoView.frame = CGRectMake(0, 0, mainScreenWidth, writeInfoView.frame.size.height);
    return writeInfoView;
}

// 更新信息视图
- (void)zj_updateInfoWithName:(NSString *)name
                      tipType:(ZJWriteInfoViewTipType)tipType
                   actionType:(ZJWriteInfoViewActionType)actionType
                         data:(id)data
               actionCallBack:(void(^)(BOOL isSelectAction))actionCallBack;
{
    _actionType = actionType;
    _data = data;
    if (actionCallBack) _actionCallBack = actionCallBack;
    
    // 名称
    self.nameLabel.text = name;
    
    // 提示类型
    self.tipBtn.hidden = (tipType == ZJWriteInfoViewTipTypeNot);
    if (tipType == ZJWriteInfoViewTipTypeInfo) {
        [self.tipBtn setImage:[UIImage imageNamed:@"addOrder_icon_tip"] forState:UIControlStateNormal];
        [self.tipBtn setImage:[UIImage imageNamed:@"addOrder_icon_tip"] forState:UIControlStateNormal];
    } else if (tipType == ZJWriteInfoViewTipTypeHelp) {
        [self.tipBtn setImage:[UIImage imageNamed:@"addOrder_icon_help"] forState:UIControlStateNormal];
        [self.tipBtn setImage:[UIImage imageNamed:@"addOrder_icon_help"] forState:UIControlStateNormal];
    }
    
    // 操作方式
    self.actionView.hidden = (actionType == ZJWriteInfoViewActionTypeWrite);
    self.textField.hidden = (actionType == ZJWriteInfoViewActionTypeSelect);
    if (actionType == ZJWriteInfoViewActionTypeWrite) {
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:data attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#919191"], NSFontAttributeName : [UIFont systemFontOfSize:15.0f]}];
        
        // 监听键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShowHide:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShowHide:) name:UIKeyboardWillHideNotification object:nil];
    } else {
        self.actionTitleLabel.text = ((ZJWriteInfoViewSelectModel *)_data).title;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_actionType == ZJWriteInfoViewActionTypeWrite) {
        if (_actionCallBack) {
            _actionCallBack(YES);
        }
    }
}

- (void)keyBoardShowHide:(NSNotification *)notification
{
    NSString *name = [notification name];
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect rect = [[[[UIApplication sharedApplication] delegate] window] convertRect:self.frame fromView:self.superview];
    
    //键盘将要显示
    if ([name isEqualToString:UIKeyboardWillShowNotification]){
        
        // 判断是否在键盘下面，往上移
        _detal = CGRectGetMaxY(rect) - keyboardFrame.origin.y;
        if (_detal > 0.0) {
            if ([self.superview isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scrollView = (UIScrollView *)self.superview;
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + _detal);
            } else {
                CGRect superViewFrame = self.superview.frame;
                superViewFrame.origin.y -= _detal;
                superViewFrame.size.height += _detal;
                self.superview.frame = superViewFrame;
            }
        }
        //键盘将要隐藏
    } else if ([name isEqualToString:UIKeyboardWillHideNotification]){
        if (_detal > 0.0) {
            if ([self.superview isKindOfClass:[UIScrollView class]]) {
                UIScrollView *scrollView = (UIScrollView *)self.superview;
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - _detal);
            } else {
                CGRect superViewFrame = self.superview.frame;
                superViewFrame.origin.y += _detal;
                superViewFrame.size.height -= _detal;
                self.superview.frame = superViewFrame;
            }
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 获取填写或选择的内容
- (NSString *)zj_getWriteContent
{
    if (_actionType == ZJWriteInfoViewActionTypeWrite) {
        return self.textField.text;
    } else {
        return _selectContent;
    }
}

// 输入类型时，判断获取的内容是否为空
- (BOOL)zj_contentIsNotNilAndValid
{
    if (_actionType == ZJWriteInfoViewActionTypeWrite) {
        return self.textField.text.length && ![self.textField.text isEqualToString:@""];
    } else if (_actionType == ZJWriteInfoViewActionTypeSelect) {
        return _selectContent.length && ![_selectContent isEqualToString:@""];
    }
    return NO;
}

#pragma mark 选择操作
- (IBAction)selectAction:(id)sender
{
    UIButton *btn = sender;
    
    // 用于通知用户点击了选择
    if (_actionCallBack) {
        _actionCallBack(btn.tag == 1);
    }
    
    if (btn.tag == 1) { // 选择弹框
        WS(ws)
        [self.pickerView show:^(NSString *selectContent) {
            _selectContent = selectContent;
            
            // 去除下划线和空字符串和市辖区字符
            ws.actionTitleLabel.text = [[[selectContent stringByReplacingOccurrencesOfString:@"/" withString:@""] stringByReplacingOccurrencesOfString:@"市辖区" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
        }];
    } else { // 提示、帮助弹框
        NameSuggestsViewController *vc = [[NameSuggestsViewController alloc] init];
        vc.modalPresentationStyle = 4;
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
        
    }
}

@end


@implementation ZJWriteInfoViewSelectModel

+ (instancetype)initWithTitle:(NSString *)title dataList:(NSArray *)dataList
{
    ZJWriteInfoViewSelectModel *model = [[ZJWriteInfoViewSelectModel alloc] init];
    model.title = title;
    model.dataList = dataList;
    return model;
}

@end

