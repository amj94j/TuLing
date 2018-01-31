#import "Xiu_Xian_Yu_LeViewController.h"
#import "DetailXiuXianYuLeViewController.h"

@interface Xiu_Xian_Yu_LeViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *VideoWebView;
@property(nonatomic,strong)UIWebView *MusicWebView;
@property(nonatomic,strong)UIWebView *JokeWebView;

@end

@implementation Xiu_Xian_Yu_LeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTitleView];
    
    [self createView];
}
//标题三个按钮
- (void)createTitleView
{
    UIButton *button = [LXTControl createButtonWithFrame:CGRectMake(0, 0, 9, 18) ImageName:@"arrowback" Target:self Action:@selector(ButtonClick) Title:@""];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    UIImageView *titleImageView = [LXTControl createImageViewWithFrame:CGRectMake(0, 0, 207, 30) ImageName:nil];
    titleImageView.layer.masksToBounds = YES;
    titleImageView.layer.cornerRadius = 15.0;
    titleImageView.userInteractionEnabled = YES;
    titleImageView.backgroundColor = RGBCOLOR(27, 125, 65);
    self.navigationItem.titleView = titleImageView;
    NSArray *titleArray = @[@"视频",@"音乐",@"段子"];
    NSArray *urlArray = @[@"xiu_xian_yu_le/video_list",@"xiu_xian_yu_le/music_list",@"xiu_xian_yu_le/joke_list"];
    for (int i = 0; i<3; i++) {
        UIButton *titleButton = [LXTControl createButtonWithFrame:CGRectMake(3+i*68, 3, 65, 24) ImageName:nil Target:self Action:@selector(titleButtonClick:) Title:titleArray[i]];
        titleButton.selected = NO;
        titleButton.tag = i+10;
        if (i == 0) {
            titleButton.selected = YES;
            [titleButton setBackgroundImage:[UIImage imageNamed:@"huakuai.png"] forState:UIControlStateNormal];
            [titleButton setTitleColor:RGBCOLOR(50, 220, 120) forState:UIControlStateNormal];
        }
        [titleImageView addSubview:titleButton];
        
        UIWebView *WebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
        WebView.delegate = self;
        WebView.scrollView.bounces = NO;
        NSURL *url = [NSURL URLWithString:[Base_URL stringByAppendingString:urlArray[i]]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        WebView.tag = i+10;
        if (i==0){
            WebView.hidden = NO;
        }else{
            WebView.hidden = YES;
            
        }
        [WebView loadRequest:request];
        
        [self.view addSubview:WebView];
    }
}

//下面三个视图
- (void)createView
{
    
}
//返回上页
- (void)ButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//标题按钮
- (void)titleButtonClick:(UIButton *)button
{
    self.selectedIndex = button.tag-10;
}
//
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex) {
        UIWebView *prewebView = [self.view viewWithTag:_selectedIndex+10];
        prewebView.hidden = YES;
        
        UIWebView *curWebView = [self.view viewWithTag:selectedIndex+10];
        curWebView.hidden = NO;
        
        UIButton *lastBtn = [self.navigationItem.titleView viewWithTag:_selectedIndex+10];
        [lastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [lastBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        UIButton *currentBtn = [self.navigationItem.titleView viewWithTag:selectedIndex+10];
        [currentBtn setTitleColor:RGBCOLOR(50, 220, 120) forState:UIControlStateNormal];
        [currentBtn setBackgroundImage:[UIImage imageNamed:@"huakuai.png"] forState:UIControlStateNormal];
        _selectedIndex = selectedIndex;
    }
}
#pragma mark 监听事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"requestString = %@ ",requestString);
    if ((![requestString isEqualToString:kXiuXianYuLeVideo])&&(![requestString isEqualToString:kXiuXianYuLeMusic])&&(![requestString isEqualToString:kXiuXianYuLeJokes])) {
        if(([requestString rangeOfString:requestString]).location!=NSNotFound)
        {
            DetailXiuXianYuLeViewController *dvc = [[DetailXiuXianYuLeViewController alloc]init];
            dvc.urlString = requestString;
            [self.navigationController pushViewController:dvc animated:YES];
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
