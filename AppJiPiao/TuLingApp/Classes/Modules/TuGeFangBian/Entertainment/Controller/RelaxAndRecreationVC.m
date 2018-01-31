//
//  RelaxAndRecreationVC.m
//  TuLingApp
//
//  Created by 韩宝国 on 16/12/26.
//  Copyright © 2016年 shensiwei. All rights reserved.
//

#import "RelaxAndRecreationVC.h"

@interface RelaxAndRecreationVC ()<XMReqDelegate>

@end

@implementation RelaxAndRecreationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"休闲娱乐";
    
    [[XMReqMgr sharedInstance] registerXMReqInfoWithKey:@"ccb08e2f03bd3a94a9973c57ca41fb7e" appSecret:@"fef472c5e75c9fb91678c137ef3a5806"];
    [XMReqMgr sharedInstance].delegate = self;

    
    [self buildSubviews];

}

- (void) getData
{
    
}

- (void) buildSubviews
{
    
}




/*
 * 喜马拉雅delegate
 */
-(void)didXMInitReqFail:(XMErrorModel *)respModel
{
    NSLog(@"init failed");
}

-(void)didXMInitReqOK:(BOOL)result
{
    NSLog(@"init ok");
}

@end
