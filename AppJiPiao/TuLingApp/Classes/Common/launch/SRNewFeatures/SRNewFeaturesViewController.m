//
//  SRNewFeaturesViewController.m
//  SRNewFeaturesDemo
//
//  Created by on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRNewFeaturesViewController.h"
#define timeInterval   3 //定时器间隔
@interface SRNewFeaturesViewController () <UIScrollViewDelegate>

{

    UIScrollView *scrollView;
}
@property (nonatomic, strong) UIViewController *rootVC;

@property (nonatomic, strong) NSArray          *imageNames;

@property (nonatomic, strong) UIPageControl    *pageControl;
@property (nonatomic, strong) UIButton         *skipButton;
@property (nonatomic, strong) UIButton         *customButton;

@property (nonatomic,strong) NSTimer *timer;


@property (nonatomic,assign) int   myCount;
@end

@implementation SRNewFeaturesViewController

+ (BOOL)sr_shouldShowNewFeature {
    
    // the app version in the sandbox
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"CFBundleShortVersionString"];
    // the current app version
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if ([currentVersion isEqualToString:lastVersion]) {
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}

+ (instancetype)sr_newFeatureWithImageNames:(NSArray *)imageNames rootViewController:(UIViewController *)rootVC {
    
    return [[self alloc] initWithImageNames:imageNames rootViewController:rootVC];
}

- (instancetype)initWithImageNames:(NSArray *)imageNames rootViewController:(UIViewController *)rootVC {
    
    if (self = [super init]) {
        _myCount=0;
        self.view.backgroundColor = [UIColor whiteColor];
        _imageNames = imageNames;
        _rootVC = rootVC;
        [self setup];
        [self startTimer];
    }
    return self;
}

- (void)setup {
    
    if (self.imageNames.count > 0) {
        CGFloat imageW = self.view.frame.size.width;
        CGFloat imageH = self.view.frame.size.height;
        
        scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:({
            scrollView.frame = self.view.bounds;
            scrollView.delegate = self;
            scrollView.pagingEnabled = YES;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.contentSize = CGSizeMake(imageW * self.imageNames.count, 0);
            scrollView;
        })];

        for (int i = 0; i < self.imageNames.count; i++) {
            [scrollView addSubview:({
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView setFrame:CGRectMake(imageW * i, 0, imageW, imageH)];
                [imageView setImage:[UIImage imageNamed:_imageNames[i]]];
                if (i == self.imageNames.count - 1) {
//                    // Here you can add a custom Button to switch the root controller.
//                    [imageView setUserInteractionEnabled:YES];
//                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAciton)];
//                    [imageView addGestureRecognizer:tap];
                }
                imageView;
            })];
        }
        
        [self.view addSubview:({
            _pageControl = [[UIPageControl alloc] init];
            _pageControl.frame = CGRectMake(0, imageH * 1787/1920, imageW, 20);
            _pageControl.hidesForSinglePage = YES;
            _pageControl.numberOfPages = self.imageNames.count;
            _pageControl.currentPageIndicatorTintColor = RGBCOLOR(145, 145, 145);
            _pageControl.pageIndicatorTintColor = [UIColor whiteColor];;
            _pageControl;
        })];
        
        [scrollView addSubview:({
           
            CGFloat buttonW = imageW-636*WIDTH/1080;
            CGFloat buttonH = buttonW *155/455;
            _skipButton = [[UIButton alloc] init];
            _skipButton.frame = CGRectMake((imageW * self.imageNames.count-imageW)+318*WIDTH/1080, 1558*HEIGHT/1920, buttonW, buttonH);
                _skipButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            [_skipButton setImage:[UIImage imageNamed:@"lan6"] forState:UIControlStateNormal];
            [_skipButton addTarget:self action:@selector(skipBtnAction) forControlEvents:UIControlEventTouchUpInside];
             _skipButton;
        })];
    }
}

- (void)tapAciton {
    
//    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
//                      duration:0.25f
//                       options:nil
//                    animations:^{
//                        [UIApplication sharedApplication].keyWindow.rootViewController = self.rootVC;
//                    }
//                    completion:nil];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = self.rootVC;
}

- (void)skipBtnAction {
    
    [self tapAciton];
}

#pragma mark - Setters

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    [_pageControl setCurrentPageIndicatorTintColor:currentPageIndicatorTintColor];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    [_pageControl setPageIndicatorTintColor:pageIndicatorTintColor];
}

- (void)setHidePageControl:(BOOL)hidePageControl {
    
    _hidePageControl = hidePageControl;
    
    _pageControl.hidden = hidePageControl;
}

- (void)setHideSkipButton:(BOOL)hideSkipButton {
    
    _hideSkipButton = hideSkipButton;
    
    _skipButton.hidden = hideSkipButton;
}







- (void)startTimer
{
    self.timer =[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)stopTimer
{
    [self.timer invalidate];
    self.timer =nil;
}



- (void)nextImage
{
    
    __weak typeof(self)weakSelf = self;
    _myCount++;
    [UIView animateWithDuration:0.5 animations:^{
        if (_myCount<self.imageNames.count) {
            scrollView.contentOffset = CGPointMake(scrollView.frame.size.width*weakSelf.myCount, 0);
            _pageControl.currentPage=weakSelf.myCount;
        }else
        {
            weakSelf.myCount=0;
        }
       
    } completion:^(BOOL finished) {

    }];

    
}






#pragma scrollView代理事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
     CGFloat offsetY = scrollView1.contentOffset.x;
    NSLog(@"offsetY");
    if (offsetY==WIDTH * (self.imageNames.count-1)) {
        [self stopTimer];
    }
    
    
}


//开始拖拽视图

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView1;

{
    
    //停止计时器
    
  //  [self.timer setFireDate:[NSDate distantFuture]];
    [self stopTimer];
    
}



//当手指在scrollview上停止触碰的时候点用该方法

-(void)scrollViewDidEndDragging:(UIScrollView*)scrollView1 willDecelerate:(BOOL)decelerate

{
    
    //手指松开时触发
    
    if(decelerate){
        
    scrollView.userInteractionEnabled
        
        = NO;
        
    }
    
}


#pragma mark - UIScrollViewDelegate
//scrollView完全停止，有触碰事件时,当手动滑动，scrollview停止滚动时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1 {
    
    NSInteger page = scrollView1.contentOffset.x / scrollView1.bounds.size.width;
    _pageControl.currentPage = page;
    _myCount=(int)page;
    //重新打开交互,重启计时器
   scrollView.userInteractionEnabled
    = YES;
    [self startTimer];
    
}

@end
