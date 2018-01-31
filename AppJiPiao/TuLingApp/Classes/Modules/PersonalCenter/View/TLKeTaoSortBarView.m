//
//  TLKeTaoSortBarView.m
//  TuLingApp
//
//  Created by gyc on 2017/7/13.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLKeTaoSortBarView.h"
#import "UIButton+LXMImagePosition.h"
#import "NSString+StrCGSize.h"
#define kBarHeight 44
#define kMarkViewHeight 1.5
@interface TLKeTaoSortBarView (){
    int _selectIndex;//当前选中的下标
    float _buttonWidth;
}
@property (nonatomic,copy) KeTaoSortBarSelectBlock selectBlock;//选中后的block

@property (nonatomic,strong) NSArray * titlesArray;//外界提供的内容
@property (nonatomic,strong) NSMutableArray * buttonArray;//创建的button

@property (nonatomic,strong) UIView * bottomMarkView;//下部的选中条
@end

@implementation TLKeTaoSortBarView

-(instancetype)initWithTitles:(NSArray *)array{

    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, kBarHeight)];
    if (self){
        
        _selectTextColor = [UIColor colorWithHexString:@"#017E44"];
        _defaultTextColor = [UIColor colorWithHexString:@"#919191"];
        
        _textFont = TLFont_Semibold_Size(16, 1);
        
        _barViewBackgroundColor = [UIColor whiteColor];
    
        _bottomMarkViewColor = [UIColor colorWithHexString:@"#017E44"];
        
        self.buttonArray = [NSMutableArray array];
        self.titlesArray =  [NSArray arrayWithArray:array];
        _selectIndex = 0;
        [self barViewUISet];
    }
    return self;
}


-(CGFloat)stringWidth:(NSString*)string{
    
    if ([NSString isBlankString:string] ){
        
        UIFont * font = nil;
        if (self.textFont){
            font = self.textFont;
        }else{
            font = TLFont_Semibold_Size(16, 1);
            self.textFont = font;
        }
        if (font){
            NSDictionary *attributes = @{NSFontAttributeName:font};
            //最新自动计算宽度方法
            CGSize textSize = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height) options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size;
            CGFloat width = ceil(textSize.width) + 20;
            
            if (width <= _buttonWidth - 20){
                return width;
            }else{
                return _buttonWidth - 20;
            }
            
        }
        
    }
    
    return _buttonWidth - 20;
}

-(void)setBarViewBackgroundColor:(UIColor *)barViewBackgroundColor{
    if (_barViewBackgroundColor == barViewBackgroundColor){
        return;
    }
    _barViewBackgroundColor = barViewBackgroundColor;
   
}

-(void)setBottomMarkViewColor:(UIColor *)bottomMarkViewColor{
    if (_bottomMarkViewColor == bottomMarkViewColor){
        return;
    }
    _bottomMarkViewColor = bottomMarkViewColor;
    self.bottomMarkView.backgroundColor = _bottomMarkViewColor;
}


-(void)setSelectTextColor:(UIColor *)selectTextColor{
    if (_selectTextColor == selectTextColor){
        return;
    }
    _selectTextColor = selectTextColor;
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        [button setTitleColor:_selectTextColor forState:UIControlStateSelected];
    }];
}

-(void)setDefaultTextColor:(UIColor *)defaultTextColor{
    if (_defaultTextColor == defaultTextColor){
        return;
    }
    
    _defaultTextColor = defaultTextColor;
}

-(void)setTextFont:(UIFont *)textFont{
    if (_textFont == textFont){
        return;
    }
    _textFont = textFont;
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        button.titleLabel.font = textFont;
    }];
}

-(void)barViewUISet{
    self.backgroundColor = self.barViewBackgroundColor;
    [self buttonsSet];
}

- (void)buttonsSet{
    //1.按钮的个数
    NSInteger seugemtNumber = self.titlesArray.count;
    
    //2,按钮的宽度
    _buttonWidth = ceilf((self.bounds.size.width) / seugemtNumber);
    
    //3.创建按钮
    for (int i=0; i<self.titlesArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*_buttonWidth, 0, _buttonWidth, self.bounds.size.height);
        TLKeTaoSortModel * model = self.titlesArray[i];
       [btn setTitle:model.name forState:UIControlStateNormal];
        [btn.titleLabel setFont:self.textFont];
  
        
        [btn setTitleColor:self.defaultTextColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectTextColor forState:UIControlStateSelected];
        btn.tag =i + 100;
        [btn addTarget:self action:@selector(changeSegumentAction:) forControlEvents:UIControlEventTouchUpInside];
        if (model.isNeedSort) {
            //需要排序的
            if (model.isUp){
                [btn setImage:[UIImage imageNamed:@"TLSort_normalUpIcon"] forState:UIControlStateNormal];//给button添加image
                [btn setImage:[UIImage imageNamed:@"TLSort_selectUpIcon"] forState:UIControlStateSelected];//给button添加image
            }else{
                [btn setImage:[UIImage imageNamed:@"TLSort_normalDownIcon"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"TLSort_selectDownIcon"] forState:UIControlStateSelected];
            }
            
            
            [btn setImagePosition:LXMImagePositionRight spacing:2];
        }else if (model.isNeedChoose){
            //需要展开的
            [btn setImage:[UIImage imageNamed:@"TLKeTao_screenNormal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"TLKeTao_screenSelect"] forState:UIControlStateSelected];
            

            [btn setImagePosition:LXMImagePositionRight spacing:2];
        }else{
        //普通文字的

        }
        [self addSubview:btn];
        if (i==0) {
            
            CGFloat width =  [self stringWidth:model.name];
            self.bottomMarkView =[[UIView alloc]initWithFrame:CGRectMake((_buttonWidth - width) / 2.0, self.bounds.size.height- kMarkViewHeight - 0.5, width, kMarkViewHeight)];
            [self.bottomMarkView setBackgroundColor:self.bottomMarkViewColor];
            [self addSubview:self.bottomMarkView];
        }
        
        UIView * bottomLineView  =[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
        bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#C6C6C6"];
        [self addSubview:bottomLineView];
        [self.buttonArray addObject:btn];
    }
    
    TLKeTaoSortModel * firstModel = _titlesArray.firstObject;
    firstModel.isSelected = YES;
    [[self.buttonArray firstObject] setSelected:YES];
    
}

-(void)changeSegumentAction:(UIButton *)btn
{
    [self selectTheSegument:(int)btn.tag - 100];
}

-(void)selectTheSegument:(int)segument event:(BOOL)isEvent{
    if (_selectIndex != segument) {
        TLKeTaoSortModel * modelOld = self.titlesArray[_selectIndex];
        modelOld.isSelected = NO;
        [self.buttonArray[_selectIndex] setSelected:NO];
        
        TLKeTaoSortModel * modelNew = self.titlesArray[segument];
        modelNew.isSelected = YES;
        
        [self.buttonArray[segument] setSelected:YES];
        CGFloat width = [self stringWidth:modelNew.name];
        MJWeakSelf;
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf.bottomMarkView setFrame:CGRectMake(segument*_buttonWidth+ (_buttonWidth - width) / 2.0, weakSelf.bounds.size.height- kMarkViewHeight - 0.5, width, kMarkViewHeight)];
        }];
        _selectIndex = segument;
        
    }else{
        TLKeTaoSortModel * model = self.titlesArray[_selectIndex];
        model.isSelected = YES;
        UIButton * button =  _buttonArray[_selectIndex];
        if (model.isNeedSort){
            //选中的是需要排序的
            if (model.isUp){
                //现在是升序
                [button setImage:[UIImage imageNamed:@"TLSort_normalDownIcon"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"TLSort_selectDownIcon"] forState:UIControlStateSelected];
            }else{
                //现在是降序
                [button setImage:[UIImage imageNamed:@"TLSort_normalUpIcon"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"TLSort_selectUpIcon"] forState:UIControlStateSelected];
            }
            
            model.isUp = !model.isUp;
            
        }else if (model.isNeedChoose){
            //选中的是需要展示分类的
            
            //            button.selected
//            [button setSelected:YES];
        }
        //
        
    }
    
    if (isEvent){
        TLKeTaoSortModel * model = _titlesArray[segument];
        if (self.selectBlock){
            self.selectBlock(segument, model.isNeedSort, model.isUp, model);
        }
    }

}

-(void)selectTheSegument:(int)segument{
    [self selectTheSegument:segument event:YES];
}


-(void)titleChangeText:(NSString*)string index:(int)index{
    
    if (![NSString isBlankString:string]){
        return;
    }
    
    if (index < self.titlesArray.count){
    
        TLKeTaoSortModel * model = self.titlesArray[index];
        model.name = string;
        UIButton * btn = _buttonArray[index];
        [btn setTitle:string forState:UIControlStateNormal];
        
        CGFloat width = [self stringWidth:string];
        [_bottomMarkView setFrame:CGRectMake(index*_buttonWidth + (_buttonWidth - width) / 2.0, self.bounds.size.height- kMarkViewHeight - 0.5, width, kMarkViewHeight)];
        
        if (model.isNeedSort) {
            //需要排序的
            if (model.isUp){
                [btn setImage:[UIImage imageNamed:@"TLSort_normalUpIcon"] forState:UIControlStateNormal];//给button添加image
                [btn setImage:[UIImage imageNamed:@"TLSort_selectUpIcon"] forState:UIControlStateSelected];//给button添加image
            }else{
                [btn setImage:[UIImage imageNamed:@"TLSort_normalDownIcon"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"TLSort_selectDownIcon"] forState:UIControlStateSelected];
            }
            
           [btn setImagePosition:LXMImagePositionRight spacing:2];
            
        }else if (model.isNeedChoose){
            //需要展开的
            [btn setImage:[UIImage imageNamed:@"TLChoose_arrowDownSelectIcon"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"TLChoose_arrowDownNormalIcon"] forState:UIControlStateNormal];
            
            [btn setImagePosition:LXMImagePositionRight spacing:2];
        }
    }
}

-(void)reloadTitleState{
    
    [self selectTheSegument:0 event:NO];
}

-(void)chooseEvent:(KeTaoSortBarSelectBlock)block{
    self.selectBlock = block;
}

@end
