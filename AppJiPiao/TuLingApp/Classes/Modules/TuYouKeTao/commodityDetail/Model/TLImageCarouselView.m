//
//  TLImageCarouselView.m
//  TuLingApp
//
//  Created by gyc on 2017/8/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLImageCarouselView.h"
#import "TLImageCarouselViewCell.h"


@interface TLImageCarouselView () <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;

@end

@implementation TLImageCarouselView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self viewUISet];
    }
    return self;
}


-(void)viewUISet{
    [self addPagerView];
    [self addPageControl];
}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
  
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 3.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    // registerClass or registerNib
    [pagerView registerClass:[TLImageCarouselViewCell class] forCellWithReuseIdentifier:@"TLImageCarouselViewCellID"];
    [self addSubview:pagerView];
    _pagerView = pagerView;
    _pagerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}
    
- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    //pageControl.numberOfPages = _datas.count;
    pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    //    pageControl.pageIndicatorImage = [UIImage imageNamed:@"Dot"];
    //    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"DotSelected"];
    //    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    //    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    [_pagerView addSubview:pageControl];
    _pageControl = pageControl;
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame) - 26, CGRectGetWidth(_pagerView.frame), 26);
    UIImage * currentImage = [UIImage imageNamed:@"page2"];
    _pageControl.pageIndicatorImage = [UIImage imageNamed:@"page1"];
    _pageControl.currentPageIndicatorImage = currentImage;
    _pageControl.pageIndicatorSize =  currentImage.size;
}

-(void)setImagesArray:(NSArray *)imagesArray{

    if (_imagesArray == imagesArray){
        return;
    }
    _imagesArray = imagesArray;
    if (imagesArray.count <= 1){
        _pagerView.autoScrollInterval = 0;
    }
    _pageControl.numberOfPages = _imagesArray.count;
    [_pagerView reloadData];
}
    
#pragma mark - TYCyclePagerViewDataSource
    
    - (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
        return _imagesArray.count;
    }
    
    - (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
        TLImageCarouselViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TLImageCarouselViewCellID" forIndex:index];
       
        id obj = self.imagesArray[index];
        if ([obj isKindOfClass:[UIImage class]]) { // UIImage对象
            cell.imageView.image = obj;
        } else if ([obj isKindOfClass:[NSString class]]) { // 本地图片名
            cell.imageView.image = [UIImage imageNamed:obj];
        } else if ([obj isKindOfClass:[NSURL class]]) { // 远程图片URL
            [cell.imageView sd_setImageWithURL:obj placeholderImage:[UIImage imageNamed:@"169"]];
        }
        
        return cell;
    }
    
    - (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
        TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
        layout.itemSize = CGSizeMake(CGRectGetWidth(pageView.frame), CGRectGetHeight(pageView.frame));
        layout.itemSpacing = 15;
        layout.itemHorizontalCenter = YES;
        return layout;
    }
    
    - (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
        _pageControl.currentPage = toIndex;
        //[_pageControl setCurrentPage:newIndex animate:YES];
        
    }
    
#pragma mark - action
    
    - (IBAction)switchValueChangeAction:(UISwitch *)sender {
        if (sender.tag == 0) {
            _pagerView.isInfiniteLoop = sender.isOn;
            [_pagerView updateData];
        }else if (sender.tag == 1) {
            _pagerView.autoScrollInterval = sender.isOn ? 3.0:0;
        }else if (sender.tag == 2) {
            _pagerView.layout.itemHorizontalCenter = sender.isOn;
            [UIView animateWithDuration:0.3 animations:^{
                [_pagerView setNeedUpdateLayout];
            }];
        }
    }
    
    - (IBAction)sliderValueChangeAction:(UISlider *)sender {
        if (sender.tag == 0) {
            _pagerView.layout.itemSize = CGSizeMake(CGRectGetWidth(_pagerView.frame)*sender.value, CGRectGetHeight(_pagerView.frame)*sender.value);
            [_pagerView setNeedUpdateLayout];
        }else if (sender.tag == 1) {
            _pagerView.layout.itemSpacing = 30*sender.value;
            [_pagerView setNeedUpdateLayout];
        }else if (sender.tag == 2) {
            _pageControl.pageIndicatorSize = CGSizeMake(6*(1+sender.value), 6*(1+sender.value));
            _pageControl.currentPageIndicatorSize = CGSizeMake(8*(1+sender.value), 8*(1+sender.value));
            _pageControl.pageIndicatorSpaing = (1+sender.value)*10;
        }
    }
    
    - (IBAction)buttonAction:(UIButton *)sender {
        _pagerView.layout.layoutType = sender.tag;
        [_pagerView setNeedUpdateLayout];
    }
    
    - (void)pageControlValueChangeAction:(TYPageControl *)sender {
        NSLog(@"pageControlValueChangeAction: %ld",sender.currentPage);
    }


@end
