//
//  ZJPersonalCenterWebVC.h
//  TuLingApp
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 shensiwei. All rights reserved.
//

#import "TicketBaseVC.h"

@interface ZJPersonalCenterWebVC : TicketBaseVC
@property (strong, nonatomic) NSURL *homeUrl;
- (instancetype)initWithURL:(NSString *)url;
@end
