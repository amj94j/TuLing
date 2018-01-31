//
//  TLBaseShareView.m
//  TuLingApp
//
//  Created by 李立达 on 2017/8/28.
//  Copyright © 2017年 shensiwei. All rights reserved.
//

#import "TLBaseShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "BSRelayoutButton.h"
#define kScaleW WIDTH/375
#define kScaleH HEIGHT/667
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface TLBaseShareView ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView *backView;
@end

@implementation TLBaseShareView
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0);
        self.frame = CGRectMake(0, HEIGHT-64, WIDTH, 64);
        [self share];
        [self addTapGestureWithTarget:self action:@selector(disappear)];
    }
    return self;
}

-(void)share
{
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor clearColor];
    _backView.frame = CGRectMake(0, mainScreenHeight, mainScreenWidth, mainScreenHeight);
    [self addSubview:self.backView];
    _allShareView = [[UIView alloc]init];
    _allShareView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:_allShareView];
    
    
    UIButton *Btn = [[UIButton alloc]init];
    Btn.frame = CGRectMake(0, mainScreenHeight-49, WIDTH, 49);
    Btn.titleLabel.font =[UIFont systemFontOfSize:17];
    [Btn setTitle:@"取消" forState:UIControlStateNormal];
    [Btn setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(aboutClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:Btn];
    
    UILabel *line =[createControl createLineWithFrame:CGRectMake(0, mainScreenHeight-49.5, WIDTH, 0.5) labelLineColor:nil];
    [self.backView addSubview:line];
    
    //四个Button
    NSArray *imageArray = @[@"UMS1.png",@"UMS4.png",@"UMS2.png",@"UMS5.png",@"UMS3.png",@"UMS6.png"];
    NSArray *titleArray = @[@"微信",@"朋友圈",@"QQ",@"QQ空间",@"微博",@"复制链接"];
    
    
    CGFloat buttonWidth = 55;
    CGFloat buttonHeight = 63;
    CGFloat  buttonMergin = (mainScreenWidth - buttonWidth * 3- 80) / 2;
    
    UIButton  *lastButton;
    
    for (int i =6; i>=1; i--) {
        
        NSString  *title = titleArray[i-1];
        UIImage   *image = [UIImage imageNamed:imageArray[i-1]];
        
        BSRelayoutButton  *button = [BSRelayoutButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.offset = 4;
        button.type = BSRelayoutButtonAlignmentImageTop;
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:13]];
        [button addTarget:self action:@selector(ShareCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:button];
        
        CGFloat x = 40 + (i - 1) % 3 * (buttonWidth + buttonMergin);
        CGFloat y = line.top - (buttonHeight + 20) * (i > 3 ? 1 : 2);
        button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        lastButton = button;
    }
    UILabel *myLabel = [[UILabel alloc]init];
   
    myLabel.font = [UIFont systemFontOfSize:18];
    myLabel.text =@"分享到";
    [myLabel sizeToFit];
    myLabel.textAlignment =NSTextAlignmentCenter;
     myLabel.frame = CGRectMake(0,lastButton.top-40-myLabel.height, WIDTH, 20);
    myLabel.textColor = [UIColor colorWithHexString:@"#6A6A6A"];
    [self.backView addSubview:myLabel];
    _allShareView.frame = CGRectMake(0,myLabel.top -20, mainScreenWidth,mainScreenHeight- myLabel.top+20 );
}

//让界面出现
- (void)appear{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.frame = CGRectMake(0, 0, mainScreenWidth, mainScreenHeight);
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
    }];
}

//让界面消失
- (void)disappear{
    
    [UIView animateWithDuration:0.1f animations:^{
        [self.layer setOpacity:0.0f];
    }                completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)aboutClick:(UIButton *)btn
{
    
    [self disappear];
}

- (void)ShareCLick:(UIButton *)btn
{
    
    switch (btn.tag) {
        case 1:
        {
            
            
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
            
            
        }
            break;
            
            
        case 2:
        {
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
        }
            break;
            
        case 3:{
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
        }
            break;
        case 4:{
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
        }
            break;
            
        case 5:{
            
            
            
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //创建网页内容对象
            UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:self.title descr:self.content?self.content:@"" thumImage:_titleImage];
            
            shareObject.shareImage=_titleImage;
            //设置网页地址
            // shareObject.webpageUrl = self.urlString;
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            messageObject.text =[NSString stringWithFormat:@"%@%@",self.title,self.urlString];
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                    [MBProgressHUD showSuccess:@"分享失败"];
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        [MBProgressHUD showSuccess:@"分享成功"];
                        
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                }
                //[self alertWithError:error];
            }];
            
            
            
        }
            break;
        case 6:{
            
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.urlString;
            [MBProgressHUD showSuccess:@"复制成功"];
        }
            break;
        default:
            break;
    }
    [self disappear];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
//    创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.title descr:self.content?self.content:@"" thumImage:_titleImage];
//    //设置网页地址
    shareObject.webpageUrl = self.urlString;
//
//    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
//    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:self.title descr:self.content?self.content:@"" thumImage:_titleImage];
//
//    shareObject.shareImage=_titleImage;
//
//    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        
        if (error) {
            
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
               
                    [MBProgressHUD showSuccess:@"分享成功"];
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //[self alertWithError:error];
    }];
    
}

@end
